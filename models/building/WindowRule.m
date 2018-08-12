classdef WindowRule < CGARule
    
    properties (Access=public)

    end
    
    methods
        
        function v=WindowRule(resource,scope)
            v=v@CGARule(resource,scope);            
            v.mIsTerminal=true;
        end       
        
        function v=render(v)
            %ruleName='window'
        end
        
    end
    
    methods (Static)             

        
    end
    
end