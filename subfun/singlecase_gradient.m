function [esingle,gsingle] = singlecase_gradient( data, casenum, weights, infEng )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 用于scrfGradient的并行化
% written by xiaofei zhou,shanghai university, shanghai, china
% 2015/12/24
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  featureEng = latticeFeatures(0,0);
  featureEng = enterEvidence(featureEng, data, casenum);
  [nodePot, edgePot] = mkPotentials(featureEng, weights);
  [nodeBel, ~, ~, edgeBel, logZ] = infer(infEng, nodePot, edgePot);

  clear nodePot edgePot MAPlabels niter data
  
  ONF = mkObsNodeFeatures(featureEng);
  ENF = mkExpectedNodeFeatures(featureEng,nodeBel);
  OEF = mkObsEdgeFeatures(featureEng);
  EEF = mkExpectedEdgeFeatures(featureEng,edgeBel);
  
  [~,nnodes] = size(ONF);
  [~,nedges] = size(OEF);
  % lik = exp(w^T f)/Z
  % loglik = w^T f - logZ = <obs, weights> - logZ
  [NW, EW] = splitWeights(featureEng, weights);
  
%   eI = zeros(1,nnodes);
%   for i=1:nnodes
%     eI(i) = sum(ONF(:,i) .* NW);
%   end
  eI = sum(ONF.*repmat(NW,[1,nnodes]));
  
%   eE = zeros(1,nedges);
%   for e=1:nedges
%     eE(e) = sum(OEF(:,e) .* EW)/2; % Correct for double counting
%   end

  eE = sum(OEF.*repmat(EW,[1,nedges]));
  
  esingle = (sum([eI(:).' eE(:).']) - logZ);
  
  % gradientNode(d) = sum_i obs(d,i) - expected(d,i) 
  gradientNode = sum(ONF - ENF, 2);
  gradientEdge = sum(OEF - EEF, 2)/2;
  
  gsingle = [gradientNode; gradientEdge];
  
  clear ONF ENF OEF EEF logZ edgeBel gradientNode gradientEdge eI eE
  
  clear featureEng  casenum weights infEng
end
