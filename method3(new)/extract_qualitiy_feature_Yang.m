function [DMSV,SPE,SV] = extract_qualitiy_feature_Yang(imsal,imcolor)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 提取质量评价特征 Yang, 共计 13 维的特征
% 由于inter-map coherence可能需要多幅显著性图的一起参与，故而就不在此处计算了
% 故而，此处的特征维数是10维
% 
% 2016/1/15 16:07PM
% copyright by xiaofei zhou,shanghai university,shanghai,china
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% max-min scale for saliency map [0,1]
imsal = double(imsal);
imsalNorm = (imsal-min(imsal(:)))/(max(imsal(:))-min(imsal(:))+eps);
imcolor = imresize(imcolor,[size(imsal,1) size(imsal,2)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\n distribution measure of saliency value...');% 4维
DMSV = DMSV_fun(imsalNorm);

fprintf('\n spatial pyramid entropy...');% 4维
SPE = SPE_fun(imsalNorm);

fprintf('\n spatial variance...');% 2维
SV = SP_fun(imsalNorm);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear imsal img
end