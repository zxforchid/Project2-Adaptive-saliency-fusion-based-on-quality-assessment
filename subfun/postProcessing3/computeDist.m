function [node1, node2, Dist] = computeDist(E, h, w)
% E 等于边数目*2 

node1h = mod(E(:,1),h);
node1w = 1 + ((E(:,1) - node1h)/h);
node1 = [node1h,node1w];
clear node1h node1w

node2h = mod(E(:,2),h);
node2w = 1 + ((E(:,2) - node2h)/h);
node2 = [node2h,node2w];
clear node2h node2w

Dist = sum(((node1 - node2).^2),2);

clear E h w
end