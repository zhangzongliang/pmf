function v=parseArgs(v,args)
if isfield(args,'srcFolder')
    v.srcFolder=args.srcFolder;
else
    v.srcFolder=pwd;
end

restoredefaultpath;
addpath(genpath(v.srcFolder));

if isfield(args,'widget')
    v.widget=args.widget;
else
    v.window=figure;
    %v.widget=axes(v.window);
    v.widget=newplot(v.window);
end

if isfield(args,'translate')
    v.translate=args.translate;
end

if isfield(args,'data')
    v=v.setData(args.data);
end


if isfield(args,'lambda')
    v.mLambda=args.lambda;
else
    v.mLambda=2.0;
end

if isfield(args,'timeTol')
    v.mTimeTol=args.timeTol;
else
    v.mTimeTol=600; % seconds
end

if isfield(args,'populationSize')
    v.mPopulationSize=args.populationSize;
else
    v.mPopulationSize=10;
    %v.mPopulationSize=25;
end

if isfield(args,'fittingMethod')
    v.mFittingMethod=args.fittingMethod;
else
    v.mFittingMethod='cuckooSearch';
end

if isfield(args,'earlyRejection')
    v.mEarlyRejection=args.earlyRejection;
else
    v.mEarlyRejection=true;
end

if isfield(args,'simType')
    v.simType=args.simType;
else
    v.simType='WMM';
end

if isfield(args,'resolution')
    v.mResource.mResolution=args.resolution;
elseif numel(v.mResource.mDataCloud)>0
    res=resolution(v.mResource.mDataCloud);
    v.mResource.mResolution=res*0.3;
else
    assert(false);
end

if isfield(args,'model')
    addpath(genpath([v.srcFolder,'/models']));
    rmpath(genpath([v.srcFolder,'/models']));
    addpath(genpath([v.srcFolder,'/models/',args.model]));
    [v.mTrainTheta,v.mLb,v.mUb,v.mThetaDescription]=...
        StartRule.prior();
    %v.forwardSampling();
    if isfield(args,'targetTheta')
        v.mTrainTheta=args.targetTheta;
    end 
    
    if isfield(args,'mLb')
        v.mLb=args.mLb;
    end
    
    if isfield(args,'mUb')
        v.mUb=args.mUb;
    end
    
    assert(all(v.mTrainTheta>=v.mLb));
    assert(all(v.mTrainTheta<=v.mUb));
    
    if isa(v.mDataKdtree,'KDTreeSearcher')
        [~,v]=v.estimate(v.mTrainTheta);
        fprintf('iter=0, defaultScore=%.4f\n',v.mScore);
        v.showTheta(v.mTrainTheta);              
        v.mTrainScore=v.mScore;
        v=v.showModel(v.mTrainTheta,[1,0,0]);
    else        
        v=v.showModel(v.mTrainTheta,[1,0,0]);
    end
else
    assert(false);
end