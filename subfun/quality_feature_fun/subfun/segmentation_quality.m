function FNC = segmentation_quality(saliencymap,image,threshold)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% version1:
% computer segmentation_quality feature
% input:
% saliencymap ����ͼ
% image       ��ɫͼ��
% threshold   ǰ��������ֵ
% output:
% result      �������FCS
% 
% version2:07/08/2015
% �Ż����򣬼ӿ��ٶ�
% ��FNC��Ϊǰ��/����������ĸ1���Է�ĸ2
%
% version3: 09/14/2015 14:08AM
% �����µ���⼰�Թ�ʽ���޸ģ�����������Ӧ�ĸı�
% 
% reference paper:
% <comparing salient object detection results without ground truth>
% written by xiaofei zhou,shanghai university,shanghai,china
% current version: 09/14/2015 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initial
[mt,nt] = size(threshold);
num_nc  = mt*nt;
FNC = zeros(1,num_nc);
image = double(image);
    [w,h,dim]=size(image);
    if dim==1
    temp=zeros(w,h,3);
    temp(:,:,1)=image;
    temp(:,:,2)=image;
    temp(:,:,3)=image;
    image=temp;
    end
% [ms,ns] = size(saliencymap);
% edges2 = edges2 .* (edges2 > threshold);

%% ����ǰ������segmentation�Ķ���FNC
step = 4;
for is=1:num_nc
    
    SB = saliencymap>threshold(is);% bianary opration
    
    % �²������ӿ�ִ���ٶ�
    SB1 = SB(1:step:end,1:step:end);
    image1 = image(1:step:end,1:step:end,:);
    [ms,ns] = size(SB1);
    % ----- %
    
    [STx,STy] = find(SB1==1);% SALIENT REGION
    [BTx,BTy] = find(SB1==0);
    ST = [STx,STy];% salient pixels coordinates
    BT = [BTx,BTy];% background pixels coordinates
    [mst,~] = size(ST);
    [mbt,~] = size(BT);
    DD1 = 0;DD2 = 0;
    
    %% ���㹫ʽ(5)��һ�� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    WMs1 = [];%��ĸ1
    WZs1 = [];%����1
    for ist=1:mst
%         fprintf('\n%d',ist)
        % ���ĵ��������꼰��Ӧ��ɫֵ
        xst = ST(ist,1);
        yst = ST(ist,2);
        % ������ܱ߽磬�Խ���������Ӱ�� 5~M-4  5~N-4  9*9������
        if xst>=5 && xst<=ms-4 && yst>=5 && yst<=ns-4
            [WM,WZ] = single_pixel_weight(xst,yst,BT,image1);
             WMs1 = [WMs1;WM];
             WZs1 = [WZs1;WZ];
             clear WM WZ
        end
    end
    DD1 = sum(WZs1)/max(sum(WMs1),eps);%��ʽ(5)��һ��
    
    %% ���㹫ʽ(5)�ڶ��� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    WMs2 = [];% ��ĸ2
    WZs2 = [];% ����2
    for ibt=1:mbt
        % ���ĵ���������
        xbt = BT(ibt,1);
        ybt = BT(ibt,2);
%         fprintf('\n%d',ibt)
        if xbt>=5 && xbt<=ms-4 && ybt>=5 && ybt<=ns-4
            [WM,WZ] = single_pixel_weight(xbt,ybt,ST,image1);     
             WMs2 = [WMs2;WM];
             WZs2 = [WZs2;WZ];
             clear WM WZ
        end
    end
    DD2 = sum(WZs2)/max(sum(WMs2),eps);%��ʽ(5)��һ��
    %% ����ÿ����ֵ�����µ�FNC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    FNC(is) = DD1 + DD2;
    
    clear SB ST BT SB1 image1
end

% clear variables
clear saliencymap DD1 DD2 WMs1 WMs2 WZs1 WZs2


end

% ���ڵ�һ���������һ�㣬������ӷ�ĸ��Ӧ��Ȩ������
function [WM,WZ] = single_pixel_weight(xsbt,ysbt,SBT,image)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WM ��ĸ��Ӧ��Ȩ������
% WZ ���Ӷ�Ӧ��Ȩ������������Ǳ�����/��ǰ���㣩
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ��ɫͼ�����ĵ�����ֵ
Ist = reshape(image(xsbt,ysbt,:),1,3); 
        
%%  ���ص��9*9����
% ��ĸ
NI = image(xsbt-4:xsbt+4,ysbt-4:ysbt+4,:);
Ist_nei = reshape(NI,81,3);
dist = sum((repmat(Ist,[81,1]) - Ist_nei).^2,2);% ����ƽ�� 81*1
u = sum(dist)/81;
% WM = exp(-0.5*sqrt(dist)/(u+eps));% ��ĸ 81*1 �������� 0
WM = exp(-0.5* dist /(u+eps));

% ���� �޳��Ǳ�����/��ǰ����
ax = repmat((xsbt-4:xsbt+4)',1,9);
ay = repmat(ysbt-4:ysbt+4,9,1);
NI_coors = [ax(:),ay(:)];
% NI_coors1(1,1:2:161) = ax(:);
% NI_coors1(1,2:2:162) = ay(:);
% delta = repmat(NI_coors1,size(SBT,1),1) - repmat(SBT,1,length(NI_coors));
% delta1 = delta(:,1:2:end) + delta(:,2:2:end);
% delta1(delta1~=0) = 1;
% delta2 = delta1.*ones(size(delta1,1),size(delta1,2));
% delta3 = sum(delta2);
% [z1,z2] = find(delta3==size(delta1,1));

SBTX = SBT(:,1);
SBTY = SBT(:,2);
ZZ_INDEX = [];% �洢������/ǰ����
for dd=1:81
    x = NI_coors(dd,1); % ��
    y = NI_coors(dd,2); % ��
    num = 0;
    
    % Ѱ��
    [indexx,~] = find(x==SBTX);
    for ii=1:length(indexx)
        y1 = SBTY(indexx(ii));
        if y1==y
            num = num + 1;
        end       
    end
    
    % ��� (������0��ʾ�Ǳ�����)
    if num~=0
        ZZ_INDEX = [ZZ_INDEX;dd];
    end
    
end

% �޳� �÷���WZ
WZ = WM(ZZ_INDEX);

% OVER
clear Ist_nei NI SBT SBTX SBTY ZZ_INDEX

end
