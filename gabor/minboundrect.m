function [xMin, xMax, yMin, yMax] = minboundrect(imgin)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%%%旋转图像求其MER

[row, col] = size(imgin);
%%%判断最小外接矩形的边界
    for i = 1 : row
        if sum(imgin(i, :)) > 255
            break;
        end
    end
    yMinTest = i;
    
    for i = row : -1 : 1
        if sum(imgin(i, :)) > 255
            break;
        end
    end
    yMaxTest = i;
    
    for i = 1 : col
        if sum(imgin(:, i)) > 255
            break;
        end
    end
    xMinTest = i;
    
    for i = col : -1 : 1
        if sum(imgin(:, i)) > 255
            break;
        end
    end
    xMaxTest = i;
    %%%判断最小外接矩形的边界
    
    %%%计算面积
    
    %%%保存当前求得的MER
    
        xMin = xMinTest;
        yMin = yMinTest;
        xMax = xMaxTest;
        yMax = yMaxTest;
      
end

