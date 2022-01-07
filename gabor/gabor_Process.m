function [Ig,Ig_sum] = gabor_Process(I,ksize,lambda,theta,phase,sigma,ratio)
%UNTITLED3 此处显示有关此函数的摘要
%   theta可以是一个向量
[m,n] = size(I);
d = ksize /2;

%pad image
Ip = zeros(m+ksize,n+ksize);
Ip(d+1:d+m,d+1:d+n) = I;

L = length(theta);
Ig = zeros(m,n,L);

for i = 1:L
    g = real(gabor_func(ksize,lambda,theta(i),phase,sigma,ratio));
    for x = 1:m
       for y = 1:n
          Ig(x,y,i) = abs(sum(sum(Ip(x:x + ksize - 1,y:y + ksize - 1).*g))); 
       end
    end
end

%转换到0-255
%
Ig_sum = (zeros(m,n));
for i = 1:L
    Ig_sum = Ig_sum + Ig(:,:,i);
    Ig(:,:,i) = ((255*Ig(:,:,i)/(max(max(Ig(:,:,i))))));
end
Ig_sum = (255*Ig_sum /max(max(Ig_sum)));
Ig = (Ig);
% Ig_sum = uint8((255*Ig_sum/(max(max(Ig_sum)))));

%去除边界
%前d行 后d行= 0
for i = 1:d
    for j = 1:n
        Ig_sum(i,j) = 0;
        Ig_sum(m-i+1,j) = 0;
    end
end
%前d列 后d列= 0
for j = 1:d
   for i = 1:m
      Ig_sum(i,j) = 0;
      Ig_sum(i,n-j+1) = 0;
   end
end
end

