function [x,y,w,h,S] = get_ROI_SR(img_in)
%计算感兴趣区域
%   此处显示详细说明
[m,n] = size(img_in);
downsizeImg = imresize(img_in, 128/size(img_in, 2));

%% Spectral Residual
myFFT = fft2(downsizeImg);
myLogAmplitude = log(abs(myFFT));
myPhase = angle(myFFT);
mySpectralResidual = myLogAmplitude - imfilter(myLogAmplitude, fspecial('average', 3), 'replicate');
saliencyMap = abs(ifft2(exp(mySpectralResidual + 1i*myPhase))).^2;

%% After Effect
saliencyMap = mat2gray(imfilter(saliencyMap, fspecial('gaussian', [7, 7], 2.5)));
% saliencyMap = mat2gray(saliencyMap);
saliencyMap2 = imresize(saliencyMap,[m,n]);


%%
%提取ROI区域
S = saliencyMap2;
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

