function [ gcmap, fiimg ] = graphcut0( A,g,prior)
N=size(prior,1)*size(prior,2);
prior= max(prior, abs(imfilter(prior, g, 'symmetric')));
prior=normalize_sal(prior); 
T=sparse(N,2);
T(:,1)=reshape(prior,[N,1]);
T(:,2)=1-reshape(prior,[N,1]);
% disp('calculating maximum flow');
[height,width]=size(prior);
[flow,labels] = maxflow(A,T);
labels = reshape(labels,[height width]);
gcmap=1-reshape(labels,height,width);% ¸÷µãÖ½±êÇ© 1 0
  fiimg=normalize_sal(prior+double(gcmap)); 
  side=[gcmap(1:end,1)',gcmap(1:end,end)',gcmap(1,1:end),gcmap(end,1:end)];
   if mean(side)>0.2 || mean(prior(:))>0.8
       fiimg=prior;
   end
   
end


