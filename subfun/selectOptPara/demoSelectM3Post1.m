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

%% 对应方法的相关参数 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
% method3-postprocessing
testNames   = {'test3k-025075','test3k-0309','test3k-04086'};
ThighsTlows = {[0.75,0.25],     [0.9,0.3],    [0.86,0.4]};
imrefineSuffixs = {'_m3_w.png','_m3_1_w.png','_m3_2_w.png'};
suffixour = imrefineSuffixs{1,2};
imoriginSuffixs = {'_m3.png','_m3_1.png','_m3_2.png'};
suffixour0 = imoriginSuffixs{1,2};
suffixMean = ['_mean.png'];
Suffixgt = '.png';
TOP6DataPath = ['D:\program debug\PHD\TOP6Data\'];
ImgsGTDataPath = ['ImgsGTData'];
MeanExpLogDataPath = ['MeanExpLogData2'];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 直接评价  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 1
%% 
fprintf('\n &&&&&&&&&&&&&&&&&&&&&&&&&&&& Draw PR &&&&&&&&&&&&&&&&&&&&&&&\n')

for tt=1
testName = testNames{1,tt};
for dd=1:3
GT_path = [TOP6DataPath,ImgsGTDataPath,'\',datasets{1,dd},'\'];
GT = dir([GT_path '*' 'png']);
meanexplogPath = [TOP6DataPath,MeanExpLogDataPath,'\',datasets{1,dd},'\'];

figure,hold on;
if strcmp(datasets{1,dd},'MSRA10K')
numtr=3000;numval=3000;numte=4000;
 load(['IndexMsra10k-',num2str(1),'.mat'])
 trlist  = tmpIndexMsra10k(1:numtr);
 vallist = tmpIndexMsra10k((numtr+1):(numtr+numval));
 telist  = tmpIndexMsra10k((numtr+numval+1):end);
else
telist = 1:length(GT); 
end
%-------PR 曲线 ------%
ourPath = ['.\data\img_result(new)\method3\',datasets{1,dd},'\',testName,'\test','\20160405-opt-ms\'];
[~, ~,ourfms03, ~, ~, ~, ourfms1,hdlY_our]  = ...
        Draw_PRF_Curve(ourPath,   suffixour,   GT_path, Suffixgt, true, true,'r');    
    
ourPath0 = ['.\data\img_result(new)\method3\',datasets{1,dd},'\',testName,'\test\'];
[~, ~,our0fms03, ~, ~, ~, our0fms1,hdlY_our0]  = ...
        Draw_PRF_Curve(ourPath0,   suffixour0,   GT_path, Suffixgt, true, true,'b');  
    
[~, ~,meanfms03,~, ~, ~, meanfms1, hdlY_mean] = ...
                Draw_PRF_Curve_testlist1(telist, meanexplogPath,   suffixMean,  GT_path, Suffixgt, true, true,'g');    
            
hdlYs = [hdlY_our;hdlY_our0;hdlY_mean];
hold off;grid on;title([testName,'-',datasets{1,dd},'-PR'])
legend_str =  {'our';'our0';'mean'}; 
gridLegend(hdlYs,1,legend_str,'location','southwest');    
set(gca,'box','on');xlabel('Recall');ylabel('Precision')
set(get(gca,'XLabel'),'FontSize',10);%图上文字为8 point或小5号
set(get(gca,'YLabel'),'FontSize',10);
clear hdlYs hdlY_our hdlY_our0 hdlY_mean

% ------- F 曲线 ---------%
    fx = [0:1:255];
    % FM03
    figure,hold on;
    Fhanle = [];
    hdlour = plot(fx, ourfms03, 'color', 'r', 'linewidth', 2);
    hdlour0 = plot(fx, our0fms03, 'color', 'b', 'linewidth', 2);    
    hdlmean = plot(fx, meanfms03, 'color', 'g', 'linewidth', 2);
    Fhanle = [Fhanle;hdlour;hdlour0;hdlmean];
    hold off;grid on;  title([testName,'-',datasets{1,dd},'-Fmeasures03']) 
    legend_str =  {'our'; 'our0'; 'mean'; };  
    gridLegend(Fhanle,1,legend_str,'location','southwest');    
    set(gca,'box','on');xlabel('threshold');ylabel('F-measure')
%     set(gca,'XTick',[0:50:250]); set(gca,'yTick',[0:0.1:1]) 
    axis([0 250,0,1])
    set(get(gca,'XLabel'),'FontSize',10);%图上文字为8 point或小5号
    set(get(gca,'YLabel'),'FontSize',10);
  clear Fhanle hdlour hdlour0 hdlmean
  clear ourfms03 our0fms03 meanfms03
    
    
    fx = [0:1:255];
    % FM1
    figure,hold on;
    Fhanle = [];
    hdlour = plot(fx, ourfms1, 'color', 'r', 'linewidth', 2);
    hdlour0 = plot(fx, our0fms1, 'color', 'b', 'linewidth', 2);   
    hdlmean = plot(fx, meanfms1, 'color', 'g', 'linewidth', 2);
    Fhanle = [Fhanle;hdlour;hdlour0;hdlmean];
    hold off;grid on;  title([testName,'-',datasets{1,dd},'-Fmeasures1']) 
    legend_str =  {'our'; 'our0'; 'mean'; };  
    gridLegend(Fhanle,1,legend_str,'location','southwest');    
    set(gca,'box','on');xlabel('threshold');ylabel('F-measure')
    axis([0 250,0,1])
    set(get(gca,'XLabel'),'FontSize',10);%图上文字为8 point或小5号
    set(get(gca,'YLabel'),'FontSize',10);
   clear Fhanle hdlour hdlour0 hdlmean
   clear ourfms1 our0fms1 meanfms1
end

end
end





