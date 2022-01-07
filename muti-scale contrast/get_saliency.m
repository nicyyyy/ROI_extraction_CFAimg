function [Sd,Sd_open] = get_saliency(img_in,sg_size)
%UNTITLED 此处显示有关此函数的摘要
%img_in:输入下采样后某个尺度下的img
%%
%分割
[m,n] = size(img_in);
m0 = floor(m/sg_size);%分割大小
n0 = floor(n/sg_size);
img_in = imresize(img_in,[m0*sg_size,n0*sg_size]);
[m,n] = size(img_in);

img_sg = segmentation(img_in,[m0,n0]);
sg_num = size(img_sg,3);%分割后的块数量

%%
%gabor
img_gabor_array = zeros(m0,n0,4,sg_num);
img_gabor = zeros(m0,n0,sg_num);%4个方向合成特征
gaborArray = gabor(3,[0 45 90 135]);%滤波器数组，波长为10，四个方向
for i = 1:sg_num
    img_gabor_array(:,:,:,i) = imgaborfilt(img_sg(:,:,i),gaborArray);%结果包含四个方向的特征图，在第三维度
end
for i = 1:sg_num
    img_gabor(:,:,i) = img_gabor_array(:,:,1,i) + img_gabor_array(:,:,2,i) + img_gabor_array(:,:,3,i) + img_gabor_array(:,:,4,i);
end
%%%%%测试
% img_gabor_0 = figure_normalize(opening(img_gabor_array(:,:,1,:),[m,n]));
% img_gabor_45 = figure_normalize(opening(img_gabor_array(:,:,2,:),[m,n]));
% img_gabor_90 = figure_normalize(opening(img_gabor_array(:,:,3,:),[m,n]));
% img_gabor_135 = figure_normalize(opening(img_gabor_array(:,:,4,:),[m,n]));
% figure('name','gabor滤波各方向结果')
% subplot(2,2,1);imshow(img_gabor_0,[]);title('0');
% subplot(2,2,2);imshow(img_gabor_45,[]);title('45');
% subplot(2,2,3);imshow(img_gabor_90,[]);title('90');
% subplot(2,2,4);imshow(img_gabor_135,[]);title('135');
%%%%%%%%%%%%%%

%计算gabor局部对比度显著图
Sd_gabor = zeros(m0,n0,sg_num);%局部gabor对比度显著图
img_gabor_mean = zeros(1,4,sg_num);%4维特征向量的均值
for i =1:sg_num
    img_gabor_mean(1,1,i) = mean(mean(img_gabor_array(:,:,1,i)));
    img_gabor_mean(1,2,i) = mean(mean(img_gabor_array(:,:,2,i)));
    img_gabor_mean(1,3,i) = mean(mean(img_gabor_array(:,:,3,i)));
    img_gabor_mean(1,4,i) = mean(mean(img_gabor_array(:,:,4,i)));
end

%%
%LBP纹理特征
img_LBP = zeros(m0,n0,sg_num);
for i = 1:sg_num
    img_LBP(:,:,i) = LBP(img_sg(:,:,i));
end

%特征均值
img_LBP_mean = zeros(1,sg_num);
for i = 1:sg_num
    img_LBP_mean(i) = mean(mean(img_LBP(:,:,i)));
end

% %计算LBP纹理特征局部对比显著图
% Sd_LBP = zeros(m0,n0,sg_num);%局部gabor对比度显著图
% for i = 1:sg_num
%     temp = 0;
%     for j = 1:sg_num
%         temp = temp + sqrt(sum(sum((img_LBP(i) - img_LBP(j)).^2)));
%     end
%     for ii = 1:m0
%        for jj = 1:n0
%            Sd_LBP(ii,jj,i) = temp;
%        end
%     end  
% end
% 
% %局部显著图展开
% Sd_LBP_open = opening(Sd_LBP,[m,n]);
% Sd_LBP_open_normalized = figure_normalize(Sd_LBP_open);
% figure('name','局部LBP特征显著图')
% imshow(Sd_LBP_open_normalized,[])

%%
%计算局部对比度显著图
Sd = zeros(m0,n0,sg_num);
for i = 1:sg_num
    temp = 0;
    for j = 1:sg_num
        temp = temp + sqrt( sum(sum((img_gabor(:,:,i) -  img_gabor(:,:,j)).^2)) + (img_LBP_mean(i) - img_LBP_mean(j)).^2 );  
    end
    for ii = 1:m0
       for jj = 1:n0
           Sd(ii,jj,i) = temp;
       end
    end  
end
% Sd = Sd_LBP_open + Sd_gabor_open;
Sd_open = opening(Sd,[m,n]);%每个块合并起来
% Sd_open = Sd_open.*back_suppresion.*W;%抑制周边
% Sd_open_normalized = figure_normalize(Sd_open);
% figure('name','显著图')
% imshow(Sd_open_normalized,[])

end

