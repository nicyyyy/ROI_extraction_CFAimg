%%��ȡ�ļ���д�ļ�
%ͼ���ļ���·��
file_path = 'F:\����ͼ����\�����Լ��\MSRA\img_yuan\';
save_path = 'F:\����ͼ����\�����Լ��\saliencymaps\HC\';
%��ȡ���ļ���������jpg��ʽ��ͼ��
img_path_list = dir(strcat(file_path,'*.jpg'));
%��ȡͼ���������
img_num = length(img_path_list);
tic
for j = 1:img_num
    img_name = img_path_list(j).name;
    img = HC(strcat(file_path,img_name));
    imwrite(img, strcat(save_path,img_name));
end
toc