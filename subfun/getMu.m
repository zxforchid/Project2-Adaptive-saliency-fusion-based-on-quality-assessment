function mu = getMu( vec1, vec2, expand)

% function getMu( vec1, vec2)
%
% This function takes in the NON-expanded form of two feature vectors and
% returns the mu vector, where:
%
% mu(1) = 1  - need for the offset
% mu(2:length(vec1)+1) =abs( vec1X-vec2X)
% the X denotes expanded form
%
% mu is a column vector
%

if nargin < 3, expand = 1; end
if expand
  v1 = expandFeatureVec(vec1); % note this has a lead "1"
  v2 = expandFeatureVec(vec2); % also has leanding "1"
else
  v1 = [1;vec1];
  v2 = [1;vec2];
end

mu=abs(v1-v2);

if norm(mu) ~= 0
    mu = mu/norm(mu);
end

%reset the leading "1"
mu(1)=1;

end




