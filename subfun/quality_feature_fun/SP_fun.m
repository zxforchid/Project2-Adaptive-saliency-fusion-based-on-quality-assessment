function  result = SP_fun(imsalNorm)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spatio variance feature
% version1: result = SP_fun(imsalNorm, imcolor)
% Liutie and Fangyuming�� spatio variance 2ά������(ÿ�˶�Ӧ1ά)
% note: ����Ҫע�⣬���߶���spatial variance�Ķ����ǲ�ͬ��
% imsalNorm �����������ͼ����һ��֮��ģ�ֵ����0~1֮�䣩
% imcolor   ��Ӧ�Ĳ�ɫͼ��
% result:
%        spL   Liu ������ 6ά
%        spF   Fang ������1ά
% ����������ƪ���ף�
% 1 learn to detect a salient object, Liutie TPAMI2011
% 2 a video saliency detection in compressed domain, Fangyuming TCSVT2014
%
% version2: result = SP_fun(imsalNorm)
% ������yang, discovering primary objects in videos bu saliency fusion and
% iterative apperance estimation ,CSVT2015�ȶԣ� ����spatial varianceӦ����
% Fang�ķ����� ֻ�������ռ���ʱ�� �� vertical �� horizontal�ֱ���ȡ����
% input: 
% imsalNorm  ��һ����������ͼ
% output:
% result = [spVertical,spHorizontal], 2ά
% 
% 2016/1/16 13:42PM
% copyright by xiaofei zhou,IVP Lab, shanghai university,shanghai
% zxforchid@163.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% version1: 2016/1/16  16:35PM
% % Liu tie�� spatial variance
% [colormaps] = generate_colormaps(imcolor, 6,  0);
% spL = calculate_spatial_variances(colormaps);
% clear colormaps 

% % fangyuming��spatial variance
% level_obj=graythresh(imsalNorm);
% obj_otsu=im2bw(imsalNorm,level_obj);
% [obj_j,obj_i]=meshgrid(1:size(imsalNorm,2),1:size(imsalNorm,1));
% obj_ie=mean(obj_i(obj_otsu));
% obj_je=mean(obj_j(obj_otsu));
% v_obj=sqrt((obj_i-obj_ie).^2+(obj_j-obj_je).^2).*obj_otsu;
% spF=sum(v_obj(:))/length(find(obj_otsu==1));
% clear level_obj obj_otsu obj_j obj_i obj_ie obj_je v_obj

% % ������
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