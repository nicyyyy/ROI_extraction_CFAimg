function L = feature_flat(M)
%UNTITLED3 将矩阵展开成一维向量
%   此处显示详细说明
[m,n] = size(M);
L = zeros(1,m*n);

for i = 1:m
   for j = 1:n
      L((i - 1)*m + j) = M(i,j); 
   end
end
end

