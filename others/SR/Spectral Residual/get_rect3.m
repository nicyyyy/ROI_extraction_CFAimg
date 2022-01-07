function [xMin, xMax, yMin, yMax] = get_rect3(saliencyMap2)
[m,n] = size(saliencyMap2);
h = mean(saliencyMap2,2);
l = mean(saliencyMap2,1);

m1 = floor(m/3);
m2 = floor(2*m/3);
n1 = floor(n/3);
n2 = floor(2*n/3);

lmax =[l(1),1];
for i = 1:n1-1
   if(lmax(1) <= l(i+1))
      lmax = [l(i+1),i+1]; 
   end
end
xMin = lmax(2);

lmax =[l(n2),n2];
for i = n2:n-1
   if(lmax(1) <= l(i+1))
      lmax = [l(i+1),i+1]; 
   end
end
xMax = lmax(2);

hmax = [h(1),1]; 
for j = 1:m1-1
    if(hmax(1) <= h(j+1))
       hmax = [h(j+1),j+1]; 
    end
end
yMin = hmax(2);

hmax = [h(m2),m2]; 
for j = m2:m-1
    if(hmax(1) <= h(j+1))
       hmax = [h(j+1),j+1]; 
    end
end
yMax = hmax(2);
figure(10)
subplot(1,2,1);plot(h);title('h');
subplot(1,2,2);plot(l);title('l');
end