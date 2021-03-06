% 2014.5.30 15:44
% by Xiaofei Zhou
% 根据固定块数分解图像
% patchSize=[p,q]
function [imgout] = imPart(imgin,patchSize)

if ndims(imgin)==3
    imgin = rgb2gray(imgin);
    imgin = double(imgin);
else
    imgin = double(imgin);
end
if sum(patchSize)==2
    imgout{1}=imgin;
end

if sum(patchSize)>2

p = patchSize(1);
q = patchSize(2);
imgout = cell(p,q);
% 把图像imgin平均的分成numOfpatches块：逐行方式处理
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
        if numy==q && numx<p % 计算边缘,合并多余的元素
            imgout{count}=imgin(x:x+patch_sizem-1,y:end);
        elseif numx==p && numy<q % 计算边缘,合并多余的元素
            imgout{count}=imgin(x:end,y:y+patch_sizen-1);
        elseif numx==p && numy==q % 计算边缘,合并多余的元素
            imgout{count}=imgin(x:end,y:end);
        else
            imgout{count}=imgin(x:x+patch_sizem-1,y:y+patch_sizen-1);% 正常分解,合并多余的元素
        end 
    end
end 

end 
return
    