function [iou_value] = Iou(interest, gth)
%函数功能: 计算Iou值
%输入：感兴趣区域提取的中心坐标、面积，真实区域的中心坐标、面积
%       interest: 提取区域[x,y,w,h]
%       gth: 标注区域[x,y,w,h]
%输出：交并比值
    W = min(interest(1) + 0.5*interest(3),gth(1) + 0.5*gth(3)) - max(interest(1) - 0.5*interest(3),gth(1) - 0.5*gth(3));%交集的宽
    H = min(interest(2) + 0.5*interest(4),gth(2) + 0.5*gth(4)) - max(interest(2) - 0.5*interest(4),gth(2) - 0.5*gth(4));%交集的高
    %求Iou
    if W <= 0 || H <= 0
       iou_value = 0; 
    end
    S_interest = interest(3)*interest(4);%交集面积
    S_gth = gth(3)*gth(4);
    cross = W*H;
    iou_value = cross/(S_interest + S_gth - cross);
    end

