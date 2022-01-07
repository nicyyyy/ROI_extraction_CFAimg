function [x,y,w,h,S] = get_ROI_HC(img_in)
%计算感兴趣区域
%   此处显示详细说明
%function saliency = HC(img_name)
%读取图像
%orpic = imread(img_name);
%获取图像的长、宽和通道值
[row ,column, nn] = size(img_in);

%%将颜色的RGB通道都由256量化成12，再选择能包含其中95%颜色数据的颜色，其余颜色归到选择的颜色中

%生成调色板pallet(color,number)
pallet = zeros(row*column,2);
%设置阶梯值，为了将rgb量化后的结果化成一个12进制的数
w = [12*12,12,1];
idx = uint32(1);
SUM = uint32(0);
RGBSUM = zeros(row,column);
for i = 1 : row
   for j = 1 : column
       %获取第i行第j列的R、G、B通道的值，并量化为12阶后再转化为一个数
       a1 = floor((double(img_in(i,j,1))/255)*(12-0.0001))*w(3);
       a2 = floor((double(img_in(i,j,2))/255)*(12-0.0001))*w(2);
       a3 = floor((double(img_in(i,j,3))/255)*(12-0.0001))*w(1);
       SUM = int32(a1) + int32(a2) + int32(a3);
%        SUM = 3* int32(a1);
       RGBSUM(i,j) = SUM;
       
       %找出处理后的数据有多少种颜色值，以及其频数
       if idx == 1
           pallet(idx,1) = SUM;
           pallet(idx,2) = pallet(idx,2) + 1;
           idx = idx + 1;
           continue;
       end
       flag = 0;
       for m = 1 : idx-1
           if pallet(m,1) == SUM
               pallet(m,2) = pallet(m,2) + 1;
               flag = 1;
               break;
           end
       end
       if flag == 0 
            pallet(idx,1) = SUM;
            pallet(idx,2) = pallet(idx,2) + 1;
            idx = idx + 1;
       end
    end
end
%获取图中所有的颜色值
idx = idx -1;
pallet = pallet(1:idx,:);

%生成新的调色板num(number,color)，使得颜色按照频数从大到小排列，且一号位为频数大小，二号位为处理后的颜色值
palletemp = pallet(:,2);
[b,pos] = sort(palletemp,'descend');
num = zeros(idx,2);
for i = 1 : idx
    num(i,1) = b(i);
    num(i,2) = pallet(pos(i),1);
end

%计算如果要保留95%的处理后的颜色值，需要保留调色板的多少位
maxnum = idx;
maxdropnum = floor(row*column*(1-0.95));
crnt = num(maxnum,1);
while(crnt<maxdropnum && maxnum>1)
    crnt = crnt + num(maxnum-1,1);
    maxnum = maxnum - 1;
end
%保证保留的颜色值小于256且尽量不太小
maxnum = min(maxnum,256);
if maxnum < 10
    maxnum = min(idx,100);
end
 
%将处理后的颜色值转化回RGB对应的值
 color3i = zeros(idx,3);
 for i = 1:idx
    color3i(i,1) = round(num(i,2)/w(1));
    color3i(i,2) = round(mod(num(i,2),w(1))/w(2));
    color3i(i,3) = round(mod(num(i,2),w(2)));
 end

%建立色板pallet(number,color,pos)，其中pos为保留颜色的序号
a = zeros(idx,1);
pallet = [num,a];
for i = 1:maxnum
    pallet(i,3) = i;
end    

%将舍弃的颜色归到其最相近的颜色当中
for i = (maxnum+1):idx
    simidx = 99999999;simval = 99999999;
    for j  = 1:maxnum
        d_ij = round((color3i(i,1)-color3i(j,1))^2 + (color3i(i,2)-color3i(j,2))^2 + (color3i(i,3)-color3i(j,3))^2);
        if d_ij < simval
            simval = d_ij;
            simidx = j;
        end
    end
    pallet(simidx,1) = pallet(simidx,1) + pallet(i,1);
    pallet(i,3) = simidx;
end
 
%将图像中属于某一“颜色值”的所有颜色的rgb值累加之后求平均再归一，即调整保留下来颜色值
 rgbcolor = zeros(idx,4);
 for n =1:idx
     for i = 1:row
         for j = 1:column
             if RGBSUM(i,j) == pallet(n,2)
                rgbcolor(n,1) = int32(rgbcolor(n,1)) + int32(img_in(i,j,1));
                rgbcolor(n,2) = int32(rgbcolor(n,2)) + int32(img_in(i,j,2));
                rgbcolor(n,3) = int32(rgbcolor(n,3)) + int32(img_in(i,j,3));
                rgbcolor(n,4) = double(pallet(n,3));
             end
         end
     end
 end
