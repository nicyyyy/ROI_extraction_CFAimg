function [x,y,w,h] = get_ROI6(img_in)
%计算感兴趣区域
%   此处显示详细说明
img_in_gray = rgb2gray(img_in);
[m_init,n_init,c] = size(img_in);%初始大小
%%
%下采样
w=fspecial('gaussian',[3 3]);
img2=imresize(imfilter(img_in_gray,w),[m_init/2 n_init/2]);
img3=imresize(imfilter(img2,w),[m_init/4 n_init/4]);
img4=imresize(imfilter(img3,w),[m_init/8 n_init/8]);

img_used = img4;
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
%抑制矩阵
W = suppression(m,n);
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

%计算gabor局部对比度显著图
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


%%
%颜色特征
% img_R=img_in(:,:,1)-((img_in(:,:,2)+img_in(:,:,3))./2);
% img_G=img_in(:,:,2)-((img_in(:,:,1)+img_in(:,:,3))./2);
% img_B=img_in(:,:,3)-((img_in(:,:,1)+img_in(:,:,2))./2);
% 
% %颜色特征下采样
% w=fspecial('gaussian',[3 3]);
% img_R2=imresize(imfilter(img_R,w),[m_init/2,n_init/2]);
% img_R3=imresize(imfilter(img_R2,w),[m_init/4,n_init/4]);
% 
% img_G2=imresize(imfilter(img_G,w),[m_init/2,n_init/2]);
% img_G3=imresize(imfilter(img_G2,w),[m_init/4 n_init/4]);
% 
% img_B2=imresize(imfilter(img_B,w),[m_init/2,n_init/2]);
% img_B3=imresize(imfilter(img_B2,w),[m_init/4,n_init/4]);
% 
% %颜色特征分块
% img_R3 = imresize(img_R3,[m0*(floor(m/m0) + 1),n0*(floor(n/n0) + 1)]);
% img_G3 = imresize(img_G3,[m0*(floor(m/m0) + 1),n0*(floor(n/n0) + 1)]);
% img_B3 = imresize(img_B3,[m0*(floor(m/m0) + 1),n0*(floor(n/n0) + 1)]);
% 
% img_R_sg = segmentation(img_R3,[m0,n0]);
% img_G_sg = segmentation(img_B3,[m0,n0]);
% img_B_sg = segmentation(img_G3,[m0,n0]);
% 
% img_R_mean = zeros(1,sg_num);
% img_G_mean = zeros(1,sg_num);
% img_B_mean = zeros(1,sg_num);
% 
% %颜色特征均值
% for i = 1:sg_num
%     img_R_mean(i) = mean(mean(img_R_sg(:,:,i)));
% end
% for i = 1:sg_num
%     img_G_mean(i) = mean(mean(img_G_sg(:,:,i)));
% end
% for i = 1:sg_num
%     img_B_mean(i) = mean(mean(img_B_sg(:,:,i)));
% end
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
Sd_open = Sd_open.*1;%抑制周边
Sd_open_normalized = figure_normalize(Sd_open);

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

[xMin, xMax, yMin, yMax] = minboundrect(S);
x = round((xMin+xMax)/2);
y = round((yMin+yMax)/2);
w = round(xMax - xMin);
h = round(yMax - yMin);
end

