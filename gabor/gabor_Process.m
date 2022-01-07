function [Ig,Ig_sum] = gabor_Process(I,ksize,lambda,theta,phase,sigma,ratio)
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   theta������һ������
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

%ת����0-255
%
Ig_sum = (zeros(m,n));
for i = 1:L
    Ig_sum = Ig_sum + Ig(:,:,i);
    Ig(:,:,i) = ((255*Ig(:,:,i)/(max(max(Ig(:,:,i))))));
end
Ig_sum = (255*Ig_sum /max(max(Ig_sum)));
Ig = (Ig);
% Ig_sum = uint8((255*Ig_sum/(max(max(Ig_sum)))));

%ȥ���߽�
%ǰd�� ��d��= 0
for i = 1:d
    for j = 1:n
        Ig_sum(i,j) = 0;
        Ig_sum(m-i+1,j) = 0;
    end
end
%ǰd�� ��d��= 0
for j = 1:d
   for i = 1:m
      Ig_sum(i,j) = 0;
      Ig_sum(i,n-j+1) = 0;
   end
end
end

