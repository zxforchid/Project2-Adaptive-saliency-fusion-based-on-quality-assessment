function  edgeFeatures = mkEdgeFeatures_parallel1(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 计算边的特征
% raw(:,r,c,s)
% EF(:,e,s) = [1, |raw(:,r,c) - raw(:,r',c')| ] if expandEdge = 0
% EF(:,e,s) = [1, Quadratic(|raw(:,r,c) - raw(:,r',c')|) ] if expandEdge = 1
% 
% version1:
% 仿真 LiuTie的 《learn to detect a salient object》 
% written by  Vicente Ordonez (2009)
% 
% version2:
% 仿真Liu feng的工作《saliency aggregation: a data-driven approach》
% 考虑8邻域，即3*3的周围邻域，这点与原先的4邻域不同（这里先采用4邻域）
% 特征函数构造不同
% raw1 对应salmap feature; raw2对应colorimg feature
% 
% written by xiaofei zhou,shanghai university,shanghai,china
% 12/18/2015 23:03PM
%
% version3:
% 并行版本，加快速度
% written by xiaofei zhou,shanghai university,shanghai,china
% 12/22/2015 
%
%  version4:
% 并行，加入inter-model的考虑
% written by xiaofei zhou,shanghai university,shanghai,china
% 12/23/2015 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% raw1 = double(raw1);
% raw2 = double(raw2);

if nargin ==2
    featureEng = varargin{1,1};
    raw1 = varargin{1,2};
    expand = featureEng.expandEdge;
    D1 = length(getMu(raw1(:,1,1,1), raw1(:,1,1,1), expand));
    D3 = size(raw1,1);
    D = D1 + D3;
end

if nargin==3
    featureEng = varargin{1,1};
    raw1 = varargin{1,2};
    raw2 = varargin{1,3};
    expand = featureEng.expandEdge;
    D1 = length(getMu(raw1(:,1,1,1), raw1(:,1,1,1), expand));
    D2 = 1;  % rgb空间欧式距离
    D3 = size(raw1,1);
    D = D1 + D2 + D3;% 显著性图对应的特征为数 + 彩色图像对应的特征维数
end

  [Draw, nr, nc, ncases] = size(raw1);% d*r*c*s


[out_edge, outNbr, edgeEndsIJ, edgeEndsRC, in_edge, nedges] = ...
    assign_edge_nums_lattice(nr, nc); % 四个方向 左右上下

nedgesDir = size(edgeEndsIJ,1);
edgeFeatures = zeros(D, nedgesDir, ncases);
%--------------------------------------------------------------------------

if nargin==3
%3个输入
% matlabpool local 8
parfor ii=1:ncases
%    version1：Vicente Ordonez (2009)
%    for e=1:nedgesDir 
%       
%     r1 = edgeEndsRC(e,1); c1 = edgeEndsRC(e,2); r2 = edgeEndsRC(e,3); c2 = edgeEndsRC(e,4); % r1,c1 起始点 ---> r2,c2终点
%     mu = getMu(raw(:,r1,c1,s), raw(:,r2,c2,s), expand); %  version1:特征向量 |x1-x2|/sqrt(|x1-x2|.^2)    
%     edgeFeatures(:,e,s) = mu;
%     
%   end
 
    % version2:
    fprintf('\n edge %d | %d',ii,ncases)
    edgeFeatures(:,:,ii) = singlecase_edgefeature3(edgeEndsRC,raw1,raw2,D,nedgesDir,ii,nr,nc);
end

% matlabpool close

clear featureEng raw1 raw2

else
%2个输入
parfor ii=1:ncases
    fprintf('\n edge %d | %d',ii,ncases)
    edgeFeatures(:,:,ii) = singlecase_edgefeature2(edgeEndsRC,raw1,D,nedgesDir,ii,nr,nc);
end
clear featureEng raw1

end


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 两个输入 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function singlecase_egde = singlecase_edgefeature2(edgeEndsRC,raw1,D,nedgesDir,s,nr,nc)
singlecase_egde = zeros(D, nedgesDir);
  for e=1:nedgesDir 
    
    % r1,c1 起始点 ---> r2,c2终点 
    r1 = edgeEndsRC(e,1); c1 = edgeEndsRC(e,2); r2 = edgeEndsRC(e,3); c2 = edgeEndsRC(e,4); 
   
    %version2: 12/20/2015, written by xiaofei zhou.
    % saliency feature
    mu1 = [1; abs(raw1(:,r1,c1,s) - raw1(:,r2,c2,s))];
    mu = mu1;

    if norm(mu) ~= 0
       mu = mu/norm(mu);
    end
    clear neis mn neis_color dist u 
    
    % 赋给CRF格式边特征
    singlecase_egde(:,e) = mu;
  end
  
  clear edgeEndsRC raw1
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 3个输入 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function singlecase_egde = singlecase_edgefeature3(edgeEndsRC,raw1,raw2,D,nedgesDir,s,nr,nc)
singlecase_egde = zeros(D, nedgesDir);
  for e=1:nedgesDir 
    
    % r1,c1 起始点 ---> r2,c2终点 
    r1 = edgeEndsRC(e,1); c1 = edgeEndsRC(e,2); r2 = edgeEndsRC(e,3); c2 = edgeEndsRC(e,4); 
   
    %version2: 12/20/2015, written by xiaofei zhou.
    % saliency feature raw1
    mu1 = [1; abs(raw1(:,r1,c1,s) - raw1(:,r2,c2,s))];
%     if norm(mu1) ~= 0
%        mu1 = mu1/norm(mu1);
%     end
    
    % color feature raw2
    neis = find4neibors(r1,c1,nr,nc);
    [mn,~] = size(neis);
    neis_color = zeros(size(raw2,1),mn);
    for nn=1:mn
        nei_rc = neis(nn,:);
        neis_color(:,nn) = raw2(:,nei_rc(1),nei_rc(2),s); 
    end
    distall = (repmat(raw2(:,r1,c1,s),[1,mn]) - neis_color).^2;
    distu = sum(sum(distall))/(mn+eps);
    
    dist = sum(sum((raw2(:,r1,c1,s)- raw2(:,r2,c2,s)).^2));
    mu2 = exp(-0.5*dist/(distu+eps)); % exp(-0.5*d/(u+eps))
    
    % inter-model
    mi = raw1(:,r1,c1,s);
    mj = raw1(:,r2,c2,s);
    nms = size(mi,1);
    mu3 = zeros(nms,1);
    for ms=1:nms
        delta_inter = repmat(mi(ms),[nms-1,1]) - [mj(1:ms-1);mj(ms+1:end)];
        mu3(ms) = sum(delta_inter);
    end
    
    
    % 合成
    mu = [mu1;mu3;mu2];
    if norm(mu) ~= 0
       mu = mu/norm(mu);
    end    
     
    % 
    clear neis mn neis_color distall distu mu1 mu2
    
    % 赋给CRF格式边特征
    singlecase_egde(:,e) = mu;
  end
  
  clear edgeEndsRC raw1 raw2
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function neis = find4neibors(r,c,nr,nc)
neis = [];
% left
if legal(r,c-1,nr,nc)
    neis = [neis;r,c-1;];
end

% above
if legal(r-1,c,nr,nc)
    neis = [neis;r-1,c;];
end

% down
if legal(r+1,c,nr,nc)
    neis = [neis;r+1,c;];
end

% right
if legal(r,c+1,nr,nc)
    neis = [neis;r,c+1;];
end


end

function [bool] = legal(i,j,nrows,ncols)
if i >= 1 && j >= 1 && i <= nrows && j <=ncols
    bool = 1;
else
    bool = 0;
end
end
