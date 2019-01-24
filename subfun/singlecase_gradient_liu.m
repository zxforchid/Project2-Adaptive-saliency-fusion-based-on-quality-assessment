function [esingle,gsingle] = singlecase_gradient_liu( data, casenum, weights, infEng )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 用于scrfGradient的并行化
% written by xiaofei zhou,shanghai university, shanghai, china
% 2015/12/24
% 
% version2:
% 仿真liufeng的工作， 并行化， 权重对应于颜色特征是1
%２０１６/１/１　１９：５２ＰＭ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  featureEng = latticeFeatures(0,0);
  featureEng = enterEvidence(featureEng, data, casenum);
  
  % 颜色特征权重为1
   weights1 = [weights;1]; % 为颜色特征补上权重1
%   weights1=[weights(1:end-1);1];
  
  [nodePot, edgePot] = mkPotentials(featureEng, weights1);
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
  [NW, EW] = splitWeights(featureEng, weights1);
  
  eI = sum(ONF.*repmat(NW,[1,nnodes]));
  eE = sum(OEF.*repmat(EW,[1,nedges]));
  esingle = (sum([eI(:).' eE(:).']) - logZ);
  
  % gradientNode(d) = sum_i obs(d,i) - expected(d,i) 
  gradientNode = sum(ONF - ENF, 2);
  gradientEdge = sum(OEF - EEF, 2)/2;
  
  % 去掉颜色的1维,令其对应梯度值为0
%   gradientEdge1 = [gradientEdge(1:end-1,:);0];
%   gsingle = [gradientNode; gradientEdge1];
  gradientEdge1 = gradientEdge(1:end-1);
  gsingle = [gradientNode; gradientEdge1];
  
%   gsingle = [gradientNode; gradientEdge];
  
  clear ONF ENF OEF EEF logZ edgeBel 
  clear gradientNode gradientEdge eI eE gradientEdge1
  clear featureEng  casenum weights infEng
end
