function result = IC_fun(imsalNorms)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inter-map coherence
% version1:
% input:
%        imsalNorms �����������ͼ����һ��֮��ģ�ֵ����0~1֮�䣩
% note: ���ﲻֻһ��saliency map, ��������������ǩ�����Ķ��saliency map; ��
%        ������������һ����ɫͼ��ֻ��һ�� saliency map, ������ȡ�������
%        Forground�ٷֱ�
% 
% output:
%��     result 1*3ά  or imsalNum * 3
% 
% 2016/1/16 17:00PM
% copyright by xiaofei zhou,IVP Lab, shanghai university,shanghai
% zxforchid@163.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imsalNum = length(imsalNorms);
tmpU = 0;
if imsalNum==1
    % ����Ӧ��ȡ��ֵ����ֵ
    tmpSal = imsalNorms{1,1};
    tmpU = mean(tmpSal(:));
    tHigh = 1.5*tmpU; tMid = tmpU; tLow = 0.5*tmpU;    
    tmpSalLength = length(tmpSal(:));
    clear imsalNorms
    
    % ��ֵ�� & ͳ��������
    salPHigh = tmpSal > tHigh; 
    salPHighvalue = sum(salPHigh(:))/(tmpSalLength + eps);
    salPMid  = tmpSal > tMid;  
    salPMidvalue  = sum(salPMid(:))/(tmpSalLength + eps);
    salPLow  = tmpSal > tLow;  
    salPLowvalue  = sum(salPLow(:))/(tmpSalLength + eps);
    clear tmpSal tmpSalLength
    clear salPHigh salPMid salPLow
    
    % ���ؽ��
    result = [salPHighvalue, salPMidvalue, salPLowvalue];
    clear salPHighvalue salPMidvalue salPLowvalue
    
else
    % ����Ӧ��ȡ��ֵ����ֵ
    for ii=1:imsalNum
        tmpSal = imsalNorms{1,ii};
        tmpU = tmpU + mean(tmpSal(:));
        clear tmpSal
    end
    tmpU = tmpU/imsalNum;
    tHigh = 1.5*tmpU; tMid = tmpU; tLow = 0.5*tmpU;
    clear tmpU
    
    % ��ֵ�� 
    for ii=1:imsalNum
        tmpSal         = imsalNorms{1,ii};
        salPHighs{1,ii} = tmpSal > tHigh; 
        salPMids{1,ii}  = tmpSal > tMid;  
        salPLows{1,ii}  = tmpSal > tLow;  
    end
    clear tHigh tMid tLow imsalNorms
    
    % ͳ�������� 1*imsalNums
    salPHighvalues = staticSalPercent(salPHighs, imsalNum);
    salPMidvalues = staticSalPercent(salPMids, imsalNum);
    salPLowvalues = staticSalPercent(salPLows, imsalNum);
    clear salPHighs salPMids salPLows
    
    % ���ؽ��
    result = [salPHighvalues',salPMidvalues',salPLowvalues'];
    clear salPLowvalues salPMidvalues salPHighvalues
end




end

function salPHighvalue = staticSalPercent(salPHighs, imsalNum)
% ����һ������ͼ�����������������⼸��������ͼ�е� ���롱�����ֵ
% Ҫ��һ��������ͼ��������
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
