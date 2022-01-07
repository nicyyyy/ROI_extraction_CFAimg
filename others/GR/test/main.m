clc
clear
%%
%路径设置
image_path = {'D:\1_毕业设计\数据集\车的\白色车\'};
label_path = {'D:\1_毕业设计\数据集\车的\白色车\white_car.mat'};
save_path = {'D:\1_毕业设计\数据集\车的\白色车\白色车处理后\'};
%
Iou_value_means = zeros(length(image_path),1);%各种场景分别的Iou均值

%%
file_num = length(image_path);
if file_num > 0
    %%
    for k = 1:file_num
        %批量读取文件夹中的图片
        img_path_list = dir(strcat(cell2mat(image_path(k)),'*.jpg'));
        %判断图片数量
        img_num = length(img_path_list);
        %存放每张图片的Iou值
        Iou_value = zeros(img_num,1);
        %存放每张图片的ROI区域
        ROI_value = zeros(img_num,4);
        
        %%
        %加载标注
        [center_local] = Gth(cell2mat(label_path(k)));
        %判断标注数量和图片数量是否一致
        if img_num ~= size(center_local,1)
            break;
        end
        %%
        %处理图片
        for img_cnt = 1:img_num
            %屏幕显示 
            clc
            str = sprintf('第%d个场景，%d/%d',k,img_cnt,img_num);
            disp(str);
            %读取图片并转化为raw图像
            img_name = img_path_list(img_cnt).name;
            inImg = imread(strcat(cell2mat(image_path(k)),img_name));
            Img_gray = rgb2gray(inImg);
    
            
            %计算感兴趣区域
            [x,y,w,h] = get_ROI_HC(inImg);
            ROI_value(img_cnt,:) = [x,y,w,h];
            
            %画矩形框
%             img_ROI = drawRectangleFrame(inImg,ROI_value(img_cnt,1:2),ROI_value(img_cnt,3:4));
%             figure(3)
%             imshow(uint8(img_ROI));
            img_ROI = inImg((y-floor(h/2)):(y+floor(h/2)),(x-floor(w/2)):(x+floor(w/2)),:);
            %计算Iou值
            Iou_value(img_cnt) = Iou(ROI_value(img_cnt,:),center_local(img_cnt,:));
            
            %保存图片
%             max_out = max(max(img_ROI));
%             min_out = min(min(img_ROI));
%             img_ROI = double(img_ROI - min_out)./double(max_out - min_out);
            imwrite(img_ROI,strcat(cell2mat(save_path(k)),img_name));
        end
        %%
        %保存Iou和ROI
        save(strcat(cell2mat(save_path(k)),num2str(k),'_Iou.mat'),'Iou_value');
        save(strcat(cell2mat(save_path(k)),num2str(k),'_ROI.mat'),'ROI_value');
        %计算每个场景的Iou均值
        Iou_value_means(k) = mean(Iou_value);
        figure(k)
        scatter([1:1:img_num],Iou_value,'filled','MarkerFaceAlpha',.5);
        grid on;
        box off;
        ax = gca;
        saveas(ax,strcat(cell2mat(save_path(k)),'Iou_plot.jpg'));
    end
end