classdef GroundFloorRule < CGARule
    
    properties (Access=public)
        p0 %zWinArc (absolute)
        p1 %zArc (absolute)
        p2 %zWallBottom (absolute)
    end
    
    methods
        
        function v=GroundFloorRule(resource,scope,p0,p1,p2)
            v=v@CGARule(resource,scope);            
            v.mIsTerminal=false;
            v.p0=p0;
            v.p1=p1;
            v.p2=p2;
            %v.mIsTerminal=true;
        end
        
        function produce(v)
            xWallOuter=v.mResource.mTheta(12);
            xWin=v.mResource.mTheta(13);
            xArc=v.mResource.mTheta(14);
            xWallArc=v.mResource.mTheta(15);
            
            xTl=xWin+xWallOuter;
            assert(xTl>0);
            numChildren=3;
            prefixes=cell(1,numChildren);
            prefixes{1}='absolute';
            prefixes{2}='absolute';
            prefixes{3}='absolute';
            
            sizes=zeros(1,numChildren);
            sizes(1)=0.5*xWallOuter;
            sizes(2)=xArc+2*xWallArc+xWallOuter;
            sizes(3)=xTl;
            
            symbols=cell(1,numChildren);
            symbols{1}=BoxRule(v.mResource,v.mScope);
            p=zeros(1,5);
            p(1:3)=[v.p0,v.p1,v.p2];
            p(4)=xWallArc;
            p(5)=xArc;
            symbols{2}=ArcTileHRule(v.mResource,v.mScope,p);
            symbols{3}=TileRule(v.mResource,v.mScope,xWin,v.p0+v.p1);     

            box=BoxRule(v.mResource,v.mScope);
            %box=WindowRule(v.mResource,v.mScope);
            outSymbols=splitRepeat(v,1,prefixes,sizes,symbols,3,box);
            
            extru=v.mResource.mTheta(16)*v.mScope.reverse;
            outSymbols{1}.mScope.mT(2)=outSymbols{1}.mScope.mT(2)-extru;
            if numel(outSymbols)>=numChildren&&isa(outSymbols{end},'BoxRule')
                outSymbols{end}.mScope.mT(2)=outSymbols{end}.mScope.mT(2)-extru;
            end
            
            v.mResource.mNodes(end+1:end+numel(outSymbols))=outSymbols;
            
            
        end        
        
    end

end