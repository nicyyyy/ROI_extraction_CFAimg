clc
clear all

%%
img_in = imread('ILSVRC2017_test_00000237.jpg');
m = size(img_in,1);
n = size(img_in,2);

img_lab = rgb2lab(img_in);
img_L_mean = mean(mean(img_lab(:,:,1)));
img_a_mean = mean(mean(img_lab(:,:,2)));
img_b_mean = mean(mean(img_lab(:,:,3)));

%%
%高斯滤波
img_R = img_in(:,:,1);
img_G = img_in(:,:,2);
img_B = img_in(:,:,3);
w = fspecial('gaussian',[7 7]);
img_R_blur = imfilter(img_R,w);
img_G_blur = imfilter(img_G,w);
img_B_blur = imfilter(img_B,w);

img_blur = cat(3,img_R_blur,img_G_blur,img_B_blur);

figure('name','滤波')
imshow(img_blur)

img_lab_blur = rgb2lab(img_blur);

%%
%计算显著图
Sd = zeros(m,n);
for i = 1:m
   for j = 1:n
       Sd(i,j) = sqrt((img_L_mean - img_lab_blur(i,j,1))^2 + (img_a_mean - img_lab_blur(i,j,2))^2 + (img_b_mean - img_lab_blur(i,j,3))^2);
   end
end
%归一化
Sd_normalized = figure_normalize(Sd);
imwrite(Sd_normalized,'FT_saliency.jpg')
figure
imshow(Sd_normalized)