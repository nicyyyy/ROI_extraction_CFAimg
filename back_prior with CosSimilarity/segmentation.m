function img_sg = segmentation(img_in,sg_size)
%UNTITLED3 分割图像
%    img_in：输入图像
%    sg_size: [m0,n0],分割成m0*n0
[m,n] = size(img_in);
m0 = sg_size(1);
n0 = sg_size(2);
x_num = floor(m/m0);
y_num = floor(n/n0);

img_sg = zeros(m0,n0,x_num*y_num);
% count = 1;
for i = 1:x_num
   for j = 1:y_num
      img_sg(:,:,(j - 1)*y_num + i) =  img_in((i*m0 - m0 + 1):i*m0,(j*n0 - n0 + 1):j*n0);
%      subplot(x_num,y_num,count);
%      imshow(uint8(img_sg(:,:,(j - 1)*y_num + i)));
%      set(gca,'XTick',[],'YTick',[]);
%      set(gca,'box','on');
%      count = count+1;
   end
end
end

