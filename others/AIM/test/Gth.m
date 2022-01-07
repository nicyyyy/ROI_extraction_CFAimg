function [center_local] = Gth(path)
%函数功能： 计算标注区域中心坐标、宽度、长度
%   center_local = [x,y,w,h];
    roi_info = load(path);
    image_counts = size(roi_info.gTruth.LabelData,1);
    %转换成普通数组
    array = table2array(roi_info.gTruth.LabelData);
    array_end = cell2mat(array);
    %存放矩形的中心坐标、面积
    center_local = zeros(image_counts,4);
    %对每张图像依次处理，获取标注矩形区域信息
    for i = 1:image_counts
        x_c = round(array_end(i,1) + array_end(i,3)/2);
        y_c = round(array_end(i,2) + array_end(i,4)/2);
        center_local(i,1) = x_c;
        center_local(i,2) = y_c;
        center_local(i,3) = array_end(i,3);%宽度
        center_local(i,4) = array_end(i,4);%高度
    end
end

