classdef ArcRule < CGARule
    
    properties (Access=public)
        params
        %     //mParams[0]: zWinArc (absolute)
        %     //mParams[1]: zArc (absolute)
        %     //mParams[2]: zWallBottom (absolute)
    end
    
    
    methods
        v=render(v);
        function v=ArcRule(resource,scope,params)      
            v=v@CGARule(resource,scope);
            v.params=params;
            v.mIsTerminal=true;
        end
        
    end
    
    methods(Static)        
        points=filter(cloud,r,delta,centerX,centerZ,alpha,extru,zBottom);
    end

end














