function [ output, fig, row, col ] = prescale( imcolor )
%PRESCALE Summary of this function goes here
%   Detailed explanation goes here
% 行的尺寸大于列的尺寸
% 三阶的图像矩阵,
% fig表示转置, row col原始尺寸
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig = 0;
[m,n,dim] = size(imcolor);% 原始尺寸 
row = m;col = n;

if dim==1 
    if m>n
       temp=zeros(m,n,3);
       temp(:,:,1)=imcolor;
       temp(:,:,2)=imcolor;
       temp(:,:,3)=imcolor;
    else
        tt = n;n=m;m=tt;
        temp=zeros(m,n,3);
        temp(:,:,1)=imcolor';
        temp(:,:,2)=imcolor';
        temp(:,:,3)=imcolor';
        fig = 1;
    end
    output=temp;
    clear temp imcolor
end 
  
if dim==3
    if m>n
        output = imcolor;
    else
        imr = imcolor(:,:,1);
        img = imcolor(:,:,2);
        imb = imcolor(:,:,3);
        output(:,:,1) = imr';
        output(:,:,2) = img';
        output(:,:,3) = imb';
        fig = 1;
        clear imr img imb
    end
    
    clear imcolor
end


end

