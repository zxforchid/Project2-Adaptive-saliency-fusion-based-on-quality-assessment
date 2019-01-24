% test drown new result
% 针对method3做的改进，加入反馈调节机制，结果有f1 f2 f3 f4 crf m3_1
% 2016/03/03 9:04AM
% copyright by xiaofei zhou,shanghai university
% 

clear all;close all;clc

%% initial %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\n 初始化 .........')
datasets = {'MSRA10K','ECSSD','PASCAL850'}; %,'JuddDB'
modelSets = {'DRFI', 'QCUT', 'rbd', 'ST', 'DSR', 'MC'};

TOP6DataPath = ['D:\program debug\PHD\TOP6Data\'];
ImgsGTDataPath = ['ImgsGTData'];
salDataPath = ['salData'];
MeanExpLogDataPath = ['MeanExpLogData2'];

suffixSal = 'png';
load('colorindex.mat')
r = linspace(0,1,15);
g = r;b=r;

ourMae = zeros(1,length(datasets));meanMae = ourMae;expMae = ourMae;logMae = ourMae;

ourP = zeros(1,length(datasets));ourR = ourP;ourFM03 = ourP;ourFM05 = ourP;ourFM07 = ourP;ourFM09 = ourP;ourFM1= ourP;
ourwP = ourP;ourwR = ourwP;ourwFM03 = ourwP;ourwFM05 = ourwP;ourwFM07 = ourwP;ourwFM09 = ourwP;ourwFM1= ourwP;

our0fms03=cell(1,length(datasets));our0fms05 =our0fms03; our0fms07=our0fms03; our0fms09=our0fms03; our0fms1=our0fms03;
our1fms03=cell(1,length(datasets));our1fms05 =our1fms03; our1fms07=our1fms03; our1fms09=our1fms03; our1fms1=our1fms03;
our2fms03=cell(1,length(datasets));our2fms05 =our2fms03; our2fms07=our2fms03; our2fms09=our2fms03; our2fms1=our2fms03;
our3fms03=cell(1,length(datasets));our3fms05 =our3fms03; our3fms07=our3fms03; our3fms09=our3fms03; our3fms1=our3fms03;
our4fms03=cell(1,length(datasets));our4fms05 =our4fms03; our4fms07=our4fms03; our4fms09=our4fms03; our4fms1=our4fms03;

meanP = ourP; meanR = ourP; meanFM03 = ourP; meanFM05 = ourP; meanFM07 = ourP; meanFM09 = ourP;meanFM1 = ourP;
meanwP = ourP; meanwR = ourP; meanwFM03 = ourP; meanwFM05 = ourP; meanwFM07 = ourP; meanwFM09 = ourP;meanwFM1 = ourP;
meanfms03 = cell(1,length(datasets));meanfms05 =meanfms03; meanfms07=meanfms03; meanfms09=meanfms03; meanfms1=meanfms03;

%% drow %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 1:length(datasets)
for dd = 1:length(datasets)
    % 确定GroundTruth
    dataset = datasets{1,dd};
    GT_path = [TOP6DataPath,ImgsGTDataPath,'\',dataset,'\'];
    GT = dir([GT_path '*' 'png']);
    ourPath = ['.\data\img_result\method3_1\',dataset,'\'];
    meanexplogPath = [TOP6DataPath,MeanExpLogDataPath,'\',dataset,'\'];
    
    figure,hold on;
    hdlY = [];          
    % 确定训练集、测试集的ID
    switch dataset
        case 'MSRA10K'
            % nethod3_1_2 5000(0.8,0.2); method3_1_1 5000(0.75,0.25); method3_1 2000(0.75,0.25)
            numTraindata = 2000;
            load('index_method2_msra10k.mat')
            telist = index(numTraindata+1:length(index));
            num_te = length(telist);
            
        case 'ECSSD'
            telist = 1:length(GT);
            num_te = length(GT);
 
        case 'PASCAL850'
            telist = 1:length(GT);
            num_te = length(GT);  
    end
    
    suffixMean = ['_mean.png'];
    suffixf1 = ['_f1.png'];
    suffixf2 = ['_f2.png'];
    suffixf3 = ['_f3.png'];
    suffixf4 = ['_f4.png'];
    suffixf0 = ['_m3_1.png'];
    Suffixgt = '.png';
%       CCour0 = [r(ir(2)),g(ig(2)),b(ib(2))]; 
    CCour0 = 'r';
    CCour1 = 'g';
    CCour2 = 'b';
    CCour3 = 'k';
    CCour4 = 'm';
%       CCour1 = [r(ir(4)),g(ig(4)),b(ib(4))];  
%       CCour2 = [r(ir(6)),g(ig(6)),b(ib(6))];  
%       CCour3 = [r(ir(8)),g(ig(8)),b(ib(8))];  
%       CCour4 = [r(ir(10)),g(ig(10)),b(ib(10))];  
      CCmean = [r(ir(6)),g(ig(6)),b(ib(6))];  
    [~, ~,our0fms03{1,dd}, our0fms05{1,dd}, our0fms07{1,dd}, our0fms09{1,dd}, our0fms1{1,dd},hdlY_our0]  = ...
        Draw_PRF_Curve(ourPath,   suffixf0,   GT_path, Suffixgt, true, true,CCour0);    
    
    [~, ~,our1fms03{1,dd}, our1fms05{1,dd}, our1fms07{1,dd}, our1fms09{1,dd}, our1fms1{1,dd},hdlY_our1]  = ...
        Draw_PRF_Curve(ourPath,   suffixf1,   GT_path, Suffixgt, true, true,CCour1);  
        
    [~, ~,our2fms03{1,dd}, our2fms05{1,dd}, our2fms07{1,dd}, our2fms09{1,dd}, our2fms1{1,dd},hdlY_our2]  = ...
        Draw_PRF_Curve(ourPath,   suffixf2,   GT_path, Suffixgt, true, true,CCour2);  
        
    [~, ~,our3fms03{1,dd}, our3fms05{1,dd}, our3fms07{1,dd}, our3fms09{1,dd}, our3fms1{1,dd},hdlY_our3]  = ...
        Draw_PRF_Curve(ourPath,   suffixf3,   GT_path, Suffixgt, true, true,CCour3);  
        
    [~, ~,our4fms03{1,dd}, our4fms05{1,dd}, our4fms07{1,dd}, our4fms09{1,dd}, our4fms1{1,dd},hdlY_our4]  = ...
        Draw_PRF_Curve(ourPath,   suffixf4,   GT_path, Suffixgt, true, true,CCour4);  
   
    [~, ~,meanfms03{1,dd}, meanfms05{1,dd}, meanfms07{1,dd}, meanfms09{1,dd}, meanfms1{1,dd}, hdlY_mean] = ...
        Draw_PRF_Curve_testlist(telist, meanexplogPath,   suffixMean,  GT_path, Suffixgt, true, true,CCmean);
    
    hdlY = [hdlY;hdlY_our0;hdlY_our1;hdlY_our2;hdlY_our3;hdlY_our4;hdlY_mean;];
    hold off;grid on;title([dataset,'-PR'])
    legend_str =  { 'f0';'f1';'f2';'f3';'f4';'mean';}; 
    gridLegend(hdlY,2,legend_str,'location','southwest');    
    set(gca,'box','on');xlabel('Recall');ylabel('Precision')
    set(get(gca,'XLabel'),'FontSize',15);%图上文字为8 point或小5号
    set(get(gca,'YLabel'),'FontSize',15);
    
   
end




















