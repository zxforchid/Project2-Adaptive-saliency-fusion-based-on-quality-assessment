function  edgeFeatures = mkEdgeFeatures_parallel(varargin)
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
%
% version3:
% ���а汾���ӿ��ٶ�
% written by xiaofei zhou,shanghai university,shanghai,china
% 12/22/2015 
% 
% version4:
% edge������ƫ�ƣ���ȥ��ƫ�������� ͬʱȥ����һ��
% 2016/1/4  19:28PM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% raw1 = double(raw1);
% raw2 = double(raw2);

if nargin ==2
    featureEng = varargin{1,1};
    raw1 = varargin{1,2};
    expand = featureEng.expandEdge;
    
    % �ڱߵ�������ƫ�� 2016/1/4 19:26PM
    D1 = length(getMu(raw1(:,1,1,1), raw1(:,1,1,1), expand))-1; 
    D = D1;
end

if nargin==3
    featureEng = varargin{1,1};
    raw1 = varargin{1,2};
    raw2 = varargin{1,3};
    expand = featureEng.expandEdge; 
    
    % �ڱߵ�������ƫ�� 2016/1/4 19:26PM
    D1 = length(getMu(raw1(:,1,1,1), raw1(:,1,1,1), expand))-1;
    D2 = 1;  % rgb�ռ�ŷʽ����
    D = D1 + D2;% ������ͼ��Ӧ������Ϊ�� + ��ɫͼ���Ӧ������ά��
end

  [Draw, nr, nc, ncases] = size(raw1);% d*r*c*s


[out_edge, outNbr, edgeEndsIJ, edgeEndsRC, in_edge, nedges] = ...
    assign_edge_nums_lattice(nr, nc); % �ĸ����� ��������

nedgesDir = size(edgeEndsIJ,1);
edgeFeatures = zeros(D, nedgesDir, ncases);
%--------------------------------------------------------------------------

if nargin==3
%3������
% matlabpool local 8
parfor ii=1:ncases
%    version1��Vicente Ordonez (2009)
%    for e=1:nedgesDir 
%       
%     r1 = edgeEndsRC(e,1); c1 = edgeEndsRC(e,2); r2 = edgeEndsRC(e,3); c2 = edgeEndsRC(e,4); % r1,c1 ��ʼ�� ---> r2,c2�յ�
%     mu = getMu(raw(:,r1,c1,s), raw(:,r2,c2,s), expand); %  version1:�������� |x1-x2|/sqrt(|x1-x2|.^2)    
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
%2������
parfor ii=1:ncases
    fprintf('\n edge %d | %d',ii,ncases)
    edgeFeatures(:,:,ii) = singlecase_edgefeature2(edgeEndsRC,raw1,D,nedgesDir,ii,nr,nc);
end
clear featureEng raw1

end


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% �������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function singlecase_egde = singlecase_edgefeature2(edgeEndsRC,raw1,D,nedgesDir,s,nr,nc)
singlecase_egde = zeros(D, nedgesDir);
  for e=1:nedgesDir 
    
    % r1,c1 ��ʼ�� ---> r2,c2�յ� 
    r1 = edgeEndsRC(e,1); c1 = edgeEndsRC(e,2); r2 = edgeEndsRC(e,3); c2 = edgeEndsRC(e,4); 
   
    %version2: 12/20/2015, written by xiaofei zhou.
    % saliency feature
%     mu1 = [1; abs(raw1(:,r1,c1,s) - raw1(:,r2,c2,s))];
%     mu = mu1;

%     if norm(mu) ~= 0
%        mu = mu/norm(mu);
%     end

    % version 4 2016/1/4 19:31PM 
    mu = [abs(raw1(:,r1,c1,s) - raw1(:,r2,c2,s))];
    
    % ����CRF��ʽ������ 
    singlecase_egde(:,e) = mu;
    
    clear mu
  end
  
  clear edgeEndsRC raw1
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 3������ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function singlecase_egde = singlecase_edgefeature3(edgeEndsRC,raw1,raw2,D,nedgesDir,s,nr,nc)
singlecase_egde = zeros(D, nedgesDir);
  for e=1:nedgesDir 
    
    % r1,c1 ��ʼ�� ---> r2,c2�յ� 
    r1 = edgeEndsRC(e,1); c1 = edgeEndsRC(e,2); r2 = edgeEndsRC(e,3); c2 = edgeEndsRC(e,4); 
   
    % saliency feature raw1
%     %version2: 12/20/2015, written by xiaofei zhou.
%     mu1 = [1; abs(raw1(:,r1,c1,s) - raw1(:,r2,c2,s))];

    % version4: 2016/1/4 19:31PM 
    mu1 = [abs(raw1(:,r1,c1,s) - raw1(:,r2,c2,s))];
    
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
    
    mu = [mu1;mu2];
    
    % ����CRF��ʽ������
    singlecase_egde(:,e) = mu;
    
    clear neis mn neis_color distall distu mu1 mu2
    clear mu
    
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
