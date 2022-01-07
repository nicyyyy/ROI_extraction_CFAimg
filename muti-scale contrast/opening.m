function img_op = opening(img_sg,op_size)
%UNTITLED5 把分块的图像合并成一张图
%   img_sg：分块的图像
%   op_size：合并后的尺寸
[m0,n0,sg_num] = size(img_sg);
m = op_size(1);
n = op_size(2);
img_op = zeros(m,n);
x_num = floor(m/m0);
y_num = floor(n/n0);

for i = 1:x_num
   for j = 1:y_num
       img_op((i*m0 - m0 + 1):i*m0,(j*n0 - n0 + 1):j*n0) = img_sg(:,:,(j - 1)*y_num + i);
   end
end
end

