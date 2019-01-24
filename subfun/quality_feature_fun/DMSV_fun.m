function result = DMSV_fun(imsalNorm)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% distribution measure of saliency value
% mean variance skewness kurtosis
% imsalNorm 输入的显著性图（归一化之后的，值介于0~1之间）
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

% 返回结果
result = [imsalMean, imsalVar, imsalSke, imsalKur];

% clear 
clear imsalNorm imsalMean imsalVar imsalSke imsalKur
end