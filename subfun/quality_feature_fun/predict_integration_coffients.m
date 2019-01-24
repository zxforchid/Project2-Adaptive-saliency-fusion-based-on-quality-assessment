function [predict_labels,accuracy,decvalue] = predict_integration_coffients(model,testdata,testlabel)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% version1:
% ����ǰ��ѵ���õ���ģ��model,�����������������Ԥ��
% Input:
% testdata testlabel �ֱ��������������������ݼ���Ӧ��������ǩ
% model ������ǰ��ѵ���õ���ģ��
% 
% Output:
% predict_labels����Ԥ���ǩ
% accuracy ��ʾ׼ȷ��
% decvalue logistic�����ֵ��δ�����о�����sgn��
% 
% Current version: 07/13/2015 
% Copyright by xiaofei zhou,shanghai university,shanghai,china
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m,n] = size(testdata);

% model.theta = theta;
% model.acc = accuracy;
% model.lambda = lambda;
% model.iternum = Iteration;

% Add intercept term to traindata
X = [ones(m, 1) testdata];
y = testlabel;

clear testdata testlabel

theta = model.theta;
decvalue = sigmoid(X * theta);% m*(n+1) X (n+1)*1

predict_labels = predict(theta, X);

accuracy = mean(double(predict_labels == y)) * 100;

clear model X y

end