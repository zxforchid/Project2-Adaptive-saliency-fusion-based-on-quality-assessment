function [rec, prec, fm03, fm05, fm07, fm09, fm1, hdlY] = Draw_PRF_Curve_testlist1_end(testlist, SMAP, smapSuffix, GT, gtSuffix, targetIsFg, targetIsHigh, color)
% Draw PR Curves for all the image with 'smapSuffix' in folder SMAP
% GT is the folder for ground truth masks
% targetIsFg = true means we draw PR Curves for foreground, and otherwise
% we draw PR Curves for background
% targetIsHigh = true means feature values for our interest region (fg or
% bg) is higher than the remaining regions.
% color specifies the curve color
% written by xiaofei zhou, shanghai university, shanghai, china
% 2016/1/28  22:22PM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
files = dir(fullfile(GT, strcat('*', gtSuffix)));
tefiles = files(testlist);
num = length(tefiles);
if 0 == num
    error('no saliency map with suffix %s are found in %s', smapSuffix, SMAP);
end

%precision and recall of all images
ALLPRECISION = zeros(num, 256);
ALLRECALL = zeros(num, 256);
parfor k = 1:num
    smapName = [tefiles(k).name(1:end-4),smapSuffix];
    smapImg = imread(fullfile(SMAP, smapName));    
    
    gtName = strrep(smapName, smapSuffix, gtSuffix);
    gtImg = imread(fullfile(GT, gtName));
    
    [precision, recall] = CalPR(smapImg, gtImg, targetIsFg, targetIsHigh);
    
    ALLPRECISION(k, :) = precision;
    ALLRECALL(k, :) = recall;
end

prec = mean(ALLPRECISION, 1);   %function 'mean' will give NaN for columns in which NaN appears.
rec = mean(ALLRECALL, 1);

aa = 0.3;
fm03 = ((1+aa) * (prec.*rec)) ./ (aa*prec + rec);

aa = 0.5;
fm05 = ((1+aa) * (prec.*rec)) ./ (aa*prec + rec);

aa = 0.7;
fm07 = ((1+aa) * (prec.*rec)) ./ (aa*prec + rec);

aa = 0.9;
fm09 = ((1+aa) * (prec.*rec)) ./ (aa*prec + rec);

aa = 1;
fm1 = ((1+aa) * (prec.*rec)) ./ (aa*prec + rec);


fm03 = fm03(256:-1:1);
fm05 = fm05(256:-1:1);
fm07 = fm07(256:-1:1);
fm09 = fm09(256:-1:1);
fm1  = fm1(256:-1:1);

% plot
if nargin > 5
%     hdlY = plot(rec, prec, 'color', color, 'linewidth', 2);
    hdlY = plot(rec, prec, color, 'linewidth', 2);
    axis([0 1 0.2 1]);
    set(gca,'xtick',[0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1],'FontSize',12);
    set(gca,'ytick',[0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0],'FontSize',12);
%     set(gca,'FontSize',20)
else
    plot(rec, prec, 'r', 'linewidth', 2);
end

 

