function [ beta, model, tmodel ] = boost_mkl3( data, label, nfeature, datanum,ntype )

n_svm = nfeature * ntype;
tmodel = []; 
tlabel = cell(n_svm,1);
tdec = cell(n_svm,1); 
tbeta = []; model = []; beta = []; tt = [];
d1 = data.rgb; d2 = data.lab; d3 = data.lbp;
l1 = label.rgb; l2 = label.lab; l3 = label.lbp;
pos = 0;

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
    end
end

iter = 10;
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

