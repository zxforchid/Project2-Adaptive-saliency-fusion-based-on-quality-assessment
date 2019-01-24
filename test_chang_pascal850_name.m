%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test_change_pascal850_name
% 修改 PASCAL850 TOP6结果的名称
% DRFI MC RBD
% 2016/1/22 21：42PM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc

%% initial
% alldataPath = ['D:\program debug\PHD\XM1_fusion\edata\PASCAL850\'];
% savepath = ['D:\program debug\PHD\XM1_fusion\edata\PASCAL\'];
% salModel = {'DRFI','MC','RBD'};
% GTPATH = ['D:\program debug\PHD\XM1_fusion\edata\PASCAL850_Imgs_GT\'];
% imgInfor = dir([GTPATH '*' 'png']);
% suffixSal = {'_BSD.png','_AMC.png','_ZhuW.png'};
% suffixsave = {'_DRFI.png','_MC.png','_rbd.png'};

modelSets = {'DRFI', 'rbd', 'ST', 'DSR', 'MC'};
datasets = {'PASCAL850'};

TOP6DataPath = ['D:\program debug\PHD\TOP6Data\'];
ImgsGTDataPath = ['ImgsGTData'];
% salDataPath = ['salData'];
% MeanExpLogDataPath = ['MeanExpLogData2'];
suffixSal = 'png';
PASCALGT = [TOP6DataPath, ImgsGTDataPath, '\', 'PASCAL850(backup)\'];
imgInfor = dir([PASCALGT '*' 'png']);
tmpsavepath = ['D:\program debug\PHD\TOP6Data\ImgsGTData\PASCAL850_B\'];
if ~isdir(tmpsavepath)
     mkdir(tmpsavepath);
end
for i=1:length(imgInfor)
    disp(i)
    imname = imgInfor(i).name(1:end-4);
    tmpColor = imread(['D:\program debug\PHD\TOP6Data\ImgsGTData\PASCAL850(backup)\',imname,'.jpg']);
    tmpGray = imread(['D:\program debug\PHD\TOP6Data\ImgsGTData\PASCAL850(backup)\',imname,'.png']);
    threshold = mean(tmpGray(:));
    tmpBT = zeros(size(tmpGray));
    
    cutimg= mat2gray(otsu(tmpGray));
    cutimg = uint8(255 * cutimg);
    imwrite(cutimg,[tmpsavepath,imname,'.png'])
%     tmpBT(tmpGray>threshold) = 255;
%     tmpBT(tmpGray<threshold) = 0;
    
%     imwrite(tmpBT,[tmpsavepath,imname,'.png'])
    imwrite(tmpColor,[tmpsavepath,imname,'.jpg'])
    
    clear tmpColor  tmpGray imname
end
%%
% for mm=1:3
%     fprintf('\n &&&&&&&&&&&& mm = %d %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n',mm)
%     tmpsavepath = [TOP6DataPath,ImgsGTDataPath,'\',datasets,'\'];
%     if ~isdir(tmpsavepath)
%         mkdir(tmpsavepath);
%     end
%     
%     for ii=1:length(imgInfor)
%         fprintf('\n %d',ii)
%         imname = imgInfor(ii).name(1:end-4);
%         tmpSal = imread([alldataPath,salModel{1,mm},'\',imname, suffixSal{1,mm}]);
% %         tmpSal = 255 * normalize_sal(tmpSal);
% %         tmpSal = uint8(tmpSal);
%         
%         imwrite(tmpSal,[tmpsavepath,imname,suffixsave{1,mm}]);
%         
%         clear tmpSal
%     end
% end


