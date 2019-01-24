function  nodeFeatures = mkNodeFeatures_matrix(featureEng, raw)
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
% written by xiaofei zhou,shanghai university,shanghai,china
% 12/18/2015 23:03PM
%
% version3:
% ���а汾���ӿ��ٶ� mkNodeFeatures_parallel
% written by xiaofei zhou,shanghai university,shanghai,china
% 12/22/2015 
%
% version4:
% ���󻯲��� mkNodeFeatures_matrix
% 2015/12/23
% written by xiaofei zhou,shanghai university,shanghai,china
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% raw = double(raw);
[Draw, nr, nc, ncases] = size(raw);
if featureEng.expandNode
  D = length(expandFeatureVec(raw(:,1,1,1)));
else
  D = Draw+1;
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

% version4: ���󻯲��� 2015/12/23 liufeng��fezature
biasmatrix = ones(1,nr, nc, ncases);
nodeFeatures(1,:,:,:) = biasmatrix;
nodeFeatures(2:end,:,:,:) = raw;
clear raw biasmatrix

% ����
nodeFeatures = reshape(nodeFeatures, [D nr*nc ncases]); 


end



