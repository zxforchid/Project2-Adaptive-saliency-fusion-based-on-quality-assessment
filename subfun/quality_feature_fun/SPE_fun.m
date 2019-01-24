function Entropy = SPE_fun(imsalNorm)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spatio pyramid entropy
% Entropy  返回的熵值 4维的
% imsalNorm 输入的显著性图（归一化之后的，值介于0~1之间）
% 2016/1/16 10:10AM
% copyright by xiaofei zhou,IVP Lab, shanghai university,shanghai
% zxforchid@163.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initial
patchsizes = {[8,8],[16,16],[24,24],[32,32]};
numPatch = length(patchsizes);
Entropy = zeros(1,numPatch);

% pyramid entropy
for pp=1:numPatch
    patchsize = patchsizes{pp};
%     N = patchsize(1)*patchsize(2);
    imsalCell = imPart(imsalNorm,patchsize);
    imsalCell = imsalCell'; 
    
    [cellSum, ~] = sumCell(imsalCell);
    cellSumNorm = (cellSum-min(cellSum(:)))/(max(cellSum(:))-min(cellSum(:))+eps);
    allCellSumNorm = sum(cellSumNorm(:));
    
    Pro = cellSumNorm./(allCellSumNorm+eps);
    LnPro = log(Pro+eps);
    Entropy(1,pp) = -1*sum(sum(Pro .* LnPro)); 
    
    clear imsalCell cellSumNorm Pro LnPro
end

clear imsalNorm
end

function [cellSum, allSum] = sumCell(imsalCell)
% 对于元胞矩阵求和
[m,n] = size(imsalCell);
cellSum = zeros(m,n);
allSum = 0;
for i=1:m
    for j=1:n
        tmpCell = imsalCell{i,j};
%         [mt,nt] = size(tmpCell);
%         tmpCellSum = sum(tmpCell(:))/(mt*nt);
        tmpCellSum = sum(tmpCell(:));
        
        cellSum(i,j) = tmpCellSum;
        allSum = allSum + tmpCellSum;
        
        clear tmpCellSum
    end
end

clear imsalCell

end