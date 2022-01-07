function [xMin, xMax, yMin, yMax] = get_rect(saliencyMap2)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
[m,n] = size(saliencyMap2);
h = std(saliencyMap2,0,2);%行向量方�?
l = std(saliencyMap2,0,1);%列向量方�?
figure(10)
subplot(2,2,1);stem(h);title('行向量方�?');
subplot(2,2,3);stem(l);title('列向量方�?');

%�?阶导�?
hh = diff(h);
ll = diff(l);
subplot(2,2,2);stem(hh);title('行向量方差一阶导');
subplot(2,2,4);stem(ll);title('列向量方差一阶导');

% %二阶导数
% hhh = diff(hh);
% lll = diff(ll);
% subplot(2,3,3);stem(hhh);title('行向量方差二阶导');
% subplot(2,3,6);stem(lll);title('列向量方差二阶导');

%中心点，方差的最大�?�处
hmax =[ h(1),1];%行的�?大�??
for i = 1:(m-1)
   if(hmax(1) <= h(1+i)) 
      hmax = [h(1+i),1+i]; 
   end
end

lmax =[ l(1),1];%列的�?大�??
for i = 1:(n-1)
   if(lmax(1) <= l(1+i)) 
      lmax = [l(1+i),1+i]; 
   end
end

%确定宽度，方差一阶导的最大最小�?�处
hhmax =[ hh(1),1];%行的�?大�??
for i = 1:(m-2)
   if(hhmax(1) <= hh(1+i)) 
      hhmax = [hh(1+i),1+i]; 
   end
end
hhmin =[ hh(1),1];%行的�?小�??
for i = 1:(m-2)
   if(hhmin(1) >= hh(1+i)) 
      hhmin = [hh(1+i),1+i]; 
   end
end

llmax =[ ll(1),1];%列的�?大�??
for i = 1:(n-2)
   if(llmax(1) <= ll(1+i)) 
      llmax = [ll(1+i),1+i]; 
   end
end
llmin =[ ll(1),1];%列的�?小�??
for i = 1:(n-2)
   if(llmin(1) >= ll(1+i)) 
      llmin = [ll(1+i),1+i]; 
   end
end

xMin = llmax(2);
xMax = llmin(2);
yMin = hhmax(2);
yMax = hhmin(2);
end

