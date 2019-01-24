function [recall_avg, precision_avg ,fpr_avg ,tpr_avg,auc_curve,aucs] = myCurveCompute111(groundtruthsPath,imgPath,extname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% version1:
% 根据yelinwei的程序改编，以期适合并行计算
% copyright by xiaofei zhou,shanghai university,shanghai,china
% 07/13/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%input binary masks as ground truths
BinarymaskNames=dir([groundtruthsPath '\*.' 'png']);%MSRC

files = dir(fullfile(imgPath, strcat('*', extname)));
% numberOfFiles = length(files);

numberOfFiles = size(BinarymaskNames,1);
precision = zeros(256, numberOfFiles);
recall = zeros(256, numberOfFiles);
% F_measure = zeros(256, numberOfFiles);

tpr = zeros(256, numberOfFiles);
fpr = zeros(256, numberOfFiles);
aucs = zeros(numberOfFiles, 1);
psort = zeros(256, 2);

% totalrate = zeros(2, 256, numberOfFiles);
% totalacc = zeros(1, 256, numberOfFiles);
% matlabpool local 8



for i = 1: numberOfFiles
%     disp(i);
%     clear imgTT;
%     clear imgT;

     [precision(:,i),recall(:,i),tpr(:,i),fpr(:,i),psort] = computesinglePRF(files,groundtruthsPath,imgPath,extname,i);
    
    %AUC
    xy = sortrows(psort, 1);% 定积分有上下限，需要重新排序
    xy_trs = xy';
    x = xy_trs(1, :);
    y = xy_trs(2, :);
    aucs(i) = trapz(x, y);
%     disp(auc(i));
    
%     auc(i) = calcAUCscore(imgT0, imgB0);
   
end
% matlabpool close

clear xy xy_trs x y

precision_avg = sum(precision, 2) / numberOfFiles;
recall_avg = sum(recall, 2) / numberOfFiles;

tpr_avg = sum(tpr, 2) / numberOfFiles;
fpr_avg = sum(fpr, 2) / numberOfFiles;

% auc_avg = sum(auc) / numberOfFiles;

psort(:, 1) = fpr_avg;
psort(:, 2) = tpr_avg;
xy = sortrows(psort, 1); % 定积分有上下限，需要重新排序
xy_trs = xy';
x = xy_trs(1, :);
y = xy_trs(2, :);
auc_curve = trapz(x, y);


end

function [precision,recall,tpr,fpr,psort] = computesinglePRF(BinarymaskNames,groundtruthsPath,imgPath,extname,i)
precision = zeros(256,1);
recall = zeros(256,1);
tpr = zeros(256,1);
fpr = zeros(256,1);
psort = zeros(256,2);

    [~, name ext] = fileparts(BinarymaskNames(i).name);  
%     disp(name); 0_5_5318_quality_integrate1.png
    str = [groundtruthsPath name ext];
    imgB =imread(str);
    imgB=mat2gray(imgB); %ylw  for PASCAL_S
    [imgB_h,imgB_w, bpp] = size(imgB);
    if bpp == 3
        imgB = rgb2gray(imgB);
    end
    imgBd = im2double(imgB);
    imgB = imgBd >= 0.5; 
    imgB0 = imgB;
    imgB = imgB0(:);       
    
%% the Dataset   
%     name(1:4)=[];
%     imstr = [imgPath  name extname]; 
    imstr = [imgPath BinarymaskNames(i).name];
    imgT0 = imread(imstr);
%     %% change size   
    [imgT0_h,imgT0_w]=size(imgT0);
%     [imgB_h,imgB_w]=size(imgB);
    if imgT0_w~=imgB_w || imgT0_h~=imgB_h
        imgT0=imresize(imgT0,[imgB_h,imgB_w]);
        disp([name ' have different size with GT']);
    end  %% ylw
    
    imgT = imgT0(:);   
    %Normalization
    maxT = double(max(imgT));
    minT = double(min(imgT));
    imgT = uint8(round(double(imgT - minT) * 255 / (maxT - minT)));
   
    for threshold = 0 : 255 
        imgTT = imgT >= threshold;
        imgTT = imgTT(:);

        TP = sum( imgB &  imgTT);      
        FP = sum(~imgB &  imgTT);
        TN = sum(~imgB & ~imgTT);
        FN = sum( imgB & ~imgTT);

        if TP == 0
            precision(threshold+1) = 0;
            recall(threshold+1) = 0;
        else
            precision(threshold+1) = TP / sum(imgTT);
            recall(threshold+1) = TP / sum(imgB);
        end
        
        %TPR FPR
        fpr(threshold+1) = FP / (FP + TN); % 橫坐标
        tpr(threshold+1) = TP / (TP + FN); % 纵坐标
        psort(threshold+1, 1) = fpr(threshold+1);
        psort(threshold+1, 2) = tpr(threshold+1);
    end
    
    clear imgT imgTT

end