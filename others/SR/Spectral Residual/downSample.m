function outImg = downSample( origImg, scale ,type)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
origImg = double(origImg);
[M,N,P] = size(origImg);
m = ceil(M/scale);
n = ceil(N/scale);
outImg = uint8(zeros(m,n,P));
col = (M/m) .*(1:m) - (M/(2*m));
row = (N/n) .*(1:n) - (N/(2*n));



switch type
    %最邻近采样法
    case 'nearest'
        outImg(:,:,:) = uint8(origImg(ceil(col),ceil(row),:));
        
    %二次差值法
    case 'linear'
        u = col;
        v = row;
        col = fix(col);
        row = fix(row);
        col(col==0) = 1;
        row(row==0) = 1;
        u = u - col;
        v = v - row;
        
        for i = 1:P
        outImg(:,:,i) = uint8(((1-u)'*(1-v)).*origImg(col,row,i)+...
            ((1-u)'*v).*origImg(col,row+1,i)+...
            (u'*(1-v)).*origImg(col+1,row,i)+...
            (u'*v).*origImg(col+1,row+1,i));
        end
        
    %双三次卷积法
    case 'cubic'
        u = col - fix(col);
        v = row - fix(row);
        origImg = cat(1,origImg(1,:,:),origImg,origImg(end,:,:),origImg(end,:,:));
        origImg = cat(2,origImg(:,1,:),origImg,origImg(:,end,:),origImg(:,end,:));
        col = ceil(col) + 1;
        row = ceil(row) + 1;
        
        for a = 1:P
            for i = 1:m
                for j = 1:n
                    A = [S(1+v(j)),S(v(j)),S(1-v(j)),S(2-v(j))];
                    C = [S(1+u(i)),S(u(i)),S(1-u(i)),S(2-u(i))];
                    B = origImg((col(i)-1):(col(i)+2),(row(j)-1):(row(j)+2),a);
                    outImg(i,j,a) = A * B * C';
                end
            end
        end
        outImg = uint8(outImg);
        
end


end

