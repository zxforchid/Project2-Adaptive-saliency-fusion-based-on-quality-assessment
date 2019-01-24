% 选择出 新方法最优的平滑项参数 imgNew2
% 计算各参数下的 平均 F-measure 平均 Precision 平均 MAE等指标
% 2016/04/25  22:30
% 

% clear all;close all;clc

%% initial %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\n 初始化 .........')
datasets = {'MSRA10K','ECSSD','PASCAL850'}; %,'JuddDB'
modelSets = {'DRFI', 'QCUT', 'rbd', 'ST', 'DSR', 'MC'};

TOP6DataPath = ['D:\program debug\PHD\TOP6Data\'];
ImgsGTDataPath = ['ImgsGTData'];

if 0
%%
paras = {0.1,0.6,2,5,7,10,15,20,50};
GCPP = cell(1,9);
testName = 'test3k-025075';


for ppp=1:9
    GCpara = paras{1,ppp};
    GCM = struct;
    
    ourMae = zeros(3,3);
    ourP = zeros(3,3);ourR=ourP;ourFM02=ourP;ourFM03=ourP;ourFM05=ourP;ourFM07=ourP;ourFM09=ourP;ourFM1=ourP;
    ourwP = zeros(3,3);ourwR=ourwP;ourwFM02=ourwP;ourwFM03=ourwP;ourwFM05=ourwP;ourwFM07=ourwP;ourwFM09=ourwP;ourwFM1=ourwP;
    
for indexTOP=[2,4,6]
    TOPfile = ['TOP',num2str(indexTOP)];
    tt = indexTOP/2;
for dd = 1:length(datasets)
    % 确定GroundTruth
    dataset = datasets{1,dd};
    GT_path = [TOP6DataPath,ImgsGTDataPath,'\',dataset,'\'];
    GT = dir([GT_path '*' 'png']);

    ourPath = ['.\data\img_result(new2)\method3\Evalueate\',dataset,'\Liu\', ...
        TOPfile,'\',testName,'\test\20160422-graphCut\',num2str(GCpara),'\'];
        
    % 确定训练集、测试集的ID
    switch dataset
        case 'MSRA10K'
            numtr=3000;numval=3000;numte=4000;
            load(['IndexMsra10k-',num2str(1),'.mat'])
            trlist  = tmpIndexMsra10k(1:numtr);
            vallist = tmpIndexMsra10k((numtr+1):(numtr+numval));
            telist  = tmpIndexMsra10k((numtr+numval+1):end);
            
        case 'ECSSD'
            telist = 1:length(GT);
            num_te = length(GT);
 
        case 'PASCAL850'
            telist = 1:length(GT);
            num_te = length(GT);  
    end
   
    suffixour = ['_1_gc.png'];%
    Suffixgt = '.png';

    % compute matrics
    ourMae(tt,dd) = CalMeanMAE(ourPath, suffixour, GT_path, Suffixgt);
    
    [ourP(tt,dd),ourR(tt,dd),ourFM02(tt,dd), ourFM03(tt,dd),ourFM05(tt,dd),ourFM07(tt,dd),ourFM09(tt,dd),ourFM1(tt,dd)] = ...
        compute_average_prf_Post3(ourPath,  suffixour, GT_path, Suffixgt);
    
    [ourwP(tt,dd),ourwR(tt,dd),ourwFM02(tt,dd),ourwFM03(tt,dd),ourwFM05(tt,dd),ourwFM07(tt,dd),ourwFM09(tt,dd),ourwFM1(tt,dd)] = ...
        compute_weighted_prf_Post3(ourPath,  suffixour, GT_path, Suffixgt); 
    
end
end

GCM.mae = ourMae;
GCM.pre = ourP;
GCM.wP = ourwP;

GCM.fm02 = ourFM02;
GCM.fm03 = ourFM03;
GCM.fm05 = ourFM05;
GCM.fm1 = ourFM1;

GCM.wfm02 = ourwFM02;
GCM.wfm03 = ourwFM03;
GCM.wfm05 = ourwFM05;
GCM.wfm1 = ourwFM1;

GCPP{1,ppp} = GCM;

clear GCM

end


save('GCPP2.mat','GCPP')

end


%% 
if 1
pres = zeros(9,3);
maes = pres;
wPs = pres;
fm02s = pres;
fm03s = pres;
fm05s = pres;
fm1s = pres;

wfm02s = pres;
wfm03s = pres;
wfm05s = pres;
wfm1s = pres;

load ('GCPP2.mat')
INDEX1 = [];
for tt=1
    fprintf('\n  --------------TOP%d ----------------\n',tt)
    
    for ppp=1:9
    TMPGCPP = GCPP{1,ppp};
    
       pres(ppp,:) =  TMPGCPP.pre(tt,:);
       maes(ppp,:) =  TMPGCPP.mae(tt,:);
       wPs(ppp,:) =  TMPGCPP.wP(tt,:);
       
       fm02s(ppp,:) =  TMPGCPP.fm02(tt,:);
       fm03s(ppp,:) =  TMPGCPP.fm03(tt,:);
       fm05s(ppp,:) =  TMPGCPP.fm05(tt,:);
       fm1s(ppp,:) =  TMPGCPP.fm1(tt,:);
       
       wfm02s(ppp,:) =  TMPGCPP.wfm02(tt,:);
       wfm03s(ppp,:) =  TMPGCPP.wfm03(tt,:);
       wfm05s(ppp,:) =  TMPGCPP.wfm05(tt,:);
       wfm1s(ppp,:) =  TMPGCPP.wfm1(tt,:);
       
       clear TMPGCPP
    end
    
     [~,yp] = max(pres);
     [~,ywp] = max(wPs);
     
     [~,yfm02] = max(fm02s);
     [~,yfm03] = max(fm03s);
     [~,yfm05] = max(fm05s);
     [~,yfm1] = max(fm1s);
     
     [~,ywfm02] = max(wfm02s);
     [~,ywfm03] = max(wfm03s);
     [~,ywfm05] = max(wfm05s);
     [~,ywfm1] = max(wfm1s);    
     
     [~,ymae] = min(maes);
     
%      INDEX1= [INDEX1;ymae; yp;yfm02;yfm03;yfm05;yfm1; ywp;ywfm02;ywfm03;ywfm05;ywfm1;];
     INDEX1= [INDEX1;ymae; yp;yfm03;ywp;ywfm03;];
end
end
