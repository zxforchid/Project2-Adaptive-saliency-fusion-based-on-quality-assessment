function [train_scale,MIN,MAX] = scaleData_train(train_data,ymin,ymax)
% 归一化质量特征
% train_data  样本数 * 特征维数
% xiaofei zhou
% 2016/1/17 9:21AM
% 
[MIN,MAX] = deal(min(train_data),max(train_data));
train_scale = scale_data(train_data,MIN,MAX,ymin,ymax);

clear train_data
end
function data = scale_data(data,MIN,MAX,ymin,ymax)
N = size(data,1);
data = data-MIN(ones(N,1),:);
data = data./(MAX(ones(N,1),:)-MIN(ones(N,1),:));
data = data*(ymax-ymin)-ymin;
end