function [ beta, model, tmodel ] = Boost_MKL( data, label, nfeature, datanum,ntype )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MKB 多核多特征学习
% Input:
% data      训练集数据， 结构体， 每个由 样本数 * 特征维数 的矩阵表示
% label     训练样本的标签 样本数 * 1
% nfeature  特征种类数  10类
% datanum   每种特征对应的样本数
% ntype     核的种类数  4个核
% 
% output:
% beta     误差项或者叫错误率项
% model    被选中的特征与核生成的分类器模型
% tmodel   所有特征与核结合生成的分类器模型
% 
% xiaofei zhou, IVP Lab, shanghai university, shanghai, china
% 2016/1/17 9:32AM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initial
n_svm = nfeature * ntype;
tmodel = []; tbeta = []; model = []; beta = []; tt = [];
tlabel = cell(n_svm,1);
tdec = cell(n_svm,1); 

d1 = data.FC; d2 = data.FCP; d3 = data.FH; d4 = data.FCS; d5 = data.FNC;d6 = data.FB;
d7 = data.DMSV; d8 = data.SPE; d9 = data.SV;d10 = data.IC;
l1 = label; l2 = label; l3 = label; l4 = label; l5 = label;l6 = label;
l7 = label;l8 = label;l9 = label;l10 = label;

pos = 0;
%% 生成所有的分类器
str = kernel_param( ntype );
for i = 1:nfeature
    d = eval(['d' num2str(i)]);
    l = eval(['l' num2str(i)]);
    for j = 1:ntype
        pos = pos + 1;
        s = str{j};
        m = svmtrain(l, d, s);
        [pred_l, acc, dec_v] = svmpredict(l, d, m);
        tmodel = [tmodel; m];
        tlabel{pos} = pred_l'; 
        tdec{pos} = dec_v';
        clear pred_l dec_v m acc
    end
    
    clear d l
end
clear d1 d2 d3 d4 d5 d6 d7 d8 d9 d10

%% 组合
% iter = 10;
iter = n_svm-2;
D = cell(nfeature,1);
for j = 1:nfeature
    D{j} = ones(datanum(j),1) / datanum(j);
end
for t = 1:iter
    for j = 1:n_svm
        if sum(j==tt) ~= 0 
            tbeta = [tbeta; -inf];
            continue; 
        end
        fi = floor((j-1)/ntype)+1;
        l = eval(['l' num2str(fi)]);
        if ~isempty(tdec{j})
            y_dec = D{fi} .* abs(tdec{j}');  
        else
            y_dec = D{fi};
        end
        b = 0.5 * log(sum(y_dec(tlabel{j}'==l))/(sum(y_dec(tlabel{j}'~=l))+eps));
        tbeta = [tbeta; b];
    end
    [var, idx] = max(tbeta);
    idx1 = find(tbeta == var);
    idx = idx1(end);
    if var<0 break; end
    beta = [beta; var];
    model = [model; tmodel(idx)];
    tt = [tt; idx];
    fi = floor((idx-1)/ntype)+1;
    l = eval(['l' num2str(fi)]);
    if ~isempty(tdec{idx})
        D{fi} = D{fi} .* exp(-var * tdec{idx}' .* l);
    else
        D{fi} = D{fi} .* exp(-var .* l);
    end
    D{fi} = D{fi} / sum(D{fi});
    tbeta = [];
    t = t + 1;
end
beta = [beta tt];

clear data label nfeature datanum ntype
end
