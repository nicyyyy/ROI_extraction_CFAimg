function g = gabor_func(ksize,lambda,theta,phase,sigma,ratio)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
d = ksize/2;
g = zeros(ksize,ksize);
for x = 1:ksize
   xd = x- d;%distance from the center
   for y = 1:ksize
      yd = y - d;
      xn = xd*cos(theta) + yd*sin(theta);
      yn = -xd*sin(theta) + yd*cos(theta);
      g(x,y) = exp(-(xn^2 + ratio^2*yn^2)/(2*sigma^2))*exp(1i*(2*pi*xn/lambda+phase));
   end
end
end

