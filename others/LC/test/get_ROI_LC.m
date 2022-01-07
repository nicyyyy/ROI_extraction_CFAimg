function [x,y,w,h,S] = get_ROI_LC(img_in)
%计算感兴趣区域
%   此处显示详细说明
[m n z]=size(img_in);
img_in=rgb2gray(img_in);
zj=zeros(1,256);
dist=zeros(1,256);
hist_im=imhist(img_in); %计算直方图
sum=0;
figure;
bar(hist_im);%画直方图
for i=1:256
    for j=1:256
        sum=sum+(abs(i-j)*hist_im(j))^2; %论文中的公式。每个像素到其他像素的欧氏距离和      
    end
    zj(i)=sum^0.5;
    sum=0;
end
figure;
 bar(zj);%画直方图     
 small=min(zj);
 big=max(zj);
 ddist=big-small;
 for i=1:256
        dist(i) = (zj(i)-small)/ddist*256;		%归一化直方图
 end	    
 
 for a=1:m
     for b=1:n
         for z=1:255
             if img_in(a,b)==z
                 img_in(a,b)=dist(z);%计算每个像素的显著值
                 break;
             end
         end
     end
 end
 img_in=mat2gray(img_in);


%%
%提取ROI区域
S = img_in;
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

