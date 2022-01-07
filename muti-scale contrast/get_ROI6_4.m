function [x,y,w,h] = get_ROI6_4(img_in)
%计算感兴趣区域
%   此处显示详细说明
% img_in = imread('tc200_10m_cc (10).jpg');
img_in_gray = rgb2gray(img_in);
[m_init,n_init,c] = size(img_in);%初始大小

%%
%下采样
w=fspecial('gaussian',[7 7]);
%灰度图
img_2 = imresize(imfilter(img_in_gray,w),[floor(m_init/2) floor(n_init/2)]);
img_3 = imresize(imfilter(img_2,w),[floor(m_init/4) floor(n_init/4)]);
img_4 = imresize(imfilter(img_3,w),[floor(m_init/8) floor(n_init/8)]);
img_5 = imresize(imfilter(img_4,w),[floor(m_init/16) floor(n_init/16)]);
img_6 = imresize(imfilter(img_5,w),[floor(m_init/32) floor(n_init/32)]);

%RGB
img_R=img_in(:,:,1);
img_G=img_in(:,:,2);
img_B=img_in(:,:,3);

imgR_2 = imresize(imfilter(img_R,w),[floor(m_init/2) floor(n_init/2)]);
imgR_3 = imresize(imfilter(imgR_2,w),[floor(m_init/4) floor(n_init/4)]);
imgR_4 = imresize(imfilter(imgR_3,w),[floor(m_init/8) floor(n_init/8)]);
imgR_5 = imresize(imfilter(imgR_4,w),[floor(m_init/16) floor(n_init/16)]);
imgR_6 = imresize(imfilter(imgR_5,w),[floor(m_init/32) floor(n_init/32)]);

imgG_2 = imresize(imfilter(img_G,w),[floor(m_init/2) floor(n_init/2)]);
imgG_3 = imresize(imfilter(imgG_2,w),[floor(m_init/4) floor(n_init/4)]);
imgG_4 = imresize(imfilter(imgG_3,w),[floor(m_init/8) floor(n_init/8)]);
imgG_5 = imresize(imfilter(imgG_4,w),[floor(m_init/16) floor(n_init/16)]);
imgG_6 = imresize(imfilter(imgG_5,w),[floor(m_init/32) floor(n_init/32)]);

imgB_2 = imresize(imfilter(img_B,w),[floor(m_init/2) floor(n_init/2)]);
imgB_3 = imresize(imfilter(imgB_2,w),[floor(m_init/4) floor(n_init/4)]);
imgB_4 = imresize(imfilter(imgB_3,w),[floor(m_init/8) floor(n_init/8)]);
imgB_5 = imresize(imfilter(imgB_4,w),[floor(m_init/16) floor(n_init/16)]);
imgB_6 = imresize(imfilter(imgB_5,w),[floor(m_init/32) floor(n_init/32)]);

%%
sg_size = 15;

[Sd_4,Sd_4_open] = get_saliency(img_4,sg_size);
[Sd_5,Sd_5_open] = get_saliency(img_5,sg_size);
[Sd_6,Sd_6_open] = get_saliency(img_6,sg_size);

Sd_4_open_normalized = figure_normalize(Sd_4_open);
Sd_5_open_normalized = figure_normalize(Sd_5_open);
Sd_6_open_normalized = figure_normalize(Sd_6_open);
% figure('name','显著图')
% subplot(1,3,1);imshow(Sd_4_open_normalized,[])
% subplot(1,3,2);imshow(Sd_5_open_normalized,[])
% subplot(1,3,3);imshow(Sd_6_open_normalized,[])

Sd = Sd_cmp(Sd_4,Sd_5,Sd_6,sg_size,size(Sd_5_open));
% figure
% imshow(Sd,[])

%%
[m,n] = size(Sd_5_open);
%背景先验
% back_sg_size = 5;
% back_suppresion_4 = prior_back(img_4,imgR_4,imgG_4,imgB_4,back_sg_size);
% back_suppresion_5 = prior_back(img_5,imgR_5,imgG_5,imgB_5,back_sg_size);
% back_suppresion_6 = prior_back(img_6,imgR_6,imgG_6,imgB_6,back_sg_size);
% % figure('name','背景先验')
% % subplot(1,3,1);imshow(back_suppresion_4,[])
% % subplot(1,3,2);imshow(back_suppresion_5,[])
% % subplot(1,3,3);imshow(back_suppresion_6,[])
% 
% back_suppresion_4 = imresize(back_suppresion_4,[m,n]);
% back_suppresion_5 = imresize(back_suppresion_5,[m,n]);
% back_suppresion_6 = imresize(back_suppresion_6,[m,n]);
% 
% back_suppresion = back_suppresion_4.*back_suppresion_5.*back_suppresion_6;
% figure
% imshow(back_suppresion)
%抑制矩阵
W = suppression(m,n);
%%
S = W.*Sd;
S_resize = imresize(S,[m_init,n_init]);
% figure
% imshow(S_resize);

level = get_th(S_resize);
for i = 1:m_init
   for j = 1:n_init
      if(S_resize(i,j) <= level) 
         S_resize(i,j) = 0;
      else
         S_resize(i,j) = 1;
      end
   end
end
Se = strel('square',20);
S_resize = imerode(S_resize,Se);
[xMin, xMax, yMin, yMax] = get_rect5(S_resize);
x = round((xMin+xMax)/2);
y = round((yMin+yMax)/2);
w = round(xMax - xMin);
h = round(yMax - yMin);
end

