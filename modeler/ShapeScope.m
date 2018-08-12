classdef ShapeScope
    properties (Access=public)
        mR=[0,0,0];
        mT=[0,0,0];
        mS=[1,1,1];
        reverse=1;
        floorIndex=-1;
        c=[1,0,0]; % color
        derivationLevel=-1;
    end
    
    methods
        function v=ShapeScope()
        end
        
        function v=r(v,angles)
            v.mR=v.mR+angles;
            v.mR=mod(v.mR,360);
        end
        
        function v=t(v,shift)
            v.mT=v.mT+shift;            
        end
        
        function v=s(v,sz)
            v.mS=sz;
        end
    end
    
end