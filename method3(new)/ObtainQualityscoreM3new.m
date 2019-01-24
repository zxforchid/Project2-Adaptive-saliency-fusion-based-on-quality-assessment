function outputFileID = ObtainQualityscoreM3new(i, init_infor,testName,testorvalid)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mehotd3 ���ݻ�õ�����ģ������SRC�Բ������������������
% 
% ���������÷ֽ������Լ�Ȩ�ں�
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
%% initial
GT = init_infor.GT;
GT_imnames = GT.GT_imnames;
imname = GT_imnames(i).name(1:end-4);
dataSet = init_infor.datasets;
ntype = 4;

% save([savePath, 'qualityModel',datasets{1,dd},'-',testName(5:end),'.mat'],'betaMkb','modelMkb','dMkb','scaleMkb')
load([init_infor.savePath, 'qualityModelMSRA10K-',testName(5:end),'.mat'])

%% ��ȡ��������
fprintf('\n ��ȡ�������� &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& \n')
% ��ȡ�������� & ��һ��
switch dataSet
    case 'MSRA10K'
        load(['.\data\qualitydata_revised\',dataSet,'\TEST\',testName(5:end),'\',imname,'.mat'])
    case 'ECSSD' 
        load(['.\data\qualitydata_revised\',dataSet,'\TEST\',testName(5:end),'\',imname,'.mat'])
    case 'PASCAL850'
        load(['.\data\qualitydata_revised\',dataSet,'\TEST\',testName(5:end),'\',imname,'.mat'])      

end
testMat = data;
tmpsal = imsalNorms{1,1};
testImSals = zeros(size(tmpsal,1),size(tmpsal,2),length(imsalNorms));
for ss=1:length(imsalNorms)
    testImSals(:,:,ss) = imsalNorms{1,ss};
end
clear imsalNorms data tmpsal

% ȥ��NAN
testDataMatrix = [testMat.FC,testMat.FCP,testMat.FH,testMat.FCS,testMat.FNC, testMat.FB];
%     testMat.DMSV,testMat.SPE,testMat.SV,testMat.IC];
[XNAN] = isnan(testDataMatrix);
[indexNAN,~] = find(XNAN==1);
testImSals(:,:,indexNAN) = [];
clear testDataMatrix

    testMat.FC(indexNAN,:) = [];
    testMat.FCP(indexNAN,:) = [];
    testMat.FH(indexNAN,:) = [];
    testMat.FCS(indexNAN,:) = [];
    testMat.FNC(indexNAN,:) = [];
    testMat.FB(indexNAN,:) = [];

tic
 % ��һ������
[testMat.FC]   = scaleData_test(testMat.FC,  0, 1, scaleMkb.FCmin,   scaleMkb.FCmax);
[testMat.FCP]  = scaleData_test(testMat.FCP, 0, 1, scaleMkb.FCPmin,  scaleMkb.FCPmax);
[testMat.FH]   = scaleData_test(testMat.FH,  0, 1, scaleMkb.FHmin,   scaleMkb.FHmax);
[testMat.FCS]  = scaleData_test(testMat.FCS, 0, 1, scaleMkb.FCSmin,  scaleMkb.FCSmax);
[testMat.FNC]  = scaleData_test(testMat.FNC, 0, 1, scaleMkb.FNCmin,  scaleMkb.FNCmax);
[testMat.FB]   = scaleData_test(testMat.FB,  0, 1, scaleMkb.FBmin,   scaleMkb.FBmax);

% ����SVM-Adaboost �õ���������
% ��ͬ��������ͼ��Ӧ�в�ͬ�ĵ÷� ������6������ ��������0~1֮�䣩
[qualityScore, ~] = MKL_test(betaMkb, modelMkb,dMkb,testMat,ntype);
 qualityScore = 1./(1+exp(-qualityScore));
 qualityScore1 = normalize_sal(qualityScore);
 qualityScore2 = qualityScore./(sum(qualityScore(:))+eps);
clear betaMkb modelMkb dMkb testMat ntype
toc
%% ���������÷������ں�

tic
fprintf('\n ���������÷������ں� &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& \n')
smap = 0;smap1 = 0;smap2 = 0;meanSal = 0;
for ii=1:length(qualityScore)
    smap  = smap  + qualityScore(ii) * testImSals(:,:,ii);
    smap1 = smap1 + qualityScore1(ii)* testImSals(:,:,ii);
    smap2 = smap2 + qualityScore2(ii)* testImSals(:,:,ii);
%     smap = smap + qualityScore(ii)*testImSals{1,ii};
%     smap1 = smap1 + qualityScore1(ii)*testImSals{1,ii};
%     smap2 = smap2 + qualityScore2(ii)*testImSals{1,ii};
end
clear testImSals qualityScore qualityScore1 qualityScore2

%% �����ںϽ��
fprintf('\n �����ںϽ�� &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& \n')
% normalization
imgwritepath = [init_infor.imwritePath,testorvalid,'\'];
if ~isdir(imgwritepath)
      mkdir(imgwritepath);
end

smap = (smap - min(smap(:))) / (max(smap(:)) - min(smap(:)) + eps) * 255;
smap = uint8(smap);toc
imwrite(smap, [imgwritepath, imname '_m3.png'])

smap1 = (smap1 - min(smap1(:))) / (max(smap1(:)) - min(smap1(:)) + eps) * 255;
smap1 = uint8(smap1);
imwrite(smap1, [imgwritepath imname '_m3_1.png'])

smap2 = (smap2 - min(smap2(:))) / (max(smap2(:)) - min(smap2(:)) + eps) * 255;
smap2 = uint8(smap2);
imwrite(smap2, [imgwritepath imname '_m3_2.png'])


clear smap smap1 smap2 mean

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