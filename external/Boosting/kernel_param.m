function str = kernel_param( nsvm )
%%
str = cell(nsvm,1);
pos = 1;
str{pos} = '-t 0';
degree = 1;
coef = 3;
for i = 1:size(degree,2)
    for j = 1:size(coef,2)
        pos = pos + 1;
        s = ['-t 1 -d ' num2str(degree(i)) ' -r ' num2str(coef(j))];
        str{pos} = s;
    end
end
pos = pos + 1;
str{pos} = '-t 2';
for i = 1:size(coef,2)
    pos = pos + 1;
    s = ['-t 3 -r ' num2str(coef(i))];
    str{pos} = s;
end