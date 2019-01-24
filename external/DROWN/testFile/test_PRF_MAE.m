% 绘制PR曲线， 计算 平均 F-meansure/precision/recall/ MAE 值
% written by xiaofei zhou, shanghia university, shanghai, china
% 2016/1/25 15:15PM
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;close all;clc

%% initial %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\n 初始化 .........')
datasets = {'MSRA10K','ECSSD','JuddDB','PASCAL850'}; %
modelSets = {'DRFI', 'QCUT', 'rbd', 'ST', 'DSR', 'MC'};

TOP6DataPath = ['D:\program debug\PHD\TOP6Data\'];
ImgsGTDataPath = ['ImgsGTData'];
salDataPath = ['salData'];
MeanExpLogDataPath = ['MeanExpLogData2'];

suffixSal = 'png';
% CC = {'r','b','m','g','k',[0 0.75 0.75]};
load('colorindex.mat')
r = linspace(0,1,15);
g = r;b=r;

ourMae = zeros(1,length(datasets));
meanMae = ourMae;expMae = ourMae;logMae = ourMae;

salP = zeros(length(modelSets),length(datasets));
salR = salP; salFM03 = salP; salFM05 = salP;salFM1 = salP;    
ourP = zeros(1,length(datasets));
ourR = ourP;ourFM03 = ourP;ourFM05 = ourP;ourFM1= ourP;
meanP = ourP; meanR = ourP; meanFM03 = ourP; meanFM05 = ourP; meanFM1 = ourP;
expP = ourP; expR = ourP; expFM03 = ourP; expFM05 = ourP; expFM1 = ourP;
logP = ourP; logR = ourP; logFM03 = ourP; logFM05 = ourP; logFM1 = ourP;
    
%% drow %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 1:length(datasets)
for dd = length(datasets)
    % 确定GroundTruth
    dataset = datasets{1,dd};
    GT_path = [TOP6DataPath,ImgsGTDataPath,'\',dataset,'\'];
    GT = dir([GT_path '*' 'png']);
    RESULTpath = ['.\data\img_result\method3_1\',dataset,'\'];
    meanexplogPath = [TOP6DataPath,MeanExpLogDataPath,'\',dataset,'\'];
    
    figure,hold on;
    hdlY = [];          
    % 确定训练集、测试集的ID
    switch dataset
        case 'MSRA10K'
            numTraindata = 2000;
            load('index_method2_msra10k.mat')
            telist = index(numTraindata+1:length(index));
            num_te = length(telist);
            
        case 'ECSSD'
            telist = 1:length(GT);
            num_te = length(GT);
            
        case 'JuddDB'
            telist = 1:length(GT);
            num_te = length(GT);   
        case 'PASCAL850'
            telist = 1:length(GT);
            num_te = length(GT);  
    end
    
    suffixMean = ['_mean.png'];
    suffixExp = ['_exp.png'];
    suffixLog = ['_log.png'];
    suffixour = ['_m3_1.png'];
    Suffixgt = '.png';
      
   % 6种模型对应的显著性图     
    for mm=1:length(modelSets)
        methodname = modelSets{mm};        
        fprintf('\n %s| %s \n',dataset,methodname)
        salPath = [TOP6DataPath,salDataPath,'\', dataset, '\', methodname,'\'];
        Suffixsalmap = ['_' methodname '.png'];
                    
        [salP(mm, dd),salR(mm, dd),salFM03(mm, dd),salFM05(mm, dd),salFM1(mm, dd)] = ...
                  compute_fmeasure_forrevised(salPath,  Suffixsalmap, GT_path, Suffixgt);   
        
        CC = [r(ir(mm)),g(ig(mm)),b(ib(mm))];
              
        [~, ~,~,~, hdlY_sal]    = DrawPRCurve1(salPath,   Suffixsalmap,   GT_path, Suffixgt, true, true,CC);    
        hdlY = [hdlY;hdlY_sal;];
        clear hdlY_sal
    end
    CCour = [r(ir(7)),g(ig(7)),b(ib(7))];
    CCmean = [r(ir(8)),g(ig(8)),b(ib(8))];
    CCexp = [r(ir(9)),g(ig(9)),b(ib(9))];
    CClog = [r(ir(10)),g(ig(10)),b(ib(10))];
     % draw  mean and crf saliency map 
    [~, ~,f03Our,~, hdlY_our]  = DrawPRCurve1(RESULTpath,   suffixour,   GT_path, Suffixgt, true, true,CCour);
    [~, ~,f03Omean,~, hdlY_mean] = DrawPRCurve_forfusion(telist, meanexplogPath,   suffixMean,  GT_path, Suffixgt, true, true,CCmean);
    [~, ~,~,~, hdlY_exp]  = DrawPRCurve_forfusion(telist, meanexplogPath,   suffixExp,   GT_path, Suffixgt, true, true,CCexp);
    [~, ~,~,~, hdlY_log]  = DrawPRCurve_forfusion(telist, meanexplogPath,   suffixLog,   GT_path, Suffixgt, true, true,CClog);
    hdlY = [hdlY;hdlY_our;hdlY_mean;hdlY_exp;hdlY_log;];
    hold off;
    grid on;   

    legend_str =  {'DRFI'; 'QCUT'; 'rbd'; 'ST'; 'DSR'; 'MC';'our';'mean';'exp';'log';};  
    gridLegend(hdlY,2,legend_str,'location','southwest');    
    set(gca,'box','on');xlabel('Recall');ylabel('Precision')
    set(get(gca,'XLabel'),'FontSize',15);%图上文字为8 point或小5号
    set(get(gca,'YLabel'),'FontSize',15);

    % 计算MAE
    ourMae(1,dd) = CalMeanMAE(RESULTpath, suffixour, GT_path, Suffixgt);
    meanMae(1,dd) = CalMeanMAE_fortelist(telist, meanexplogPath, suffixMean, GT_path, Suffixgt);
    expMae(1,dd) = CalMeanMAE_fortelist(telist, meanexplogPath, suffixExp, GT_path, Suffixgt);
    logMae(1,dd) = CalMeanMAE_fortelist(telist, meanexplogPath, suffixLog, GT_path, Suffixgt);
    
    % 计算平均的F-measure /precision /recall    
    [ourP(1,dd),ourR(1,dd),ourFM03(1,dd),ourFM05(1,dd),ourFM1(1,dd)] = ...
        compute_fmeasure_forrevised(RESULTpath,  suffixour, GT_path, Suffixgt);   
    [meanP(1,dd),meanR(1,dd),meanFM03(1,dd),meanFM05(1,dd),meanFM1(1,dd)] = ...
        compute_fmeasure_fortelist(telist, meanexplogPath,  suffixMean, GT_path, Suffixgt);
    [expP(1,dd),expR(1,dd),expFM03(1,dd),expFM05(1,dd),expFM1(1,dd)] = ...
        compute_fmeasure_fortelist(telist, meanexplogPath,  suffixExp, GT_path, Suffixgt);
    [logP(1,dd),logR(1,dd),logFM03(1,dd),logFM05(1,dd),logFM1(1,dd)] = ...
        compute_fmeasure_fortelist(telist, meanexplogPath,  suffixLog, GT_path, Suffixgt);

end
