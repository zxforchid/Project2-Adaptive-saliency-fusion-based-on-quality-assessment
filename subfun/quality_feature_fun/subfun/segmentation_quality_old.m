function FNC = segmentation_quality_old(saliencymap,image,threshold)
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
% version3: 09/14/2015 9:37AM

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

[ms,ns] = size(saliencymap);

% %% computer Wij  ���ڵ��Ա���ԭ�򣬳������㷶Χ���ʶ��������ַ���
% WIJ = sparse(zeros(ms*ns,ms*ns));
% % temp_img = reshape(image,ms*ns,1,3);
% % temp_img1 = repmat(temp_img,[1,ms*ns]);
% tic
% for i=1:ms*ns
%     i1 = mod(i,ms); % ��
%     j1 = (i-i1)/ms + 1; % ��
%     a1 = reshape(image(i1,j1),1,3);
%     
%     for j=1:ms*ns
%         i2 = mod(j,ms);
%         j2 = (j-i2)/ms + 1;
%         a2 = reshape(image(i2,j2),1,3);
%         
%         WIJ(i,j) = sqrt((a1-a2)*(a1-a2)');
%         
%     end
% end
% toc
% edges2 = edges2 .* (edges2 > threshold);

%% ����ǰ������segmentation�Ķ���FNC
for is=1:num_nc
    SB = saliencymap>threshold(is);% bianary opration
    [STx,STy] = find(SB==1);% SALIENT REGION
    [BTx,BTy] = find(SB==0);
    ST = [STx,STy];% salient region coordinates
    BT = [BTx,BTy];
    [mst,~] = size(ST);
    [mbt,~] = size(BT);
    DD1 = 0;DD2 = 0;
    
    %% ���㹫ʽ(5)��һ�� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    W1 = [];%��ĸ1
    W11 = [];%����1
    for ist=1:mst
        % ���ĵ��������꼰��Ӧ��ɫֵ
        xst = ST(ist,1);
        yst = ST(ist,2);
        
        % ������ܱ߽磬�Խ���������Ӱ��
        if xst>=2 && xst<=ms-1 && yst>=2 && yst<=ns-1
            
        Ist = reshape(image(xst,yst,:),1,3);
        
        % �����ĸ1,i��8���� (����i�����������)
        nei = [xst,yst-1;xst-1,yst-1;xst-1,yst;xst-1,yst+1;xst,yst+1;xst+1,yst+1;xst+1,yst;xst+1,yst-1];
        Ist_nei = zeros(8,3);
        dist = 0;u=0;wi=0;
        Ist_nei(1,:) = reshape(image(xst,yst-1,:),1,3);
        Ist_nei(2,:) = reshape(image(xst-1,yst-1,:),1,3);
        Ist_nei(3,:) = reshape(image(xst-1,yst,:),1,3);
        Ist_nei(4,:) = reshape(image(xst-1,yst+1,:),1,3);
        Ist_nei(5,:) = reshape(image(xst,yst+1,:),1,3);
        Ist_nei(6,:) = reshape(image(xst+1,yst+1,:),1,3);
        Ist_nei(7,:) = reshape(image(xst+1,yst,:),1,3);
        Ist_nei(8,:) = reshape(image(xst+1,yst-1,:),1,3);
        dist = sum(abs(repmat(Ist,[8,1]) - Ist_nei).^2,2);% ����ƽ��
        u = sum(sqrt(dist))/9;
        wi = sum(exp(-0.5*sqrt(dist)/(u+eps)));
        W1 = [W1;wi];
        
        clear Ist_nei u wi dist
        
%         % �������1(�ų������еķǱ�����)
%         Ist_nei1 = [];num=0;
%         u1=0;wi1=0;dist1=0;
%         for ii=1:8
%             index = nei(ii,:);
%             [indexlabel,~] = find(index(1)==BTx & index(2)==BTy);
%             if numel(indexlabel)~=0
%                 num = num+1;
%                Ist_nei1 = [Ist_nei1;reshape(image(index(1),index(2),:),1,3);];
%             end          
%         end
%         if num~=0
%             dist1 = sum(abs(repmat(Ist,[num,1]) - Ist_nei1).^2,2);% ����ƽ��
%             u1 = sum(sqrt(dist1))/num;
%             wi1 = sum(exp(-0.5*sqrt(dist1)/(u1+eps)));           
%         else
%             wi1 = 0;
%         end
%         
%         W11 = [W11;wi1];
%         
%         clear Ist_nei1 u1 wi1 dist1 num
        
        end
    end
%     DD1 = sum(W11)/max(sum(W1),eps);%��ʽ(5)��һ��
     DD1 = sum(W1);
    %% ���㹫ʽ(5)�ڶ��� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    W2 = [];% ��ĸ2
    W22 = [];% ����2
    for ibt=1:mbt
        % ���ĵ���������
        xbt = BT(ibt,1);
        ybt = BT(ibt,2);
        if xbt>=2 && xbt<=ms-1 && ybt>=2 && ybt<=ns-1
        Ibt = reshape(image(xbt,ybt,:),1,3);
        
        % �����ĸ2(����i�����������)
        nei = [xbt,ybt-1;xbt-1,ybt-1;xbt-1,ybt;xbt-1,ybt+1;xbt,ybt+1;xbt+1,ybt+1;xbt+1,ybt;xbt+1,ybt-1];
        Ibt_nei = zeros(8,3);
        dist = 0;u=0;wi=0;
        Ibt_nei(1,:) = reshape(image(xbt,ybt-1,:),1,3);
        Ibt_nei(2,:) = reshape(image(xbt-1,ybt-1,:),1,3);
        Ibt_nei(3,:) = reshape(image(xbt-1,ybt,:),1,3);
        Ibt_nei(4,:) = reshape(image(xbt-1,ybt+1,:),1,3);
        Ibt_nei(5,:) = reshape(image(xbt,ybt+1,:),1,3);
        Ibt_nei(6,:) = reshape(image(xbt+1,ybt+1,:),1,3);
        Ibt_nei(7,:) = reshape(image(xbt+1,ybt,:),1,3);
        Ibt_nei(8,:) = reshape(image(xbt+1,ybt-1,:),1,3);
        dist = sum(abs(repmat(Ibt,[8,1]) - Ibt_nei).^2,2);% ����ƽ��
        u = sum(sqrt(dist))/9;
        wi = sum(exp(-0.5*sqrt(dist)/(u+eps)));
        W2 = [W2;wi];
        
        clear Ibt_nei u wi dist
        end
    end
%     W22 = W11;  
%     DD2 = sum(W22)/max(sum(W2),eps);%��ʽ(5)��һ��
    DD2 = max(sum(W2),eps);
    %% ����ÿ����ֵ�����µ�FNC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     FNC(is) = DD1 + DD2;
    FNC(is) = DD1/max(DD2,eps);
    
    clear SB ST STx STy BT BTx BTy
end

% clear variables
clear saliencymap


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         % �������2(�ų������еķǱ�����)
%         Ibt_nei1 = [];num=0;
%         u1=0;wi1=0;dist1=0;
%         for ii=1:8
%             index = nei(ii,:);
%             [indexlabel,~] = find(index(1)==BTx & index(2)==BTy);
%             if numel(indexlabel)~=0
%                 num = num+1;
%                Ibt_nei1 = [Ibt_nei1;reshape(image(index(1),index(2),:),1,3);];
%             end          
%         end
%         if num~=0
%             dist1 = sum(abs(repmat(Ist,[num,1]) - Ibt_nei1).^2,2);% ����ƽ��
%             u1 = sum(sqrt(dist1))/num;
%             wi1 = sum(exp(-0.5*sqrt(dist1)/(u1+eps)));           
%         else
%             wi1 = 0;
%         end
%         
%         W22= [W22;wi1];
%         
%         clear Ibt_nei1 u1 wi1 dist1 num