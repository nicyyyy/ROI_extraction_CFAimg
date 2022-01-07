function [x,y,w,h,S_out] = get_ROI_CA(file_names)
%计算感兴趣区域
%   此处显示详细说明
n = 1920;
m = 1080;

MOV = saliency(file_names);
%%
%提取ROI区域
S = MOV{1}.SaliencyMap;
S = imresize(S,[m,n]);
S_out = S;
level = get_th(S);
for i = 1:m
   for j = 1:n
      if(S(i,j) <= level) 
         S(i,j) = 0;
      else
         S(i,j) = 1;
      end
   end
end
Se = strel('square',20);
S = imerode(S,Se);

[xMin, xMax, yMin, yMax] = minboundrect(S);
x = round((xMin+xMax)/2);
y = round((yMin+yMax)/2);
w = round(xMax - xMin);
h = round(yMax - yMin);
end

