function [score,v]=estimate(varargin)
%varargin: v, theta
if nargin==1
    v=varargin{1};
    assert(numel(v.mResource.mTerminals)>0);
elseif nargin==2
    v=varargin{1};
    theta=varargin{2};
    v=v.generate(theta);
else
    assert(false);
end

v=v.render();
[~,dists]=knnsearch(v.mDataKdtree,v.mResource.mCloud);

switch v.simType
    case 'WMM'
        sumDists=sum(dists);
        sumWeights=size(v.mResource.mCloud,1);
        assert(sumWeights>0);
        emd=sumDists/sumWeights;
    case 'MM'
        emd=max(dists);
    otherwise
        assert(false);
end

score=v.mResource.measure/(emd^v.mLambda+v.mEpsilon);
v.mScore=score;
end
