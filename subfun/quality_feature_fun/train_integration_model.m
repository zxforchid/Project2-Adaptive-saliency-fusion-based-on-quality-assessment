function model = train_integration_model( traindata,trainlabel )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% version1:
% 利用质量评价训练评价模型,这里利用logistic regression 模型进行训练
% version2:
% 用SVM进行训练测试
% 
% INPUT:
% traindata  强弱显著图对应的特征矩阵
% trainlabel 对应的标签数据 1,0
% Logistic regression模型
% 
% OUTPUT:
% model      训练出的评价模型
% REFERENCE: <comparing salienct object detection results without ground truth>
% copyright by xiaofei zhou,shanghai university,shanghai,china
% CURRENT version: 07/30/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m,n] = size(traindata);% 样本数目M  特征维数N
Iteration = 400;
lambda = 1;

% Add intercept term to traindata
X = [ones(m, 1) traindata];
y = trainlabel;

clear traindata trainlabel

% Initialize fitting parameters
initial_theta = zeros(n + 1, 1);

%  Set options for fminunc
options = optimset('GradObj', 'on', 'MaxIter', Iteration);

%  Run fminunc to obtain the optimal theta
[theta, cost] = ...
	fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);

% % Optimize regulariztion
% [theta, costJ, exit_flag] = ...
% 	fminunc(@(t)(costFunctionReg(t, X, y, lambda)), initial_theta, options);

% Compute accuracy on our training set
p = predict(theta, X);

accuracy = mean(double(p == y)) * 100;

% output
model.theta = theta;
model.acc = accuracy;
model.lambda = lambda;
model.iternum = Iteration;

% end
clear X y
end

