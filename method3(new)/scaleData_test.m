function [test_scale] = scaleData_test(test_data,ymin,ymax, MIN, MAX)
% ��һ���������� ����
% test_data  ������ * ����ά��, 
% ����Ҫע�����ʱ�� ������һ����ɫͼ���Ӧ���������ͼ�� 
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