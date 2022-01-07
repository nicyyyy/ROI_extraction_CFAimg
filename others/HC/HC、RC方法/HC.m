%function saliency = HC(img_name)
%��ȡͼ��
%orpic = imread(img_name);
orpic = imread('000000122586.jpg');
%��ȡͼ��ĳ������ͨ��ֵ
[row ,column, nn] = size(orpic);

%%����ɫ��RGBͨ������256������12����ѡ���ܰ�������95%��ɫ���ݵ���ɫ��������ɫ�鵽ѡ�����ɫ��

%���ɵ�ɫ��pallet(color,number)
pallet = zeros(row*column,2);
%���ý���ֵ��Ϊ�˽�rgb������Ľ������һ��12���Ƶ���
w = [12*12,12,1];
idx = uint32(1);
SUM = uint32(0);
RGBSUM = zeros(row,column);
for i = 1 : row
   for j = 1 : column
       %��ȡ��i�е�j�е�R��G��Bͨ����ֵ��������Ϊ12�׺���ת��Ϊһ����
       a1 = floor((double(orpic(i,j,1))/255)*(12-0.0001))*w(3);
       a2 = floor((double(orpic(i,j,2))/255)*(12-0.0001))*w(2);
       a3 = floor((double(orpic(i,j,3))/255)*(12-0.0001))*w(1);
       SUM = int32(a1) + int32(a2) + int32(a3);
%        SUM = 3* int32(a1);
       RGBSUM(i,j) = SUM;
       
       %�ҳ������������ж�������ɫֵ���Լ���Ƶ��
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
%��ȡͼ�����е���ɫֵ
idx = idx -1;
pallet = pallet(1:idx,:);

%�����µĵ�ɫ��num(number,color)��ʹ����ɫ����Ƶ���Ӵ�С���У���һ��λΪƵ����С������λΪ��������ɫֵ
palletemp = pallet(:,2);
[b,pos] = sort(palletemp,'descend');
num = zeros(idx,2);
for i = 1 : idx
    num(i,1) = b(i);
    num(i,2) = pallet(pos(i),1);
end

%�������Ҫ����95%�Ĵ�������ɫֵ����Ҫ������ɫ��Ķ���λ
maxnum = idx;
maxdropnum = floor(row*column*(1-0.95));
crnt = num(maxnum,1);
while(crnt<maxdropnum && maxnum>1)
    crnt = crnt + num(maxnum-1,1);
    maxnum = maxnum - 1;
end
%��֤��������ɫֵС��256�Ҿ�����̫С
maxnum = min(maxnum,256);
if maxnum < 10
    maxnum = min(idx,100);
end
 
%����������ɫֵת����RGB��Ӧ��ֵ
 color3i = zeros(idx,3);
 for i = 1:idx
    color3i(i,1) = round(num(i,2)/w(1));
    color3i(i,2) = round(mod(num(i,2),w(1))/w(2));
    color3i(i,3) = round(mod(num(i,2),w(2)));
 end

%����ɫ��pallet(number,color,pos)������posΪ������ɫ�����
a = zeros(idx,1);
pallet = [num,a];
for i = 1:maxnum
    pallet(i,3) = i;
end    

%����������ɫ�鵽�����������ɫ����
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
 
%��ͼ��������ĳһ����ɫֵ����������ɫ��rgbֵ�ۼ�֮����ƽ���ٹ�һ������������������ɫֵ
 rgbcolor = zeros(idx,4);
 for n =1:idx
     for i = 1:row
         for j = 1:column
             if RGBSUM(i,j) == pallet(n,2)
                rgbcolor(n,1) = int32(rgbcolor(n,1)) + int32(orpic(i,j,1));
                rgbcolor(n,2) = int32(rgbcolor(n,2)) + int32(orpic(i,j,2));
                rgbcolor(n,3) = int32(rgbcolor(n,3)) + int32(orpic(i,j,3));
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

%����ɫ��ʽ��RGBתΪLab
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


%%�Եõ���������ͼ����ƽ������

%%��ƽ��ǰ�ĸ���ɫ��������ֵ

%�����ɫi����ɫj��Lab�ռ��ϵľ���
distemp = zeros(maxnum,maxnum,2);
%ÿ�н���ɫj����ɫi����Lab�ռ��ϵľ��밴��С��������
dist = zeros(maxnum,maxnum,2);
%���ƽ��ǰ����ɫ����ֵ
colorsaltemp = zeros(maxnum,2);
for i = 1:maxnum
    for j = 1:maxnum
        %������ɫi����ɫj��Lab�ռ��ϵľ���
        distemp(i,j,1) = norm(labcolor(i,:)-labcolor(j,:),2);
        distemp(i,j,2) = j;
    end
    for k = 1:maxnum
        if k == i
            continue;
        end
        %��ɫi��ƽ��֮ǰ����ɫ����ֵ��ΪS(c)=��P(c)D(c,a)��aΪ��������ɫ
        colorsaltemp(i,1) = colorsaltemp(i,1) + (pallet(k,1)/(row*column))*distemp(i,k,1);
        colorsaltemp(i,2) = i;
    end
    
    [b,pos] = sort(distemp(i,:,1),'ascend');  
    for k = 1:maxnum
        dist(i,k,1) = b(k);
        dist(i,k,2) = distemp(i,pos(k),2);
    end
end


%�Ը���ɫ����ƽ������
colorsal = zeros(maxnum,2);
%����Ȩֵʱʹ�õ���ɫi��������ڽ���ɫ�ĸ���
n = double(round(maxnum/4));
%��������ɫi��Lab�ռ����������n=maxnum/4����ľ���ĺ�
totaldist = zeros(maxnum,1);
for i = 1:maxnum
    %��������ɫi��Lab�ռ����������n=maxnum/4����ľ���ĺ�
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

%����ԭͼ������ص�����ֵ
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
%����3*3�ĸ�˹�˲�����������ͼ�����˲�
A=fspecial('gaussian',[3,3],0.5);  
saliency=imfilter(saliency,A,'replicate');
%��ʾ������ͼ
subplot(1,2,1),imshow(saliency); 
subplot(1,2,2),imshow(sal,[]);
imwrite(saliency,'HC����ͼ.jpg')