for i = 1:maxnum
    for j = (maxnum+1):idx
        if rgbcolor(j,4) == i
            rgbcolor(i,1) = (rgbcolor(i,1) + rgbcolor(j,1));
            rgbcolor(i,2) = (rgbcolor(i,2) + rgbcolor(j,2));
            rgbcolor(i,3) = (rgbcolor(i,3) + rgbcolor(j,3));
        end
    end
    rgbcolor(i,1) = (rgbcolor(i,1)/pallet(i,1))/255;
    rgbcolor(i,2) = (rgbcolor(i,2)/pallet(i,1))/255;
    rgbcolor(i,3) = (rgbcolor(i,3)/pallet(i,1))/255;
end

%将颜色格式由RGB转为Lab
labcolor = zeros(maxnum,3);
for i = 1:maxnum
    a = zeros(1,1,3);
    a(1,1,1) = rgbcolor(i,1);
    a(1,1,2) = rgbcolor(i,2);
    a(1,1,3) = rgbcolor(i,3);
    b = RGB2Lab(a);
    labcolor(i,1) = b(1,1,1);
    labcolor(i,2) = b(1,1,2);
    labcolor(i,3) = b(1,1,3);
end


%%对得到的显著性图进行平滑处理

%%求平滑前的各颜色的显著性值

%存放颜色i与颜色j在Lab空间上的距离
distemp = zeros(maxnum,maxnum,2);
%每行将颜色j与颜色i的在Lab空间上的距离按从小到大排列
dist = zeros(maxnum,maxnum,2);
%存放平滑前的颜色显著值
colorsaltemp = zeros(maxnum,2);
for i = 1:maxnum
    for j = 1:maxnum
        %计算颜色i与颜色j在Lab空间上的距离
        distemp(i,j,1) = norm(labcolor(i,:)-labcolor(j,:),2);
        distemp(i,j,2) = j;
    end
    for k = 1:maxnum
        if k == i
            continue;
        end
        %颜色i在平滑之前的颜色显著值，为S(c)=ΣP(c)D(c,a)，a为其他的颜色
        colorsaltemp(i,1) = colorsaltemp(i,1) + (pallet(k,1)/(row*column))*distemp(i,k,1);
        colorsaltemp(i,2) = i;
    end
    
    [b,pos] = sort(distemp(i,:,1),'ascend');  
    for k = 1:maxnum
        dist(i,k,1) = b(k);
        dist(i,k,2) = distemp(i,pos(k),2);
    end
end


%对各颜色进行平滑操作
colorsal = zeros(maxnum,2);
%计算权值时使用的颜色i与和其最邻近颜色的个数
n = double(round(maxnum/4));
%保存与颜色i在Lab空间上最相近的n=maxnum/4个点的距离的和
totaldist = zeros(maxnum,1);
for i = 1:maxnum
    %计算与颜色i在Lab空间上最相近的n=maxnum/4个点的距离的和
    for j = 2:n
        totaldist(i,1) = totaldist(i,1) + dist(i,j,1);
    end
    valcrnt = 0;
    for j = 1:n
        valcrnt = valcrnt + colorsaltemp(dist(i,j,2),1)*(totaldist(i,1)-dist(i,j,1));
    end
    colorsal(i,1) = valcrnt/((n-1)*totaldist(i,1));
    colorsal(i,2) = i;
end

%保存原图像各像素的显著值
sal = zeros(row,column);
for i = 1:row
    for j = 1:column
        for n = 1:idx
            if RGBSUM(i,j) == pallet(n,2)
                sal(i,j) = colorsal(pallet(n,3),1);
            end
        end
    end
end
saliency = (sal - min(min(sal)))/(max(max(sal)) - min(min(sal)));
%saliency2 = sal/max(max(sal));
%创建3*3的高斯滤波器对显著性图进行滤波
A=fspecial('gaussian',[3,3],0.5);  
saliency=imfilter(saliency,A,'replicate');



%%
%提取ROI区域
S = saliency;
level = get_th(S);
for i = 1:row
   for j = 1:column
      if(S(i,j) <= level) 
         S(i,j) = 0;
      else
         S(i,j) = 1;
      end
   end
end
Se = strel('square',20);
S = imerode(S,Se);

[xMin, xMax, yMin, yMax] = minboundrect(S);
x = round((xMin+xMax)/2);
y = round((yMin+yMax)/2);
w = round(xMax - xMin);
h = round(yMax - yMin);
end

