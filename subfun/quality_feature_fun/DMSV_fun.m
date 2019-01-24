function result = DMSV_fun(imsalNorm)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% distribution measure of saliency value
% mean variance skewness kurtosis
% imsalNorm �����������ͼ����һ��֮��ģ�ֵ����0~1֮�䣩
% 2016/1/16 10:10AM
% copyright by xiaofei zhou,IVP Lab, shanghai university,shanghai
% zxforchid@163.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mean
imsalMean = mean(imsalNorm(:));

% variance
imsalVar = var(imsalNorm(:));

% skewness
imsalSke = skewness(imsalNorm(:));

% kurtosis
imsalKur = kurtosis(imsalNorm(:));

% ���ؽ��
result = [imsalMean, imsalVar, imsalSke, imsalKur];

% clear 
clear imsalNorm imsalMean imsalVar imsalSke imsalKur
end