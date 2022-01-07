function img_background_open_normalized_bio = prior_back(img_used,img_R,img_G,img_B,back_sg_size)
%UNTITLED 求背景抑制矩阵，四个角大小为输入尺寸的1/10，计算和每个角的特征相似程度（重复进行了提取了特征，后期优化）
%   back_suppresion：0-1之间
%%
%分割
[m,n] = size(img_used);
m0 = floor(m/back_sg_size);%分割大小
n0 = floor(n/back_sg_size);
img_used = imresize(img_used,[m0*back_sg_size,n0*back_sg_size]);
[m,n] = size(img_used);

img_sg = segmentation(img_used,[m0,n0]);
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
%%
%Lab颜色特征
[img_L,img_a,img_b] = RGB2Lab(img_R,img_G,img_B);
%颜色特征分块
img_L = imresize(img_L,[m0*(floor(m/m0) + 1),n0*(floor(n/n0) + 1)]);
img_a = imresize(img_a,[m0*(floor(m/m0) + 1),n0*(floor(n/n0) + 1)]);
img_b = imresize(img_b,[m0*(floor(m/m0) + 1),n0*(floor(n/n0) + 1)]);

img_L_sg = segmentation(img_L,[m0,n0]);
img_a_sg = segmentation(img_b,[m0,n0]);
img_b_sg = segmentation(img_a,[m0,n0]);

img_L_mean = zeros(1,sg_num);
img_a_mean = zeros(1,sg_num);
img_b_mean = zeros(1,sg_num);

%颜色特征均值
for i = 1:sg_num
    img_L_mean(i) = 1*mean(mean(img_L_sg(:,:,i)));
end
for i = 1:sg_num
    img_a_mean(i) = 1*mean(mean(img_a_sg(:,:,i)));
end
for i = 1:sg_num
    img_b_mean(i) = 1*mean(mean(img_b_sg(:,:,i)));
end
%%
%背景先验
%四个角：1，floor(n/n0),sg_num,sg_num - floor(n/n0)
left_top = 1;
right_top = floor(n/n0);
left_bottom = sg_num - floor(n/n0) + 1;
right_bottom = sg_num;

%求每个块到四个角的距离之和
% img_background = zeros(m0,n0,sg_num);
% for i = 1:sg_num
%     Distance_left_top = sqrt((sum(sum((img_gabor(:,:,i) -  img_gabor(:,:,left_top)).^2)) + (img_L_mean(i) - img_L_mean(left_top))^2 + (img_a_mean(i) - img_a_mean(left_top))^2 + (img_b_mean(i) - img_b_mean(left_top))^2));
%     Distance_right_top = sqrt((sum(sum((img_gabor(:,:,i) -  img_gabor(:,:,right_top)).^2)) + + (img_L_mean(i) - img_L_mean(right_top))^2 + (img_a_mean(i) - img_a_mean(right_top))^2 + (img_b_mean(i) - img_b_mean(right_top))^2));
%     Distance_left_bottom = sqrt((sum(sum((img_gabor(:,:,i) -  img_gabor(:,:,left_bottom)).^2)) + + (img_L_mean(i) - img_L_mean(left_bottom))^2 + (img_a_mean(i) - img_a_mean(left_bottom))^2 + (img_b_mean(i) - img_b_mean(left_bottom))^2));
%     Distance_right_bottom = sqrt((sum(sum((img_gabor(:,:,i) -  img_gabor(:,:,right_bottom)).^2)) + + (img_L_mean(i) - img_L_mean(right_bottom))^2 + (img_a_mean(i) - img_a_mean(right_bottom))^2 + (img_b_mean(i) - img_b_mean(right_bottom))^2));
%     temp = min([Distance_left_top,Distance_right_top,Distance_left_bottom,Distance_right_bottom]);
% %     temp = Distance_right_top;
%     for ii = 1:m0
%        for jj = 1:n0
%            img_background(ii,jj,i) = temp;
%        end
%     end  
% end

