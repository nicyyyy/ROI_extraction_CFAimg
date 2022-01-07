% 要求
% 1：为保证程序运行速度，图片的分辨率最好统一调整为320x180的，不可设置的乱七八糟；
% 2：数字的状态保持一致，都竖着或者都横着（指的是数字），这样准确度更高；
% 3：当现场写的数字A要进行匹配时，只需修改picture2这一项图片的名字即可，其他不需修改；
% 4：图像的路径在程序中已标明，可自主改变，保证完美运行即可，可适当修改；
% 5：目前，从30张中任选一张，能判断到底是ABC这三个人谁写的，具体你可以自己再实验。
% 6：将ABC三位同学的笔迹分别编号为1-10、11-20、21-30，后缀为“.jpg”
clc;
img=('D:\MatlabProject\image\');  
picture2=imread('D:\MatlabProject\16.jpg');
picture2=rgb2gray(picture2);
judgement=90;
j=0;

for i=1:30
    picture1=(imread([img,num2str(i),'.jpg']));
    picture1=rgb2gray(picture1);
%     subplot(6,5,i),imshow(picture1);
    result=ImageRecognition(picture1,picture2);
    if(result<=judgement)
        judgement=result;
        j=i;
    end
end
if(j>=1&&j<=10)
    disp('此数字出自A同学之手笔！');
else if(j>=11&&j<=20)
        disp('此数字出自B同学之手笔！');
    else 
        disp('此数字出自C同学之手笔！');
    end
end


