function [out_edge, outNbr, edgeEndsIJ, edgeEndsRC, in_edge, nedges] = ...
    assign_edge_nums_superpixel_lattice(nrows, ncols, adjcMatrix)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 基于超像素的版本
% written by xiaofei zhou,shanghai university, shanghai, china
% 2016/1/8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [out_edge, outNbr, edgeEndsIJ, edgeEndsRC, in_edge, nedges] = ...
%     assign_edge_nums_lattice(nrows, ncols)

%   To assign edge numbers:
%   we loop through the nodes in COLUMN major (Matlab-style) order
%       At each node, we then assign in the order: 
%           Left(West), Above(North), Below(Souht), Right(East)
%
%   This ordering is done to be compatible with
%   StarEdge_MakeEdgeNums_Lattice2.m
%   (orders edges by increasing fromNode, then increasing toNode)
%
% out_edge(r,c,dir) = number of edge going OUT of rc in direction dir
% outNbr(r,c,dir,:) = [r' c'] if we follow an edge in direction dir from rc we land in r'c'
% edgeEndsIJ(e,:) = [i j] means we follow e from i to j
% edgeEndsRC(e,:) = [r1 c2 r2 c2] means we follow e from r1c1 to r2c2
% in_edge(r,c,dir)
%
% Example: consider a 2x2 lattice
%
%    3     7
% N1 ->   <- N3
% |5         |6
% v          v
%
% ^          ^
% |1         |2
% N2->    <- N4
%   4      8
%
% so edges 1:2 are the northbound, 3:4 the eastbound, etc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% assign each edge in each direction a unique number
north = 1; east = 2; south = 3; west = 4; % matches BP_C_edgeDir/private/*.c
%north = 2; east = 1; south = 4; west = 3;
ndir = 4; % num directions to send msgs in
out_edge = zeros(nrows, ncols, ndir);
in_edge = zeros(nrows, ncols, ndir);
outNbr = zeros(nrows, ncols, ndir, 2);
nedgesUndir = nrows*(ncols-1) + ncols*(nrows-1);
nedgesDir = nedgesUndir*2;
edgeEndsRC = zeros(nedgesDir, 4);
edgeEndsIJ = zeros(nedgesDir, 2);
e = 1;
for c = 1:ncols
    for r = 1:nrows
        
        % left
        if legal(r,c-1,nrows,ncols)
            out_edge(r,c,west) = e;
            in_edge(r,c-1,east) = e;
            outNbr(r,c,west,:) = [r c-1];
            edgeEndsRC(e,:) = [r c r c-1];
            e = e+1;
        end
        
        % above
        if legal(r-1,c,nrows,ncols)
            out_edge(r,c,north) = e;
            in_edge(r-1,c,south) = e;
            outNbr(r,c,north,:) = [r-1 c];
            edgeEndsRC(e,:) = [r c r-1 c];
            e = e+1;
        end

        % below
        if legal(r+1,c,nrows,ncols)
            out_edge(r,c,south) = e;
            in_edge(r+1,c,north) = e;
            outNbr(r,c,south,:) = [r+1 c];
            edgeEndsRC(e,:) = [r c r+1 c];
            e = e+1;
        end
        
        % right
        if legal(r,c+1,nrows,ncols)
            out_edge(r,c,east) = e;
            in_edge(r,c+1,west) = e;
            outNbr(r,c,east,:) = [r c+1];
            edgeEndsRC(e,:) = [r c r c+1];
            e = e+1;
        end

    end
end
nedges = e-1;

edgeEndsIJ(:,1) = subv2ind([nrows ncols], edgeEndsRC(:,1:2));% 输出以列为单位的位置标号
edgeEndsIJ(:,2) = subv2ind([nrows ncols], edgeEndsRC(:,3:4));
end

function [bool] = legal(i,j,nrows,ncols)
if i >= 1 && j >= 1 && i <= nrows && j <=ncols
    bool = 1;
else
    bool = 0;
end
end