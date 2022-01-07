function [x,y,w,h,S] = get_ROI_FT(img_in)
%计算感兴趣区域
%   此处显示详细说明

% img_in = imread('ILSVRC2017_test_00000237.jpg');
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


%%
%提取ROI区域
S = Sd_normalized;
level = get_th(S);
for i = 1:m
   for j = 1:n
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

