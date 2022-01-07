% 1：获得输入两幅图片的直方图分布
% 2：将直方图依次划分为64个区，即每个区有4个灰度等级
% 3：分别将各自的64个区生成64个元素，即一个向量（图像指纹）
% 4：计算两个向量的余弦相似度
% 5：判断，若相似度
 function v=ImageRecognition(picture1,picture2)
t1=picture1;
[a1,b1]=size(t1);
t2=picture2;
%  t2=imresize(t2,[a1 b1],'bicubic');%缩放为一致大小
t1=round(t1);
t2=round(t2);
e1=zeros(1,256);
e2=zeros(1,256);
% 获取直方图分布
for i=1:a1
    for j=1:b1
        m1=t1(i,j)+1;
        m2=t2(i,j)+1;
        e1(m1)=e1(m1)+1;
        e2(m2)=e2(m2)+1;
    end
end
% 将直方图分为64个区
m1=zeros(1,64);
m2=zeros(1,64);
for i=0:63
    m1(1,i+1)=e1(4*i+1)+e1(4*i+2)+e1(4*i+3)+e1(4*i+4);
    m2(1,i+1)=e2(4*i+1)+e2(4*i+2)+e2(4*i+3)+e2(4*i+4);
end
% 计算余弦相似度
A=sqrt(sum(sum(m1.^2)));
B=sqrt(sum(sum(m2.^2)));
C=sum(sum(m1.*m2));
cos1=C/(A*B);%计算余弦值
cos2=acos(cos1);%弧度
v=cos2*180/pi ;%换算成角度

