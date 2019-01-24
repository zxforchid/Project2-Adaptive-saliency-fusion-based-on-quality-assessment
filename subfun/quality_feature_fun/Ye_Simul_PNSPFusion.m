clear all;
clc;
warning off; %#ok<WNOFF>
TestFileNames = dir(['F:\MyWork\TCSVT_YLW\NEW\Input\Saliency\SalMaps_SB\' '/*.' 'png']);
numberOfFiles = size(TestFileNames,1);
fusion_sum_time=0;fusion_max_time=0;fusion_product_time=0;fusion_pnsp_time=0;
fusion_my_time=0;
for img_no =1:numberOfFiles  %
    [path name1 ext] = fileparts(TestFileNames(img_no).name);
    disp(img_no); %['pic'   name1]
    str1 = ['F:\MyWork\TCSVT_YLW\NEW\Input\Saliency\SalMaps_SB\' name1 '.png'];
    str2 = ['F:\MyWork\TCSVT_YLW\NEW\Input\Objectness\ALL\' name1 '.png'];
    out_sum=['F:\MyWork\TCSVT_YLW\NEW\Input\Saliency\SB_fusion\Fusion_sum\' name1 '_sum.png'];
    out_max=['F:\MyWork\TCSVT_YLW\NEW\Input\Saliency\SB_fusion\Fusion_max\' name1 '_max.png'];
    out_product=['F:\MyWork\TCSVT_YLW\NEW\Input\Saliency\SB_fusion\Fusion_product\' name1 '_product.png'];
    out_pnsp=['F:\MyWork\TCSVT_YLW\NEW\Input\Saliency\SB_fusion\Fusion_pnsp\' name1 '_pnsp.png'];
% %     out_my=['F:\newcut“÷÷∆\Saliency\ST\Fusion\Fusion_my\' name1 '_salobj.png'];

    sal=im2double(imread(str1));
    obj=im2double(imread(str2));
    %% sum
    tic
    fusion_sum=sal+obj;
    fusion_sum=mat2gray(fusion_sum);
    imwrite(fusion_sum,out_sum);
    fusion_sum_time=fusion_sum_time+toc;
    %% max
    tic
    fusion_max=max(sal,obj);
    fusion_max=mat2gray(fusion_max);
    imwrite(fusion_max,out_max);
    fusion_max_time=fusion_max_time+toc;
    %% product
    tic
    fusion_product=sal.*obj;
    fusion_product=mat2gray(fusion_product);
    imwrite(fusion_product,out_product);
    fusion_product_time=fusion_product_time+toc;
    %% PNSP
   tic
   level_sal=graythresh(sal);
   sal_otsu=im2bw(sal,level_sal); 
   [sal_j,sal_i]=meshgrid(1:size(sal,2),1:size(sal,1));
   sal_ie=mean(sal_i(sal_otsu));
   sal_je=mean(sal_j(sal_otsu));
%    v_sal=sqrt((sal_i(sal_otsu)-sal_ie).^2+(sal_j(sal_otsu)-sal_je).^2);
%    v_sal=mean(v_sal);
   v_sal=sqrt((sal_i-sal_ie).^2+(sal_j-sal_je).^2).*sal_otsu;%.*(sal
   v_sal=sum(v_sal(:))/length(find(sal_otsu==1));
   
   level_obj=graythresh(obj);
   obj_otsu=im2bw(obj,level_obj);
   [obj_j,obj_i]=meshgrid(1:size(obj,2),1:size(obj,1));
   obj_ie=mean(obj_i(obj_otsu));
   obj_je=mean(obj_j(obj_otsu));
   v_obj=sqrt((obj_i-obj_ie).^2+(obj_j-obj_je).^2).*obj_otsu;
   v_obj=sum(v_obj(:))/length(find(obj_otsu==1));
   
   gama1=v_sal/max(v_sal,v_obj);
   gama2=v_obj/max(v_sal,v_obj);
   gama3=(gama1+gama2)/2;
   fusion_pnsp=gama1*sal+gama2*obj+gama3*sal.*obj;
   fusion_pnsp=mat2gray(fusion_pnsp);
   imwrite(fusion_pnsp,out_pnsp);
   fusion_pnsp_time=fusion_pnsp_time+toc;
   
%% My salobj
% tic
%    salobj=fusion_salobj(sal,obj);
% %    imwrite(salobj,out_my);
% fusion_my_time=fusion_my_time+toc;   

end  
fusion_sum_avetime=fusion_sum_time/numberOfFiles;
fusion_max_avetime=fusion_max_time/numberOfFiles;
fusion_product_avetime=fusion_product_time/numberOfFiles;
fusion_pnsp_avetime=fusion_pnsp_time/numberOfFiles;
% fusion_my_avetime=fusion_my_time/numberOfFiles;