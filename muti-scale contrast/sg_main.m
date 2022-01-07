clear all;
clc
close all;
%%
img_in = imread('tc200_10m_cc (10).jpg');
img_in_gray = rgb2gray(img_in);
[m_init,n_init,c] = size(img_in);%初始大小
%%
%下采样
down_sample_time = 4;%下采样次数
w=fspecial('gaussian',[7 7]);
for i = 1:down_sample_time
    if i == 1
        img_used = imresize(imfilter(img_in_gray,w),[floor(m_init/2) floor(n_init/2)]);
    else
        img_used = imresize(imfilter(img_used,w),[floor(m_init/(2^i)) floor(n_init/(2^i))]);
    end
end

%%
%分割
[m,n] = size(img_used);
m0 = floor(m/15);%分割大小
n0 = floor(n/15);
img_used = imresize(img_used,[m0*(floor(m/m0) + 1),n0*(floor(n/n0) + 1)]);
[m,n] = size(img_used);

img_sg = segmentation(img_used,[m0,n0]);
sg_num = size(img_sg,3);%分割后的块数量

%%
% %计算灰度共生矩阵特征
% img_GLCM = zeros(8,8,sg_num);%各块的灰度共生矩阵
% img_GLCM_feature = zeros(4,sg_num);%各块的灰度共生矩阵的特征
% 
% for i = 1:sg_num
%     img_GLCM(:,:,i) = graycomatrix(img_sg(:,:,i));
%     state = (graycoprops(img_GLCM(:,:,i)));
% end
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

% for i = 1:sg_num
%     temp = 0;
%     for j = 1:sg_num
%         temp = temp + sqrt(sum((img_gabor_mean(1,:,i) - img_gabor_mean(1,:,j)).^2));  
%     end
%     for ii = 1:m0
%        for jj = 1:n0
%            Sd_gabor(ii,jj,i) = temp;
%        end
%     end  
% end
% %局部显著图展开
% Sd_gabor_open = opening(Sd_gabor,[m,n]);
% Sd_gabor_open_normalized = figure_normalize(Sd_gabor_open);
% figure('name','局部方向特征显著图')
% imshow(Sd_gabor_open_normalized,[])

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
%颜色特征
% img_R=img_in(:,:,1)-((img_in(:,:,2)+img_in(:,:,3))./2);
% img_G=img_in(:,:,2)-((img_in(:,:,1)+img_in(:,:,3))./2);
% img_B=img_in(:,:,3)-((img_in(:,:,1)+img_in(:,:,2))./2);
img_R=img_in(:,:,1);
img_G=img_in(:,:,2);
img_B=img_in(:,:,3);

%颜色特征下采样
for i = 1:down_sample_time
    if i == 1
        img_R_downsampled = imresize(imfilter(img_R,w),[floor(m_init/2) floor(n_init/2)]);
    else
        img_R_downsampled = imresize(imfilter(img_R_downsampled,w),[floor(m_init/(2^i)) floor(n_init/(2^i))]);
    end
end
for i = 1:down_sample_time
    if i == 1
        img_G_downsampled = imresize(imfilter(img_G,w),[floor(m_init/2) floor(n_init/2)]);
    else
        img_G_downsampled = imresize(imfilter(img_G_downsampled,w),[floor(m_init/(2^i)) floor(n_init/(2^i))]);
    end
end
for i = 1:down_sample_time
    if i == 1
        img_B_downsampled = imresize(imfilter(img_B,w),[floor(m_init/2) floor(n_init/2)]);
    else
        img_B_downsampled = imresize(imfilter(img_B_downsampled,w),[floor(m_init/(2^i)) floor(n_init/(2^i))]);
    end
end

img_R = imresize(img_R_downsampled,[m0*(floor(m/m0) + 1),n0*(floor(n/n0) + 1)]);
img_G = imresize(img_G_downsampled,[m0*(floor(m/m0) + 1),n0*(floor(n/n0) + 1)]);
img_B = imresize(img_B_downsampled,[m0*(floor(m/m0) + 1),n0*(floor(n/n0) + 1)]);

img_R_sg = segmentation(img_R,[m0,n0]);
img_G_sg = segmentation(img_G,[m0,n0]);
img_B_sg = segmentation(img_G,[m0,n0]);

img_R_mean = zeros(1,sg_num);
img_G_mean = zeros(1,sg_num);
img_B_mean = zeros(1,sg_num);

%颜色特征均值
for i = 1:sg_num
    img_R_mean(i) = mean(mean(img_R_sg(:,:,i)));
end
for i = 1:sg_num
    img_G_mean(i) = mean(mean(img_G_sg(:,:,i)));
end
for i = 1:sg_num
    img_B_mean(i) = mean(mean(img_B_sg(:,:,i)));
end
%%
%抑制矩阵
W = suppression(m,n);
%%
%背景先验
back_suppresion = prior_back(img_used,img_R_downsampled,img_G_downsampled,img_B_downsampled);
figure('name','背景先验')
imshow(back_suppresion,[])
back_suppresion = imresize(back_suppresion,[m,n]);
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
Sd_open = Sd_open.*back_suppresion.*W;%抑制周边
Sd_open_normalized = figure_normalize(Sd_open);
figure('name','显著图')
imshow(Sd_open_normalized,[])

%%
%提取ROI区域
S = imresize(Sd_open_normalized,[m_init,n_init]);
level = get_th(S);
for i = 1:m_init
   for j = 1:n_init
      if(S(i,j) <= level) 
         S(i,j) = 0;
      else
         S(i,j) = 1;
      end
   end
end
Se = strel('square',20);
S = imerode(S,Se);
figure('name','二值化显著图')
imshow(S,[])
[xMin, xMax, yMin, yMax] = minboundrect(S);
nn = xMax - xMin;
mm = yMax - yMin;
grabimg = zeros(mm,nn);
for i =1:mm
    for j = 1:nn
    grabimg(i,j) = img_in(yMin+i-1,xMin+j-1);
    end
end
figure('name','ROI提取效果')
subplot(1,2,1);imshow(img_in);title('原图');
subplot(1,2,2);imshow(uint8(grabimg));title('提取后');