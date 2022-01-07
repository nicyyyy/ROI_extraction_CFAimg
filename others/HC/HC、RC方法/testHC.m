%%读取文件，写文件
%图像文件夹路径
file_path = 'F:\数字图像处理\显著性检测\MSRA\img_yuan\';
save_path = 'F:\数字图像处理\显著性检测\saliencymaps\HC\';
%获取该文件夹中所有jpg格式的图像
img_path_list = dir(strcat(file_path,'*.jpg'));
%获取图像的总数量
img_num = length(img_path_list);
tic
for j = 1:img_num
    img_name = img_path_list(j).name;
    img = HC(strcat(file_path,img_name));
    imwrite(img, strcat(save_path,img_name));
end
toc