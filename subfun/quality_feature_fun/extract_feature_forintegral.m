% function [feature_strong,feature_weak] = extract_feature_forintegral(path,suffix,imnames,ii)
function extract_feature_forintegral(path,suffix,imnames,ii)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ȡ��������
% 07/11/2015
% xiaofei zhou
% ��single�����ݽ�ʡ�ռ�
% 07/13/2015 13:37PM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% path.imgRoot=imgRoot;
% path.imgRoot_weaksal=imgRoot_weaksal;
% path.saldir_final=saldir_final;
% path.saldir_final0=saldir_final0;
% path.saldir_strong=saldir_strong;
% path.imgmat = imgmat;

imgRoot_color = path.imgRoot;
imgRoot_weaksal = path.imgRoot_weaksal;
imgRoot_strongsal = path.saldir_strong;
imgmat = path.imgmat;
%% 
    imname_color  = [imgRoot_color imnames(ii).name];
    imname_strong = [imgRoot_strongsal imnames(ii).name(1:end-4) suffix.strong]; 
    imname_weak   = [imgRoot_weaksal imnames(ii).name(1:end-4) suffix.weak];
    im_color      = imread(imname_color);
    im_strong     = imread(imname_strong);
    im_weak       = imread(imname_weak);
%     [m,n]         = size(im_color);
%     im_strong     = imresize(im2double(imread(imname_strong)),[m,n]);
%     im_weak       = imresize(im2double(imread(imname_weak)),[m,n]);
    
% %     % ----ȥ����ԵӰ��---- % 
% %     im_color = im_color(16:m-15,);
% %     % ------------------- %

    fprintf('\nSTRONG ........')
    feature_strong = single(extract_qualitiy_features(im_strong,im_color));
    
    fprintf('\nWEAK ........')
    feature_weak = single(extract_qualitiy_features(im_weak,im_color));
    
     save([imgmat imnames(ii).name(1:end-4) '.mat'],'feature_strong','feature_weak')
%%    
    clear im_color im_strong im_weak feature_strong feature_weak
end