%�����ĸ���־��󣬲��ҵ�����ȡһ����־������ȡ���� 2011-10-17
function F_diff=extract_diff_CF(dct_diff_plane,M1,M2,T)
F_diff=extractCooccurencesFromColumns(ExtractCoocColumns(dct_diff_plane,[M1;M2]),T);

function F = extractCooccurencesFromColumns(blocks,t) %ת�Ƹ��ʾ�����һ��n*2�ľ���ÿһ��Ϊ������
% blocks = columns of values from which we want to extract the
% cooccurences. marginalize to [-t..t]. no normalization involved

blocks(blocks<-t) = -t; % marginalization
blocks(blocks>t) = t;   % marginalization

% pre-allocate output cooccurence features
F = zeros(2*t+1,2*t+1);
for i=-t:t
    fB = blocks(blocks(:,1)==i,2);
    if ~isempty(fB)
        for j=-t:t
            F(i+t+1,j+t+1) = sum(fB==j);
        end
    end
end

function columns = ExtractCoocColumns(A,target)
% Take the target DCT modes and extracts their corresponding n-tuples from
% the DCT plane A. Store them as individual columns.
mask = getMask(target);%����mode��������ȡmask
v = floor(size(A,1)/8)+1-(size(mask,1)/8); % number of vertical block shifts
h = floor(size(A,2)/8)+1-(size(mask,2)/8); % number of horizontal block shifts

for i=1:size(target,1)
    C = A(target(i,1)+(1:8:8*v)-1,target(i,2)+(1:8:8*h)-1);%ȡ����mode�ĵ㣬ˮƽ�ƶ��봹ֱ�ƶ������Կ�Ϊ��λ
    if ~exist('columns','var'),columns = zeros(numel(C),size(target,1)); end %����һ��������ģʽ����Ϣ
    columns(:,i) = C(:);%����������ÿһ����modeʽ�е�һ����
end

function mask = getMask(target)
% transform list of DCT modes of interest into a mask with all zeros and
% ones at the positions of those DCT modes of interest
x=8;y=8;
if sum(target(:,1)>8)>0 && sum(target(:,1)>16)==0, x=16; end
if sum(target(:,1)>16)>0 && sum(target(:,1)>24)==0, x=24; end
if sum(target(:,1)>24)>0 && sum(target(:,1)>32)==0, x=32; end
if sum(target(:,2)>8)>0 && sum(target(:,2)>16)==0, y=16; end
if sum(target(:,2)>16)>0 && sum(target(:,2)>24)==0, y=24; end
if sum(target(:,2)>24)>0 && sum(target(:,2)>32)==0, y=32; end

mask = zeros(x,y);
for i=1:size(target,1)
    mask(target(i,1),target(i,2)) = 1;
end

function [diff_Fh,diff_Fv,diff_Fd,diff_Fm]=CopmuteDiffmatrix(path) %�����ĸ���־�������ΪdctPlane
jobj=jpeg_read(path);
Plane=jobj.coef_arrays{1};
absDctPlane=abs(Plane);

diff_Fh=absDctPlane(:,1:end-1) - absDctPlane(:,2:end);
diff_Fv=absDctPlane(1:end-1,:) - absDctPlane(2:end,:);
diff_Fd=absDctPlane(1:end-1,1:end-1) - absDctPlane(2:end,2:end);
diff_Fm=absDctPlane(2:end,1:end-1) - absDctPlane(1:end-1,2:end);

