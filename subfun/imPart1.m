function [imgout] = imPart1(imgin,patchSize)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% version1: impart
% 2014.5.30 15:44
% by Xiaofei Zhou
% ���ݹ̶������ֽ�ͼ��
% patchSize=[p,q]
% version2:
% �Բ�ɫͼ����ʱ���������ɫ
% 2015/12/28
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if ndims(imgin)==3
%     imgin = rgb2gray(imgin);
%     imgin = double(imgin);
% else
%     imgin = double(imgin);
% end

imgin = double(imgin);

if sum(patchSize)==2
    imgout{1}=imgin;
end

%% �Ҷ�ͼ��
if sum(patchSize)>2 && ndims(imgin)==2

p = patchSize(1);
q = patchSize(2);
imgout = cell(p,q);
% ��ͼ��imginƽ���ķֳ�numOfpatches�飺���з�ʽ����
[m, n] = size(imgin);
patch_sizem=floor(m/p);
patch_sizen=floor(n/q);
count=0;
numx=0;
for x = 1:patch_sizem:(p-1)*patch_sizem+1
    numx=numx+1;numy=0;
    for y = 1:patch_sizen:(q-1)*patch_sizen+1
        count=count+1;
        numy=numy+1;
        if numy==q && numx<p % �����Ե,�ϲ������Ԫ��
            imgout{count}=imgin(x:x+patch_sizem-1,y:end);
        elseif numx==p && numy<q % �����Ե,�ϲ������Ԫ��
            imgout{count}=imgin(x:end,y:y+patch_sizen-1);
        elseif numx==p && numy==q % �����Ե,�ϲ������Ԫ��
            imgout{count}=imgin(x:end,y:end);
        else
            imgout{count}=imgin(x:x+patch_sizem-1,y:y+patch_sizen-1);% �����ֽ�,�ϲ������Ԫ��
        end 
    end
end 
end 

%% ��ɫͼ��
if sum(patchSize)>2 && ndims(imgin)==3
imgout = cell(1,3);
for nn=1:3
imgin1 = imgin(:,:,nn);
p = patchSize(1);
q = patchSize(2);
imgout{1,nn} = cell(p,q);
% ��ͼ��imginƽ���ķֳ�numOfpatches�飺���з�ʽ����
[m, n] = size(imgin1);
patch_sizem=floor(m/p);
patch_sizen=floor(n/q);
count=0;
numx=0;
for x = 1:patch_sizem:(p-1)*patch_sizem+1
    numx=numx+1;numy=0;
    for y = 1:patch_sizen:(q-1)*patch_sizen+1
        count=count+1;
        numy=numy+1;
        if numy==q && numx<p % �����Ե,�ϲ������Ԫ��
            imgout{1,nn}{count}=imgin1(x:x+patch_sizem-1,y:end);
        elseif numx==p && numy<q % �����Ե,�ϲ������Ԫ��
            imgout{1,nn}{count}=imgin1(x:end,y:y+patch_sizen-1);
        elseif numx==p && numy==q % �����Ե,�ϲ������Ԫ��
            imgout{1,nn}{count}=imgin1(x:end,y:end);
        else
            imgout{1,nn}{count}=imgin1(x:x+patch_sizem-1,y:y+patch_sizen-1);% �����ֽ�,�ϲ������Ԫ��
        end 
    end
end     
    
end

end 



end
    