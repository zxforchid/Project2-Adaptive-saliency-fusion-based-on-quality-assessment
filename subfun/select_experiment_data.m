% 从THUS10000中选取实验数据 GC HC LC CA
% 12/19/2015 
% written by xiaofei zhou,shanghai university,shanghai,china
% zxforchid@163.com
% 

clear all;close all;clc

GT_path = ['D:\program debug\PHD\XM1_fusion\fangzhen_liufeng\binarymasks\'];
GT_imnames=dir([GT_path '*' 'bmp']);

suff_colorimg = '.jpg';

salmodels.name = {'GC', 'HC', 'LC', 'CA'};
salmodels.suffsal = 'jpg';
salmodels.paths = ['D:\program debug\PHD\XM1_fusion\fangzhen_liufeng\saliencymaps\'];

files = ['D:\program debug\PHD\XM1_fusion\' ];% 'THUS10000_CA\'

for i=1:4
    goalfile{i,1} = [salmodels.paths, salmodels.name{1,i},'\'];
    if ~isdir(goalfile{i,1})
       mkdir(goalfile{i,1});
    end
    
    tmpfile = [files, 'THUS10000_', salmodels.name{1,i},'\'];
    
    for j = [1:77,79:522,524:570,572:916,918:length(GT_imnames)]
%       for j=1000
        fprintf('\n %d | %d ',i,j)
        imname = GT_imnames(j).name(1:end-4);
        ll = length(imname);
        for jj=ll:-1:1
            tmpchar = imname(jj);
            if strcmp(tmpchar,'_')
                dd = jj;
                break;
            end
        end
        
        tmp_imname = imname(dd+1:end);
        
        tmpimg = [tmpfile, tmp_imname, '_', salmodels.name{1,i}, '.png'];
        
        salimg = imread(tmpimg);
        salimg = normalize_sal(im2double(salimg));
        
        
        imwrite(salimg,[goalfile{i,1} imname '.jpg']); 
        
        clear salimg

       gtimg = imread([GT_path, GT_imnames(j).name]);
       imwrite(gtimg,['D:\program debug\PHD\XM1_fusion\fangzhen_liufeng\binarymasks1\' GT_imnames(j).name]);
    
    end
    
end



