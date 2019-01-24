function [data, imsalNorms, imsaltrainIndex] = extractAllQualityFeature(ii, init_infor,Thigh,Tlow,tr_te_sign)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% demoCreateFeatures.m
% 重新生成所有特征
% 
% inputs: 
% ii            输入图像的标号
% init_infor    初始化信息，包含有数据库名称、多尺度尺寸等
% tr_te_sign    训练与测试的标记  ‘train’ 'test'
% testNmae      训练/测试文件名字
% 
% output:
% data          质量数据
% imsalNorms    显著性图  1*numModels
% imsaltrainIndex  录用的显著性图
% 
% IVPLab,shanghai university,shanghai,china
% http://www.ivp.shu.edu.cn/Default.aspx
% xiaofei zhou,zxforchid@163.com
% 2016/3/28  16:47PM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initial 获取彩色图像、显著性图、保存路径的地址信息
GT = init_infor.GT;
suffixcolor = GT.suffixcolor;
suffixgt = GT.suffixgt;
GT_imnames = GT.GT_imnames;
GT_path = GT.GT_path;

salmodels = init_infor.salmodels;
num_model = salmodels.num_model;
dataset = init_infor.datasets;

%% 读取彩色图像 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
fprintf('\n 读取彩色图像 ...')
imname = GT_imnames(ii).name(1:end-4);
imcolor = imread([GT_path imname suffixcolor]);
[h, w, ~] = size(imcolor);
% clear imcolor

% 载入已经计算好的质量特征
switch dataset
    case 'MSRA10K'
        load(['.\data\qualitydata(old)\',dataset,'\test\',imname,'.mat'])
    case 'ECSSD' 
        load(['.\data\qualitydata(old)\',dataset,'\',imname,'.mat'])
    case 'PASCAL850'
        load(['.\data\qualitydata(old)\',dataset,'\',imname,'.mat'])      
    case 'PASCAL1500'
        load(['.\data\qualitydata(old)\',dataset,'\',imname,'.mat'])
end
DATA = data;
clear imsalNorms data

%% 获取标签 分训练与测试 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
fprintf('\n 获取GT - %s ...',tr_te_sign)
switch tr_te_sign
    case 'train'
        imgt = imread([GT_path,imname,suffixgt]);
        imgt = imgt(:,:,1);
        
    case 'test'
        imgt = round(255*rand(h,w)); 
end
imGT = (imgt>=128);% logical model

%% 读取显著性图并确定标签，选择样本，提取特征 &&&&&&&&&&&&&&&&&&&&&&&&&
fprintf('\n 读取显著性图、获取标签与样本、提取特征 ...')
data.FC = []; data.FCP = []; data.FH = []; data.FCS = []; data.FNC = []; 
data.FB = []; data.DMSV = [];data.SPE = [];data.SV = [];data.IC = [];
imsalNorms = {};% 装载通过质量验证的显著性图
data.Label = []; % 记录通过质量验证的显著性图的标签
imsaltrainIndex = [];% 每一幅图像对应的训练样本的标号
jvalid = 0; % 通过质量验证的计数器
for j=1:num_model      
    imsal = imread([salmodels.paths, dataset, '\', salmodels.name{1,j}, '\', ...
           imname, '_', salmodels.name{1,j},'.' salmodels.suffixsal]);
     [hs,ws,ds] = size(imsal);
     if ds==3
         imsal = imsal(:,:,1); 
     end
     if (hs*ws) ~= (h*w) % 同原始输入图像保持一致
         imsal = imresize(imsal,[h,w]);
     end
     imsalNorm = normalize_sal(imsal);

     % 确定质量标签， 二次确定样本
     % 这里暂时参考yang的工作， 以precision为准 2016/1/15 15:53PM
     imGT = double(imGT);   
%      imsalTP = sum(sum(imGT.*imsalNorm));
%      imsalFPTP = sum(imGT(:));
%      switch tr_te_sign
%          case 'train'
%              imsalPre = imsalTP/(imsalFPTP+eps);
%          case 'test'
%              imsalPre = 1;
%      end
     imsalLabel = 1;
%      if imsalPre>= Thigh %0.65 %0.69% 0.78  %0.75
%          
%      else
%          if imsalPre<= Tlow %0.45 %0.4 % 0.3 %0.25
%              imsalLabel = -1;
%          else
%              continue;
%          end
%      end
     %
     fprintf('\n显著性图 %d | %d ----------------------------------\n',j,ii)
     jvalid = jvalid + 1;
     imsalNorms{1,jvalid} = imsalNorm;      
     imsaltrainIndex = [imsaltrainIndex, j];
     data.Label = [data.Label;imsalLabel];
     
     % 提取质量特征： LIU and Yang
     fprintf('\n Liu feature ----------------------------------\n')
     [~,FCP,~,~,FNC,FB] = ...
         extract_qualitiy_feature_Liu(imsalNorm,imcolor);
     fprintf('\n Yang feature ----------------------------------\n')
     [DMSV,SPE,SV] = ...
         extract_qualitiy_feature_Yang(imsal,imcolor);
    
     % 保存质量特征及相关信息 
     data.FCP = [data.FCP;FCP]; 
     data.FNC = [data.FNC;FNC]; 
     data.FB = [data.FB;FB]; 
     
     data.FC = [data.FC;DATA.FC(j,:)];      
     data.FH = [data.FH;DATA.FH(j,:)]; 
     data.FCS = [data.FCS;DATA.FCS(j,:)];   
     data.DMSV = [data.DMSV;DATA.DMSV(j,:)];
     data.SPE = [data.SPE;DATA.SPE(j,:)];
     data.SV = [data.SV;DATA.SV(j,:)];
     
     % clear 
     clear imsal imsalNorm   
end
% 每一幅彩色图像对应的训练样本的数目
imsaltrainNum = length(imsaltrainIndex);
if imsaltrainNum~=0
%    IC = IC_fun(imsalNorms);
   data.IC = [data.IC;DATA.IC(imsaltrainIndex,:)];
%    clear IC
end

clear DATA imsaltrainNum 

%% 保存数据 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
% if strcmp(tr_te_sign,'train' ) 
%     qualityDataPath = ['.\data\qualitydata\',dataset,'\TRAIN\method3\',testName(5:end),'\'];
%      mkdir(qualityDataPath);
%     save( [qualityDataPath,imname,'.mat'],'data','imsaltrainIndex')
% end
if strcmp(tr_te_sign,'test' ) 
     qualityDataPath = ['.\data\qualitydata\',dataset,'\TEST\'];
     if ~isdir(qualityDataPath)
        mkdir(qualityDataPath);
     end
    save( [qualityDataPath,imname,'.mat'],'data','imsaltrainIndex','imsalNorms')
end
%% 清理数据，释放内存
clear init_infor

end