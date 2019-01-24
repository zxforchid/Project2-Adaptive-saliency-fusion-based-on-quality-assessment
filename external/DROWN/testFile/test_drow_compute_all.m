% 处理以下任务：
% （1）绘制P-R曲线，F-measure曲线（0.3,0.5,0.7,0.9,1）
% （2）计算平均 F-measure, Precision, Recall
% （3）计算MAE
% written by xiaofei zhou, shanghia university, shanghai, china
% 2016/1/28 14:00 PM
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;close all;clc

%% initial %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\n 初始化 .........')
datasets = {'MSRA10K','ECSSD','PASCAL850'}; %,'JuddDB'
modelSets = {'DRFI', 'QCUT', 'rbd', 'ST', 'DSR', 'MC'};

TOP6DataPath = ['D:\program debug\PHD\TOP6Data\'];
ImgsGTDataPath = ['ImgsGTData'];
salDataPath = ['salData'];
MeanExpLogDataPath = ['MeanExpLogDataNew'];

suffixSal = 'png';
load('colorindex.mat')
r = linspace(0,1,15);
g = r;b=r;
salMae = zeros(length(modelSets),length(datasets));
ourMae = zeros(1,length(datasets));meanMae = ourMae;expMae = ourMae;logMae = ourMae;

salP = zeros(length(modelSets),length(datasets));salR = salP; salFM03 = salP; salFM05 = salP;salFM07 = salP;salFM09 = salP;salFM1 = salP;  
salwP = zeros(length(modelSets),length(datasets));salwR = salwP; salwFM03 = salwP; salwFM05 = salwP;salwFM07 = salwP;salwFM09 = salwP;salwFM1 = salwP; 
salfms03 = cell(length(modelSets),length(datasets));salfms05 = salfms03; salfms07= salfms03; salfms09= salfms03; salfms1= salfms03;

ourP = zeros(1,length(datasets));ourR = ourP;ourFM03 = ourP;ourFM05 = ourP;ourFM07 = ourP;ourFM09 = ourP;ourFM1= ourP;
ourwP = ourP;ourwR = ourwP;ourwFM03 = ourwP;ourwFM05 = ourwP;ourwFM07 = ourwP;ourwFM09 = ourwP;ourwFM1= ourwP;
ourfms03=cell(1,length(datasets));ourfms05 =ourfms03; ourfms07=ourfms03; ourfms09=ourfms03; ourfms1=ourfms03;

meanP = ourP; meanR = ourP; meanFM03 = ourP; meanFM05 = ourP; meanFM07 = ourP; meanFM09 = ourP;meanFM1 = ourP;
meanwP = ourP; meanwR = ourP; meanwFM03 = ourP; meanwFM05 = ourP; meanwFM07 = ourP; meanwFM09 = ourP;meanwFM1 = ourP;
meanfms03 = cell(1,length(datasets));meanfms05 =meanfms03; meanfms07=meanfms03; meanfms09=meanfms03; meanfms1=meanfms03;

expP = ourP; expR = ourP; expFM03 = ourP; expFM05 = ourP; expFM07 = ourP; expFM09 = ourP;expFM1 = ourP;
expwP = ourP; expwR = ourP; expwFM03 = ourP; expwFM05 = ourP; expwFM07 = ourP; expwFM09 = ourP;expwFM1 = ourP;
expfms03 = cell(1,length(datasets));expfms05 =expfms03; expfms07=expfms03; expfms09=expfms03; expfms1=expfms03;

logP = ourP; logR = ourP; logFM03 = ourP; logFM05 = ourP; logFM07 = ourP; logFM09 = ourP; logFM1 = ourP;
logwP = ourP; logwR = ourP; logwFM03 = ourP; logwFM05 = ourP; logwFM07 = ourP; logwFM09 = ourP; logwFM1 = ourP;
logfms03 = cell(1,length(datasets));logfms05 =logfms03; logfms07=logfms03; logfms09=logfms03; logfms1=logfms03;
 
testNames   = {'test3k-025075','test3k-0309','test3k-04086','test3k-05082'};
ThighsTlows = {[0.75,0.25],     [0.9,0.3],    [0.86,0.4],    [0.82,0.5]};
testName = testNames{1,1};
%% drow %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 1:length(datasets)
TOPfile = 'TOP6';
for dd = 1:length(datasets)
    % 确定GroundTruth
    dataset = datasets{1,dd};
    GT_path = [TOP6DataPath,ImgsGTDataPath,'\',dataset,'\'];
    GT = dir([GT_path '*' 'png']);
% %     D:\program debug\PHD\project2\data\img_result(new)\method3\Evalueate\MSRA10K\All\TOP6\test3k-025075\test
%     ourPath = ['.\data\img_result(new4)\method3\Evalueate\',dataset,'\Liu\',TOPfile,'\',testName,'\test\'];
% %     meanexplogPath = [TOP6DataPath,MeanExpLogDataPath,'\',dataset,'\'];
% % D:\program debug\PHD\project2\data\img_result(new2)\method3\Evalueate\MSRA10K\All\TOP6\test3k-025075\test\20160411-CRF

%     ourPath = ['.\data\img_result(new1)\method3\Evalueate\',dataset,'\Liu\TOP6\',testName,'\test\'];%20160422-graphCut\7\
    meanexplogPath = [TOP6DataPath,MeanExpLogDataPath,'\',TOPfile,'\',dataset,'\'];
    figure,hold on;
    hdlY = [];          
    % 确定训练集、测试集的ID
    switch dataset
        case 'MSRA10K'
            numtr=3000;numval=3000;numte=4000;
            load(['IndexMsra10k-',num2str(1),'.mat'])
            trlist  = tmpIndexMsra10k(1:numtr);
            vallist = tmpIndexMsra10k((numtr+1):(numtr+numval));
            telist  = tmpIndexMsra10k((numtr+numval+1):end);
            ourPath = ['.\data\img_result(new2)\method3\Evalueate\',dataset,'\Liu\',TOPfile,'\',testName,'\test\'];%20160422-graphCut\0.1\
        case 'ECSSD'
            telist = 1:length(GT);
            num_te = length(GT);
            ourPath = ['.\data\img_result(new2)\method3\Evalueate\',dataset,'\Liu\',TOPfile,'\',testName,'\test\'];% 20160422-graphCut\0.1\
        case 'PASCAL850'
            telist = 1:length(GT);
            num_te = length(GT);  
            ourPath = ['.\data\img_result(new2)\method3\Evalueate\',dataset,'\Liu\',TOPfile,'\',testName,'\test\'];% 20160422-graphCut\0.1\
    end
    
    suffixMean = ['_mean.png'];
    suffixExp = ['_exp.png'];
    suffixLog = ['_log.png'];
    suffixour = ['_m3.png'];%   _1_gc_filter_m3_1  _1_gc
    Suffixgt = '.png';
      
   %% PR曲线 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&  
    for mm=1:length(modelSets)
        methodname = modelSets{mm};        
        fprintf('\n %s| %s \n',dataset,methodname)
        salPath = [TOP6DataPath,salDataPath,'\', dataset, '\', methodname,'\'];
        Suffixsalmap = ['_' methodname '.png'];
        if 0
         [salwP(mm, dd),salwR(mm, dd),salwFM03(mm, dd),salwFM05(mm, dd),salwFM07(mm, dd), salwFM09(mm, dd), salwFM1(mm, dd)] = ...
             compute_weighted_prf_fortelist1(telist,salPath,  Suffixsalmap, GT_path, Suffixgt);
        
        [salP(mm, dd),salR(mm, dd),salFM03(mm, dd),salFM05(mm, dd),salFM07(mm, dd), salFM09(mm, dd), salFM1(mm, dd)] = ...
             compute_average_prf_fortelist1(telist,salPath,  Suffixsalmap, GT_path, Suffixgt);   
         
         salMae(mm,dd) = CalMeanMAE_fortelist1(telist, salPath, Suffixsalmap, GT_path, Suffixgt);
        end
        
        CC = [r(ir(mm)),g(ig(mm)),b(ib(mm))];    
        [~, ~,salfms03{mm,dd}, salfms05{mm,dd}, salfms07{mm,dd}, salfms09{mm,dd}, salfms1{mm,dd}, hdlY_sal] = ...
             Draw_PRF_Curve_testlist1(telist, salPath,   Suffixsalmap,   GT_path, Suffixgt, true, true,CC);    
        
        hdlY = [hdlY;hdlY_sal;];
        clear hdlY_sal
           
    end
    
    % draw  mean/exp/log/our method PRF curves 
     CCour = 'r'; CCmean = 'b'; CCexp = 'k';CClog = 'g'; 
    [~, ~,ourfms03{1,dd}, ourfms05{1,dd}, ourfms07{1,dd}, ourfms09{1,dd}, ourfms1{1,dd},hdlY_our]  = ...
        Draw_PRF_Curve_end(ourPath,   suffixour,   GT_path, Suffixgt, true, true,CCour);    
    
    [~, ~,meanfms03{1,dd}, meanfms05{1,dd}, meanfms07{1,dd}, meanfms09{1,dd}, meanfms1{1,dd}, hdlY_mean] = ...
        Draw_PRF_Curve_testlist1_end(telist, meanexplogPath,   suffixMean,  GT_path, Suffixgt, true, true,CCmean);
    
    [~, ~,expfms03{1,dd}, expfms05{1,dd}, expfms07{1,dd}, expfms09{1,dd}, expfms1{1,dd}, hdlY_exp]  = ...
        Draw_PRF_Curve_testlist1_end(telist, meanexplogPath,   suffixExp,   GT_path, Suffixgt, true, true,CCexp);
    
    [~, ~,logfms03{1,dd}, logfms05{1,dd}, logfms07{1,dd}, logfms09{1,dd}, logfms1{1,dd}, hdlY_log]  = ...
        Draw_PRF_Curve_testlist1_end(telist, meanexplogPath,   suffixLog,   GT_path, Suffixgt, true, true,CClog);
    
    hdlY = [hdlY;hdlY_our;hdlY_mean;hdlY_exp;hdlY_log;];
    hold off;grid on;%title([dataset,'-PR'])
    legend_str =  {'DRFI'; 'QCUT'; 'RBD'; 'ST'; 'DSR'; 'MC'; 'OUR';'AVG';'EXP';'LOG';}; 
    gridLegend(hdlY,3,legend_str,'location','southwest');    
    set(gca,'box','on');xlabel('Recall');ylabel('Precision')
    set(get(gca,'XLabel'),'FontSize',15);%图上文字为8 point或小5号
    set(get(gca,'YLabel'),'FontSize',15);
    
    
    %% 绘制F-measures曲线 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%     fx = [255:-1:0];
    fx = [0:1:255];
    % FM03
    figure,hold on;
    Fhanle = [];
    for  mm=1:length(modelSets)
%         CC = colors{1,mm};
%         hdlSal = plot(fx, salfms03{mm, dd}, CC, 'linewidth', 2);
         CC = [r(ir(mm)),g(ig(mm)),b(ib(mm))]; 
         hdlSal = plot(fx, salfms03{mm, dd}, 'color', CC,'LineStyle', '--', 'linewidth', 2);         
         Fhanle = [Fhanle;hdlSal;];
    end
    
    hdlour = plot(fx, ourfms03{1,dd}, 'color', CCour, 'linewidth', 2);
    hdlmean = plot(fx, meanfms03{1,dd}, 'color', CCmean, 'linewidth', 2);
    hdlexp = plot(fx, expfms03{1,dd}, 'color', CCexp, 'linewidth', 2);
    hdllog = plot(fx, logfms03{1,dd}, 'color', CClog, 'linewidth', 2);
    Fhanle = [Fhanle;hdlour;hdlmean;hdlexp;hdllog];
    hold off;grid on;  %title([dataset,'-Fmeasures03']) 
    legend_str =  {'DRFI'; 'QCUT'; 'RBD'; 'ST'; 'DSR'; 'MC'; 'OUR';'AVG';'EXP';'LOG';};   
    gridLegend(Fhanle,3,legend_str,'location','southwest');    
    set(gca,'box','on');xlabel('threshold');ylabel('F-measure')
    axis([0 255,0,1])
    set(get(gca,'XLabel'),'FontSize',15);%图上文字为8 point或小5号
    set(get(gca,'YLabel'),'FontSize',15);

 
    % FM1
    figure,hold on;
    Fhanle = [];
    for  mm=1:length(modelSets)
%         CC = colors{1,mm};
%         hdlSal = plot(fx, salfms1{mm, dd}, CC, 'linewidth', 2);
         CC = [r(ir(mm)),g(ig(mm)),b(ib(mm))]; 
         hdlSal = plot(fx, salfms1{mm, dd}, 'color', CC, 'LineStyle', '--','linewidth', 2);         
         Fhanle = [Fhanle;hdlSal;];
    end
    hdlour = plot(fx, ourfms1{1,dd}, 'color', CCour, 'linewidth', 2);
    hdlmean = plot(fx, meanfms1{1,dd}, 'color', CCmean, 'linewidth', 2);
    hdlexp = plot(fx, expfms1{1,dd}, 'color', CCexp, 'linewidth', 2);
    hdllog = plot(fx, logfms1{1,dd}, 'color', CClog, 'linewidth', 2);
    Fhanle = [Fhanle;hdlour;hdlmean;hdlexp;hdllog];
    hold off;grid on; % title([dataset,'-Fmeasures1']) 
    legend_str =  {'DRFI'; 'QCUT'; 'RBD'; 'ST'; 'DSR'; 'MC'; 'OUR';'AVG';'EXP';'LOG';};   
    gridLegend(Fhanle,3,legend_str,'location','southwest');    
    set(gca,'box','on');xlabel('threshold');ylabel('F-measure')
    axis([0 255,0,1])
    set(get(gca,'XLabel'),'FontSize',15);%图上文字为8 point或小5号
    set(get(gca,'YLabel'),'FontSize',15);
    
    
    if 1
    ourMae(1,dd) = CalMeanMAE(ourPath, suffixour, GT_path, Suffixgt);
    [ourP(1,dd),ourR(1,dd),ourFM03(1,dd),ourFM05(1,dd),ourFM07(1,dd),ourFM09(1,dd),ourFM1(1,dd)] = ...
        compute_average_prf(ourPath,  suffixour, GT_path, Suffixgt);  
    [ourwP(1,dd),ourwR(1,dd),ourwFM03(1,dd),ourwFM05(1,dd),ourwFM07(1,dd),ourwFM09(1,dd),ourwFM1(1,dd)] = ...
        compute_weighted_prf(ourPath,  suffixour, GT_path, Suffixgt);   
    end
    
    if 0
    %% 计算MAE &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    
    meanMae(1,dd) = CalMeanMAE_fortelist1(telist, meanexplogPath, suffixMean, GT_path, Suffixgt);
    expMae(1,dd) = CalMeanMAE_fortelist1(telist, meanexplogPath, suffixExp, GT_path, Suffixgt);
    logMae(1,dd) = CalMeanMAE_fortelist1(telist, meanexplogPath, suffixLog, GT_path, Suffixgt);
    
    %% 计算平均的F-measure /precision /recall   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    
    [meanP(1,dd),meanR(1,dd),meanFM03(1,dd),meanFM05(1,dd),meanFM07(1,dd),meanFM09(1,dd),meanFM1(1,dd)] = ...
        compute_average_prf_fortelist1(telist, meanexplogPath,  suffixMean, GT_path, Suffixgt);
    
    [expP(1,dd),expR(1,dd),expFM03(1,dd),expFM05(1,dd),expFM07(1,dd),expFM09(1,dd),expFM1(1,dd)] = ...
        compute_average_prf_fortelist1(telist, meanexplogPath,  suffixExp, GT_path, Suffixgt);
    
    [logP(1,dd),logR(1,dd),logFM03(1,dd),logFM05(1,dd),logFM07(1,dd),logFM09(1,dd),logFM1(1,dd)] = ...
        compute_average_prf_fortelist1(telist, meanexplogPath,  suffixLog, GT_path, Suffixgt);

    
    %% 计算加权的F-measure/Precision/Recall
   
    
    [meanwP(1,dd),meanwR(1,dd),meanwFM03(1,dd),meanwFM05(1,dd),meanwFM07(1,dd),meanwFM09(1,dd),meanwFM1(1,dd)] = ...
        compute_weighted_prf_fortelist1(telist, meanexplogPath,  suffixMean, GT_path, Suffixgt);
    
    [expwP(1,dd),expwR(1,dd),expwFM03(1,dd),expwFM05(1,dd),expwFM07(1,dd),expwFM09(1,dd),expwFM1(1,dd)] = ...
        compute_weighted_prf_fortelist1(telist, meanexplogPath,  suffixExp, GT_path, Suffixgt);
    
    [logwP(1,dd),logwR(1,dd),logwFM03(1,dd),logwFM05(1,dd),logwFM07(1,dd),logwFM09(1,dd),logwFM1(1,dd)] = ...
        compute_weighted_prf_fortelist1(telist, meanexplogPath,  suffixLog, GT_path, Suffixgt);
    
    end
end

MAES = [ourMae;meanMae;expMae;logMae;salMae];

F03  = [ourFM03;meanFM03;expFM03;logFM03;salFM03];
F1   = [ourFM1;meanFM1;expFM1;logFM1;salFM1];

WF03  = [ourwFM03;meanwFM03;expwFM03;logwFM03;salwFM03];
WF1   = [ourwFM1; meanwFM1; expwFM1; logwFM1; salwFM1];
