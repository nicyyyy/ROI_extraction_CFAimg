function [xMin, xMax, yMin, yMax] = minboundrect(imgin)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%%%��תͼ������MER

[row, col] = size(imgin);
%%%�ж���С��Ӿ��εı߽�
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
    %%%�ж���С��Ӿ��εı߽�
    
    %%%�������
    
    %%%���浱ǰ��õ�MER
    
        xMin = xMinTest;
        yMin = yMinTest;
        xMax = xMaxTest;
        yMax = yMaxTest;
      
end

