function [x,y,w,h] = get_ROI(img_in)
%计算感兴趣区域
%   此处显示详细说明

[m0,n0] = size(img_in);

w = fspecial('gaussian',[25,25],10);
img_pyramid_2 = imresize(imfilter(img_in,w,'replicate'),0.2);
[m,n] = size(img_pyramid_2);

ksize = 40;
lambda = 10;%正弦函数波长，通常大于等于2，但是不能超过输入图像尺寸的1/5
theta = [0,pi/6,pi/3,pi/2,pi*2/3,pi*5/6];
phase = 0;
sigma = 2*pi;%带宽，高斯函数的标准差，通常取2pi
ratio = 0.5;%空间的宽高比，决定gabor函数形状的椭圆率，等于1时是圆形，小于1是，形状随着平行条纹方向而拉长，通常取值0.5

[I_gabor,I_gabor_sum] = gabor_Process(img_pyramid_2,ksize,lambda,theta,phase,sigma,ratio);

%%
%特征融合
saliencyMap = I_gabor_sum;
% figure(1)
% imshow(uint8(saliencyMap))

%%
%阈值分割
level = get_th(saliencyMap);
BW = saliencyMap;
for i = 1:m
   for j = 1:n
      if(BW(i,j) <= level) 
          BW(i,j) = 0;
      else
          BW(i,j) = 255;
      end
   end
end
BW = imresize(BW,[m0,n0]);
% figure(2)
% imshow(uint8(BW))
%%
%ROI提取
[xMin, xMax, yMin, yMax] = minboundrect(BW);
x = round((xMin+xMax)/2);
y = round((yMin+yMax)/2);
w = round(xMax - xMin);
h = round(yMax - yMin);
end

