function result = IC_fun(imsalNorms)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inter-map coherence
% version1:
% input:
%        imsalNorms 输入的显著性图（归一化之后的，值介于0~1之间）
% note: 这里不只一个saliency map, 而是满足质量标签条件的多幅saliency map; 若
%        对于输入任意一幅彩色图像，只有一幅 saliency map, 则我们取其自身的
%        Forground百分比
% 
% output:
%　     result 1*3维  or imsalNum * 3
% 
% 2016/1/16 17:00PM
% copyright by xiaofei zhou,IVP Lab, shanghai university,shanghai
% zxforchid@163.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imsalNum = length(imsalNorms);
tmpU = 0;
if imsalNum==1
    % 自适应获取二值化阈值
    tmpSal = imsalNorms{1,1};
    tmpU = mean(tmpSal(:));
    tHigh = 1.5*tmpU; tMid = tmpU; tLow = 0.5*tmpU;    
    tmpSalLength = length(tmpSal(:));
    clear imsalNorms
    
    % 二值化 & 统计显著率
    salPHigh = tmpSal > tHigh; 
    salPHighvalue = sum(salPHigh(:))/(tmpSalLength + eps);
    salPMid  = tmpSal > tMid;  
    salPMidvalue  = sum(salPMid(:))/(tmpSalLength + eps);
    salPLow  = tmpSal > tLow;  
    salPLowvalue  = sum(salPLow(:))/(tmpSalLength + eps);
    clear tmpSal tmpSalLength
    clear salPHigh salPMid salPLow
    
    % 返回结果
    result = [salPHighvalue, salPMidvalue, salPLowvalue];
    clear salPHighvalue salPMidvalue salPLowvalue
    
else
    % 自适应获取二值化阈值
    for ii=1:imsalNum
        tmpSal = imsalNorms{1,ii};
        tmpU = tmpU + mean(tmpSal(:));
        clear tmpSal
    end
    tmpU = tmpU/imsalNum;
    tHigh = 1.5*tmpU; tMid = tmpU; tLow = 0.5*tmpU;
    clear tmpU
    
    % 二值化 
    for ii=1:imsalNum
        tmpSal         = imsalNorms{1,ii};
        salPHighs{1,ii} = tmpSal > tHigh; 
        salPMids{1,ii}  = tmpSal > tMid;  
        salPLows{1,ii}  = tmpSal > tLow;  
    end
    clear tHigh tMid tLow imsalNorms
    
    % 统计显著率 1*imsalNums
    salPHighvalues = staticSalPercent(salPHighs, imsalNum);
    salPMidvalues = staticSalPercent(salPMids, imsalNum);
    salPLowvalues = staticSalPercent(salPLows, imsalNum);
    clear salPHighs salPMids salPLows
    
    % 返回结果
    result = [salPHighvalues',salPMidvalues',salPLowvalues'];
    clear salPLowvalues salPMidvalues salPHighvalues
end




end

function salPHighvalue = staticSalPercent(salPHighs, imsalNum)
% 计算一幅显著图的显著性区域在另外几幅显著性图中的 “与”的最大值
% 要归一化（除以图像的面积）
salPHighvalue = zeros(1,imsalNum);
    for i=1:imsalNum
        objSal = salPHighs{1,i};
        objSalLength = length(objSal(:));
        objPercent = [];
        for j=[1:i-1,i+1:imsalNum]
            othSal = salPHighs{1,j};
            objPercent = [objPercent, sum(sum(objSal.*othSal))];
        end
        salPHighvalue(1,i) = max(objPercent)/(objSalLength+eps);
        clear objPercent
    end

end
