function [fmin,best,nest,fitness,v]=getBestNest(v,nest,newnest,fitness)
for j=1:size(nest,1)
    if v.mEarlyRejection
        level=0;
    else
        level=-1;
    end
    v=v.generate(newnest(j,:)');
    v.mResource.mTopSamplingLevelAllReached=false;
    while ~v.mResource.mTopSamplingLevelAllReached
        v.mResource.mTopSamplingLevelAllReached=true;
        v.mResource.mCurrSamplingLevel=level;
        [~,v]=v.estimate();
        fnew=-v.mScore;
        accepted=(fnew<=fitness(j));
        if ~accepted
            break;
        end
        level=level+v.mEarlyRejectStep;
    end
    v.mResource.mCurrSamplingLevel=-1;    
    
    if accepted
        fitness(j)=fnew;
        nest(j,:)=newnest(j,:);
    end   
end
[fmin,K]=min(fitness);
best=nest(K,:);
end