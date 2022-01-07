clear
clc

%% Read image from file
inImg = im2double(rgb2gray(imread('img4.JPG')));
[m,n] = size(inImg);
downsizeImg = imresize(inImg, 128/size(inImg, 2));

%% Spectral Residual
myFFT = fft2(downsizeImg);
myLogAmplitude = log(abs(myFFT));
myPhase = angle(myFFT);
mySpectralResidual = myLogAmplitude - imfilter(myLogAmplitude, fspecial('average', 3), 'replicate');
saliencyMap = abs(ifft2(exp(mySpectralResidual + i*myPhase))).^2;

%% After Effect
saliencyMap = mat2gray(imfilter(saliencyMap, fspecial('gaussian', [7, 7], 2.5)));
% saliencyMap = mat2gray(saliencyMap);
saliencyMap2 = imresize(saliencyMap,[m,n]);
figure(1)
imshow(saliencyMap2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%聚类
% %
% A = reshape(saliencyMap2,m*n,1);
% res = kmeans(A,2);
% kmeansresult = reshape(res,m,n);
% %前景背景判断
% num = m*n*2/3;%一类超过2/3，认为是背景
% cnt = 0;
% for i = 1:m
%     for j = 1:n
%        if(kmeansresult(m,n) == 2) 
%            cnt = cnt + 1;
%        end
%     end
% end
% if(cnt >= num)
%     kmeansresult = (kmeansresult - 3)*(-1);
% end
% %二值化
% kmeansresultth = (kmeansresult - 1)*255;
% figure(3)
% imshow(kmeansresultth)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%阈值分割
% BW = imbinarize(saliencyMap2, 0.3);
level = get_th(saliencyMap2);
BW = saliencyMap2;
for i = 1:m
   for j = 1:n
      if(BW(i,j) <= 0.3) 
          BW(i,j) = 0;
      else
          BW(i,j) = 255;
      end
   end
end
figure(6)
imshow(BW)
figure(7)
imhist(saliencyMap2)
%求最小外接矩形
%[XLU,YLU,XLD,YLD,XRU,YRU,XRD,YRD,typicalAngle] = minboundrect(kmeansresultth);

%从rectx中提取感兴趣区域
% mm = XRU - XLU;
% nn = YLU - YLD;
% grabimg = zeros(mm,nn);
% for i =1:mm
%     for j = 1:nn
%     grabimg(i,j) = inImg(XLU+i-1,YLU+j-1);
%     end
% end


[xMin, xMax, yMin, yMax] = get_rect4(BW);
rectx = [xMin, xMax, xMax, xMin, xMin];
recty = [yMax, yMax, yMin, yMin, yMax];
figure(4)
imshow(inImg);
line(rectx(:),recty(:),'color','r');


% [xMin, xMax, yMin, yMax] = get_rect2(saliencyMap2);

nn = xMax - xMin;
mm = yMax - yMin;
grabimg = zeros(mm,nn);
for i =1:mm
    for j = 1:nn
    grabimg(i,j) = inImg(yMin+i-1,xMin+j-1);
    end
end
figure(5)
subplot(1,2,1);imshow(inImg);title('原图');
subplot(1,2,2);imshow(grabimg);title('提取后');