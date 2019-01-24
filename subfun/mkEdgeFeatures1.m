function  edgeFeatures = mkEdgeFeatures1(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����ߵ�����
% raw(:,r,c,s)
% EF(:,e,s) = [1, |raw(:,r,c) - raw(:,r',c')| ] if expandEdge = 0
% EF(:,e,s) = [1, Quadratic(|raw(:,r,c) - raw(:,r',c')|) ] if expandEdge = 1
% 
% version1:
% ���� LiuTie�� ��learn to detect a salient object�� 
% written by  Vicente Ordonez (2009)
% 
% version2:
% ����Liu feng�Ĺ�����saliency aggregation: a data-driven approach��
% ����8���򣬼�3*3����Χ���������ԭ�ȵ�4����ͬ�������Ȳ���4����
% �����������첻ͬ
% raw1 ��Ӧsalmap feature; raw2��Ӧcolorimg feature
% 
% written by xiaofei zhou,shanghai university,shanghai,china
% 12/18/2015 23:03PM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% raw1 = double(raw1);
% raw2 = double(raw2);

if nargin ==2
    featureEng = varargin{1,1};
    raw1 = varargin{1,2};
    expand = featureEng.expandEdge;
    D1 = length(getMu(raw1(:,1,1,1), raw1(:,1,1,1), expand));
    D = D1;
end

if nargin==3
    featureEng = varargin{1,1};
    raw1 = varargin{1,2};
    raw2 = varargin{1,3};
    expand = featureEng.expandEdge;
    D1 = length(getMu(raw1(:,1,1,1), raw1(:,1,1,1), expand));
    D2 = 1;  % rgb�ռ�ŷʽ����
    D = D1 + D2;% ������ͼ��Ӧ������Ϊ�� + ��ɫͼ���Ӧ������ά��
end

  [Draw, nr, nc, ncases] = size(raw1);% d*r*c*s


% if nr1==nr && nc1==nc && ncases1==ncases
    



[out_edge, outNbr, edgeEndsIJ, edgeEndsRC, in_edge, nedges] = ...
    assign_edge_nums_lattice(nr, nc); % �ĸ����� ��������

nedgesDir = size(edgeEndsIJ,1);
edgeFeatures = zeros(D, nedgesDir, ncases);
for s=1:ncases
    fprintf('\n case %d | %d',s,ncases)
  for e=1:nedgesDir 
    
    % r1,c1 ��ʼ�� ---> r2,c2�յ� 
    r1 = edgeEndsRC(e,1); c1 = edgeEndsRC(e,2); r2 = edgeEndsRC(e,3); c2 = edgeEndsRC(e,4); 
% version1:   
%     % version1:�������� |x1-x2|/sqrt(|x1-x2|.^2)
%     mu = getMu(raw(:,r1,c1,s), raw(:,r2,c2,s), expand); 
   
    %version2: 12/20/2015, written by xiaofei zhou.
    % saliency feature
    mu1 = [1; abs(raw1(:,r1,c1,s) - raw1(:,r2,c2,s))];
%     mu1 = getMu(raw1(:,r1,c1,s), raw1(:,r2,c2,s), expand); 
    
    if nargin==3
    % color feature
    neis = find4neibors(r1,c1,nr,nc);
    [mn,~] = size(neis);
    neis_color = [];
    for nn=1:mn
        nei_rc = neis(nn,:);
        neis_color = [neis_color,raw2(:,nei_rc(1),nei_rc(2),s)]; 
    end
    dist = sum((repmat(raw2(:,r1,c1,s),[1,mn]) - neis_color).^2,2);% ����ƽ�� 4�������
    u = sum(dist)/4;
    mu2 = exp(-0.5*norm(raw2(:,r1,c1,s)- raw2(:,r2,c2,s)))/(u+eps); % exp(-0.5*d/(u+eps))
    mu = [mu1;mu2];
    
    else
        mu = mu1;
    end
    
    
    if norm(mu) ~= 0
       mu = mu/norm(mu);
    end
    clear neis mn neis_color dist u 
    
    % ����CRF��ʽ������
    edgeFeatures(:,e,s) = mu;
    
  end
end

% else
%     error(message('color is not the same with sal!'));
% end

clear featureEng raw1 raw2
end

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
