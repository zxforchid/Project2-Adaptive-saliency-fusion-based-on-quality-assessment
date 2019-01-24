function Entropy = SPE_fun(imsalNorm)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spatio pyramid entropy
% Entropy  ���ص���ֵ 4ά��
% imsalNorm �����������ͼ����һ��֮��ģ�ֵ����0~1֮�䣩
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
% ����Ԫ���������
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