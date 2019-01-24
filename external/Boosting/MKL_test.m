function [  conf,labe ] = MKL_test(beta, model, d, data,ntype)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MKB ��˶�����ѧϰ
% Input:
% data     ѵ�������ݣ� �ṹ�壬 ÿ���� ������ * ����ά�� �ľ����ʾ
% beta     �������߽д�������
% model    ��ѡ�е�����������ɵķ�����ģ��
% ntype    �˵�������  3����
% 
% output:
% conf     ����ֵ
% labe     Ԥ���ǩ
%
% note: �������ǽ�����ֵ���� logistic�У� �õ��������
% 
% xiaofei zhou, IVP Lab, shanghai university, shanghai, china
% 2016/1/17 9:32AM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = size(data.FC,1);
conf  = zeros(1,n);

FC = data.FC; FCP = data.FCP; FH = data.FH; FCS = data.FCS; FNC = data.FNC;
FB = data.FB; DMSV = data.DMSV; SPE = data.SPE; SV = data.SV;IC = data.IC;

l=ones(n,1);
 for j = 1:size(beta,1)
      idx = beta(j,2);
        m = model(j);
        switch (floor((idx-1)/ntype))
            case 0; 
                [pred_l, acc, dec] = svmpredict(l, FC, m);
                prob = distribution_prob( d, FC, j );
            case 1;
                [pred_l, acc, dec] = svmpredict(l, FCP, m);
                prob = distribution_prob( d, FCP, j );
               
            case 2;             
                [pred_l, acc, dec] = svmpredict(l, FH, m);
                 prob = distribution_prob( d, FH, j );
                 
            case 3; 
                [pred_l, acc, dec] = svmpredict(l, FCS, m);
                prob = distribution_prob( d, FCS, j );
                
            case 4;
                [pred_l, acc, dec] = svmpredict(l, FNC, m);
                prob = distribution_prob( d, FNC, j );
               
            case 5;             
                [pred_l, acc, dec] = svmpredict(l, FB, m);
                 prob = distribution_prob( d, FB, j );
                 
            case 6;             
                [pred_l, acc, dec] = svmpredict(l, DMSV, m);
                 prob = distribution_prob( d, DMSV, j );
                 
            case 7; 
                [pred_l, acc, dec] = svmpredict(l, SPE, m);
                prob = distribution_prob( d, SPE, j );
                
            case 8;
                [pred_l, acc, dec] = svmpredict(l, SV, m);
                prob = distribution_prob( d, SV, j );
               
            case 9;             
                [pred_l, acc, dec] = svmpredict(l, IC, m);
                 prob = distribution_prob( d, IC, j );    
                 
        end
        % logistic �ع����
        decLogistic = dec;
%         decLogistic = 1./(1+exp(-0.5*dec));
%         conf = (conf' + beta(j,1) * dec.* prob)';
        conf = (conf' + beta(j,1) * decLogistic.* prob)';
 end
labe=zeros(1,n);
% labe(conf>0)=1;
% conf(conf>0)=conf(conf>0)/max(conf)*0.4+0.6;
% conf(conf<0)=-(conf(conf<0)+abs(min(conf)))/min(conf)*0.4;

end




