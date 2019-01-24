%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 使用卢湖川的 graphCut 程序，并根据自身的情况做一定的改变
% postProcessing3_3
% 2016/04/21 21:12PM
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


testNames   = {'test3k-025075'};
ThighsTlows = {[0.75,0.25]};
% lambdaParas = [0.01,0.025,0.05,0.1,0.2,0.5,0.75];
lambdaParas = [0.15,0.2,0.25,0.3];%[7,15];%[50, 20, 5, 0.6, 0.1];
FeatureNames = {'Yang','Liu','All'};
kvalid = 100;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for FF=2
    FeatureName = FeatureNames{1,FF};
for indexTOP=[6]
    TOPfile = ['TOP',num2str(indexTOP)];
    if indexTOP==2
       TOPmodelSets = {'DRFI', 'QCUT'};
    end
    if indexTOP==3
       TOPmodelSets = {'DRFI', 'QCUT', 'rbd'};
    end
    if indexTOP==4
       TOPmodelSets = {'DRFI', 'QCUT', 'rbd', 'ST'};
    end
    if indexTOP==5
       TOPmodelSets = {'DRFI', 'QCUT', 'rbd', 'ST','DSR'};
    end
    if indexTOP==6
       TOPmodelSets = {'DRFI', 'QCUT', 'rbd', 'ST', 'DSR', 'MC'};
    end
for TT=1
testName = testNames{1,TT};
Thigh = ThighsTlows{1,TT}(1);Tlow = ThighsTlows{1,TT}(2);
fprintf('\n testNames = %s .................................',testName)
fprintf('\n Thigh = %f , Tlow = %f .........................\n',Thigh,Tlow)

%% BEGIN &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
for dd = 1:length(datasets)
% for dd=1
imwritePath = ['.\data\img_result(new4)\method3\Evalueate\',datasets{1,dd},'\',FeatureName,'\',TOPfile,'\',testName,'\'];
savePath = ['.\data\mat_result(new1)\method3\Evalueate\',FeatureName,'\',TOPfile,'\'];
resultPath = {imwritePath,savePath};

init_infor = initialMethod5(datasets{1,dd}, pathForhead, modelSets, sign, resultPath);

if dd==1 % MSRA
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


%% &&&&&&&&&&&&&&&&&&& Testing  &&&&&&&&&&&&&&&&&&&&&&&&
if 1
fprintf('\n &&&&&&&&&&&&&&&&&& Testing:  &&&&&&&&&&&&&&&&&&&& \n')
% 
% % 利用验证集去寻找最优参数
% if dd==100
%     outputFileID = zeros(numval, 1);
%     for cC=1:length(lambdaParas)
%         lambdaPara = lambdaParas(cC);
%     parfor ite = 1:length(vallist)/3
%            disp(ite)
%            i = vallist(ite);
%            outputFileID(ite) = posprocessFunM3_3(i, init_infor,testName,'valid', lambdaPara);
%     end
%     
%     end
% end
% lambdaPara = 10;
% 利用得到的最优参数去计算测试集
if 1
for cC=1:length(lambdaParas)
lambdaPara = lambdaParas(cC);
outputFileID = zeros(numte, 1);
parfor ite = 1:length(telist)
       disp(ite)
%       i = undoneList(ite);
       i = telist(ite);
       outputFileID(ite) = posprocessFunM3_3(i, init_infor,testName,'test', lambdaPara);
       
%      outputFileID(ite) = ObtainQualityscoreM3new(i, init_infor,testName,'test');
end
end
end
end

end
end
end
end
%% &&&&&&&&&&&&&&&&&&&&&&& clear 变量 &&&&&&&&&&&&&&&&&&&&&&&&&&&&
clear all







