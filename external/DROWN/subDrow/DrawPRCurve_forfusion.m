function [rec, prec, fvalues, FM, hdlY] = DrawPRCurve_forfusion(testlist, SMAP, smapSuffix, GT, gtSuffix, targetIsFg, targetIsHigh, color)
% Draw PR Curves for all the image with 'smapSuffix' in folder SMAP
% GT is the folder for ground truth masks
% targetIsFg = true means we draw PR Curves for foreground, and otherwise
% we draw PR Curves for background
% targetIsHigh = true means feature values for our interest region (fg or
% bg) is higher than the remaining regions.
% color specifies the curve color

% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014
% version2:
% 为了新的测试
% eg:MSRA10K 训练集测试集各一半
% testlist  5000个图像编号
% written by xiaofei zhou, shanghai university, shanghai, china
% 2016/1/5  22:22PM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
files = dir(fullfile(SMAP, strcat('*', smapSuffix)));
tefiles = files(testlist);
num = length(tefiles);
if 0 == num
    error('no saliency map with suffix %s are found in %s', smapSuffix, SMAP);
end

%precision and recall of all images
ALLPRECISION = zeros(num, 256);
ALLRECALL = zeros(num, 256);
Fvalues = zeros(num,1);
parfor k = 1:num
    smapName = tefiles(k).name;
    smapImg = imread(fullfile(SMAP, smapName));    
    
    gtName = strrep(smapName, smapSuffix, gtSuffix);
    gtImg = imread(fullfile(GT, gtName));
    
    [precision, recall] = CalPR(smapImg, gtImg, targetIsFg, targetIsHigh);
    
    ALLPRECISION(k, :) = precision;
    ALLRECALL(k, :) = recall;
    Fvalues(k,:) = mean(((1+0.3)*precision + recall)./(0.3*precision + recall));
end
aa = 0.3;
prec = mean(ALLPRECISION, 1);   %function 'mean' will give NaN for columns in which NaN appears.
rec = mean(ALLRECALL, 1);

fvalues = ((1+aa)*mean(ALLPRECISION, 2).*mean(ALLRECALL, 2))./(aa*mean(ALLPRECISION, 2)+mean(ALLRECALL, 2));
% FM = ((1+aa)*mean(prec)*mean(rec))/(aa*mean(prec)+mean(rec));% version1

% FMs = ((1+aa)*prec + rec)./(aa*prec + rec); % version2
% FM = mean(FMs);

FM = mean(Fvalues); % version3

% plot
if nargin > 5
    hdlY = plot(rec, prec, 'color', color, 'linewidth', 2);
%     hdlY = plot(rec, prec, color, 'linewidth', 2);
    axis([0 1 0.2 1]);
    set(gca,'xtick',[0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1],'FontSize',12);
    set(gca,'ytick',[0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0],'FontSize',12);
%     set(gca,'FontSize',20)
else
    plot(rec, prec, 'r', 'linewidth', 2);
end

 

