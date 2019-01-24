function [FC,FCP,FH,FCS,FNC,FB] = extract_qualitiy_feature_Liu(saliencymap,img)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ȡ������������ Liu Feng, ���� 68 ά������
% 2016/1/15 16:07PM
% copyright by xiaofei zhou,shanghai university,shanghai,china
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% max-min scale [0,1]
saliencymap = double(saliencymap);
saliencymap = (saliencymap-min(saliencymap(:)))/(max(saliencymap(:))-min(saliencymap(:))+eps);
img = imresize(img,[size(saliencymap,1) size(saliencymap,2)]);

% 10��level��ֵ
tt = [0:1/11:1];
tt = tt(2:end-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\nsaliecny coverage FC...');% 10ά
FC = saliency_coverage(saliencymap,tt);

fprintf('\nsaliencymap compactness FCP...');% 3ά
if sum(sum(saliencymap))==0
%     FCP = zeros(1,30);
    FCP = zeros(1,3);
else
    FCP = saliency_map_compactness(saliencymap);
end

fprintf('\nsaliency histogram FH...');% 20ά
FH = saliency_histogram(saliencymap);

fprintf('\ncolorseparation FCS...'); % 1ά
FCS = color_separation(saliencymap,img);


fprintf('\nboundary quality FB...');% 4ά
FB = boundary_quality(saliencymap,img);

fprintf('\nsegmentation quality FNC...');% 3ά
FNC = segmentation_quality(saliencymap,img,[0.5,0.75,0.95]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear saliencymap img tt
end