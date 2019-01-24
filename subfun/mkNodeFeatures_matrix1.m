function  nodeFeatures = mkNodeFeatures_matrix1(featureEng, raw, sign)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �����������
% raw(:,r,c,s)
% NF(:,i,s) = [1, raw(:,r,c,s))] if expandNode=0
% NF(:,i,s) = [1, quadratice(raw(:,r,c,s))] if expandNode=1
% 
% version1:
% ���� LiuTie�� ��learn to detect a salient object�� 
% written by  Vicente Ordonez (2009)
% 
% version2:
% ����Liu feng�Ĺ�����saliency aggregation: a data-driven approach��
% 12/18/2015 23:03PM
%
% version3:
% ���а汾���ӿ��ٶ� mkNodeFeatures_parallel
% 12/22/2015 
%
% version4:
% ���󻯲��� mkNodeFeatures_matrix
% 2015/12/23
%
% version5:
% �������ģ��֮����ݶ� mkNodeFeatures_matrix1
% 2015/12/28
% 
% written by xiaofei zhou,shanghai university,shanghai,china
% zxforchid@163.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% raw = double(raw);
[Draw, nr, nc, ncases] = size(raw);
rawgradient = intermodel_gradient(raw,sign);
[Draw1, ~, ~, ~] = size(rawgradient);
if featureEng.expandNode
  D = length(expandFeatureVec(raw(:,1,1,1)));
else
  D = Draw+1+Draw1;
end

nodeFeatures = zeros(D, nr, nc, ncases);

% version3: �����㷨�õģ�������ֱ�Ӿ��󻯲�����
% parfor s=1:ncases
%
% %    for r=1:nr
% %     for c=1:nc
% %       if featureEng.expandNode
% %           h = expandFeatureVec(raw(:,r,c,s));
% %           nodeFeatures(:,r,c,s) = h/norm(h);
% %       else
% %          % BUG: Change made here: Vicente Ordonez (2009).
% %          % ͬversion1����һ��
% % 	     nodeFeatures(:,r,c,s) = [1, raw(:,r,c,s)'];
% %       end
% %     end
% %   end
%     fprintf('\n node %d | %d',s,ncases)
%     nodeFeatures(:,:,:,s) = singlecase_rawfeature(raw,s,nr,nc,D);
% end

% version4: ���󻯲��� 2015/12/23
biasmatrix = ones(1,nr, nc, ncases);
nodeFeatures(1,:,:,:) = biasmatrix;
nodeFeatures(2:D-Draw1,:,:,:) = raw;
nodeFeatures(D-Draw1+1:end,:,:,:) = rawgradient;

clear raw biasmatrix rawgradient

% ����
nodeFeatures = reshape(nodeFeatures, [D nr*nc ncases]); 


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rawgradient = intermodel_gradient(raw,sign)
% '1' δչ�� ��2��չ��
[Draw, nr, nc, ncases] = size(raw);

if strcmp(sign,'1')
    rawgradient = zeros(1, nr, nc, ncases);
   parfor nn=1:ncases
        tmpraw = raw(:,:,:,nn);
        
        tmpsum = 0;
        for i=1:Draw-1
            for j=i+1:Draw
                tmp1 = tmpraw(i,:,:,:);
                tmp2 = tmpraw(j,:,:,:);
                tmp3 = abs(tmp1-tmp2);
                tmpsum = tmpsum + tmp3;
%                 clear tmp1 tmp2 tmp3
            end    
        end
        
        rawgradient(:,:,:,nn) = tmpsum;
    end
else
    rawgradient = zeros(Draw, nr, nc, ncases);
    parfor nn=1:ncases
        tmpraw = raw(:,:,:,nn);   
        
        for i=1:Draw % 1
            tmpsum = 0; 
            
            for j=[1:i-1,i+1:Draw] % 2,3,4,...,M
                tmp1 = tmpraw(i,:,:,:);
                tmp2 = tmpraw(j,:,:,:);
                tmp3 = abs(tmp1-tmp2);
                tmpsum = tmpsum + tmp3;
%                 clear tmp1 tmp2 tmp3
            end      
            rawgradient(i,:,:,nn) = tmpsum;
            
        end 
     end
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rawgradient = intermodel_gradient1(raw)
% ����ģ��֮����ݶȲ�����Ϊ���ֵ
% raw feature*m*n*case
% 2015/12/28
% xiaofei zhou
[Draw, nr, nc, ncases] = size(raw);
rawgradient = zeros(1, nr, nc, ncases);
for nn=1:ncases
    tmpraw = raw(:,:,:,nn);
    tmpsum = 0;
    for i=1:Draw-1
        for j=i+1:Draw
            tmp1 = tmpraw(i,:,:,:);
            tmp2 = tmpraw(j,:,:,:);
            tmp3 = abs(tmp1-tmp2);
            tmpsum = tmpsum + tmp3;
            clear tmp1 tmp2 tmp3
        end    
    end
    rawgradient(:,:,:,nn) = tmpsum;
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rawgradient = intermodel_gradient2(raw)
% ����ģ��֮����ݶȲ�����Ϊ���ֵ
% raw feature*m*n*case
% 2015/12/28
% xiaofei zhou
[Draw, nr, nc, ncases] = size(raw);
rawgradient = zeros(Draw, nr, nc, ncases);
for nn=1:ncases
    tmpraw = raw(:,:,:,nn);   
    
    for i=1:Draw % 1
        tmpsum = 0;
        
        for j=[1:i-1,i+1:Draw] % 2,3,4,...,M
            tmp1 = tmpraw(i,:,:,:);
            tmp2 = tmpraw(j,:,:,:);
            tmp3 = abs(tmp1-tmp2);
            tmpsum = tmpsum + tmp3;
            clear tmp1 tmp2 tmp3
        end
        
        rawgradient(i,:,:,nn) = tmpsum;
    end
    
end
end

