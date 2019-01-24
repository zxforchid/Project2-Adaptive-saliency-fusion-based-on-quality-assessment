function [result,mu,sigma] = scalefordata_crf_train(X)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ר��ΪCRF�����������һ������ ѵ��
% ��һ������������
% ����z-score����
% xiaofei zhou
% 2015/12/28
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[D,mn,ncases] = size(X);
X1 = zeros(mn*ncases,D);
result = zeros(D,mn,ncases);
for i=1:ncases
    tmp = X(:,:,i);
    tmp = tmp';
    X1((i-1)*mn+1:i*mn,:) = tmp;
    clear tmp
end
clear X

% z-score
mu = mean(X1);
X_norm = bsxfun(@minus, X1, mu);

sigma = std(X_norm);
X2 = bsxfun(@rdivide, X_norm, sigma);
X2(:,1) = 1;
clear X1 X_norm 

for i=1:ncases
    tmp = X2((i-1)*mn+1:i*mn,:);
    result(:,:,i) = tmp'; 
    clear tmp
end

clear X2 
end