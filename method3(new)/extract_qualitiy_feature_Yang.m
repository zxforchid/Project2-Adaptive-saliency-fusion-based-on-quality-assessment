function [DMSV,SPE,SV] = extract_qualitiy_feature_Yang(imsal,imcolor)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ȡ������������ Yang, ���� 13 ά������
% ����inter-map coherence������Ҫ���������ͼ��һ����룬�ʶ��Ͳ��ڴ˴�������
% �ʶ����˴�������ά����10ά
% 
% 2016/1/15 16:07PM
% copyright by xiaofei zhou,shanghai university,shanghai,china
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% max-min scale for saliency map [0,1]
imsal = double(imsal);
imsalNorm = (imsal-min(imsal(:)))/(max(imsal(:))-min(imsal(:))+eps);
imcolor = imresize(imcolor,[size(imsal,1) size(imsal,2)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\n distribution measure of saliency value...');% 4ά
DMSV = DMSV_fun(imsalNorm);

fprintf('\n spatial pyramid entropy...');% 4ά
SPE = SPE_fun(imsalNorm);

fprintf('\n spatial variance...');% 2ά
SV = SP_fun(imsalNorm);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear imsal img
end