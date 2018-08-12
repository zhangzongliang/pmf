classdef TileRule < CGARule
    
    properties (Access=public)
        p0 %xWin (absolute)
        p1 %zWin (absolute) 
    end
    
    methods
        
        function v=TileRule(resource,scope,p0,p1)
            v=v@CGARule(resource,scope); 
            v.p0=p0;
            v.p1=p1;
            v.mIsTerminal=false;
        end
        
        function produce(v)
            numChildren=2;
            prefixes=cell(1,numChildren);
            prefixes{1}='absolute';
            prefixes{2}='floating';
            
            sizes=zeros(1,numChildren);
            sizes(1)=v.p0;
            sizes(2)=1;            
          
            symbols=cell(1,numChildren);
            symbols{1}=WallWindowWallRule(v.mResource,v.mScope,v.p1);
            symbols{2}=BoxRule(v.mResource,v.mScope);
            
            outSymbols=v.splitNoRepeat(1,prefixes,sizes,symbols);            
            if numel(outSymbols)==numChildren
                extru=v.mResource.mTheta(16)*v.mScope.reverse;
                outSymbols{2}.mScope.mT(2)=outSymbols{2}.mScope.mT(2)-extru;
            end
            v.mResource.mNodes(end+1:end+numel(outSymbols))=outSymbols;
        end        
        
    end
    
    
end