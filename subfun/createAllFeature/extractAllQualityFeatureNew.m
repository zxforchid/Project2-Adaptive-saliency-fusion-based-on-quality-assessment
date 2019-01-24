function [data, imsalNorms, imsaltrainIndex] = extractAllQualityFeatureNew(ii, init_infor,Thigh,Tlow,tr_te_sign, MEL)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% demoCreateFeatures.m
% ����������������
% 
% inputs: 
% ii            ����ͼ��ı��
% init_infor    ��ʼ����Ϣ�����������ݿ����ơ���߶ȳߴ��
% tr_te_sign    ѵ������Եı��  ��train�� 'test'
% testNmae      ѵ��/�����ļ�����
% 
% output:
% data          ��������
% imsalNorms    ������ͼ  1*numModels
% imsaltrainIndex  ¼�õ�������ͼ
% 
% IVPLab,shanghai university,shanghai,china
% http://www.ivp.shu.edu.cn/Default.aspx
% xiaofei zhou,zxforchid@163.com
% 2016/3/28  16:47PM
%
% 
% version2:
% ���ڼ��� MEAN/EXP/LOG����������
% 2016/04/12 22:44PM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initial ��ȡ��ɫͼ��������ͼ������·���ĵ�ַ��Ϣ
GT = init_infor.GT;
suffixcolor = GT.suffixcolor;
suffixgt = GT.suffixgt;
GT_imnames = GT.GT_imnames;
GT_path = GT.GT_path;

salmodels = init_infor.salmodels;
num_model = salmodels.num_model;
dataset = init_infor.datasets;

%% ��ȡ��ɫͼ�� &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
fprintf('\n ��ȡ��ɫͼ�� ...')
imname = GT_imnames(ii).name(1:end-4);
imcolor = imread([GT_path imname suffixcolor]);
[h, w, dcolor] = size(imcolor);
if dcolor==1
    tmppp=uint8(zeros(h, w, 3));
    tmppp(:,:,1) = imcolor;
    tmppp(:,:,2) = imcolor;
    tmppp(:,:,3) = imcolor;  
    imcolor = tmppp;
    clear tmppp;
end


%% ��ȡ��ǩ ��ѵ������� &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
fprintf('\n ��ȡGT - %s ...',tr_te_sign)
switch tr_te_sign
    case 'train'
        imgt = imread([GT_path,imname,suffixgt]);
        imgt = imgt(:,:,1);
        
    case 'test'
        imgt = round(255*rand(h,w)); 
end
imGT = (imgt>=128);% logical model

%% ��ȡ������ͼ��ȷ����ǩ��ѡ����������ȡ���� &&&&&&&&&&&&&&&&&&&&&&&&&
fprintf('\n ��ȡ������ͼ����ȡ��ǩ����������ȡ���� ...')
data.FC = []; data.FCP = []; data.FH = []; data.FCS = []; data.FNC = []; 
data.FB = []; data.DMSV = [];data.SPE = [];data.SV = [];data.IC = [];
imsalNorms = {};% װ��ͨ��������֤��������ͼ
data.Label = []; % ��¼ͨ��������֤��������ͼ�ı�ǩ
imsaltrainIndex = [];% ÿһ��ͼ���Ӧ��ѵ�������ı��
jvalid = 0; % ͨ��������֤�ļ�����
for j=1:1   
    imsal = imread([init_infor.imwritePath,imname,'_',MEL,'.png']);
%     imsal = imread([init_infor.imwritePath,dataset,'\',imname,'_',MEL,'.png']);
%     imsal = imread([salmodels.paths, dataset, '\', salmodels.name{1,j}, '\', ...
%            imname, '_', salmodels.name{1,j},'.' salmodels.suffixsal]);
     [hs,ws,ds] = size(imsal);
     if ds==3
         imsal = imsal(:,:,1); 
     end
     if (hs*ws) ~= (h*w) % ͬԭʼ����ͼ�񱣳�һ��
         imsal = imresize(imsal,[h,w]);
     end
     imsalNorm = normalize_sal(imsal);

     % ȷ��������ǩ�� ����ȷ������
     % ������ʱ�ο�yang�Ĺ����� ��precisionΪ׼ 2016/1/15 15:53PM
     imGT = double(imGT);   
     imsalLabel = 1;

     %
     fprintf('\n������ͼ %d | %d ----------------------------------\n',j,ii)
     jvalid = jvalid + 1;
     imsalNorms{1,jvalid} = imsalNorm;      
     imsaltrainIndex = [imsaltrainIndex, j];
     data.Label = [data.Label;imsalLabel];
     
     % ��ȡ���������� LIU and Yang
     fprintf('\n Liu feature ----------------------------------\n')
     [FC,FCP,FH,FCS,FNC,FB] = ...
         extract_qualitiy_feature_Liu(imsalNorm,imcolor);
     fprintf('\n Yang feature ----------------------------------\n')
     [DMSV,SPE,SV] = ...
         extract_qualitiy_feature_Yang(imsal,imcolor);
    
     % �������������������Ϣ 
     data.FCP = [data.FCP;FCP]; 
     data.FNC = [data.FNC;FNC]; 
     data.FB = [data.FB;FB]; 
     
     data.FC = [data.FC;FC(j,:)];      
     data.FH = [data.FH;FH(j,:)]; 
     data.FCS = [data.FCS;FCS(j,:)];   
     data.DMSV = [data.DMSV;DMSV(j,:)];
     data.SPE = [data.SPE;SPE(j,:)];
     data.SV = [data.SV;SV(j,:)];
     
     % clear 
     clear imsal imsalNorm   
end
% ÿһ����ɫͼ���Ӧ��ѵ����������Ŀ
imsaltrainNum = length(imsaltrainIndex);
if imsaltrainNum~=0
   IC = IC_fun(imsalNorms);
   data.IC = [data.IC;IC(imsaltrainIndex,:)];
   clear IC
end

clear DATA imsaltrainNum 

%% �������� &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
% if strcmp(tr_te_sign,'train' ) 
%     qualityDataPath = ['.\data\qualitydata\',dataset,'\TRAIN\method3\',testName(5:end),'\'];
%      mkdir(qualityDataPath);
%     save( [qualityDataPath,imname,'.mat'],'data','imsaltrainIndex')
% end
if strcmp(tr_te_sign,'test' ) 
%      qualityDataPath = ['.\data\qualitydata\',dataset,'\',MEL,'\'];
     qualityDataPath = ['.\data\qualitydata\',dataset,'\Liu\TOP6\test3k-025075\test\'];
     if ~isdir(qualityDataPath)
        mkdir(qualityDataPath);
     end
    save( [qualityDataPath,imname,'.mat'],'data','imsaltrainIndex','imsalNorms')
end
%% �������ݣ��ͷ��ڴ�
clear init_infor

end