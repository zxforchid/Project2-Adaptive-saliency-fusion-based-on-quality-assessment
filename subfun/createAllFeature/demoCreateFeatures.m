%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% demoCreateFeatures.m
% 重新生成所有特征
% 
% IVPLab,shanghai university,shanghai,china
% http://www.ivp.shu.edu.cn/Default.aspx
% xiaofei zhou,zxforchid@163.com
% 2016/3/28  16:47PM
% 
% 生成 mean/exp/log的特征 TOP6
% 2016/04/12  22：41PM
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;close all;clc

%% initial &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
fprintf('\n 初始化 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
datasets = {'MSRA10K','ECSSD','PASCAL850'};
modelSets = {'DRFI', 'QCUT', 'rbd', 'ST', 'DSR', 'MC'};
pathForhead = 'D:\program debug\PHD\';sign = '1';

% MELS = {'mean','exp','log'};
% for kkk=2:3
%     MEL = MELS{1,kkk};
%% BEGIN &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
MEL = 'm3_1';
for dd = 1:3

% D:\program debug\PHD\TOP6Data\MeanExpLogDataNew\TOP6
% imwritePath = ['.\data\img_result\method3\'];
% savePath = ['.\data\mat_result\'];
% D:\program debug\PHD\project2\data\img_result(new)\method3\Evalueate\MSRA10K\Liu\TOP6\test3k-025075\test
% imwritePath = ['D:\program debug\PHD\TOP6Data\MeanExpLogDataNew\TOP6\'];\
imwritePath = [' D:\program debug\PHD\project2\data\img_result(new)\method3\Evalueate\',datasets{1,dd},'\Liu\TOP6\test3k-025075\test\'];
savePath = ['.\data\mat_result\'];

resultPath = {imwritePath,savePath};

init_infor = initialMethod5(datasets{1,dd}, pathForhead, modelSets, sign, resultPath);
% GT = init_infor.GT;
% telist = 1:GT.num_img;
% num_te = GT.num_img;
if dd==1 % MSRA
    % --- 2016/03/31 --- %
    numtr=3000;numval=3000;numte=4000;
    load(['IndexMsra10k-',num2str(1),'.mat'])
    trlist  = tmpIndexMsra10k(1:numtr);
    vallist = tmpIndexMsra10k((numtr+1):(numtr+numval));
    telist  = tmpIndexMsra10k((numtr+numval+1):end);

else % ECSSD
   GT = init_infor.GT;
   telist = 1:GT.num_img;
   numte = GT.num_img;
end

%% &&&&&&&&&&&&&&& Training obtain quality model &&&&&&&&&&&&&&&&&
Thigh = 1;Tlow = 1;
fprintf('\n &&&&&&&&&&&&&&& Training: obtain quality model &&&&&&&&&&&&&&&&& \n')
%% 提取质量特征
fprintf('\n 提取质量特征 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n')
qualityData = cell(numte,1);
trainIndex = cell(numte,1);
% load ('undoneListECSSD20160330.mat')
% numUndone = length(undoneList);
% qualityData = cell(numUndone,1);
% trainIndex = cell(numUndone,1);
% (round(numUndone/2)+1):numUndone
% for itr =  1
% i = undoneList(itr);
parfor itr=1:numte
    i = telist(itr);
    disp(itr)
[qualityData{itr,1},~,trainIndex{itr,1}] = extractAllQualityFeatureNew(i, init_infor,Thigh,Tlow, 'test',MEL);

end

end
% end

%% &&&&&&&&&&&&&&&&&&&&&&& clear 变量 &&&&&&&&&&&&&&&&&&&&&&&&&&&&
clear all







