function [  conf,labe ] = mkltest_new3(beta, model, d, data,ntype)
n = size(data.rgb,1);
conf  = zeros(1,n);
rgb=data.rgb;
lab=data.lab;
co=data.lbp;
l=ones(n,1);
 for j = 1:size(beta,1)
      idx = beta(j,2);
        m = model(j);
        switch (floor((idx-1)/ntype))
            case 0; 
                [pred_l, acc, dec] = svmpredict(l, rgb, m);
                prob = distribution_prob( d, rgb, j );
            case 1;
                [pred_l, acc, dec] = svmpredict(l, lab, m);
                prob = distribution_prob( d, lab, j );
               
            case 2;
                if size(co,1) ~= 0                 
                    [pred_l, acc, dec] = svmpredict(l, co, m);
                    prob = distribution_prob( d, co, j );
                else break;
                end
        end
        conf = (conf' + beta(j,1) * dec.* prob)';
 end
labe=zeros(1,n);
labe(conf>0)=1;
conf(conf>0)=conf(conf>0)/max(conf)*0.4+0.6;
conf(conf<0)=-(conf(conf<0)+abs(min(conf)))/min(conf)*0.4;




