%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% demoMthod3_revised
% 2016.09.07 10:09AM
% 
% IVPLab,shanghai university,shanghai,china
% http://www.ivp.shu.edu.cn/Default.aspx
% xiaofei zhou,zxforchid@163.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;close all;clc

%% initial &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
fprintf('\n 初始化 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
datasets = {'MSRA10K','ECSSD','PASCAL850'};
modelSets = {'DRFI', 'ST', 'rbd', 'BSCA', 'QCUT', 'DSR', 'HDCT', 'MC'};
% pathForhead = 'D:\ZXF\';sign = '1';
pathForhead = 'D:\program debug\PHD\';sign = '1';

testNames   = {'test3k-025075'};
ThighsTlows = {[0.75,0.25]};
lambdaPara = 0.1;

%% BEGIN &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
for indexTOP=6%[2,4,8]%2,4,6,
    TOPfile = ['TOP',num2str(indexTOP)];
    if indexTOP==2
       TOPmodelSets = {'DRFI', 'ST'};
    end
    
    if indexTOP==4
       TOPmodelSets = {'DRFI', 'ST', 'rbd', 'BSCA'};
    end
    
    if indexTOP==6
       TOPmodelSets = {'DRFI', 'ST', 'rbd', 'BSCA', 'QCUT', 'DSR'};
    end
    
% {'DRFI', 'QCUT', 'rbd', 'ST', 'DSR', 'MC'};
    if indexTOP==8
%         TOPmodelSets = {'DRFI', 'QCUT', 'rbd', 'ST', 'DSR', 'MC', 'HDCT','BSCA'};
       TOPmodelSets = {'DRFI', 'ST', 'rbd', 'BSCA', 'QCUT', 'DSR', 'HDCT', 'MC'};
    end

for TT=1
testName = testNames{1,TT};
Thigh = ThighsTlows{1,TT}(1);Tlow = ThighsTlows{1,TT}(2);
fprintf('\n testNames = %s .................................',testName)
fprintf('\n Thigh = %f , Tlow = %f .........................\n',Thigh,Tlow)

%% sub_initial &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
for dd = 1:3

imwritePath = ['.\data\revised1\image\',datasets{1,dd},'\',TOPfile,'\',testName,'\'];
savePath = ['.\data\revised\mat\',TOPfile,'\'];
resultPath = {imwritePath,savePath};

init_infor = initialMethod5(datasets{1,dd}, pathForhead, TOPmodelSets, sign, resultPath);

if dd==1 % MSRA
    numtr=3000;numval=3000;numte=4000;
    load(['IndexMsra10k-',num2str(1),'.mat'])
    trlist  = tmpIndexMsra10k(1:numtr);
    vallist = tmpIndexMsra10k((numtr+1):(numtr+numval));
    telist  = tmpIndexMsra10k((numtr+numval+1):end);
else 
   GT = init_infor.GT;
   telist = 1:GT.num_img;
   numte = GT.num_img;
end
tic
%% &&&&&&&&&&&&&&& Training obtain quality model &&&&&&&&&&&&&&&&&
% 仅是利用 MSRA10K（3000） 进行训练，其余数据均做测试之用
if dd==100
fprintf('\n &&&&&&&&&&&&&&& Training: obtain quality model &&&&&&&&&&&&&&&&& \n')
%% 提取质量特征
fprintf('\n 提取质量特征 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n')
qualityData = cell(numtr,1);
trainIndex = cell(numtr,1);
parfor itr=1:numtr
    i = trlist(itr);
    disp(i)
    [qualityData{itr,1},~,trainIndex{itr,1}] = ...
        extractQualityFeatureM3(i, init_infor,Thigh,Tlow, 'train',testName);

end
% load('undoneListMSRA10K20160908.mat')
% parfor t=1:round(length(undoneList)/2 - 1)
%     i=undoneList(t);
%      [~,~,~] = extractQualityFeatureM3(i, init_infor,Thigh,Tlow, 'test',testName);
% end
save([savePath,'qualityData',datasets{1,dd},'-',testName(5:end),'.mat'],...
    'qualityData','trainIndex','-v7.3')
end


%% 形成大的训练集矩阵
if dd==100
fprintf('\n 形成大的训练集矩阵 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n')
trainMat.FC = []; trainMat.FCP = []; trainMat.FH = []; 
trainMat.FCS = []; trainMat.FNC = []; trainMat.FB = []; 
trainMat.DMSV = [];trainMat.SPE = [];trainMat.SV = [];
trainMat.IC = []; Label = [];
for ii=1:numtr
    tmpData = qualityData{ii,1};
    trainMat.FC  = [trainMat.FC; tmpData.FC   ];
    trainMat.FCP = [trainMat.FCP;tmpData.FCP  ];
    trainMat.FH  = [trainMat.FH; tmpData.FH   ];
    trainMat.FCS = [trainMat.FCS;tmpData.FCS  ];
    trainMat.FNC = [trainMat.FNC;tmpData.FNC  ];
    trainMat.FB  = [trainMat.FB; tmpData.FB   ];
    Label        = [Label;       tmpData.Label];
    
    qualityData{ii,1} = [];
    clear tmpData
end
trainDataMatrix = ...
    [trainMat.FC,trainMat.FCP,trainMat.FH,trainMat.FCS,trainMat.FNC, trainMat.FB];
[XNAN] = isnan(trainDataMatrix);
[indexNAN,~] = find(XNAN==1);
clear trainDataMatrix

trainMat.FC(indexNAN,:) = [];trainMat.FCP(indexNAN,:) = [];trainMat.FH(indexNAN,:) = [];
trainMat.FCS(indexNAN,:) = [];trainMat.FNC(indexNAN,:) = [];trainMat.FB(indexNAN,:) = [];
Label(indexNAN) = [];

save([savePath,'trainData',datasets{1,dd},'-',testName(5:end),'.mat'],'trainMat','Label','-v7.3')
clear qualityData
end
%% SVM-AdaBoost 得出打分模型
if dd==100
fprintf('\n SVM-AdaBoost &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n')
%10种特征，3种核函数， 每种特征对应的样本数
ntype = 4;
nfeature = 6;
datanum = repmat(size(Label,1),1,nfeature);

% 特征归一化
[trainMat.FC,scaleMkb.FCmin,scaleMkb.FCmax]    = scaleData_train(trainMat.FC,0,1);
[trainMat.FCP,scaleMkb.FCPmin,scaleMkb.FCPmax] = scaleData_train(trainMat.FCP,0,1);
[trainMat.FH,scaleMkb.FHmin,scaleMkb.FHmax]    = scaleData_train(trainMat.FH,0,1);
[trainMat.FCS,scaleMkb.FCSmin,scaleMkb.FCSmax] = scaleData_train(trainMat.FCS,0,1);
[trainMat.FNC,scaleMkb.FNCmin,scaleMkb.FNCmax] = scaleData_train(trainMat.FNC,0,1);
[trainMat.FB,scaleMkb.FBmin,scaleMkb.FBmax]    = scaleData_train(trainMat.FB,0,1);

% 开始训练MKB
[ betaMkb, modelMkb, tmMkb ] = Boost_MKL( trainMat, Label, nfeature, datanum,ntype);
dMkb = distribution( modelMkb ); 
save([savePath, 'qualityModel',datasets{1,dd},'-',testName(5:end),'.mat'],'betaMkb','modelMkb','dMkb','scaleMkb')
end

toc
%% &&&&&&&&&&&&&&&&&&& Testing  &&&&&&&&&&&&&&&&&&&&&&&&
if 1
fprintf('\n &&&&&&&&&&&&&&&&&& Testing:  &&&&&&&&&&&&&&&&&&&& \n')

outputFileID = zeros(numte, 1);
for ite = 1:length(telist)
    disp(ite)
    i = telist(ite);
    
    outputFileID(ite) = ObtainQualityscoreM3new_revised(i, init_infor,testName,'test',lambdaPara);
end
end

end

end
end
%% &&&&&&&&&&&&&&&&&&&&&&& clear 变量 &&&&&&&&&&&&&&&&&&&&&&&&&&&&
clear all



% if dd==1
%     outputFileID = zeros(numval, 1);
%     for ite = 1:length(vallist)
%     disp(ite)
% %     i = undoneList(ite);
%     i = vallist(ite);
%     
%     outputFileID(ite) = ObtainQualityscoreM3new(i, init_infor,testName,'valid');
%     end
% end



