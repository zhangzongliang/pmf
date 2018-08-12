classdef Modeler
    properties (Access=public)
        mIterationTol=10000;
        mPopulationSize=10;
        mEarlyRejection=true;
        mDividingBase=10;
        mControl=15;
        mDataImage;
        mDataKdtree;
        mIteration=0;
        mTimeTol=7200;
        mBestModel;
        mBestTheta;
        mBestScore=-1;
        mLb;
        mUb;
        mSigmas;
        mThetas;
        mScores;
        mTrainModel;
        mTrainTheta;
        mTrainScore;
        mTempModel;
        mInverseTemperatures;
        mAcceptProbs;
        mTemperatureExponent=1.3;
        mProposeVarianceRatio=0.05;
        mLocalMoveProbability=0.5;
        mLambda=2.0;
        mDividingLevel=-1;
        mModelCloud;
        mMeasure=0;
        mSumDists=0;
        mSumWeights=0;
        mTopLevelReached=false;
        mScore=0;
        mTime=0;
        mMaxLocalShift=20;%pixel
        mSpecificParam;
        mMaxGlobalScale=1.5;
        mMaxLocalScale=1.5;
        mThetaDescription;
        mMaxGlobalRotation=pi/4;% 45 degree
        mMaxLocalRotation=pi/12;% 15 degree
        mMaxGlobalShift=50;
        mMaxInk=6;
        mFittingMethod='cuckooSearch';
        mVariables;
        mResource;
        mRule;
        mEpsilon=1e-8; % should be very small. In practice, can just be zero
        mEvol;
        mStartTime=0;
    end
    
    methods %(Access=public)
        
        
        function v=Modeler(args)
            %v.mResource=Rule.mResource;
            v.mResource=Resource();
            if  nargin > 0
                v.mLambda=args.lambda;
                v.mIterationTol=args.iterationTol;
                v.mMaxInk=args.maxInk;
                v.mMaxGlobalShift=args.maxGlobalShift;
                v.mMaxLocalShift=args.maxLocalShift;
                v.mMaxGlobalScale=args.maxGlobalScale;
                v.mMaxLocalScale=args.maxLocalScale;
                v.mMaxGlobalRotation=pi/(180/args.maxGlobalRotation);
                v.mMaxLocalRotation=pi/(180/args.maxLocalRotation);
                v.mControl=args.control;
                
            end
        end
        
        obj=modelToTheta(obj,M,list_sid);
        obj=thetaToModel(obj,theta,M,list_sid);
        obj=cuckooSearch(obj);
        obj=computeScoreAtLevel(obj,level);
        obj=metropolis(obj,index);
        obj=setModel(obj,train);
        
        
        function v=setData(v,test)
            assert(isa(test,'logical'));
            v.mDataImage=test;
            test=imresize(v.mDataImage,0.5);
            [x,y]=ind2sub(size(test),find(test==1));
            v.mResource.mDataCloud=[x,y];
            v.mDataKdtree=KDTreeSearcher(v.mResource.mDataCloud);
        end
        
        function obj=forwardSampling(obj,folder)
            obj.mPopulationSize=16;
            obj=obj.initializeModelingRandomly();
            figure;
            for i=1:obj.mPopulationSize
                obj.thetaToModel(obj.mThetas{i},obj.mTempModel);
                img=obj.mTempModel.pimg;
                %figure;imshow(img);
                %imwrite(img,[folder,'/',num2str(i),'.png']);
                subplot(4,4,i);imshow(img);
            end
            %subplot(2,2,4);imshow(obj.mTempModel.pimg);            
        end
        
        
        function v=fitting(v)
            assert(numel(v.mVariables)>0);
            v.mIterationTol=v.mIterationTol*numel(v.mVariables);
            if strcmp(v.mFittingMethod,'cuckooSearch')
                v=v.cuckooSearch();
            else
                assert(false);
            end
        end

        
        function score=computeScore(v,theta)
            v.thetaToModel(theta,v.mTempModel);
            v.mModelCloud=v.imageTo2DCloud(v.mTempModel.pimg);
            v.mMeasure=size(v.mModelCloud,1);
            [~,dists]=knnsearch(v.mDataKdtree,v.mModelCloud);
            v.mSumWeights=v.mMeasure;
            v.mTopLevelReached=true;
            v.mSumDists=v.mSumDists+sum(dists);
            emd=v.mSumDists/v.mSumWeights;
            v.mScore=v.mMeasure/(emd^v.mLambda+v.mEpsilon);
            score=v.mScore;
        end
        
        
        function [fmin,best,nest,fitness]=getBestNest(obj,nest,newnest,fitness)
            for j=1:size(nest,1)
                fnew=-obj.computeScore(newnest(j,:)');
                if fnew<=fitness(j)
                    fitness(j)=fnew;
                    nest(j,:)=newnest(j,:);
                end
            end
            [fmin,K]=min(fitness) ;
            best=nest(K,:);
        end
        
    end
    
    
    methods(Static)
        T=runTesting(iRun,numTests,models,iTestClass,iTest,testFolder,argsModeler,verbose);
        
        function child=localMove(parent,mLb,mUb,sigma)
            child=randn*sigma+parent;
            child=Modeler.circleBound(child,mLb,mUb);
        end
        
        function child=globalMove(mLb,mUb)
            child=mLb+(mUb-mLb).*rand;
        end
        
        function s=circleBoundVector(s,Lb,Ub)
            for i=1:numel(s);
                s(i)=Modeler.circleBound(s(i),Lb(i),Ub(i));
            end
        end
        
        function r=circleBound(ret,mLowerBound,mUpperBound)
            mLength=mUpperBound-mLowerBound;
            if ret<mLowerBound
                length=mLowerBound-ret;
                count=floor(length/mLength);
                rest=length-count*mLength;
                r=mUpperBound-rest;
            elseif ret>mUpperBound
                length=ret-mUpperBound;
                count=floor(length/mLength);
                rest=length-count*mLength;
                r=mLowerBound+rest;
            else
                r=ret;
            end
        end
        
        
        function cloud=imageTo2DCloud(pimg)
            ind=find(pimg>0.5);
            if numel(ind)>0
                [x,y]=ind2sub(size(pimg),ind);
                cloud=[x,y];
                cloud=cloud/2+0.25;
            else
                cloud=[-1,-1]/2+0.25;
            end
            
        end
        
        function matCloud=imageTo3DCloud(pimg)
            %figure;imshow(pimg);
            if isa(pimg,'double')
                ind=find(pimg>0.5);
            elseif isa(pimg,'logical')
                ind=find(pimg==1);
            else assert(false);
            end
            
            if numel(ind)<1
                assert(false);
            end
            
            [x,y]=ind2sub(size(pimg),ind);
            cloud=[x,y];
            cloud=cloud/2+0.25;
            z=zeros(size(y));
            matCloud=pointCloud([cloud,z]);
            %pcwrite(matCloud,'model.ply','PLYFormat','ascii');
        end
        
        function nest=getCuckoos(nest,best,Lb,Ub)
            n=size(nest,1);
            beta=3/2;
            sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
            for j=1:n
                s=nest(j,:);
                u=randn(size(s))*sigma;
                v=randn(size(s));
                step=u./abs(v).^(1/beta);
                stepsize=0.01*step.*(s-best);
                s=s+stepsize.*randn(size(s));
                nest(j,:)=Modeler.simpleBounds(s,Lb,Ub);
            end
        end
        
        
        function new_nest=emptyNests(nest,Lb,Ub,pa)
            n=size(nest,1);
            K=rand(size(nest))>pa;
            stepsize=rand*(nest(randperm(n),:)-nest(randperm(n),:));
            new_nest=nest+stepsize.*K;
            for j=1:size(new_nest,1)
                s=new_nest(j,:);
                new_nest(j,:)=Modeler.simpleBounds(s,Lb,Ub);
            end
        end
        
        
        function s=simpleBounds(s,Lb,Ub)
            ns_tmp=s;
            I=ns_tmp<Lb;
            ns_tmp(I)=Lb(I);
            J=ns_tmp>Ub;
            ns_tmp(J)=Ub(J);
            s=ns_tmp;
        end
        
        
        function I=addGrossOutliers(I,n)
            assert(isa(I,'logical'));
            ind=find(I==1);
            [mx,my]=size(I);
            for i=1:n*numel(ind);
                x=randi(mx);
                y=randi(my);
                I(x,y)=true;
            end
        end
        
        function rotation=get2DRotateMatrix(angle,pivot)
            ca=cos(angle);
            sa=sin(angle);
            rotation=[ca, -sa, (1.0-ca).*pivot(1)+pivot(2).*sa;...
                sa, ca, (1.0-ca).*pivot(2)-pivot(1).*sa];
        end
        
        function cloud=grossOutlier(cloud,num,sd)
            assert(num>0);
            rng(sd);
            [m,n]=size(cloud);
            numOutliers=m*num;
            outliers=zeros(numOutliers,n);
            for i=1:n
                %minI=min(cloud(:,i))-beyond;
                %maxI=max(cloud(:,i))+beyond;
                minI=min(cloud(:,i));
                maxI=max(cloud(:,i));
                %beyond=0.5*(maxI-minI);
                beyond=0.5*(maxI-minI);
                minI=minI-beyond;
                maxI=maxI+beyond;
                outliers(:,i)=minI+(maxI-minI).*rand(numOutliers,1);
            end
            cloud=[cloud;outliers];
            rng('shuffle');
        end
        
        function cloud=gaussianNoise(cloud,dev,sd)
            assert(dev>0);
            rng(sd);
            noi=randn(size(cloud));
            cloud=cloud+dev*noi;           
            rng('shuffle');
        end

    end
    
end