%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% demoSelect
% 根据验证集数据，选择最优参数
% 
% IVPLab,shanghai university,shanghai,china
% http://www.ivp.shu.edu.cn/Default.aspx
% xiaofei zhou,zxforchid@163.com
% 2016/4/6  15:36 PM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;close all;clc

%% initial &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
fprintf('\n 初始化 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
datasets = {'MSRA10K','ECSSD','PASCAL850'};
modelSets = {'DRFI', 'QCUT', 'rbd', 'ST', 'DSR', 'MC'};
pathForhead = 'D:\program debug\PHD\';sign = '1';

testNames   = {'test3k-025075','test3k-0309','test3k-04086'};
ThighsTlows = {[0.75,0.25],     [0.9,0.3],    [0.86,0.4]};
imourSuffixs = {'_m8.png','_m8_1.png','_m8_2.png'};
suffixour = imourSuffixs{1,2};
suffixMean = ['_mean.png'];
Suffixgt = '.png';
TOP6DataPath = ['D:\program debug\PHD\TOP6Data\'];
ImgsGTDataPath = ['ImgsGTData'];
MeanExpLogDataPath = ['MeanExpLogData2'];

TT=1;testName = testNames{1,TT};dd=1;
LS = [50:50:200];DS = [10:10:50];

GT_path = [TOP6DataPath,ImgsGTDataPath,'\',datasets{1,dd},'\'];
meanexplogPath = [TOP6DataPath,MeanExpLogDataPath,'\',datasets{1,dd},'\'];
%% 
if 0
Pre = zeros(1,length(LS)*length(DS));Rec = Pre; FM03 = Pre; FM1 = Pre;
wP = Pre; wR = Pre; wFM03 = Pre; wFM1 = Pre;Mae = Pre;
nn=0;
for LL=1:length(LS)
    for DD=1:length(DS)
        fprintf('\n&&&& LL=%d, DD=%d&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n',LS(LL),DS(DD))
        nn= nn + 1;
        ourPath = ['.\data\img_result(new)\method8\1-1\MSRA10K\test3k-025075\',num2str(LS(LL)),'-',num2str(DS(DD)),'\'];
        
        [Pre(1,nn),Rec(1,nn),FM03(1,nn),~,~,~,FM1(1,nn)] = ...
        compute_average_prf(ourPath,  suffixour, GT_path, Suffixgt);  
    
        [wP(1,nn),wR(1,nn),wFM03(1,nn),~,~,~,wFM1(1,nn)] = ...
        compute_weighted_prf(ourPath,  suffixour, GT_path, Suffixgt);  
    
        Mae(1,nn) = CalMeanMAE(ourPath, suffixour, GT_path, Suffixgt);
        
        
    end
    
end


fprintf('\n &&&&&&&&&&&&&&&&&&&&&&&&&&&& average PRF &&&&&&&&&&&&&&&&&&&&&&&\n')
[~,maxpre] = max(Pre);
[~,maxrec] = max(Rec);
[~,maxfm03] = max(FM03);
[~,maxfm1] = max(FM1);
fprintf('\n p = %d \n r = %d \n fm03 = %d \n fm1 = %d \n',maxpre,maxrec,maxfm03,maxfm1)

fprintf('\n &&&&&&&&&&&&&&&&&&&&&&&&&&&& weighted PRF &&&&&&&&&&&&&&&&&&&&&&&\n')
[~,maxwpre] = max(wP);
[~,maxwrec] = max(wR);
[~,maxwfm03] = max(wFM03);
[~,maxwfm1] = max(wFM1);
fprintf('\n wp = %d \n wr = %d \n wfm03 = %d \n wfm1 = %d \n',maxwpre,maxwrec,maxwfm03,maxwfm1)

[~,minMae] = min(Mae);
fprintf('\n minMAE = %d\n',minMae);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 1
 numtr=3000;numval=3000;numte=4000;
 load(['IndexMsra10k-',num2str(1),'.mat'])
 trlist  = tmpIndexMsra10k(1:numtr);
 vallist = tmpIndexMsra10k((numtr+1):(numtr+numval));
 telist  = tmpIndexMsra10k((numtr+numval+1):end);
 
suffixMean = ['_mean.png'];
suffixour0 = ['_m3_1.png'];
suffixour = ['_m8_1.png'];Suffixgt = '.png';
figure,hold on;
[~, ~,meanfms03,~, ~, ~, meanfms1, hdlY_mean] = ...
                Draw_PRF_Curve_testlist1(telist, meanexplogPath,   suffixMean,  GT_path, Suffixgt, true, true,'g');
            
ourPath = ['.\data\img_result(new)\method8\1\MSRA10K\test3k-025075\',num2str(100),'-',num2str(10),'\'];
[~, ~,ourfms03, ~, ~, ~, ourfms1,hdlY_our]  = ...
        Draw_PRF_Curve(ourPath,   suffixour,   GT_path, Suffixgt, true, true,'r'); 
    
ourPath0 = ['.\data\img_result(new)\method3\',datasets{1,dd},'\',testName,'\test\'];
[~, ~,our0fms03, ~, ~, ~, our0fms1,hdlY_our0]  = ...
        Draw_PRF_Curve(ourPath0,   suffixour0,   GT_path, Suffixgt, true, true,'b'); 
    
hdlYs = [hdlY_mean;hdlY_our;hdlY_our0];
hold off;grid on;title([datasets{1,dd},'-PR'])
legend_str =  {'mean';'our';'our0'}; 
gridLegend(hdlYs,1,legend_str,'location','southwest');    
set(gca,'box','on');xlabel('Recall');ylabel('Precision')
set(get(gca,'XLabel'),'FontSize',10);%图上文字为8 point或小5号
set(get(gca,'YLabel'),'FontSize',10);


    fx = [0:1:255];
    % FM03
    figure,hold on;
    Fhanle = [];
    hdlour0 = plot(fx, our0fms03, 'color', 'b', 'linewidth', 2);
    hdlour = plot(fx, ourfms03, 'color', 'r', 'linewidth', 2);
    hdlmean = plot(fx, meanfms03, 'color', 'g', 'linewidth', 2);
    Fhanle = [Fhanle;hdlour0;hdlour;hdlmean];
    hold off;grid on;  title([datasets{1,dd},'-Fmeasures03']) 
    legend_str =  {'our0'; 'our'; 'mean'; };  
    gridLegend(Fhanle,1,legend_str,'location','southwest');    
    set(gca,'box','on');xlabel('threshold');ylabel('F-measure')
%     set(gca,'XTick',[0:50:250]); set(gca,'yTick',[0:0.1:1]) 
    axis([0 250,0,1])
    set(get(gca,'XLabel'),'FontSize',10);%图上文字为8 point或小5号
    set(get(gca,'YLabel'),'FontSize',10);
    
    
    
    fx = [0:1:255];
    % FM1
    figure,hold on;
    Fhanle = [];
    hdlour0 = plot(fx, our0fms1, 'color', 'b', 'linewidth', 2);
    hdlour = plot(fx, ourfms1, 'color', 'r', 'linewidth', 2);
    hdlmean = plot(fx, meanfms1, 'color', 'g', 'linewidth', 2);
    Fhanle = [Fhanle;hdlour0;hdlour;hdlmean];
    hold off;grid on;  title([datasets{1,dd},'-Fmeasures1']) 
    legend_str =  {'our0'; 'our'; 'mean'; };  
    gridLegend(Fhanle,1,legend_str,'location','southwest');    
    set(gca,'box','on');xlabel('threshold');ylabel('F-measure')
%     set(gca,'XTick',[0:50:250]); set(gca,'yTick',[0:0.1:1]) 
    axis([0 250,0,1])
    set(get(gca,'XLabel'),'FontSize',10);%图上文字为8 point或小5号
    set(get(gca,'YLabel'),'FontSize',10);    
    
    
[Pre,Rec,FM03,~,~,~,FM1] = ...
        compute_average_prf(ourPath,  suffixour, GT_path, Suffixgt);  
[Pre0,Rec0,FM030,~,~,~,FM10] = ...
        compute_average_prf(ourPath0,  suffixour0, GT_path, Suffixgt); 
[meanP,meanR,meanFM03,~,~,~,meanFM1] = ...
        compute_average_prf_fortelist(telist, meanexplogPath,  suffixMean, GT_path, Suffixgt);    
    
[wP,wR,wFM03,~,~,~,wFM1] = ...
        compute_weighted_prf(ourPath,  suffixour, GT_path, Suffixgt);  
[wP0,wR0,wFM030,~,~,~,wFM10] = ...
        compute_weighted_prf(ourPath0,  suffixour0, GT_path, Suffixgt);  
[meanwP,meanwR,meanwFM03,~,~,~,meanwFM1] = ...
        compute_weighted_prf_fortelist(telist, meanexplogPath,  suffixMean, GT_path, Suffixgt);
    
Mae = CalMeanMAE(ourPath, suffixour, GT_path, Suffixgt);
Mae0 = CalMeanMAE(ourPath0, suffixour0, GT_path, Suffixgt);
meanMae = CalMeanMAE_fortelist(telist, meanexplogPath, suffixMean, GT_path, Suffixgt);

PRF = [Pre,Rec,FM03,FM1;Pre0,Rec0,FM030,FM10;meanP,meanR,meanFM03,meanFM1];
WPRF = [wP,wR,wFM03,wFM1;wP0,wR0,wFM030,wFM10;meanwP,meanwR,meanwFM03,meanwFM1];
maes = [Mae;Mae0;meanMae];
end






