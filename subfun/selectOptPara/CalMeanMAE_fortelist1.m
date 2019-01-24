function mae = CalMeanMAE_fortelist1(testlist, SRC, srcSuffix, GT, gtSuffix)
% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014
files = dir(fullfile(GT, strcat('*', gtSuffix)));
tefiles = files(testlist);
% num = length(tefiles);

if isempty(tefiles)
    error('No saliency maps are found: %s\n', fullfile(SRC, strcat('*', srcSuffix)));
end

MAE = zeros(length(tefiles), 1);
parfor k = 1:length(tefiles)
    srcName = [tefiles(k).name(1:end-4),srcSuffix];
%     srcName = tefiles(k).name;
    srcImg = imread(fullfile(SRC, srcName));
    
    gtName = strrep(srcName, srcSuffix, gtSuffix);
    gtImg = imread(fullfile(GT, gtName));
    
    MAE(k) = CalMAE(srcImg, gtImg);
end

mae = mean(MAE);
fprintf('MAE for %s: %f\n', srcSuffix, mae);