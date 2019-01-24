function result = scalefordata_crf_test(X, mu, sigma)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 专门为CRF服务的特征归一化函数 测试
% 归一化结点与边特征
% 采用z-score方法
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


% mu = mean(X);
X_norm = bsxfun(@minus, X1, mu);
clear mu

% sigma = std(X_norm);
X2 = bsxfun(@rdivide, X_norm, sigma);
X2(:,1) = 1;
clear X1 X_norm sigma

for i=1:ncases
    tmp = X2((i-1)*mn+1:i*mn,:);
    result(:,:,i) = tmp'; 
    clear tmp
end

clear X2
end