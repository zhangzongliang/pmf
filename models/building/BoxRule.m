classdef BoxRule < CGARule
    
    properties (Access=public)

    end
    
    methods
        
        function v=BoxRule(resource,scope)
            v=v@CGARule(resource,scope);            
            v.mIsTerminal=true;
        end       
    end
    
    methods (Static)             

        
    end
    
end