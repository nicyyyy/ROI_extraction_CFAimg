% Ҫ��
% 1��Ϊ��֤���������ٶȣ�ͼƬ�ķֱ������ͳһ����Ϊ320x180�ģ��������õ����߰��㣻
% 2�����ֵ�״̬����һ�£������Ż��߶����ţ�ָ�������֣�������׼ȷ�ȸ��ߣ�
% 3�����ֳ�д������AҪ����ƥ��ʱ��ֻ���޸�picture2��һ��ͼƬ�����ּ��ɣ����������޸ģ�
% 4��ͼ���·���ڳ������ѱ������������ı䣬��֤�������м��ɣ����ʵ��޸ģ�
% 5��Ŀǰ����30������ѡһ�ţ����жϵ�����ABC��������˭д�ģ�����������Լ���ʵ�顣
% 6����ABC��λͬѧ�ıʼ��ֱ���Ϊ1-10��11-20��21-30����׺Ϊ��.jpg��
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
    disp('�����ֳ���Aͬѧ֮�ֱʣ�');
else if(j>=11&&j<=20)
        disp('�����ֳ���Bͬѧ֮�ֱʣ�');
    else 
        disp('�����ֳ���Cͬѧ֮�ֱʣ�');
    end
end


