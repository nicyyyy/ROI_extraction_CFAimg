function TH = get_th(saliencyMap2)
%%根据文献 基于谱残差和多分辨率分析的显著目标检测_刘娟妮 计算显著性图的分割阈值
%saliencyMap2和TH都在0到1之间
[counts,binl] = imhist((saliencyMap2),256);
% figure(12)
% stem(binl,counts)

f = counts./sum(counts);
E = sum(binl.*f);
S = sqrt(sum((binl-E).*(binl-E).*f));
TH = (E+S)*1.3;
end