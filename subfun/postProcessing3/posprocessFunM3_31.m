function outputFileID = posprocessFunM3_31(i, init_infor,testName,testorvalid, lambdaPara)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 使用卢湖川的 graphCut 程序，并根据自身的情况做一定的改变
% posprocessFunM3_3
%
% input:
% i             待处理图像的序列号
% init_infor    初始化信息，包含有数据库名称、多尺度尺寸等   
% testNmae      训练/测试文件名字
% lambdaPara    graphCut 平滑项的参数
% 
% output:
% outputFileID 待处理图像的ID标号
% 
% IVPLab,shanghai university,shanghai,china
% http://www.ivp.shu.edu.cn/Default.aspx
% xiaofei zhou,zxforchid@163.com
%  2016/04/21 21:12PM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initial
GT = init_infor.GT;
suffixcolor = GT.suffixcolor;
GT_imnames = GT.GT_imnames;
GT_path = GT.GT_path;
imname = GT_imnames(i).name(1:end-4);
dataset = init_infor.datasets;


%% 读取彩色图像
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

% tic 
%% 建立图模型
% edge 连接
E = edges4connected(h,w);

% 平滑项
m1 = imcolor(:,:,1);
m2 = imcolor(:,:,2);
m3 = imcolor(:,:,3); 
clear imcolor

[~, ~, sptialDist] = computeDist(E, h, w);
colorDist = (m1(E(:,1))-m1(E(:,2))).^2+(m2(E(:,1))-m2(E(:,2))).^2+(m3(E(:,1))-m3(E(:,2))).^2;
meanColorDist = mean(colorDist);
V = exp(-colorDist/(5*meanColorDist))./sptialDist;
AA = lambdaPara * sparse(E(:,1),E(:,2),V);

% 滤波器核
g = fspecial('gauss', [5 5], sqrt(5));  

clear sptialDist E colorDist meanColorDist V
%% 读取显著性图
imgwritepath = [init_infor.imwritePath,testorvalid,'\'];
% sal1 = double(imread([imgwritepath,imname,'_m3.png']));  sal1 = normalize_sal(sal1);
sal2 = double(imread([imgwritepath,imname,'_m3.png']));sal2 = normalize_sal(sal2);
% sals{1,1} = sal1; 
sals{1,1} = sal2;
clear sal1 sal2

%% crf refine & 保存结果
imgwritepath1 = [init_infor.imwritePath,testorvalid,'\20160422-graphCut\',num2str(lambdaPara),'\'];
if ~isdir(imgwritepath1)
      mkdir(imgwritepath1);
end


for ss=1
    tmpSal = sals{1,ss};

    [ gcMap, ~ ]  = graphcut0(AA,g,tmpSal);
    gcMap = double(gcMap);
    
%     smap0 = tmpSal.*gcMap; 
%     smap0 = normalize_sal(smap0);
%     imwrite(uint8(255*smap1), [imgwritepath1, imname ,'_1_gc.png'])
    
%     smap1filter= guidedfilter(smap1,smap1,7,0.1);
%     smap1filter = normalize_sal(smap1filter);
%     imwrite(uint8(255*smap1filter), [imgwritepath1, imname ,'_1_gc_filter.png'])   
    
    smap1 = tmpSal + gcMap;
    smap1 = normalize_sal(smap1); %toc
    imwrite(uint8(255*smap1), [imgwritepath1, imname ,'_1_gc.png'])
    
%     smap1filter= guidedfilter(smap1,smap1,7,0.1);
%     smap1filter = normalize_sal(smap1filter);   
%     imwrite(uint8(255*smap1filter), [imgwritepath1, imname ,'_1_gc_filter.png'])   
    
    
%     smap2 = normalize_sal(0.3*smap0 + 0.7*smap1);
%     imwrite(uint8(255*smap2), [imgwritepath1, imname ,'_2_gc.png'])
%     smap2filter= guidedfilter(smap2,smap2,7,0.1);
%     smap2filter = normalize_sal(smap2filter);   
%     imwrite(uint8(255*smap2filter), [imgwritepath1, imname ,'_2_gc_filter.png'])   
    
%     figure,
%     subplot(2,2,1),imshow(smap1,[]),title('smap1')
%     subplot(2,2,2),imshow(smap1filter,[]),title('smap1filter')
%     subplot(2,2,3),imshow(smap2,[]),title('smap2')
%     subplot(2,2,4),imshow(smap2filter,[]),title('smap2filter')
    
    clear tmpSal smap1 smap1filter smap2 smap2filter 
end

clear AA g 

%% 
outputFileID = i;
end


function [node1, node2, Dist] = computeDist(E, h, w)
% E 等于边数目*2 

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
%% Lu graph-Cut 
% % construct graph
% E = edges4connected(m,n);
% V=1./(1+sqrt((m1(E(:,1))-m1(E(:,2))).^2+(m2(E(:,1))-m2(E(:,2))).^2+(m3(E(:,1))-m3(E(:,2))).^2));
% AA=1000*sparse(E(:,1),E(:,2),0.3*V);
% g = fspecial('gauss', [5 5], sqrt(5));

% [cutim]=graphcut0(AA,g,map);
% cutim=normalize(cutim);
% step2graphfilter= guidedfilter(step2graph,step2graph,7,0.1);


