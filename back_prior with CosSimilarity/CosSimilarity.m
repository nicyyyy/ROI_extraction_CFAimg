function cos1 = CosSimilarity(m1,m2)
%UNTITLED2 计算m1向量和m2向量的余弦值
%   此处显示详细说明
A=sqrt(sum(sum(m1.^2)));
B=sqrt(sum(sum(m2.^2)));
C=sum(sum(m1.*m2));
cos1=C/(A*B);%计算余弦值
end

