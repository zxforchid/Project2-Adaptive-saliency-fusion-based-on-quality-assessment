% 比较Method3基于质量评价的线性加权融合
% 后缀名分别为 m3 m3_1 m3_2
% 
clear all;close all;clc

fprintf('\n 初始化 .........')
datasets = {'MSRA10K','ECSSD','PASCAL850'}; %,'JuddDB'
modelSets = {'DRFI', 'QCUT', 'rbd', 'ST', 'DSR', 'MC'};

TOP6DataPath = ['D:\program debug\PHD\TOP6Data\'];
ImgsGTDataPath = ['ImgsGTData'];
salDataPath = ['salData'];
MeanExpLogDataPath = ['MeanExpLogData2'];

suffixSal = 'png';
suffixour0 = ['_m3.png'];
suffixour1 = ['_m3_1.png'];
suffixour2 = ['_m3_2.png'];
suffixMean = ['_mean.png'];
Suffixgt = '.png';
ddd=1;
testNames = {'test2k-0309','test2k-025075','test5k-045084','test5k-055079','test5k-06650701'};
testName = testNames{1,1};
for ddd=1:3
dataset = datasets{1,ddd};
GT_path = [TOP6DataPath,ImgsGTDataPath,'\',dataset,'\'];
meanexplogPath = [TOP6DataPath,MeanExpLogDataPath,'\',dataset,'\'];

ourPath = ['.\data\img_result\method3\',dataset,'\',testName,'\'];
    switch dataset
        case 'MSRA10K'
            numTraindata = 2000;
            load('index_method2_msra10k.mat')
            telist = index(numTraindata+1:length(index));
            num_te = length(telist);
            
        case 'ECSSD'
            telist = 1:1000;
            num_te = 1000;
 
        case 'PASCAL850'
            telist = 1:850;
            num_te = 850;  
    end
    
figure,hold on;

[~, ~,~, ~, ~, ~, ~,hdlY_our0] = Draw_PRF_Curve( ourPath,   suffixour0,   GT_path, Suffixgt, true, true,'r'); 
[~, ~,~, ~, ~, ~, ~,hdlY_our1] = Draw_PRF_Curve( ourPath,   suffixour1,   GT_path, Suffixgt, true, true,'g'); 
[~, ~,~, ~, ~, ~, ~,hdlY_our2] = Draw_PRF_Curve( ourPath,   suffixour2,   GT_path, Suffixgt, true, true,'b'); 
[~, ~,~,~, ~, ~, ~, hdlY_mean] = Draw_PRF_Curve_testlist(telist, meanexplogPath,   suffixMean,  GT_path, Suffixgt, true, true,'m');
hdlY = [hdlY_our0;hdlY_our1;hdlY_our2;hdlY_mean];
hold off;grid on;title([dataset,'-PR'])
legend_str =  { 'm3';'m3-1';'m3-2';'mean'}; 
gridLegend(hdlY,1,legend_str,'location','southwest');    
set(gca,'box','on');xlabel('Recall');ylabel('Precision')
set(get(gca,'XLabel'),'FontSize',15);%图上文字为8 point或小5号
set(get(gca,'YLabel'),'FontSize',15);
title(dataset)

end


