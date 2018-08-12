classdef WallWindowWallRule < CGARule
    
    properties (Access=public)
        p0 %zWin (absolute)
    end
    
    methods
        
        function v=WallWindowWallRule(resource,scope,p0)
            v=v@CGARule(resource,scope); 
            v.p0=p0;
            v.mIsTerminal=false;
        end
        
        function produce(v)
            numChildren=2;
            prefixes=cell(1,numChildren);
            prefixes{1}='floating';
            prefixes{2}='absolute';
            
            sizes=zeros(1,numChildren);
            sizes(1)=1;
            sizes(2)=v.p0;            
            
            symbols=cell(1,numChildren);
            symbols{1}=BoxRule(v.mResource,v.mScope);
            symbols{2}=WindowRule(v.mResource,v.mScope);
            
            outSymbols=v.splitNoRepeat(3,prefixes,sizes,symbols);
            v.mResource.mNodes(end+1:end+numel(outSymbols))=outSymbols;
        end        
        
    end
    
    
end