function  result = SP_fun(imsalNorm)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spatio variance feature
% version1: result = SP_fun(imsalNorm, imcolor)
% Liutie and Fangyuming的 spatio variance 2维的特征(每人对应1维)
% note: 这里要注意，二者对于spatial variance的定义是不同的
% imsalNorm 输入的显著性图（归一化之后的，值介于0~1之间）
% imcolor   对应的彩色图像
% result:
%        spL   Liu 的特征 6维
%        spF   Fang 的特征1维
% 这里引用两篇文献：
% 1 learn to detect a salient object, Liutie TPAMI2011
% 2 a video saliency detection in compressed domain, Fangyuming TCSVT2014
%
% version2: result = SP_fun(imsalNorm)
% 经过与yang, discovering primary objects in videos bu saliency fusion and
% iterative apperance estimation ,CSVT2015比对， 发现spatial variance应该是
% Fang的方法， 只是在最终计算时， 把 vertical 与 horizontal分别提取出来
% input: 
% imsalNorm  归一化的显著性图
% output:
% result = [spVertical,spHorizontal], 2维
% 
% 2016/1/16 13:42PM
% copyright by xiaofei zhou,IVP Lab, shanghai university,shanghai
% zxforchid@163.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% version1: 2016/1/16  16:35PM
% % Liu tie的 spatial variance
% [colormaps] = generate_colormaps(imcolor, 6,  0);
% spL = calculate_spatial_variances(colormaps);
% clear colormaps 

% % fangyuming的spatial variance
% level_obj=graythresh(imsalNorm);
% obj_otsu=im2bw(imsalNorm,level_obj);
% [obj_j,obj_i]=meshgrid(1:size(imsalNorm,2),1:size(imsalNorm,1));
% obj_ie=mean(obj_i(obj_otsu));
% obj_je=mean(obj_j(obj_otsu));
% v_obj=sqrt((obj_i-obj_ie).^2+(obj_j-obj_je).^2).*obj_otsu;
% spF=sum(v_obj(:))/length(find(obj_otsu==1));
% clear level_obj obj_otsu obj_j obj_i obj_ie obj_je v_obj

% % 输出结果
% result = [spL',spF];
% clear spL spF
% clear imsalNorm imcolor
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
% version2: 2016/1/16 16:36PM
level_obj=graythresh(imsalNorm);
obj_otsu=im2bw(imsalNorm,level_obj);
[obj_j,obj_i]=meshgrid(1:size(imsalNorm,2),1:size(imsalNorm,1));
spHorizontal = mean(obj_i(obj_otsu));
spVertical = mean(obj_j(obj_otsu));
result = [spHorizontal, spVertical];
clear spHorizontal spVertical

clear imsalNorm 

end