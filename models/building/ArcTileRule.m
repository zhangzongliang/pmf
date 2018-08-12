classdef ArcTileRule < CGARule
    
    properties (Access=public)
        params
        %     //mParams[0]: zWinArc (absolute)
        %     //mParams[1]: zArc (absolute)
        %     //mParams[2]: zWallBottom (absolute)
    end
    
    methods
        
        function v=ArcTileRule(resource,scope,params)
            v=v@CGARule(resource,scope);
            v.params=params;
            v.mIsTerminal=false;
        end
        
        function produce(v)
            assert(numel(v.params)==3);
            numChildren=3;
            prefixes=cell(1,numChildren);
            prefixes{1}='floating';
            prefixes{2}='absolute';
            prefixes{3}='absolute';
            
            sizes=zeros(1,numChildren);
            sizes(1)=1;
            sizes(2)=v.params(1);
            sizes(3)=v.params(2);
            
            symbols=cell(1,numChildren);
            symbols{1}=BoxRule(v.mResource,v.mScope);
            symbols{2}=WindowRule(v.mResource,v.mScope);
            symbols{3}=ArcRule(v.mResource,v.mScope);
            
            outSymbols=v.splitNoRepeat(3,prefixes,sizes,symbols);
            v.mResource.mNodes(end+1:end+numel(outSymbols))=outSymbols;
        end
        
    end
    
    
end