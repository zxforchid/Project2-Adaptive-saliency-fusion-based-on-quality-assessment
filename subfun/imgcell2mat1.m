function imgmat = imgcell2mat1(imgcell) 
% 将impart划分的patch块转换为每块的值
% 用于处理彩色图像
% 2015/12/28
% xiaofei zhou
[~,nc] = size(imgcell);
[m,n] = size(imgcell{1,1});
imgmat = zeros(m,n,nc);
for k=1:nc
    tmp = (imgcell{1,k})';
    
    for i=1:m
       for j=1:n            
            tmp1 = tmp{i,j};
            imgmat(i,j,k) = mean(mean(tmp1));
        end
    end
    clear tmp
end

clear imgcell

end