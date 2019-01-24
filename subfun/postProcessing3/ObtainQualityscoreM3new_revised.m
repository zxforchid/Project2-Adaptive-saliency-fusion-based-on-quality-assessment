function outputFileID = ObtainQualityscoreM3new_revised(i, init_infor,testName,testorvalid,lambdaPara)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��������ģ�ͽ���������֣�Ȼ������������ɱ任���г����ںϣ�
% ������graph-cut��������MTAP���ް汾��
% 
% input:
% i             ������ͼ������к�
% init_infor    ��ʼ����Ϣ�����������ݿ����ơ���߶ȳߴ��   
% testNmae      ѵ��/�����ļ�����
% isDicTrain    �ֵ�ѵ�����ı�־ 1 ѵ��  0 ��ѵ��
% 
% output:
% outputFileID ������ͼ���ID���
% 
% V2: 2016.09.07 13:00PM
% ��ԭ�г����ϣ����respondse�Գ�����������޸�
% 
% IVPLab,shanghai university,shanghai,china
% http://www.ivp.shu.edu.cn/Default.aspx
% xiaofei zhou,zxforchid@163.com
% 2016/1/12 10:23PM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1 initial
GT = init_infor.GT;
GT_imnames = GT.GT_imnames;
imname = GT_imnames(i).name(1:end-4);
dataSet = init_infor.datasets;
ntype = 4;

salmodels = init_infor.salmodels;
num_model = salmodels.num_model;

% ��ȡѵ��ģ��
% save([savePath, 'qualityModel',datasets{1,dd},'-',testName(5:end),'.mat'],'betaMkb','modelMkb','dMkb','scaleMkb')
load([init_infor.savePath, 'qualityModel','MSRA10K','-',testName(5:end),'.mat'])% our method on top2 4 6

