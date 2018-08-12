classdef CylinderRule < CGARule
    
    properties (Access=public)
        mX=0; % location x
        mY=0; % location y
        mZ=0; % location z
        mR=1; % radius
        mS=0; % start (relative)
        mL=2*pi; % length (relative)
        mH=1; % height
        mMeasure=2*pi;
    end
    
    methods
        
        function v=CylinderRule(resource,scope)
            v=v@CGARule(resource,scope);
            v.mIsTerminal=true;
            v=v.setParameters(resource.mTheta);
        end
                
        function v=setParameters(v,params)
            assert(numel(params)==7);
            v.mX=params(1);
            v.mY=params(2);
            v.mZ=params(3);
            v.mR=params(4);
            v.mS=params(5);
            v.mL=params(6);            
            v.mH=params(7);
            v.mMeasure=v.mL*v.mR*v.mH;
            v=v.computeTopDividingLevel();
        end
        
        function v=render(v)
            [level,v]=v.computeDividingLevel();
            
            i=(1/2^(level(1)+1):1/2^level(1):1)';
            j=v.mS+(v.mL).*i;
            x=v.mX+(v.mR).*cos(j);
            y=v.mY+(v.mR).*sin(j);
            
            i=(1/2^(level(2)+1):1/2^level(2):1);
            j=v.mZ+(v.mH).*i;
            numZ=numel(j);
            j=repmat(j,numel(x),1);
            j=j(:);
            
            cloud=[x,y];
            cloud=repmat(cloud,numZ,1);
            center=repmat(v.mResource.mTranslation,size(cloud,1),1);
            cloud=[cloud,j]+center;
            v.mResource.mCloud=[v.mResource.mCloud;cloud];
            v.mResource.measure=v.mResource.measure+v.mMeasure;            

        end

        function v=computeTopDividingLevel(v)
            v.mTopLevel=zeros(2,1);
            level=log2(1+(v.mL*v.mR)/v.mResource.mResolution);
            v.mTopLevel(1)=floor(level);
            level=log2(1+v.mH/v.mResource.mResolution);
            v.mTopLevel(2)=floor(level);
            assert(all(v.mTopLevel>=0));
        end        
      
    end    

end