%%
img_background = zeros(m0,n0,sg_num);
%计算四个角的余弦相似度
CosSimilarity_left_top = zeros(1,sg_num);
CosSimilarity_right_top = zeros(1,sg_num);
CosSimilarity_left_bottom = zeros(1,sg_num);
CosSimilarity_right_bottom = zeros(1,sg_num);

%四个角的特征展开成一维
left_top_flat = [feature_flat(img_gabor(:,:,left_top)),img_L_mean(left_top),img_a_mean(left_top),img_b_mean(left_top)];
right_top_flat = [feature_flat(img_gabor(:,:,right_top)),img_L_mean(right_top),img_a_mean(right_top),img_b_mean(right_top)];
left_bottom_flat = [feature_flat(img_gabor(:,:,left_bottom)),img_L_mean(left_bottom),img_a_mean(left_bottom),img_b_mean(left_bottom)];
right_bottom_flat = [feature_flat(img_gabor(:,:,right_bottom)),img_L_mean(right_bottom),img_a_mean(right_bottom),img_b_mean(right_bottom)];

for i = 1:sg_num
   feature_temp = [feature_flat(img_gabor(:,:,i)),img_L_mean(i),img_a_mean(i),img_b_mean(i)];
   %计算各余弦相似度
   CosSimilarity_left_top(i) = CosSimilarity(feature_temp,left_top_flat);
   CosSimilarity_right_top(i) = CosSimilarity(feature_temp,right_top_flat);
   CosSimilarity_left_bottom(i) = CosSimilarity(feature_temp,left_bottom_flat);
   CosSimilarity_right_bottom(i) = CosSimilarity(feature_temp,right_bottom_flat);
   %取四个中的最大值
   temp = max([CosSimilarity_left_top(i),CosSimilarity_right_top(i),CosSimilarity_left_bottom(i),CosSimilarity_right_bottom(i)]);
   
    for ii = 1:m0
       for jj = 1:n0
           img_background(ii,jj,i) = temp;
       end
    end  
end
%画图，实际运行时注释掉
img_CosSimilarity_left_top = zeros(m0,n0,sg_num);
img_CosSimilarity_right_top = zeros(m0,n0,sg_num);
img_CosSimilarity_left_bottom = zeros(m0,n0,sg_num);
img_CosSimilarity_right_bottom= zeros(m0,n0,sg_num);
for k = 1:sg_num
   for i = 1:m0
      for j = 1:n0
          img_CosSimilarity_left_top(i,j,k) = CosSimilarity_left_top(k);
          img_CosSimilarity_right_top(i,j,k) = CosSimilarity_right_top(k);
          img_CosSimilarity_left_bottom(i,j,k) = CosSimilarity_left_bottom(k);
          img_CosSimilarity_right_bottom(i,j,k) = CosSimilarity_right_bottom(k);
      end
   end
end
img_CosSimilarity_left_top_open = opening(img_CosSimilarity_left_top,[m,n]); 
img_CosSimilarity_right_top_open = opening(img_CosSimilarity_right_top,[m,n]); 
img_CosSimilarity_left_bottom_open = opening(img_CosSimilarity_left_bottom,[m,n]); 
img_CosSimilarity_right_bottom_open = opening(img_CosSimilarity_right_bottom,[m,n]); 
% figure('name','余弦相似度')
% subplot(2,2,1);imagesc(img_CosSimilarity_left_top_open);%title('左上');
% subplot(2,2,2);imagesc(img_CosSimilarity_right_top_open);%title('右上');
% subplot(2,2,3);imagesc(img_CosSimilarity_left_bottom_open);%title('左下');
% subplot(2,2,4);imagesc(img_CosSimilarity_right_bottom_open);%title('右下');
%%
img_background_open = opening(img_background,[m,n]);
img_background_open_normalized = figure_normalize(img_background_open);
img_background_open_normalized = 1 - img_background_open_normalized;
%%
%二值化
img_background_open_normalized_bio = zeros(m,n);
level = 0.4*max(max(img_background_open_normalized));
for i = 1:m
   for j = 1:n
       if(img_background_open_normalized(i,j) >= level)
           img_background_open_normalized_bio(i,j) = 1;
       else
           img_background_open_normalized_bio(i,j) = 0;
       end
   end
end
end

