function [err, grad, J] = scrfGradient_parallel(weights, ndx, featureEng, infEng, data, lambda)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% version1:
% Input
% weights - interpreted by featureEng
% featureEngine
% inferenceEngine
% data - interpreted by featureEng
% ndx - specifies which set of data to use (for mini-batch training)
% lambda - quadratic regularizer on weights
%
% Output
% err = *negative* log likelihood
% grad(i) = sum_{s in ndx} J(s,i)
% J(s,i) = gradient(i,s) = d err(s) / dw(i)
%
% version2:
% 并行版本，加快速度(比较耗内存)
% written by xiaofei zhou,shanghai university, shanghai, china
% 2015/12/23  19:53PM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nstates = featureEng.nstates;
NcasesTotal = data.ncases;
NcasesBatch = length(ndx); 
Nfeatures = length(weights);
gradient = zeros(Nfeatures, NcasesBatch);
es = zeros(1,NcasesBatch);
% matlabpool local 4
parfor s=1:NcasesBatch
%     disp(s)
  casenum = ndx(s);
%   featureEng1 = enterEvidence(featureEng, data, casenum);
%   [nodePot, edgePot] = mkPotentials(featureEng1, weights);
% %   [nodeBel, MAPlabels, niter, edgeBel, logZ(s)] = infer(infEng, nodePot, edgePot);
%   [nodeBel, MAPlabels, niter, edgeBel, logZ] = infer(infEng, nodePot, edgePot);
%   
%   ONF = mkObsNodeFeatures(featureEng1);
%   ENF = mkExpectedNodeFeatures(featureEng1,nodeBel);
%   OEF = mkObsEdgeFeatures(featureEng1);
%   EEF = mkExpectedEdgeFeatures(featureEng1,edgeBel);
%   
%   [Dnode,nnodes] = size(ONF);
%   [Dedge,nedges] = size(OEF);
%   % lik = exp(w^T f)/Z
%   % loglik = w^T f - logZ = <obs, weights> - logZ
%   [NW,EW] = splitWeights(featureEng1, weights);
%   
% %   eI = zeros(1,nnodes);
% %   for i=1:nnodes
% %     eI(i) = sum(ONF(:,i) .* NW);
% %   end
%   eI = sum(ONF.*repmat(NW,[1,nnodes]));
%   
% %   eE = zeros(1,nedges);
% %   for e=1:nedges
% %     eE(e) = sum(OEF(:,e) .* EW)/2; % Correct for double counting
% %   end
%   eE = sum(OEF.*repmat(EW,[1,nedges]))/2;
%   
% %   es(s) = (sum([eI(:).' eE(:).']) - logZ(s));
%   es(s) = (sum([eI(:).' eE(:).']) - logZ);
%   
%   % gradientNode(d) = sum_i obs(d,i) - expected(d,i) 
%   gradientNode = sum(ONF - ENF, 2);
%   gradientEdge = sum(OEF - EEF, 2)/2;
% 
%   gradient(:,s) = [gradientNode; gradientEdge];

  [es(s),gradient(:,s)] = singlecase_gradient(data,casenum, weights, infEng );
  
  
end
J = gradient.';

% compute final values + regularizer
% err = -log-likelihood + lambda*(batch_size/train_set_size)*sum(w(i)^2)
% grad = 
%   -(obs_features-expected_features) - 2*lambda*(batch_size/train_set_size*w(i)

err = -sum(es) + ((lambda/2)*sum(weights.^2))*NcasesBatch/NcasesTotal;
grad = -sum(gradient,2) + (lambda*weights)*NcasesBatch/NcasesTotal;

clear featureEng data
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [esingle,gsingle] = singlecase_gradient( data,casenum, weights, infEng )
%   featureEng = latticeFeatures(0,0);
%   featureEng = enterEvidence(featureEng, data, casenum);
%   [nodePot, edgePot] = mkPotentials(featureEng, weights);
%   [nodeBel, MAPlabels, niter, edgeBel, logZ(s)] = infer(infEng, nodePot, edgePot);
% 
%   clear nodePot edgePot MAPlabels niter data
%   
%   ONF = mkObsNodeFeatures(featureEng);
%   ENF = mkExpectedNodeFeatures(featureEng,nodeBel);
%   OEF = mkObsEdgeFeatures(featureEng);
%   EEF = mkExpectedEdgeFeatures(featureEng,edgeBel);
%   
%   [Dnode,nnodes] = size(ONF);
%   [Dedge,nedges] = size(OEF);
%   % lik = exp(w^T f)/Z
%   % loglik = w^T f - logZ = <obs, weights> - logZ
%   [NW, EW] = splitWeights(featureEng, weights);
%   
% %   eI = zeros(1,nnodes);
% %   for i=1:nnodes
% %     eI(i) = sum(ONF(:,i) .* NW);
% %   end
%   eI = sum(ONF.*repmat(NW,[1,nnodes]));
%   
% %   eE = zeros(1,nedges);
% %   for e=1:nedges
% %     eE(e) = sum(OEF(:,e) .* EW)/2; % Correct for double counting
% %   end
% 
%   eE = sum(OEF.*repmat(EW,[1,nedges]));
%   
%   esingle = (sum([eI(:).' eE(:).']) - logZ(s));
%   
%   % gradientNode(d) = sum_i obs(d,i) - expected(d,i) 
%   gradientNode = sum(ONF - ENF, 2);
%   gradientEdge = sum(OEF - EEF, 2)/2;
%   
%   gsingle = [gradientNode; gradientEdge];
%   
%   clear ONF ENF OEF EEF logZ edgeBel gradientNode gradientEdge eI eE
%   
%   clear featureEng  casenum weights infEng
% end
