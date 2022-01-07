function TH = get_th(saliencyMap2)
%%�������� �����ײв�Ͷ�ֱ��ʷ���������Ŀ����_������ ����������ͼ�ķָ���ֵ
%saliencyMap2��TH����0��1֮��
[counts,binl] = imhist((saliencyMap2),256);
% figure(12)
% stem(binl,counts)

f = counts./sum(counts);
E = sum(binl.*f);
S = sqrt(sum((binl-E).*(binl-E).*f));
TH = (E+S)*1.3;
end