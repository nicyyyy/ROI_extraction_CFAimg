function Out_image = figure_normalize(In_image)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
o_max_image = max(max(In_image));
o_min_image = min(min(In_image));
Out_image = double(In_image - o_min_image)/double(o_max_image - o_min_image);
end

