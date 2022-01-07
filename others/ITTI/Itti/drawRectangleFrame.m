function grabimg = drawRectangleFrame(image,windowLocation,windowSize)
%输入：图片，region =[中心坐标(x,y)，宽、高]
% [row,col] = size(image); % 输入图像尺寸
% line_wide = 10;
% x = windowLocation(1) - round(windowSize(1)/2);%矩形框位置坐标，其格式为[x,y]
% y = windowLocation(2) - round(windowSize(2)/2);
% height = windowSize(2);%矩形框尺寸，其格式为[height,width]，即[高度,宽度]
% width = windowSize(1);
% if((x<=row && y<=col)&&(height<=row && width<=col))
%     LabelLineColor = 255;          % 标记线颜色
%     img_ROI = image;
%     topMost = y;                  % 矩形框上边缘
%     botMost = y+height;        % 矩形框下边缘
%     lefMost = x;                  % 矩形框左边缘
%     rigMost = x+width;        % 矩形框右边缘
%     for i = 1:line_wide
%     img_ROI(topMost+i-1:botMost-i+1,lefMost+i-1,:) = LabelLineColor; % 左边框
%     img_ROI(topMost+i-1:botMost-i+1,rigMost-i+1,:) = LabelLineColor; % 右边框
%     img_ROI(topMost+i-1,lefMost+i-1:rigMost-i+1,:) = LabelLineColor; % 上边框
%     img_ROI(botMost-i+1,lefMost+i-1:rigMost-i+1,:) = LabelLineColor; % 下边框
%     end
% end
w = windowSize(1);
h = windowSize(2);
xMin = windowLocation(2) - floor(h/2);
yMin = windowLocation(1) - floor(w/2); 
grabimg = zeros(h,w);
for i =1:h
    for j = 1:w
    grabimg(i,j) = image(xMin+i-1,yMin+j-1);
    end
end
end