% initial for demoMthod5
% 2016/3/11 19:29PM
% IVPLab,shanghai university,shanghai,china
% http://www.ivp.shu.edu.cn/Default.aspx
% xiaofei zhou,zxforchid@163.com
% 2016/1/21 22:22PM
% 
function init_infor = initialMethod5(dataSet, pathForhead, modelSets, sign, resultPath)
% ��ȡ��ʼ����Ϣ
TOP6DataPath = ['TOP6Data'];
ImgsGTDataPath = ['ImgsGTData'];
salDataPath = ['salData'];

% salModel��Ϣ
salmodels.name = modelSets;
salmodels.suffixsal = 'png';
salmodels.paths = [pathForhead,'\',TOP6DataPath,'\',salDataPath,'\'];
salmodels.num_model = length(salmodels.name);
init_infor.salmodels = salmodels;
init_infor.datasets = dataSet;

% gt��color��Ϣ
GT.GT_path = [pathForhead,'\',TOP6DataPath,'\',ImgsGTDataPath,'\',dataSet,'\'];
GT.suffixcolor = '.jpg';
GT.suffixgt = '.png';
GT.GT_imnames = dir([GT.GT_path '*' GT.suffixgt(2:end)]);
GT.num_img = length(GT.GT_imnames); % 10k

init_infor.GT = GT;

% �߶���Ϣ
scale.patchsizes = {[9,9],[11,11],[13,13],[15,15],[17,17],[19,19],[21,21],[23,23]};
scale.num_ps = length(scale.patchsizes);
scale.scalesizes = {50,100,150,200,250,300,350,400};
scale.num_ss = length(scale.scalesizes);
init_infor.scale = scale;

init_infor.sign = sign; % 1 δչ��  2 չ��
init_infor.nstates = 2;

% ��ǩѡ����ֵ
% init_infor.thresh = threshSal;

% imwrite������·��
imwritePath = resultPath{1,1};
savePath = resultPath{1,2};
if ~isdir(imwritePath)
      mkdir(imwritePath);
end
if ~isdir(savePath)
      mkdir(savePath);
end
init_infor.imwritePath = imwritePath;
init_infor.savePath = savePath;
end