function Sd_normalized = Sd_cmp(Sd_1,Sd_2,Sd_3,sg_size,open_size)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
[m,n,sg_num] = size(Sd_2);
d_max = sqrt(2*(sg_num - 1)^2);
Sd = zeros(m,n,sg_num);

for k = 1:sg_num
    temp = 0;
    xk = floor(k/sg_size) + 1;
    yk = k - floor(k/sg_size)*sg_size;
   for p = 1:sg_num
       %计算k与p之间的距离
       xp = floor(p/sg_size) + 1;
       yp = p - floor(p/sg_size)*sg_size;
       d_kp = sqrt((xk - xp)^2 + (yk - yp)^2);
       w = d_kp/d_max;
       
       %计算显著度
       temp = temp + w*(2*Sd_2(1,1,k) - Sd_1(1,1,p) - Sd_3(1,1,p));
   end
   for ii = 1:m
       for jj = 1:n
           Sd(ii,jj,k) = temp;
       end
   end
end
m2 = open_size(1);
n2 = open_size(2);
Sd_open = opening(Sd,[m2,n2]);
Sd_normalized = figure_normalize(Sd_open);
end

