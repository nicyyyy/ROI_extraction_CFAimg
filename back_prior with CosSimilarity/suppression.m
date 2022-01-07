function W = suppression(m,n)
%UNTITLED 生成抑制矩阵，
%   [m,n] 大小

x0 = m/2;
y0 = n/2;
W = zeros(m,n);
for i = 1:m
   for j = 1:n
       W(i,j) = exp(-((i - x0)^2)/(m/2)^2-((j - y0)^2)/(n/2)^2);
   end
end
W = figure_normalize(W);
end

