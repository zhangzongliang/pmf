function v=cuckooSearch(v)
assert(isa(v.mDataKdtree,'KDTreeSearcher'));
startTime=cputime;

evol=[];
evol.times=[];
evol.scores=[];
evol.thetas=[];
evol.iters=[];
evol.times=[evol.times;0];
evol.iters=[evol.iters;0];
evol.targetScore=v.mTrainScore;
evol.fittingMethod='cuckooSearch';
evol.timeTol=v.mTimeTol;

n=v.mPopulationSize;
pa=0.25;
Lb=v.mLb(:)';
Ub=v.mUb(:)';

v.mSigmas=v.mProposeVarianceRatio.*(v.mUb-v.mLb);
nest=zeros(n,numel(v.mTrainTheta));
for i=1:n
    nest(i,:)=Lb+(Ub-Lb).*rand(size(Lb));
    %     nest(i,:)=v.mTrainTheta';
    %     for j=1:numel(v.mTrainTheta);
    %         nest(i,j)=Modeler.localMove(v.mTrainTheta(j),v.mLb(j),v.mUb(j),v.mSigmas(j));
    %     end
end

fitness=Inf(n,1);
[fmin,bestnest,nest,fitness,v]=v.getBestNest(nest,nest,fitness);

v=v.showModel(nest(i,:),[1,0,0]);

evol.scores=[evol.scores;-fmin];
evol.thetas=[evol.thetas;bestnest];

N_iter=0;
elapsedTime=cputime-startTime;
%while N_iter<v.mIterationTol
% while N_iter<10000
while elapsedTime<v.mTimeTol
    new_nest=v.getCuckoos(nest,bestnest,Lb,Ub);
    [fnew,best,nest,fitness,v]=v.getBestNest(nest,new_nest,fitness);
    N_iter=N_iter+n;
    new_nest=v.emptyNests(nest,Lb,Ub,pa);
    [fnew,best,nest,fitness,v]=v.getBestNest(nest,new_nest,fitness);
    N_iter=N_iter+n;
    elapsedTime=cputime-startTime;
    if fnew<fmin        
        fmin=fnew;
        bestnest=best;
        v.mBestScore=-fmin;
        fprintf('iter=%d, score=%.4f\n',N_iter,-fmin);
        v.showTheta(bestnest);
        
        evol.times=[evol.times;elapsedTime];
        evol.iters=[evol.iters;N_iter];
        evol.scores=[evol.scores;-fmin];
        evol.thetas=[evol.thetas;bestnest];       
        
        v=v.showModel(bestnest,[1,0,0]);
    end

end

v.mEvol=evol;
v.mEvol.finalScore=v.mEvol.scores(end);
v.mNumEvolvedIters=N_iter;

v.mTime=cputime-startTime;
v.mBestScore=-fmin;
v.mBestTheta=bestnest;
end