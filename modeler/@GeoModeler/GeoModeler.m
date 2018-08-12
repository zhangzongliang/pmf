classdef GeoModeler < Modeler
    % Geometric modeler
    properties (Access=public)
        mNumEvols=5;
        mEvols;
        mIEvol;
        mSynthetic=true;
        mEarlyRejectStep=4;
        mNumEvolvedIters=0;
        widget;
        simType='WMM';
        similarity;
        srcFolder;
        window;
        translate=false;
    end
    
    methods
        v=cuckooSearch(v);
        [fmin,best,nest,fitness,v]=getBestNest(v,nest,newnest,fitness);
        v=generate(v,theta);
        v=parseArgs(v,args);
        v=setData(v,cloud);
        v=showModel(v,theta,color);
        [score,v]=estimate(varargin);
        
        function v=GeoModeler(args)
            
            if  nargin > 0
                v=v.parseArgs(args);
            end            

        end
                               
        function cloud=getSyntheticData(v,imperfection,intensity,resolution)
            v.mResource.mResolution=resolution;
            v=v.renderModel(v.mTrainTheta);
            if strcmp(imperfection,'perfect')
                cloud=v.mResource.mCloud;
            elseif strcmp(imperfection,'gross')
                cloud=v.grossOutlier(v.mResource.mCloud,intensity,0);
            else
                assert(false);
            end
        end        
        
        function v=render(v)
            v.mResource=v.mResource.clear();
            for i=1:numel(v.mResource.mTerminals)
                v.mResource.mTerminals{i}=v.mResource.mTerminals{i}.render();
                if v.mResource.mTerminals{i}.topSamplingLevelAllReached==false
                    v.mResource.mTopSamplingLevelAllReached=false;
                end
            end            
        end
        
        function v=renderModel(v,theta)
            assert(numel(theta)==numel(v.mTrainTheta));
            assert(all(theta>=v.mLb));
            assert(all(theta<=v.mUb));
            v=v.generate(theta);
            v=v.render();
        end
                
        function showTheta(v,theta)
            names=v.mThetaDescription;
            assert(numel(theta)==numel(names));
            fprintf('theta=[');
            for i=1:numel(theta)
                fprintf('%.4f ',theta(i));
                if mod(i,5)==0
                    fprintf('...\n  ');
                end
            end
            fprintf(']\n');
            for i=1:numel(theta)
                fprintf('%s=%.4f  [%.2f %.2f]\n',names{i},theta(i),v.mLb(i),v.mUb(i));
            end
            fprintf('\n');
        end        
        
    end
    
end




















