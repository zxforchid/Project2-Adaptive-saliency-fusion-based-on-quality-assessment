% 测试method3 method5 method6 method7的结果：
% test2k-0309  test5k-0309
% IVPLab,shanghai university,shanghai,china
% http://www.ivp.shu.edu.cn/Default.aspx
% xiaofei zhou,zxforchid@163.com
% 2016/03/18 21:36PM
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;close all;clc

%% 初始化 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
fprintf('\n 初始化 .........')
datasets = {'MSRA10K','ECSSD','PASCAL850'}; %,'JuddDB'
modelSets = {'DRFI', 'QCUT', 'rbd', 'ST', 'DSR', 'MC'};

TOP6DataPath = ['D:\program debug\PHD\TOP6Data\'];
ImgsGTDataPath = ['ImgsGTData'];
salDataPath = ['salData'];
MeanExpLogDataPath = ['MeanExpLogData2'];

suffixSal = 'png';Suffixgt = '.png';suffixMean = ['_mean.png'];
% testNames = {'test2k-0309','test2k-025075','test5k-045084','test5k-055079','test5k-06650701'};
testNames = {'test2k-0309','test5k-0309'};
methodNames = {'3','5','6','7-ndl-lasso','7-dl-omp','7-dl-crc'};

%% begin &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
for mm=1:length(methodNames)
    if mm<=3
        methodName = methodNames{1,mm};
        suffixour0 = ['_m',methodName,'.png'];
        suffixour1 = ['_m',methodName,'_1.png'];
        suffixour2 = ['_m',methodName,'_2.png'];
    else
        methodName = methodNames{1,mm};
        suffixour0 = ['_m',methodName(1),'.png'];
        suffixour1 = ['_m',methodName(1),'_1.png'];
        suffixour2 = ['_m',methodName(1),'_2.png'];
    end

    
    % result data ---------------------------------------------------------
    for TT=1:length(testNames)
        testName = testNames{1,TT};
        
        % database --------------------------------------------------------
        for ddd=1:length(datasets)
            dataset = datasets{1,ddd};
            GT_path = [TOP6DataPath,ImgsGTDataPath,'\',dataset,'\'];
            meanexplogPath = [TOP6DataPath,MeanExpLogDataPath,'\',dataset,'\'];
            ourPath = ['.\data\img_result\method',methodName,'\',dataset,'\',testName,'\'];
            
            switch dataset
                case 'MSRA10K'
                    num_tr = testName(5);
                    num_tr = str2num(num_tr)*1000;
                    load('index_method2_msra10k.mat')
                    telist = index(num_tr+1:length(index));
                    num_te = length(telist);
            
                case 'ECSSD'
                    telist = 1:1000;
                    num_te = 1000;
 
                case 'PASCAL850'
                    telist = 1:850;
                    num_te = 850;  
            end
    
            % 绘图 PR 曲线
            figure,hold on;
            [~, ~,~, ~, ~, ~, ~,hdlY_our0] = ...
                Draw_PRF_Curve( ourPath,   suffixour0,   GT_path, Suffixgt, true, true,'r'); 
            
            [~, ~,~, ~, ~, ~, ~,hdlY_our1] = ...
                Draw_PRF_Curve( ourPath,   suffixour1,   GT_path, Suffixgt, true, true,'g'); 
            
            [~, ~,~, ~, ~, ~, ~,hdlY_our2] = ...
                Draw_PRF_Curve( ourPath,   suffixour2,   GT_path, Suffixgt, true, true,'b'); 
            
            [~, ~,~,~, ~, ~, ~, hdlY_mean] = ...
                Draw_PRF_Curve_testlist(telist, meanexplogPath,   suffixMean,  GT_path, Suffixgt, true, true,'m');

            hdlY = [hdlY_our0;hdlY_our1;hdlY_our2;hdlY_mean];
            hold off;grid on; % title([dataset,'-PR'])
            legend_str =  { ['m',methodName];['m',methodName,'-1'];['m',methodName,'-2'];['mean']}; 
            gridLegend(hdlY,1,legend_str,'location','southwest');    
            set(gca,'box','on');xlabel('Recall');ylabel('Precision')
            set(get(gca,'XLabel'),'FontSize',15);%图上文字为8 point或小5号
            set(get(gca,'YLabel'),'FontSize',15);
            title(['m',testName,'-',dataset,'-PR'])
        end 
        % database --------------------------------------------------------
       
    end
    % resultdata ----------------------------------------------------------
    
end








