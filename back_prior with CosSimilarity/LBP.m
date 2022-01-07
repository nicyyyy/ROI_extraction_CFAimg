function texture = LBP(picture)
%UNTITLED3 获取LBP纹理特征
%   输入picture：灰度图
%   输出texture：LBP纹理特征
[m,n] = size(picture);
texture = zeros(m,n);
for i=2:1:m-1
    for j=2:1:n-1
        neighbor=(zeros(1,8));
       
        neighbor(1,1)=picture(i-1,j);
        neighbor(1,2)=picture(i-1,j+1);
        neighbor(1,3)=picture(i,j+1);
        neighbor(1,4)=picture(i+1,j+1);
        neighbor(1,5)=picture(i+1,j);
        neighbor(1,6)=picture(i+1,j-1);
        neighbor(1,7)=picture(i,j-1);
        neighbor(1,8)=picture(i-1,j-1);
        center=picture(i,j);
        temp=uint8(0);
        for k=1:1:8
             temp =temp+ (neighbor(1,k) >= center)* 2^(k-1);
        end
        texture(i,j)=temp;
       
    end
end
end

