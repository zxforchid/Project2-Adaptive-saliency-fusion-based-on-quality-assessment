function [err, grad, J] = scrfGradient_LIU(weights, ndx, featureEng, infEng, data, lambda)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% version1:
% 仿真liufeng的工作， 并行化， 权重对应于颜色特征是1
%２０１６/１/１　１９：５２ＰＭ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nstates = featureEng.nstates;
NcasesTotal = data.ncases;
NcasesBatch = length(ndx);

% 此处weight少一维（颜色）
Nfeatures = length(weights);
gradient = zeros(Nfeatures, NcasesBatch);
es = zeros(1,NcasesBatch);
% matlabpool local 4
parfor s=1:NcasesBatch   
  casenum = ndx(s);
%   featureEng = enterEvidence(featureEng, data, casenum);
%   [nodePot, edgePot] = mkPotentials(featureEng, weights);
%   [nodeBel, MAPlabels, niter, edgeBel, logZ] = infer(infEng, nodePot, edgePot);
% 
%   ONF = mkObsNodeFeatures(featureEng);
%   ENF = mkExpectedNodeFeatures(featureEng,nodeBel);
%   OEF = mkObsEdgeFeatures(featureEng);
%   EEF = mkExpectedEdgeFeatures(featureEng,edgeBel);
%   
%   [Dnode,nnodes] = size(ONF);
%   [Dedge,nedges] = size(OEF);
%   
%   % lik = exp(w^T f)/Z
%   % loglik = w^T f - logZ = <obs, weights> - logZ
%   [NW, EW] = splitWeights(featureEng, weights);
%   eI = sum(ONF.*repmat(NW,[1,nnodes]));
%   eE = sum(OEF.*repmat(EW,[1,nedges]))/2;  
%   es(s) = (sum([eI(:).' eE(:).']) - logZ);
%   
%   % gradientNode(d) = sum_i obs(d,i) - expected(d,i) 
%   gradientNode = sum(ONF - ENF, 2);
%   gradientEdge = sum(OEF - EEF, 2)/2;
%   gradient(:,s) = [gradientNode; gradientEdge];
[es(s),gradient(:,s)] = singlecase_gradient_liu(data,casenum, weights, infEng );

end
% matlabpool close

J = gradient.';

% compute final values + regularizer
% err = -log-likelihood + lambda*(batch_size/train_set_size)*sum(w(i)^2)
% grad = 
%   -(obs_features-expected_features) - 2*lambda*(batch_size/train_set_size*w(i)

err = -sum(es) + ((lambda/2)*sum(weights.^2))*NcasesBatch/NcasesTotal;
grad = -sum(gradient,2) + (lambda*weights)*NcasesBatch/NcasesTotal;

end
