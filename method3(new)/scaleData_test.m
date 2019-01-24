function [test_scale] = scaleData_test(test_data,ymin,ymax, MIN, MAX)
% 归一化质量特征 测试
% test_data  样本数 * 特征维数, 
% 这里要注意测试时， 我们是一个彩色图像对应多幅显著性图， 
% xiaofei zhou
% 2016/1/17 9:21AM
% 
test_scale = scale_data(test_data,MIN,MAX,ymin,ymax);

clear train_data
end
function data = scale_data(data,MIN,MAX,ymin,ymax)
N = size(data,1);
data = data-MIN(ones(N,1),:);
data = data./(MAX(ones(N,1),:)-MIN(ones(N,1),:));
data = data*(ymax-ymin)-ymin;
end