%% 2 ��ȡ��������
fprintf('\n ��ȡ�������� &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& \n')
% ��ȡ�������� & ��һ��
% qualityDataPath = ['.\data\qualitydata_revised\',dataset,'\TEST\',testName(5:end),'\'];
% save( [qualityDataPath,imname,'.mat'],'data','imsaltrainIndex','imsalNorms')
switch dataSet % ����Ҫע�⣬�����test������ȫ��ģ�͵�������������ͼ������
    case 'MSRA10K'
        load(['.\data\qualitydata_revised\',dataSet,'\TEST\',testName(5:end),'\',imname,'.mat'])
    case 'ECSSD' 
        load(['.\data\qualitydata_revised\',dataSet,'\TEST\',testName(5:end),'\',imname,'.mat'])
    case 'PASCAL850'
        load(['.\data\qualitydata_revised\',dataSet,'\TEST\',testName(5:end),'\',imname,'.mat'])   
    case 'ASD'
%         qualityDataPath = ['E:\MATLAB_TEST\project2_revisedData\LiuCompare\qualitydata_revised\',dataset,'\TEST\',testName(5:end),'\'];
        load(['E:\MATLAB_TEST\project2_revisedData\LiuCompare\qualitydata_revised\',dataSet,'\TEST\',testName(5:end),'\',imname,'.mat'])
end
testMat = data;

% ����top_xxѡ��������ͼ������ ---
tmpsal = imsalNorms{1,1};
testImSals = zeros(size(tmpsal,1),size(tmpsal,2),num_model);
% for ss=1:length(imsalNorms) 
for ss=1:num_model
    testImSals(:,:,ss) = imsalNorms{1,ss};
end
clear imsalNorms data tmpsal

testMat.FC(num_model+1:end,:)   = [];
testMat.FCP(num_model+1:end,:)  = [];
testMat.FH(num_model+1:end,:)   = [];
testMat.FCS(num_model+1:end,:)  = [];
testMat.FNC(num_model+1:end,:)  = [];
testMat.FB(num_model+1:end,:)   = [];
    
testMat.DMSV(num_model+1:end,:) = [];
testMat.SPE(num_model+1:end,:)  = [];
testMat.SV(num_model+1:end,:)   = [];
testMat.IC(num_model+1:end,:)   = [];
    
    
% ȥ��NAN
testDataMatrix = [testMat.FC,testMat.FCP,testMat.FH,testMat.FCS,testMat.FNC, testMat.FB];
[XNAN] = isnan(testDataMatrix);
[indexNAN,~] = find(XNAN==1);
testImSals(:,:,indexNAN) = [];
clear testDataMatrix

testMat.FC(indexNAN,:) = [];testMat.FCP(indexNAN,:) = [];testMat.FH(indexNAN,:) = [];
testMat.FCS(indexNAN,:) = [];testMat.FNC(indexNAN,:) = [];testMat.FB(indexNAN,:) = [];

 % ��һ������
[testMat.FC]   = scaleData_test(testMat.FC,  0, 1, scaleMkb.FCmin,   scaleMkb.FCmax);
[testMat.FCP]  = scaleData_test(testMat.FCP, 0, 1, scaleMkb.FCPmin,  scaleMkb.FCPmax);
[testMat.FH]   = scaleData_test(testMat.FH,  0, 1, scaleMkb.FHmin,   scaleMkb.FHmax);
[testMat.FCS]  = scaleData_test(testMat.FCS, 0, 1, scaleMkb.FCSmin,  scaleMkb.FCSmax);
[testMat.FNC]  = scaleData_test(testMat.FNC, 0, 1, scaleMkb.FNCmin,  scaleMkb.FNCmax);
[testMat.FB]   = scaleData_test(testMat.FB,  0, 1, scaleMkb.FBmin,   scaleMkb.FBmax);


% ����SVM-Adaboost �õ���������
% ��ͬ��������ͼ��Ӧ�в�ͬ�ĵ÷� ������6������ ��������0~1֮�䣩
% [qualityScore, ~] = MKL_test(betaMkb, modelMkb,dMkb,testMat,ntype);
[qualityScore, ~] = MKL_test_Liu(betaMkb, modelMkb,dMkb,testMat,ntype);
% qualityScore
 qualityScore = 1./(1+exp(-qualityScore));
clear betaMkb modelMkb dMkb testMat ntype

%% 3 ���������÷������ں�

fprintf('\n ���������÷������ں� &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& \n')
smap = 0;
for ii=1:length(qualityScore)
%     smap  = smap  + testImSals(:,:,ii).^qualityScore(ii);
   smap  = smap  + normalize_sal(testImSals(:,:,ii).^qualityScore(ii));
end
clear testImSals qualityScore


imgwritepath = [init_infor.imwritePath];
smap0 = (smap - min(smap(:))) / (max(smap(:)) - min(smap(:)) + eps) * 255;
smap0 = uint8(smap0);
imwrite(smap0, [imgwritepath, imname '_m3.png'])

%% 4 ���� &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
fprintf('\n ����refinement &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& \n')
GT_path = GT.GT_path;
suffixcolor = GT.suffixcolor;
imcolor = imread([GT_path imname suffixcolor]);
[h, w, dim] = size(imcolor);
if dim==1
    temp=uint8(zeros(h,w,3));
    temp(:,:,1)=imcolor;
    temp(:,:,2)=imcolor;
    temp(:,:,3)=imcolor;
    imcolor=temp;
end

imcolor = double(imcolor);

% edge ����
E = edges4connected(h,w);

% ƽ����
m1 = imcolor(:,:,1);
m2 = imcolor(:,:,2);
m3 = imcolor(:,:,3); 
clear imcolor

[~, ~, sptialDist] = computeDist(E, h, w);
colorDist = (m1(E(:,1))-m1(E(:,2))).^2+(m2(E(:,1))-m2(E(:,2))).^2+(m3(E(:,1))-m3(E(:,2))).^2;
meanColorDist = mean(colorDist);
V = exp(-colorDist/(5*meanColorDist))./sptialDist;
AA = lambdaPara * sparse(E(:,1),E(:,2),V);

% �˲�����
g = fspecial('gauss', [5 5], sqrt(5));  

clear sptialDist E colorDist meanColorDist V

% ���»�ȡ������ͼ
smap = normalize_sal(smap);

[ gcMap, ~ ]  = graphcut0(AA,g,smap);
 gcMap = double(gcMap);

smap1 = smap + gcMap;
smap1 = normalize_sal(smap1); %toc
imwrite(uint8(255*smap1), [imgwritepath, imname ,'_1_gc.png'])



%% clear

clear smap0 smap1 smap

%% ����

outputFileID = i;
end

%--------------------------------------------------------------------------%
% ��region-level 2 pixle-level
% 2016/1/12
function temp_smap = spSaliency2Pixels( sp_sal_prob, tmpidxImg, enhance )
    if nargin < 3
        enhance = true;
    end
    
    % normalization 0~1
    sp_sal_prob = (sp_sal_prob - min(sp_sal_prob)) /...
        (max(sp_sal_prob) - min(sp_sal_prob) + eps);
    
    % enhance the difference between salient and background regions
    if enhance
        sp_sal_prob = exp( 1.25 * sp_sal_prob );
        sp_sal_prob = (sp_sal_prob - min(sp_sal_prob)) /...
            (max(sp_sal_prob) - min(sp_sal_prob) + eps);
    end
    
    % assign the saliency value of each segment to its contained pixels
    spstats = regionprops( tmpidxImg, 'PixelIdxList' );
    temp_smap = zeros( size(tmpidxImg) );
    for r = 1 : length(spstats)
        temp_smap( spstats(r).PixelIdxList ) = sp_sal_prob( r );
    end
    
    clear tmpidxImg sp_sal_prob spstats
    
end



function [node1, node2, Dist] = computeDist(E, h, w)
% E ���ڱ���Ŀ*2 

node1h = mod(E(:,1),h);
node1w = 1 + ((E(:,1) - node1h)/h);
node1 = [node1h,node1w];
clear node1h node1w

node2h = mod(E(:,2),h);
node2w = 1 + ((E(:,2) - node2h)/h);
node2 = [node2h,node2w];
clear node2h node2w

Dist = sum(((node1 - node2).^2),2);

clear E h w
end