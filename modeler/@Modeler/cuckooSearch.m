function v=cuckooSearch(v)
start=cputime;
v.mTempModel=v.mTrainModel.copy();
n=v.mPopulationSize;
pa=0.25;
Lb=v.mLb';
Ub=v.mUb';

v.mSigmas=v.mProposeVarianceRatio.*(v.mUb-v.mLb);
nest=zeros(n,numel(v.mTrainTheta));
for i=1:n
    %nest(i,:)=Lb+(Ub-Lb).*rand(size(Lb));
    nest(i,:)=v.mTrainTheta';
    for j=1:numel(v.mTrainTheta)
        nest(i,j)=Modeler.localMove(v.mTrainTheta(j),v.mLb(j),v.mUb(j),v.mSigmas(j));
    end
end

fitness=10^10*ones(n,1);
[fmin,bestnest,nest,fitness]=v.getBestNest(nest,nest,fitness);

N_iter=0;
while N_iter<v.mIterationTol
    new_nest=v.getCuckoos(nest,bestnest,Lb,Ub);
    [fnew,best,nest,fitness]=v.getBestNest(nest,new_nest,fitness);
    N_iter=N_iter+n;
    new_nest=v.emptyNests(nest,Lb,Ub,pa) ;
    [fnew,best,nest,fitness]=v.getBestNest(nest,new_nest,fitness);
    N_iter=N_iter+n;
    if fnew<fmin
        fmin=fnew;
        bestnest=best;
        
        v.thetaToModel(bestnest',v.mTempModel);
        v.mBestModel=v.mTempModel.copy();
        fittedImage=v.mBestModel.pimg;
        subplot(1,3,3);imshow(fittedImage);title({'bestModel',['score=',...
            num2str(-fmin)],['iter=',num2str(N_iter)]});
        drawnow;
    end
end

v.mTime=cputime-start;
v.mBestScore=-fmin;
v.thetaToModel(bestnest',v.mTempModel);
v.mBestModel=v.mTempModel.copy();

end