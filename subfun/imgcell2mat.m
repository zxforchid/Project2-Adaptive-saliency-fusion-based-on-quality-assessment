function imgmat = imgcell2mat(imgcell) 
% 将impart划分的patch块转换为每块的值
% 2015/12/28
% xiaofei zhou
[m,n,r] = size(imgcell);
imgmat = zeros(m,n);
for i=1:m
    for j=1:n
         imgmat(i,j) = mean(mean(imgcell{i,j}));
    end
end

clear imgcell

end