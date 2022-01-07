function [xMin, xMax, yMin, yMax] = get_rect2(saliencyMap2)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
[m,n] = size(saliencyMap2);

% sod1 = diff(saliencyMap2,2,1);%
sod1 = zeros(m,n);
for i = 1:m
   for j = 2:n-1
       sod1(i,j) = abs(saliencyMap2(i,j+1) - 2*saliencyMap2(i,j) + saliencyMap2(i,j-1));
   end
end

%sod2 = diff(saliencyMap2,2,2);%
sod2 = zeros(m,n);
for i = 2:m-1
   for j = 1:n
       sod2(i,j) = abs(saliencyMap2(i+1,j) - 2*saliencyMap2(i,j) + saliencyMap2(i-1,j));
   end
end
figure(10)
subplot(1,2,1);imshow(mat2gray(sod1));title('sod1');
subplot(1,2,2);imshow(mat2gray(sod2));title('sod2');

m1 = floor(m/3);
m2 = floor(2*m/3);
n1 = floor(n/3);
n2 = floor(2*n/3);


L = zeros(m,1);
for i = 1:m
    hmax =[sod1(i,1),1];
    for j = 1:n1-1
        if(hmax(1) <= sod1(i,1+j)) 
            hmax = [sod1(i,1+j),1+j]; 
        end
    end
   L(i) = hmax(2);
end
xMin = max(L);

for i = 1:m
    hmax =[ sod1(i,n2),n2];
    for j = n2:n-1
        if(hmax(1) <= sod1(i,1+j)) 
            hmax = [sod1(i,1+j),1+j]; 
        end
    end
   L(i) = hmax(2);
end
xMax = min(L);


%%%%%%%%
D = zeros(n,1);
for j = 1:n
    lmax =[ sod2(1,j),1];
    for i = 1:m1-1
        if(lmax(1) <= sod2(1+i,j)) 
            lmax = [sod2(1+i,j),1+i]; 
        end
    end
   D(j) = lmax(2);
end
yMin = max(D);

for j = 1:n
    lmax =[ sod2(m2,j),m2];
    for i = m2:m-1
        if(lmax(1) <= sod2(1+i,j)) 
            lmax = [sod2(1+i,j),1+i]; 
        end
    end
   D(j) = lmax(2);
end
yMax = min(D);


figure(10)

rectx = [xMin, xMax, xMax, xMin, xMin];
recty = [yMax, yMax, yMin, yMin, yMax];
subplot(1,2,1);imshow(mat2gray(sod1));line(rectx(:),recty(:),'color','r');title('sod1');
subplot(1,2,2);imshow(mat2gray(sod2));line(rectx(:),recty(:),'color','r');title('sod2');
end

