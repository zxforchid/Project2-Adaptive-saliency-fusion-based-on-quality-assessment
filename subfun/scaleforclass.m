function [train_scale,test_scale] = scaleforclass(train_data,test_data,ymin,ymax)
% scaleForSVM 
% by faruto Email:farutoliyang@gmail.com
% 2009.10.28

[train_data,pstrain] = mapminmax(train_data');
pstrain.ymin = ymin;
pstrain.ymax = ymax;
[train_data,pstrain] = mapminmax(train_data,pstrain);

[test_data,pstest] = mapminmax(test_data');
pstest.ymin = ymin;
pstest.ymax = ymax;
[test_data,pstest] = mapminmax(test_data,pstest);

train_scale = train_data';
test_scale = test_data';

% function [train_scale,test_scale] = scaleforclass(train_data,test_data,ymin,ymax)
% % correct scaling for SVM | Jan Kodovsky | 2011-10-12
% 
% [MIN,MAX] = deal(min(train_data),max(train_data));
% 
% train_scale = scale_data(train_data,MIN,MAX,ymin,ymax);
% test_scale  = scale_data(test_data,MIN,MAX,ymin,ymax);
% end
% 
% function data = scale_data(data,MIN,MAX,ymin,ymax)
% N = size(data,1);
% data = data-MIN(ones(N,1),:);
% data = data./(MAX(ones(N,1),:)-MIN(ones(N,1),:));
% data = data*(ymax-ymin)-ymin;
% end