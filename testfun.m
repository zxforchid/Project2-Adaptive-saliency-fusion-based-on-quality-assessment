% test function

clear all;clc;close all
% fprintf('\n 初始化 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
% datasets = {'MSRA10K','ECSSD','PASCAL1500'};
% modelSets = {'DRFI', 'QCUT', 'rbd', 'ST', 'DSR', 'MC'};
% sign = '1';
% threshSal = 0.50;
% dd1=3;
% imwritePath = ['.\data\img_result\method3_1\',datasets{1,dd1},'\'];
% savePath = ['.\data\mat_result\method3\'];
% resultPath = {imwritePath,savePath};
% init_infor = iniitial_method3(datasets{1,dd1}, modelSets, sign, threshSal, resultPath);
% GT = init_infor.GT;
% GT_imnames = GT.GT_imnames;
% load('index_method2_msra10k.mat')
% num_tr = 2000;
% trlist = index(1:num_tr);
% telist = index(num_tr+1:end);
% num_te = length(telist);
% scale = init_infor.scale;
% num_ss = scale.num_ss;


% datasets = {'MSRA10K','ECSSD','PASCAL850'};
% modelSets = {'DRFI', 'QCUT', 'rbd', 'ST', 'DSR', 'MC'};
% pathForhead = 'D:\program debug\PHD\';sign = '1';
% 
% imwritePath = ['.\data\img_result\method3\'];
% savePath = ['.\data\mat_result\'];
% resultPath = {imwritePath,savePath};
% dd = 2;
% init_infor = initialMethod5(datasets{1,dd}, pathForhead, modelSets, sign, resultPath);
% GT = init_infor.GT;
% telist = 1:GT.num_img;
% num_te = GT.num_img;

if 0
GTPATH = ['D:\ZXF\TOP6Data\ImgsGTData\MSRA10K\'];
GTNAME = dir([GTPATH '*' 'jpg']);
%% 
doneImgName = 'D:\ZXF\project2_revised\data\qualitydata_revised\MSRA10K\TEST\3k-025075\';
doneList = dir([doneImgName '*' 'mat']);
undoneList = [];
% telist = 1:1500;
% num_te=1500;
for ii=1:10000
%     ii = telist(ii);
    imname = GTNAME(ii).name(1:end-4);
    n=0;
    for dd = 1:length(doneList)
        tmpDone = doneList(dd).name(1:end-4);
%         tmpDone1 = doneList(dd+1).name(1:end-9);
%         tmpDone2 = doneList(dd+2).name(1:end-9);
%         (~strcmp(tmpDone, imname))&&(~strcmp(tmpDone1, imname))&&(~strcmp(tmpDone2, imname))
        if ~strcmp(tmpDone, imname)
            n=n+1;
        end
    end
    
    if n==length(doneList)/1
        undoneList = [undoneList;ii];
    end
    
end
save('undoneListMSRA10K20160908.mat','undoneList')

aa = 1


end


%% 调整质量特征顺序  old ---> new
TOPmodelSetsOld = {'DRFI', 'QCUT', 'rbd', 'ST', 'DSR', 'MC', 'HDCT','BSCA'};
TOPmodelSetsNew = {'DRFI', 'ST', 'rbd', 'BSCA', 'QCUT', 'DSR', 'HDCT', 'MC'};
%                    1       4     3       8       2      5       7      6
datasets = {'MSRA10K','ECSSD','PASCAL850'};

for dd=1:3
    tmpdataset = datasets{1,dd};
qualitypath = ['D:\ZXF\project2_revised\data\qualitydata_revised(old_index)\',tmpdataset,'\TEST\3k-025075\'];
qualityname = dir([qualitypath '*' 'mat']);

qualitypath1 = ['D:\ZXF\project2_revised\data\qualitydata_revised_new\',tmpdataset,'\TEST\3k-025075\'];
     if ~isdir(qualitypath1)
     mkdir(qualitypath1);
     end


%   'data','imsaltrainIndex','imsalNorms'
%      data.FC 
%      data.FCP 
%      data.FH 
%      data.FCS
%      data.FNC 
%      data.FB 
%      data.Label
%      imsalNorms{1,jvalid}
%      imsaltrainIndex
% 

% newdata.Label = [];
for ii=1:length(qualityname)
    disp(ii)
    load([qualitypath,qualityname(ii).name])
    
    newdata.FC = []; newdata.FCP = []; newdata.FH = []; newdata.FCS = []; newdata.FNC = []; newdata.FB = []; 
    newdata.DMSV = [];newdata.SPE = [];newdata.SV = [];newdata.IC = [];
    newimsalNorms = cell(1,8);
%       1       4     3       8       2      5       7      6
     newdata.FC  = [data.FC(1,:); data.FC(4,:); data.FC(3,:); data.FC(8,:); data.FC(2,:); data.FC(5,:); data.FC(7,:); data.FC(6,:);]; 
     newdata.FCP = [data.FCP(1,:);data.FCP(4,:);data.FCP(3,:);data.FCP(8,:);data.FCP(2,:);data.FCP(5,:);data.FCP(7,:);data.FCP(6,:);]; 
     newdata.FH  = [data.FH(1,:); data.FH(4,:); data.FH(3,:); data.FH(8,:); data.FH(2,:); data.FH(5,:); data.FH(7,:); data.FH(6,:);]; 
     newdata.FCS = [data.FCS(1,:);data.FCS(4,:);data.FCS(3,:);data.FCS(8,:);data.FCS(2,:);data.FCS(5,:);data.FCS(7,:);data.FCS(6,:);]; 
     newdata.FNC = [data.FNC(1,:);data.FNC(4,:);data.FNC(3,:);data.FNC(8,:);data.FNC(2,:);data.FNC(5,:);data.FNC(7,:);data.FNC(6,:);]; 
     newdata.FB  = [data.FB(1,:); data.FB(4,:); data.FB(3,:); data.FB(8,:); data.FB(2,:); data.FB(5,:); data.FB(7,:); data.FB(6,:);]; 
    
     nn=1;
     for mm=[1,4,3,8,2,5,7,6]
     newimsalNorms{1,nn} = imsalNorms{1,mm};
     nn = nn + 1;
     end
    
    newdata.Label = data.Label;
    
    
    clear data  imsalNorms 
    
    data = newdata;
    imsalNorms = newimsalNorms;
    
    clear newdata newimsalNorms
    
    save( [qualitypath1,qualityname(ii).name],'data','imsaltrainIndex','imsalNorms')
end
    

end

aa = 1;















% 用于测试各种函数
% 2016/1/15 16:16PM
% 

% clear all;close all;clc
% imcolor = imread('.\data\77.jpg');
% imsal = imread('.\data\77_DRFI.png');
% 
% imsal = double(imsal);
% imsal = (imsal-min(imsal(:)))/(max(imsal(:))-min(imsal(:))+eps);
% 
% imcolor = imresize(imcolor,[size(imsal,1) size(imsal,2)]);

% % [FC,FCP,FH,FCS,FNC,FB] = extract_qualitiy_feature_Liu(imsal,imcolor);
%     imsalCell = imPart(imsal,[8,8]);
%     imsalCell = imsalCell';

% SPE = SPE_fun(imsal);

% a1a= SP_fun(imsal, imcolor);
% result = SP_fun(imsal);
% dd = 0;
% ff = 0;
% for i=1:5
%     for j=1:4
%         dd = dd ++1;
%         if dd >5
%             continue
%         end
%         
%         ff = 1+ff
%     end
% end
% 
% 
% aa = 1


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% demo
% version1:
% 试验SVM-boosting+CRF算法
% written by xiaoei zhou, shanghai university, shanghai
% zxforchid@163.com
% 2016/1/14  18:12PM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % clear all;close all;clc
% 
% %% initial &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
% fprintf('\n 初始化 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
% datasets = {'MSRA10K','ECSSD','PASCAL'};
% modelSets = {'DRFI', 'QCUT', 'rbd', 'ST', 'DSR', 'MC'};
% sign = '1';
% threshSal = 0.50;
% 
% imwritePath = ['.\data\img_result\method3_1\',datasets{1,1},'\'];
% savePath = ['.\data\mat_result\method3\'];
% resultPath = {imwritePath,savePath};
% init_infor = iniitial_method2(datasets, modelSets, sign, threshSal, resultPath);
% GT = init_infor.GT;
% load('index_method2_msra10k.mat')
% num_tr = 2000;
% trlist = index(1:num_tr);
% telist = index(num_tr+1:end);
% num_te = length(telist);
% scale = init_infor.scale;
% num_ss = scale.num_ss;
% 
% %% &&&&&&&&&&&&&&& Training obtain quality model &&&&&&&&&&&&&&&&&
% if 0
% fprintf('\n &&&&&&&&&&&&&&& Training: obtain quality model &&&&&&&&&&&&&&&&& \n')
% %% 提取质量特征
% fprintf('\n 提取质量特征 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n')
% % qualityData = cell(num_tr,1);
% % trainIndex = cell(num_tr,1);
% load ([savePath,'qualityData.mat'])
% GT = init_infor.GT;
% GT_imnames = GT.GT_imnames;
% for itr=1:num_tr
%     i = trlist(itr);
%     nn = length(trainIndex{itr});
%     if nn==1
%     imname = GT_imnames(i).name(1:end-4);
%     load(['.\data\qualitydata\',imname,'.mat'])
%     
% %     fprintf('\n\n %d \n',itr)
%     
%     [qualityData{itr,1},~,trainIndex{itr,1}] = extract_quality_feature(i, init_infor, 'train');
%     end
% end
% save([savePath,'qualityData.mat'],'qualityData','trainIndex','-v7.3')
% end
% %% 形成大的训练集矩阵
% if 0
% fprintf('\n 形成大的训练集矩阵 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n')
% load ([savePath,'qualityData.mat'])
% trainMat.FC = []; trainMat.FCP = []; trainMat.FH = []; 
% trainMat.FCS = []; trainMat.FNC = []; trainMat.FB = []; 
% trainMat.DMSV = [];trainMat.SPE = [];trainMat.SV = [];
% trainMat.IC = []; Label = [];
% for ii=1:num_tr
%     tmpData = qualityData{ii,1};
%     trainMat.FC = [trainMat.FC;tmpData.FC];
%     trainMat.FCP = [trainMat.FCP;tmpData.FCP];
%     trainMat.FH = [trainMat.FH;tmpData.FH];
%     trainMat.FCS = [trainMat.FCS;tmpData.FCS];
%     trainMat.FNC = [trainMat.FNC;tmpData.FNC];
%     trainMat.FB = [trainMat.FB;tmpData.FB];
%     trainMat.DMSV = [trainMat.DMSV;tmpData.DMSV];
%     trainMat.SPE = [trainMat.SPE;tmpData.SPE];
%     trainMat.SV = [trainMat.SV;tmpData.SV];
%     trainMat.IC = [trainMat.IC;tmpData.IC];
%     Label       = [Label;tmpData.Label];
%     
%     qualityData{ii,1} = [];
%     clear tmpData
% end
% save([savePath,'trainData.mat'],'trainMat','Label','-v7.3')
% clear qualityData
% end
% %% SVM-AdaBoost 得出打分模型
% if 0
% load ([savePath,'trainData.mat'])
% fprintf('\n SVM-AdaBoost &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n')
% %10种特征，3种核函数， 每种特征对应的样本数
% ntype = 3;
% nfeature = 10;
% datanum = repmat(size(Label,1),1,nfeature);
% 
% % 特征归一化
% [trainMat.FC,scaleMkb.FCmin,scaleMkb.FCmax] = scaleData_train(trainMat.FC,0,1);
% [trainMat.FCP,scaleMkb.FCPmin,scaleMkb.FCPmax] = scaleData_train(trainMat.FCP,0,1);
% [trainMat.FH,scaleMkb.FHmin,scaleMkb.FHmax] = scaleData_train(trainMat.FH,0,1);
% [trainMat.FCS,scaleMkb.FCSmin,scaleMkb.FCSmax] = scaleData_train(trainMat.FCS,0,1);
% [trainMat.FNC,scaleMkb.FNCmin,scaleMkb.FNCmax] = scaleData_train(trainMat.FNC,0,1);
% [trainMat.FB,scaleMkb.FBmin,scaleMkb.FBmax] = scaleData_train(trainMat.FB,0,1);
% [trainMat.DMSV,scaleMkb.DMSVmin,scaleMkb.DMSVmax] = scaleData_train(trainMat.DMSV,0,1);
% [trainMat.SPE,scaleMkb.SPEmin,scaleMkb.SPEmax] = scaleData_train(trainMat.SPE,0,1);
% [trainMat.SV,scaleMkb.SVmin,scaleMkb.SVmax] = scaleData_train(trainMat.SV,0,1);
% [trainMat.IC,scaleMkb.ICmin,scaleMkb.ICmax] = scaleData_train(trainMat.IC,0,1);
% 
% % 开始训练MKB
% [ betaMkb, modelMkb, tmMkb ] = Boost_MKL( trainMat, Label, nfeature, datanum,ntype);
% dMkb = distribution( modelMkb ); 
% save([savePath, 'qualityModel.mat'],'betaMkb','modelMkb','dMkb','scaleMkb')
% end
% %% &&&&&&&&&&&&&&&&&&& Testing CRF infere &&&&&&&&&&&&&&&&&&&&&&&&
% fprintf('\n &&&&&&&&&&&&&&&&&& Testing: CRF infer &&&&&&&&&&&&&&&&&&&& \n')
% outputFileID = zeros(num_te, 1);
% parfor ite = num_te/2+1:num_te
%     disp(ite)
%     ii = telist(ite);
%     outputFileID(ite) = Obtain_QS(ii, init_infor);
% end
% 
% %% &&&&&&&&&&&&&&&&&&&&&&& clear 变量 &&&&&&&&&&&&&&&&&&&&&&&&&&&&
% clear all
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
