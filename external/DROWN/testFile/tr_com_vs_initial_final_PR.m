% 比较complementary VS initial VS final
% MSRA2000/PASCALL 
% 11/27/2015
% 


clear all;close all;clc

datasetnames = {'MSRA5000','PASCAL1500'};
methodnames  = {'DRFI','GMR','ST','HS','RC'};
CC = {'r','b','m','g','k'};
PRFS = cell(2,5);
for dd = 1:length(datasetnames)
    datasetname = datasetnames{dd};
    figure,hold on;
    hdlY = [];
    for mm=1:length(methodnames)
        methodname = methodnames{mm};
        
        fprintf('\n %s| %s \n',datasetname,methodname)
        %% initial
        switch datasetname
            case 'MSRA5000'                
                 RES_WEAK = ['D:\program debug\PHD\ICASSP\DATA_RESULT\CCCC2\' methodname '\test2000\original\'];
                 RES_STRONG = ['D:\program debug\PHD\ICASSP\DATA_RESULT\CCCC3\' methodname '\test2000\boosted\strong\'];
                 RES_LINEAR = ['D:\program debug\PHD\ICASSP\DATA_RESULT\CCCC3\' methodname '\test2000\boosted\linear\'];
                 RES_FINAL = ['D:\program debug\PHD\ICASSP\DATA_RESULT\CCCC3\' methodname '\test2000\boosted\quality\'];
       
            case 'PASCAL1500'
                 RES_WEAK = ['D:\program debug\PHD\ICASSP\DATA_RESULT\CCCC2\' methodname '\original\' datasetname '\'];
                 RES_STRONG = ['D:\program debug\PHD\ICASSP\DATA_RESULT\CCCC3\' methodname '\boosted\' datasetname '\strong\'];
                 RES_LINEAR = ['D:\program debug\PHD\ICASSP\DATA_RESULT\CCCC3\' methodname '\boosted\' datasetname '\linear\'];
                 RES_FINAL = ['D:\program debug\PHD\ICASSP\DATA_RESULT\CCCC3\' methodname '\boosted\' datasetname '\quality\'];
        end
       
       imgRoot= ['D:\program debug\PHD\ICASSP\DATA_RESULT\COLOR_GT\' datasetname '\image\'];       % test image path
       GT=['D:\program debug\PHD\ICASSP\DATA_RESULT\COLOR_GT\' datasetname '\gt\'];       % ground truth image path

      SUFFIXweak = ['_' methodname '.png'];
      gtSuffix = '.png';
      SUFFIXstrong = '_strong_filter.png';
      SUFFIXfinal = '_quality_integrate1.png';
      %% draw           
    [~, ~,~,~, hdlY_initial]    = DrawPRCurve1(RES_WEAK,   SUFFIXweak,   GT, gtSuffix, true, true,[CC{mm} '--']);
    [~, ~,~,~, hdlY_complement] = DrawPRCurve1(RES_STRONG, SUFFIXstrong, GT, gtSuffix, true, true,[CC{mm} ':']);
    [~, ~,~,~, hdlY_final]      = DrawPRCurve1(RES_FINAL,  SUFFIXfinal,  GT, gtSuffix, true, true, CC{mm});
    
%     PP{dd,mm} = [hdlY_initial,hdlY_complement,hdlY_final];
    if 0
    [P_i,R_i,FM03_i,FM05_i,FM1_i] = compute_fmeasure_forrevised(RES_WEAK,  SUFFIXweak, GT, gtSuffix);
    [P_c,R_c,FM03_c,FM05_c,FM1_c] = compute_fmeasure_forrevised(RES_STRONG,SUFFIXstrong, GT, gtSuffix);
    
    PRFS{dd,mm} = [P_i,R_i,FM03_i,FM05_i,FM1_i;P_c,R_c,FM03_c,FM05_c,FM1_c];
    clear P_c R_c FM03_c FM05_c FM1_c P_i R_i FM03_i FM05_i FM1_i
    end 

    hdlY = [hdlY;hdlY_initial;hdlY_complement;hdlY_final;];
    
    clear hdlY_initial hdlY_complement hdlY_final
    end
    hold off;
    grid on;   
%     lg = legend({'DRFI-i';'DRFI-c';'GMR-i';'GMR-c';'ST-i';'ST-c';'HS-i';'HS-c';'RC-i';'RC-c';});
%     lg = legend({'DRFI-i';'DRFI*';'GMR-i';'GMR*';'ST-i';'ST*';'HS-i';'HS*';'RC-i';'RC*';});
%     lg = legend({'DRFI-i';'DRFI-c';'DRFI*';'GMR-i';'GMR-c';'GMR*';'ST-i';'ST-c';'ST*';'HS-i';'HS-c';'HS*';'RC-i';'RC-c';'RC*';});
%     legend_str = {'DRFI-I';'DRFI-C';'DRFI*';'GMR-I';'GMR-C';'GMR*';'ST-I';'ST-C';'ST*';'HS-I';'HS-C';'HS*';'RC-I';'RC-C';'RC*';};
  legend_str =  {'DRFI-I';'GMR-I';'ST-I';'HS-I';'RC-I';'DRFI-C';'GMR-C';'ST-C';'HS-C';'RC-C'; 'DRFI*' ;'GMR*'; 'ST*'; 'HS*'; 'RC*';};  
% method1
%     my_columnlegend_2(3, legend_str, 'southwest');
%     columnlegend(3, legend_str, 'Location', 'southwest');

% method2
hdlY1 = [];
hdlY1 = [hdlY1;hdlY(1);hdlY(4);hdlY(7);hdlY(10);hdlY(13);hdlY(2);hdlY(5);hdlY(8);hdlY(11);hdlY(14);hdlY(3);hdlY(6);hdlY(9);hdlY(12);hdlY(15);];


gridLegend(hdlY1,3,legend_str,'location','southwest');

%     set(lg, 'location', 'southwest');
    set(gca,'box','on');
    xlabel('Recall')
    ylabel('Precision')
    set(get(gca,'XLabel'),'FontSize',15);%图上文字为8 point或小5号
    set(get(gca,'YLabel'),'FontSize',15);
%     if strcmp(datasetname,'MSRA5000')
%        title('MSRA')
%     else
%         title(datasetname)
%     end
    

end
