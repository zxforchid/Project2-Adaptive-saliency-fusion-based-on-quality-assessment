function [aveP,aveR,aveFM02, aveFM03,aveFM05,aveFM07, aveFM09, aveFM1] = compute_weighted_prf_Post3(SMAP, smapSuffix, GT, gtSuffix)
% version1: 1/28/2016   14:04 PM
% 
% by xiaofei zhou,shanghai university
% email: zxforchid@163.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
files = dir(fullfile(SMAP, strcat('*', smapSuffix)));
num = length(files);
if 0 == num
    error('no saliency map with suffix %s are found in %s', smapSuffix, SMAP);
end

aveP1 = zeros(num,1);
aveR1 = zeros(num,1);
aveFM031 = zeros(num,1);
aveFM051 = zeros(num,1);
aveFM071 = zeros(num,1);
aveFM091 = zeros(num,1);
aveFM11 = zeros(num,1);

parfor k = 1:num
    smapName = files(k).name;
    smapImg = imread(fullfile(SMAP, smapName));    
    
    gtName = strrep(smapName, smapSuffix, gtSuffix);
    gtImg = imread(fullfile(GT, gtName));
    gtImg = gtImg(:,:,1);
    smapImg = smapImg(:,:,1);
    if ~islogical(gtImg)
        gtImg = gtImg(:,:,1) > 128;
    end
   
    if any(size(smapImg) ~= size(gtImg))
%        error('saliency map and ground truth mask have different size');
        smapImg = imresize(smapImg,[size(gtImg,1),size(gtImg,2)]);
    end
    smapImg = normalize_sal(smapImg);
    [precision, recall, Fmeasres]= WFb(smapImg,gtImg,[0.2, 0.3,0.5,0.7,0.9,1]);
    

     aveP1(k,1)    = precision;
     aveR1(k,1)    = recall;
     aveFM021(k,1) = Fmeasres(1);
     aveFM031(k,1) = Fmeasres(2);
     aveFM051(k,1) = Fmeasres(3);
     aveFM071(k,1) = Fmeasres(4);
     aveFM091(k,1) = Fmeasres(5);
     aveFM11(k,1)  = Fmeasres(6);
    
end

aveP = mean(aveP1);
aveR = mean(aveR1);
aveFM02 = mean(aveFM021);
aveFM03 = mean(aveFM031);
aveFM05 = mean(aveFM051);
aveFM07 = mean(aveFM071);
aveFM09 = mean(aveFM091);
aveFM1  = mean(aveFM11);


end