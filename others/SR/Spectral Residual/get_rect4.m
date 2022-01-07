function [xMin, xMax, yMin, yMax] = get_rect4(BW)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
th = 0.98;
[m,n] = size(BW);
for i = 1:m
    for j = 1:n
        if(BW(m,n) ~= 0)
            BW(m,n) = 1;
        end
    end
end
%%
h = sum(BW,1);
%行，从前往后积分
h_sum_1 = zeros(n,1);
for j = 1:n
    h_sum_1(j) = sum(h(1:j));
end
%行，从后往前积分
h_sum_2 = zeros(n,1);
for j = 1:n
    h_sum_2(n-j+1) = sum(h(n-j+1:n));
end
% figure(8)
% subplot(1,2,1);plot(h_sum_1);title('从前往后');
% subplot(1,2,2);plot(h_sum_2);title('从后往前');

h_th = h_sum_1(n) *th;
for j = 1:n
   if(h_sum_1(j) >= h_th)
      xMax = j;
      break;
   end
end
for j = 1:n
    if(h_sum_2(n-j+1) >= h_th)
       xMin = n-j+1;
       break;
    end
end
%%
l = sum(BW,2);
%列，从前往后积分
l_sum_1 = zeros(m,1);
for i = 1:m
    l_sum_1(i) = sum(l(1:i));
end
%行，从后往前积分
l_sum_2 = zeros(m,1);
for i = 1:m
    l_sum_2(m-i+1) = sum(l(m-i+1:m));
end
% figure(9)
% subplot(1,2,1);plot(l_sum_1);title('从前往后');
% subplot(1,2,2);plot(l_sum_2);title('从后往前');

l_th = l_sum_1(m) *th;
for i = 1:m
   if(l_sum_1(i) >= l_th)
      yMax = i;
      break;
   end
end
for i = 1:m
    if(l_sum_2(m-i+1) >= l_th)
       yMin = m-i+1;
       break;
    end
end
% figure(11)
% subplot(1,2,1);plot(h);title('列向量求和')
% subplot(1,2,2);plot(l);title('行向量求和');
end

