function [aveP,aveR,aveFM03,aveFM05,aveFM07, aveFM09, aveFM1] = compute_fmeasure_fortelist(testlist, SMAP, smapSuffix, GT, gtSuffix)
% by xiaofei zhou,shanghai university
% email: zxforchid@163.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
files = dir(fullfile(SMAP, strcat('*', smapSuffix)));
tefiles = files(testlist);
num = length(tefiles);
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
    disp(k)
    smapName = tefiles(k).name;
    smapImg = imread(fullfile(SMAP, smapName));    
    
    gtName = strrep(smapName, smapSuffix, gtSuffix);
    gtImg = imread(fullfile(GT, gtName));
    smapImg = smapImg(:,:,1);
    if ~islogical(gtImg)
        gtImg = gtImg(:,:,1) > 128;
    end
    if any(size(smapImg) ~= size(gtImg))
       error('saliency map and ground truth mask have different size');
    end
    
    cutimg= mat2gray(otsu(smapImg));
%     cutimg= BW;
    [row,col]=size(cutimg);
    sz=row*col;
    
     cutimg=reshape(cutimg,sz,1);
     gtImg=reshape(gtImg,sz,1);

     cutimg=cutimg(:);%变为向量
     gtImg=gtImg(:);
%      [precision,recall ,f_measure ,f05 ,f1] = Evaluate(gtImg,cutimg);
     [precision,recall ,f_measure ,f05 ,f07,f09,f1]= Evaluate(gtImg,cutimg);
     aveP1(k,1)    = precision;
     aveR1(k,1)    = recall;
     aveFM031(k,1) = f_measure;
     aveFM051(k,1) = f05;
     aveFM071(k,1) = f07;
     aveFM091(k,1) = f09;
     aveFM11(k,1)  = f1;
    
end

aveP = mean(aveP1);
aveR = mean(aveR1);
aveFM03 = mean(aveFM031);
aveFM05 = mean(aveFM051);
aveFM07 = mean(aveFM071);
aveFM09 = mean(aveFM091);
aveFM1  = mean(aveFM11);


end