%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% demoMthod3 new
% version1:
% 使用 MKB 进行训练测试
% 同样是采用 MSRA10K训练模型，用于测试所有数据库
% % 2016/3/17  15:45AM
% 
% version2:
% 对fusion的结果 (m3 m3_1 m3_2)使用CRF进行 spatial consistence; 同时在valid
% 数据上面寻找 CRF 对应的相关参数
% 
% 2016/03/31  13:23PM
% 
% IVPLab,shanghai university,shanghai,china
% http://www.ivp.shu.edu.cn/Default.aspx
% xiaofei zhou,zxforchid@163.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;close all;clc

%% initial &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
fprintf('\n 初始化 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
datasets = {'MSRA10K','ECSSD','PASCAL850'};
modelSets = {'DRFI', 'QCUT', 'rbd', 'ST', 'DSR', 'MC'};
pathForhead = 'D:\program debug\PHD\';sign = '1';

%% 
% testNames = {'test2k-025075','test2k-025092','test2k-0309','test2k-040865','test2k-05082','test2k-060759', ...
%              'test3k-025075','test3k-025092','test3k-0309','test3k-04086','test3k-050817','test3k-060755', ...
%              'test4k-025075','test4k-025092','test4k-0309','test4k-04086','test4k-050816','test4k-06076', ...
%              'test5k-025075','test5k-025092','test5k-0309','test5k-04086','test5k-050815','test5k-06076'};
% ThighsTlows = {[0.75,0.25],   [0.92,0.25],    [0.9,0.3],    [0.865,0.4],    [0.82,0.5],    [0.759,0.6], ...
%                [0.75,0.25],   [0.92,0.25],    [0.9,0.3],    [0.86,0.4],     [0.817,0.5],   [0.755,0.6], ...
%                [0.75,0.25],   [0.92,0.25],    [0.9,0.3],    [0.86,0.4],     [0.816,0.5],   [0.76,0.6], ...
%                [0.75,0.25],   [0.92,0.25],    [0.9,0.3],    [0.86,0.4],     [0.815,0.5],   [0.76,0.6]};

%-- 2016/03/30/22:55PM ---%
% testNames = {'test2k-025075','test2k-0309','test5k-0309',};
% ThighsTlows = {[0.75,0.25],  [0.9,0.3],    [0.9,0.3]};

%-- 2016/03/31/        ---%
testNames   = {'test3k-025075','test3k-0309','test3k-04086','test3k-05082'};
ThighsTlows = {[0.75,0.25],     [0.9,0.3],    [0.86,0.4],    [0.82,0.5]};

for TT=1:3
testName = testNames{1,TT};
Thigh = ThighsTlows{1,TT}(1);Tlow = ThighsTlows{1,TT}(2);
fprintf('\n testNames = %s .................................',testName)
fprintf('\n Thigh = %f , Tlow = %f .........................\n',Thigh,Tlow)

%% BEGIN &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
for dd = 1:3

imwritePath = ['.\data\img_result(new)\method3\',datasets{1,dd},'\',testName,'\'];
savePath = ['.\data\mat_result(new)\method3\'];
resultPath = {imwritePath,savePath};

init_infor = initialMethod5(datasets{1,dd}, pathForhead, modelSets, sign, resultPath);

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
if dd==10
fprintf('\n &&&&&&&&&&&&&&& Training: obtain quality model &&&&&&&&&&&&&&&&& \n')
%% 提取质量特征
fprintf('\n 提取质量特征 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n')
qualityData = cell(numtr,1);
trainIndex = cell(numtr,1);
parfor itr=1:numtr
    i = trlist(itr);
    disp(i)
[qualityData{itr,1},~,trainIndex{itr,1}] = extractQualityFeatureM3(i, init_infor,Thigh,Tlow, 'train',testName);

end
save([savePath,'qualityData',datasets{1,dd},'-',testName(5:end),'.mat'],...
    'qualityData','trainIndex','-v7.3')
end

tic
%% 形成大的训练集矩阵
if dd==10
fprintf('\n 形成大的训练集矩阵 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n')
trainMat.FC = []; trainMat.FCP = []; trainMat.FH = []; 
trainMat.FCS = []; trainMat.FNC = []; trainMat.FB = []; 
trainMat.DMSV = [];trainMat.SPE = [];trainMat.SV = [];
trainMat.IC = []; Label = [];
for ii=1:numtr
    tmpData = qualityData{ii,1};
    trainMat.FC = [trainMat.FC;tmpData.FC];
    trainMat.FCP = [trainMat.FCP;tmpData.FCP];
    trainMat.FH = [trainMat.FH;tmpData.FH];
    trainMat.FCS = [trainMat.FCS;tmpData.FCS];
    trainMat.FNC = [trainMat.FNC;tmpData.FNC];
    trainMat.FB = [trainMat.FB;tmpData.FB];
    trainMat.DMSV = [trainMat.DMSV;tmpData.DMSV];
    trainMat.SPE = [trainMat.SPE;tmpData.SPE];
    trainMat.SV = [trainMat.SV;tmpData.SV];
    trainMat.IC = [trainMat.IC;tmpData.IC];
    Label       = [Label;tmpData.Label];
    
    qualityData{ii,1} = [];
    clear tmpData
end
trainDataMatrix = [trainMat.FC,trainMat.FCP,trainMat.FH,trainMat.FCS,trainMat.FNC, ...
    trainMat.FB,trainMat.DMSV,trainMat.SPE,trainMat.SV,trainMat.IC];
[XNAN] = isnan(trainDataMatrix);
[indexNAN,~] = find(XNAN==1);
clear trainDataMatrix

    trainMat.FC(indexNAN,:) = [];
    trainMat.FCP(indexNAN,:) = [];
    trainMat.FH(indexNAN,:) = [];
    trainMat.FCS(indexNAN,:) = [];
    trainMat.FNC(indexNAN,:) = [];
    trainMat.FB(indexNAN,:) = [];
    trainMat.DMSV(indexNAN,:) = [];
    trainMat.SPE(indexNAN,:) = [];
    trainMat.SV(indexNAN,:) = [];
    trainMat.IC(indexNAN,:) = [];
    Label(indexNAN) = [];

save([savePath,'trainData',datasets{1,dd},'-',testName(5:end),'.mat'],'trainMat','Label','-v7.3')
clear qualityData
end
%% SVM-AdaBoost 得出打分模型
if dd==10
fprintf('\n SVM-AdaBoost &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n')
%10种特征，3种核函数， 每种特征对应的样本数
ntype = 4;
nfeature = 10;
datanum = repmat(size(Label,1),1,nfeature);

% 特征归一化
[trainMat.FC,scaleMkb.FCmin,scaleMkb.FCmax] = scaleData_train(trainMat.FC,0,1);
[trainMat.FCP,scaleMkb.FCPmin,scaleMkb.FCPmax] = scaleData_train(trainMat.FCP,0,1);
[trainMat.FH,scaleMkb.FHmin,scaleMkb.FHmax] = scaleData_train(trainMat.FH,0,1);
[trainMat.FCS,scaleMkb.FCSmin,scaleMkb.FCSmax] = scaleData_train(trainMat.FCS,0,1);
[trainMat.FNC,scaleMkb.FNCmin,scaleMkb.FNCmax] = scaleData_train(trainMat.FNC,0,1);
[trainMat.FB,scaleMkb.FBmin,scaleMkb.FBmax] = scaleData_train(trainMat.FB,0,1);
[trainMat.DMSV,scaleMkb.DMSVmin,scaleMkb.DMSVmax] = scaleData_train(trainMat.DMSV,0,1);
[trainMat.SPE,scaleMkb.SPEmin,scaleMkb.SPEmax] = scaleData_train(trainMat.SPE,0,1);
[trainMat.SV,scaleMkb.SVmin,scaleMkb.SVmax] = scaleData_train(trainMat.SV,0,1);
[trainMat.IC,scaleMkb.ICmin,scaleMkb.ICmax] = scaleData_train(trainMat.IC,0,1);

% 开始训练MKB
[ betaMkb, modelMkb, tmMkb ] = Boost_MKL( trainMat, Label, nfeature, datanum,ntype);
dMkb = distribution( modelMkb ); 
save([savePath, 'qualityModel',datasets{1,dd},'-',testName(5:end),'.mat'],'betaMkb','modelMkb','dMkb','scaleMkb')
end

toc
%% &&&&&&&&&&&&&&&&&&& Testing  &&&&&&&&&&&&&&&&&&&&&&&&
if 1
fprintf('\n &&&&&&&&&&&&&&&&&& Testing:  &&&&&&&&&&&&&&&&&&&& \n')

% load ('undoneListMSRA10K20160302.mat')
% numUndone = length(undoneList);
% parfor ite = 1:round(numUndone/3)-1
if dd==1
    outputFileID = zeros(numval, 1);
    for ite = 1:length(vallist)
    disp(ite)
%     i = undoneList(ite);
    i = vallist(ite);
    
    outputFileID(ite) = ObtainQualityscoreM3new(i, init_infor,testName,'valid');
    end
end

outputFileID = zeros(numte, 1);
parfor ite = 1:length(telist)
    disp(ite)
%     i = undoneList(ite);
    i = telist(ite);
    
    outputFileID(ite) = ObtainQualityscoreM3new(i, init_infor,testName,'test');
end
end

end

end
%% &&&&&&&&&&&&&&&&&&&&&&& clear 变量 &&&&&&&&&&&&&&&&&&&&&&&&&&&&
clear all







