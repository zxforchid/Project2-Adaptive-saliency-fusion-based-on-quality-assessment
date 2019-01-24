function FB = boundary_quality(saliencymap,image)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% version1: 07/08/2015
% scale ����ͼ������ţ�����edges-master�еĲ���
% computer boundary_quality feature
% version2: 09/15/2015  21:33PM
% ��ȥ�߽����ص� ���FB��ֵ
% input:
% saliencymap ����ͼ
% image       ��ɫͼ��
% output:
% result      �������FB  4ά��
% reference paper:
% <comparing salient object detection results without ground truth>
% written by xiaofei zhou,shanghai university,shanghai,china
% current version: 09/15/2015 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initial 
SCALES = [0.25,0.5,0.75,1.0];
[mt,nt] = size(SCALES);
num_fb = mt*nt;
FB = zeros(1,num_fb);

%% compute saliency boundary map(�����Ż����Գ����þ������)
for ii=1:num_fb
    % ��߶�֮���߶�
scale = SCALES(ii);
temp_sal = imresize(saliencymap,scale);
temp_sal = normalize(temp_sal);
[ms,ns] = size(temp_sal);

temp_img = imresize(image,scale);
% temp_img = normalize(temp_img);

%% compute EI edge map
model=edgesDetect_model(scale);
EI = edgesDetect(temp_img,model);
clear model

%% compute BM  boundary map
BM = zeros(ms-2,ns-2);
wps = zeros(ms-2,ns-2);
for i=2:ms-1
    for j=2:ns-1       
        mp = temp_sal(i,j);% p��
        mp12 = 0;maxdiff = 0;wp = 0;
        
        % compute edge neighbor ���Ե�ߴ�ֱ p1p2
        % �����Ե��ǿ��
        temp = zeros(4,1);
        temp(1,1) = abs(EI(i,j-1)-EI(i,j+1));       
        temp(2,1) = abs(EI(i-1,j-1)-EI(i+1,j+1));
        temp(3,1) = abs(EI(i-1,j)-EI(i+1,j));
        temp(4,1) = abs(EI(i-1,j+1)-EI(i+1,j-1));
        
        % find the edge direction and P1 P2
        % ȷ����Ե�߷��� ����ȷ��P1 P2��λ��
        [~,maxindex] = max(temp);
        maxindex = maxindex(end);
        switch maxindex
            case 1
                mp1 = temp_sal(i,j-1);
                mp2 = temp_sal(i,j+1);
                
            case 2
                mp1 = temp_sal(i-1,j-1);
                mp2 = temp_sal(i+1,j+1);
                
            case 3
                mp1 = temp_sal(i-1,j);
                mp2 = temp_sal(i+1,j);
                
            case 4
                mp1 = temp_sal(i-1,j+1);
                mp2 = temp_sal(i+1,j-1);
        end
        % ��Ӧ�� |M(p1) - M(p2)|
        mp12 = abs(mp1-mp2);
        
        % ��Ӧ�� max(|M(p) - M(p)|,|M(p) - M(p2)|)
        maxdiff = max([abs(mp-mp1),abs(mp-mp2)]);
        
        % ��Ӧ��Wp
        wp = mp*maxdiff;     
        
        % ��Ӧ��BM(P)
        BM(i-1,j-1) = wp*mp12;        
        
        % �ռ�wp ���ڹ�һ��
        wps(i-1,j-1) = wp;
        
    end
end
% ��Ӧ�ڹ�ʽ 7
sumwps = sum(sum(wps));
BM = BM/max(sumwps,eps);

% % ���߽� �������
% BM(2:ms-1,1) = BM(2:ms-1,3);
% BM(2:ms-1,ns) = BM(2:ms-1,ns-2);
% BM(1,:) = BM(3,:);
% BM(ms,:) = BM(ms-2,:);

% ȥ�� EI�ı߽�� ʹ֮��BM��ͬ�ߴ�
EI1 = EI(2:ms-1,2:ns-1);
EI1 = normalize(EI1);

%% compute fb feature
FB(ii) = sum(sum(BM.*EI1));


%% clear 
clear BM EI EI1
end

end

