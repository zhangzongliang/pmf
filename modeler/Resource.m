classdef Resource < handle
    
    properties
		mCloud;
        mResolution=0.1; % divding resolution
        mTopSamplingLevelAllReached=true;
        mCurrSamplingLevel=-1;
        mDataCloud=[];
        mDataCenter;
        mTranslation=[0,0,0];
        mModel=[];
        mTheta=[];
        mNodes;
        mTerminals;          
        vertexes=[];
        sampled=[];
        measure=0;
        faces={};
        colors=[];
    end
    
    methods
        function v=Resource()
            assert(v.mResolution>0);
        end
        function v=clear(v)
            v.faces={};
            v.measure=0;
            v.mCloud=[];
            v.vertexes=[];
            v.colors=[];
        end
    end
    
end