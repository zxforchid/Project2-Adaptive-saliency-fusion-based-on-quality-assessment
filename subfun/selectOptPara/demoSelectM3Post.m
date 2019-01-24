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
dd=1;
%% 对应方法的相关参数 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
% method3-postprocessing
testNames   = {'test3k-025075','test3k-0309','test3k-04086'};
ThighsTlows = {[0.75,0.25],     [0.9,0.3],    [0.86,0.4]};
% crfparas = [0.01,0.025,0.05,0.1,0.2,0.5,0.75]; % 7个参数
crfparas = [0.01,0.1,2,10, 50, 80];
% imSuffixs = {'_m3_crf.png','_m3_1_crf.png','_m3_2_crf.png'};
imSuffixs = {'_1_gc.png','_1_gc_filter.png','_2_gc.png','_2_gc.filter'};
TT=1;testName = testNames{1,TT};

suffixour = imSuffixs{1,4};Suffixgt = '.png';
TOP6DataPath = ['D:\program debug\PHD\TOP6Data\'];
ImgsGTDataPath = ['ImgsGTData'];
MeanExpLogDataPath = ['MeanExpLogData2'];
GT_path = [TOP6DataPath,ImgsGTDataPath,'\',datasets{1,dd},'\'];
meanexplogPath = [TOP6DataPath,MeanExpLogDataPath,'\',datasets{1,dd},'\'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 参数选择  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 1
load('colorindex.mat')
r = linspace(0,1,15);
g = r;b=r;
%% 
fprintf('\n &&&&&&&&&&&&&&&&&&&&&&&&&&&& Draw PR &&&&&&&&&&&&&&&&&&&&&&&\n')
Pre = zeros(1,length(crfparas));Rec = Pre; FM03 = Pre; FM1 = Pre;
wP = Pre; wR = Pre; wFM03 = Pre; wFM1 = Pre;Mae = Pre;
hdlY = cell(1,length(crfparas));
figure,hold on;
for cc=1:length(crfparas)
fprintf('\n&&&&&&&&&& cc = %d &&&&&&&&&&&&\n',cc);
crfpara = crfparas(cc);   
 CCour = [r(ir(cc)),g(ig(cc+5)),b(ib(cc+7))];
 ourPath = ['.\data\img_result(new1)\method3\Evalueate\',datasets{1,dd},'\Liu\TOP6\','test3k-025075\','valid','\20160421-graphCut\',num2str(crfpara),'\'];
% ourPath = ['.\data\img_result(new1)\method3\',datasets{1,dd},'\',testName,'\','valid','\20160421-graphCut\',num2str(crfpara),'\'];
[~, ~,~, ~, ~, ~, ~,hdlY{1,cc}]  = ...
        Draw_PRF_Curve(ourPath,   suffixour,   GT_path, Suffixgt, true, true,CCour);    
    
[Pre(1,cc),Rec(1,cc),FM03(1,cc),~,~,~,FM1(1,cc)] = ...
        compute_average_prf(ourPath,  suffixour, GT_path, Suffixgt);  
    
[wP(1,cc),wR(1,cc),wFM03(1,cc),~,~,~,wFM1(1,cc)] = ...
        compute_weighted_prf(ourPath,  suffixour, GT_path, Suffixgt);  
    
Mae(1,cc) = CalMeanMAE(ourPath, suffixour, GT_path, Suffixgt);

end

hdlYs = [hdlY{1,1};hdlY{1,2};hdlY{1,3};hdlY{1,4};hdlY{1,5};hdlY{1,6};];
hold off;grid on;title([datasets{1,dd},'-PR'])
legend_str =  {num2str(crfparas(1));num2str(crfparas(2));num2str(crfparas(3));...
     num2str(crfparas(4));num2str(crfparas(5));num2str(crfparas(6));}; 
gridLegend(hdlYs,2,legend_str,'location','southwest');    
set(gca,'box','on');xlabel('Recall');ylabel('Precision')
set(get(gca,'XLabel'),'FontSize',10);%图上文字为8 point或小5号
set(get(gca,'YLabel'),'FontSize',10);



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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 根据前述结果,在验证集上进行测试比对
if 0
 numtr=3000;numval=3000;numte=4000;
 load(['IndexMsra10k-',num2str(1),'.mat'])
 trlist  = tmpIndexMsra10k(1:numtr);
 vallist = tmpIndexMsra10k((numtr+1):(numtr+numval));
 telist  = tmpIndexMsra10k((numtr+numval+1):end);
% telist = vallist(1:length(vallist)/6);    
suffixMean = ['_mean.png'];
suffixour0 = ['_m3_1.png'];
suffixour = ['_m3_crf.png'];Suffixgt = '.png';
figure,hold on;
[~, ~,meanfms03,~, ~, ~, meanfms1, hdlY_mean] = ...
                Draw_PRF_Curve_testlist1(telist, meanexplogPath,   suffixMean,  GT_path, Suffixgt, true, true,'g');
            
ourPath = ['.\data\img_result(new)\method3\',datasets{1,dd},'\',testName,'\test','\20160405-crf\',num2str(crfparas(1)),'\'];
[~, ~,ourfms03, ~, ~, ~, ourfms1,hdlY_our]  = ...
        Draw_PRF_Curve(ourPath,   suffixour,   GT_path, Suffixgt, true, true,'r'); 

ourPath0 = ['.\data\img_result(new)\method3\',datasets{1,dd},'\',testName,'\test\'];
[~, ~,our0fms03, ~, ~, ~, our0fms1,hdlY_our0]  = ...
        Draw_PRF_Curve_testlist1(telist, ourPath0,   suffixour0,   GT_path, Suffixgt, true, true,'b'); 
    
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
    set(get(gca,'XLabel'),'FontSize',15);%图上文字为8 point或小5号
    set(get(gca,'YLabel'),'FontSize',15);
    
    
    
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
    set(get(gca,'XLabel'),'FontSize',15);%图上文字为8 point或小5号
    set(get(gca,'YLabel'),'FontSize',15);

[Pre,Rec,FM03,~,~,~,FM1] = ...
        compute_average_prf(ourPath,  suffixour, GT_path, Suffixgt);  
[Pre0,Rec0,FM030,~,~,~,FM10] = ...
        compute_average_prf_fortelist1(telist,ourPath0,  suffixour0, GT_path, Suffixgt); 
[meanP,meanR,meanFM03,~,~,~,meanFM1] = ...
        compute_average_prf_fortelist1(telist, meanexplogPath,  suffixMean, GT_path, Suffixgt);    
    
[wP,wR,wFM03,~,~,~,wFM1] = ...
        compute_weighted_prf(ourPath,  suffixour, GT_path, Suffixgt);  
[wP0,wR0,wFM030,~,~,~,wFM10] = ...
        compute_weighted_prf_fortelist1(telist,ourPath0,  suffixour0, GT_path, Suffixgt);  
[meanwP,meanwR,meanwFM03,~,~,~,meanwFM1] = ...
        compute_weighted_prf_fortelist1(telist, meanexplogPath,  suffixMean, GT_path, Suffixgt);
    
Mae = CalMeanMAE(ourPath, suffixour, GT_path, Suffixgt);
Mae0 = CalMeanMAE_fortelist1(telist,ourPath0, suffixour0, GT_path, Suffixgt);
meanMae = CalMeanMAE_fortelist1(telist, meanexplogPath, suffixMean, GT_path, Suffixgt);

PRF = [Pre,Rec,FM03,FM1;Pre0,Rec0,FM030,FM10;meanP,meanR,meanFM03,meanFM1];
WPRF = [wP,wR,wFM03,wFM1;wP0,wR0,wFM030,wFM10;meanwP,meanwR,meanwFM03,meanwFM1];
maes = [Mae;Mae0;meanMae];
end




