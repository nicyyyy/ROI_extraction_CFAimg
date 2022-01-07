function [xMin, xMax, yMin, yMax] = get_rect5(imgin)
[m,n] = size(imgin);
%%
%求质心
cnt = 0;
x_sum = 0;
y_sum = 0;
for i = 1:m
   for j = 1:n
      if(imgin(i,j) == 1)
          cnt = cnt + 1;
          x_sum = x_sum + i;
          y_sum = y_sum + j;
      end
   end
end
x_center = x_sum/cnt;
y_center = y_sum/cnt;

%%
x_d = zeros(cnt,1);
y_d = zeros(cnt,1);
c = 1;
for i = 1:m
   for j = 1:n
      if(imgin(i,j) == 1)
         x_d(c) = abs(x_center - i); 
         y_d(c) = abs(y_center - j); 
         c = c + 1;
      end
   end
end

%%
x_mean = mean(x_d);
x_std = std(x_d);
y_mean = mean(y_d);
y_std = std(y_d);

x = x_mean + x_std;
y = y_mean + y_std;

yMin = floor(x_center - x);
yMax = floor(x_center + x);
xMin = floor(y_center - y);
xMax = floor(y_center + y);
% figure
% subplot(1,2,1);scatter([1:cnt],x_d,'x');
% subplot(1,2,2);scatter([1:cnt],y_d,'x');
end
