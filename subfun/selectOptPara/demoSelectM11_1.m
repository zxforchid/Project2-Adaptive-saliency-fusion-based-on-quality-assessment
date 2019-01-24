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
dd=2;
%% 对应方法的相关参数 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
% method11-1
lamda  = {[1:0.2:2],[0.2:0.2:1]};

suffixour = '_m11.png';Suffixgt = '.png';
TOP6DataPath = ['D:\program debug\PHD\TOP6Data\'];
ImgsGTDataPath = ['ImgsGTData'];
MeanExpLogDataPath = ['MeanExpLogData2'];
GT_path = [TOP6DataPath,ImgsGTDataPath,'\',datasets{1,dd},'\'];
meanexplogPath = [TOP6DataPath,MeanExpLogDataPath,'\',datasets{1,dd},'\'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 参数选择  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
%% 
fprintf('\n &&&&&&&&&&&&&&&&&&&&&&&&&&&& Draw PR &&&&&&&&&&&&&&&&&&&&&&&\n')
Pre = zeros(1,length(lamda{1,1})*length(lamda{1,2}));
Rec = Pre; FM03 = Pre; FM1 = Pre;
wP = Pre; wR = Pre; wFM03 = Pre; wFM1 = Pre;Mae = Pre;
hdlY = cell(1,length(lamda{1,1})*length(lamda{1,2}));
nn=0;
figure,hold on;
for i=1:length(lamda{1,1})
    for j=1:length(lamda{1,2})

nn=nn+1;
para1 = lamda{1,1}(i);
para2 = lamda{1,2}(j);
fprintf('\n&&&&&&&&&& i = %d | j = %d &&&&&&&&&&&&\n',para1,para2);

ourPath = ['.\data\img_result\method11-1\',num2str(para1),'-',num2str(para2),'\',datasets{1,dd},'\'];
% [~, ~,~, ~, ~, ~, ~,hdlY{1,cc}]  = ...
%         Draw_PRF_Curve(ourPath,   suffixour,   GT_path, Suffixgt, true, true,CCour);    
    
[Pre(1,nn),Rec(1,nn),FM03(1,nn),~,~,~,FM1(1,nn)] = ...
        compute_average_prf(ourPath,  suffixour, GT_path, Suffixgt);  
    
[wP(1,nn),wR(1,nn),wFM03(1,nn),~,~,~,wFM1(1,nn)] = ...
        compute_weighted_prf(ourPath,  suffixour, GT_path, Suffixgt);  
    
Mae(1,nn) = CalMeanMAE(ourPath, suffixour, GT_path, Suffixgt);

    end
end

% hdlYs = [hdlY{1,1};hdlY{1,2};hdlY{1,3};hdlY{1,4};hdlY{1,5};hdlY{1,6};hdlY{1,7}];
% hold off;grid on;title([datasets{1,dd},'-PR'])
% legend_str =  {num2str(paras(1));num2str(paras(2));num2str(paras(3));...
%      num2str(paras(4));num2str(paras(5));num2str(paras(6));num2str(paras(7));}; 
% gridLegend(hdlYs,2,legend_str,'location','southwest');    
% set(gca,'box','on');xlabel('Recall');ylabel('Precision')
% set(get(gca,'XLabel'),'FontSize',10);%图上文字为8 point或小5号
% set(get(gca,'YLabel'),'FontSize',10);



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
if 1
% 根据前述结果,在验证集上进行测试比对
suffixMean = ['_mean.png'];
figure,hold on;
ourPath1 = ['.\data\img_result\method11-1\',num2str(1.2),'-',num2str(0.4),'\',datasets{1,dd},'\'];
[~, ~,our1fms03, ~, ~, ~, our1fms1,hdlY_our1]  = ...
        Draw_PRF_Curve(ourPath1,   suffixour,   GT_path, Suffixgt, true, true,'r'); 

ourPath2 = ['.\data\img_result\method11-1\',num2str(1),'-',num2str(0.4),'\',datasets{1,dd},'\'];
[~, ~,our2fms03, ~, ~, ~, our2fms1,hdlY_our2]  = ...
        Draw_PRF_Curve(ourPath2,   suffixour,   GT_path, Suffixgt, true, true,'g'); 
 
[~, ~,meanfms03,~, ~, ~, meanfms1, hdlY_mean] = ...
         Draw_PRF_Curve(meanexplogPath,   suffixMean,  GT_path, Suffixgt, true, true,'b');
     
hdlYs = [hdlY_mean;hdlY_our1;hdlY_our2];
hold off;grid on;title([datasets{1,dd},'-PR'])
legend_str =  {'mean';'our1';'our2'}; 
gridLegend(hdlYs,1,legend_str,'location','southwest');    
set(gca,'box','on');xlabel('Recall');ylabel('Precision')
set(get(gca,'XLabel'),'FontSize',10);%图上文字为8 point或小5号
set(get(gca,'YLabel'),'FontSize',10);


    fx = [0:1:255];
    % FM03
    figure,hold on;
    Fhanle = [];
    hdlour1 = plot(fx, our1fms03, 'color', 'r', 'linewidth', 2);
    hdlour2 = plot(fx, our2fms03, 'color', 'g', 'linewidth', 2);
    hdlmean = plot(fx, meanfms03, 'color', 'b', 'linewidth', 2);
    Fhanle = [Fhanle;hdlour1;hdlour2;hdlmean];
    hold off;grid on;  title([datasets{1,dd},'-Fmeasures03']) 
    legend_str =  {'our1'; 'our2'; 'mean'; };  
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
    hdlour1 = plot(fx, our1fms1, 'color', 'r', 'linewidth', 2);
    hdlour2 = plot(fx, our2fms1, 'color', 'g', 'linewidth', 2);
    hdlmean = plot(fx, meanfms1, 'color', 'b', 'linewidth', 2);
    Fhanle = [Fhanle;hdlour1;hdlour2;hdlmean];
    hold off;grid on;  title([datasets{1,dd},'-Fmeasures1']) 
    legend_str =  {'our1'; 'our2'; 'mean'; };  
    gridLegend(Fhanle,1,legend_str,'location','southwest');    
    set(gca,'box','on');xlabel('threshold');ylabel('F-measure')
    axis([0 250,0,1])
    set(get(gca,'XLabel'),'FontSize',10);%图上文字为8 point或小5号
    set(get(gca,'YLabel'),'FontSize',10);    

end



