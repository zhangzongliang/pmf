classdef TileHRule < CGARule
    
    properties (Access=public)
        zWinUpper %p0
        xWallArc  %p1
        xArc      %p2
    end
    
    methods
        
        function v=TileHRule(resource,scope,zWinUpper,xWallArc,xArc)
            v=v@CGARule(resource,scope);
            v.zWinUpper=zWinUpper;
            v.xWallArc=xWallArc;
            v.xArc=xArc;
            v.mIsTerminal=false;
        end
        
        function produce(v)
            
            numChildren=4;
            prefixes=cell(1,numChildren);
            prefixes{1}='absolute';
            prefixes{2}='absolute';
            prefixes{3}='absolute';
            prefixes{4}='floating';
            
            sizes=zeros(1,numChildren);
            sizes(1)=0.5*v.xArc+0.5*v.xWallArc;
            sizes(2)=v.xWallArc;
            sizes(3)=0.5*v.xArc+0.5*v.xWallArc;
            sizes(4)=1;
            
            symbols=cell(1,numChildren);
            symbols{1}=WallWindowWallRule(v.mResource,v.mScope,v.zWinUpper);
            symbols{2}=BoxRule(v.mResource,v.mScope);
            symbols{3}=WallWindowWallRule(v.mResource,v.mScope,v.zWinUpper);
            symbols{4}=BoxRule(v.mResource,v.mScope);
            
            outSymbols=v.splitNoRepeat(1,prefixes,sizes,symbols);
            
            if numel(outSymbols)==numChildren
                extru=v.mResource.mTheta(16)*v.mScope.reverse;
                outSymbols{numChildren}.mScope.mT(2)=outSymbols{numChildren}.mScope.mT(2)-extru;
            end
            
            if v.mScope.floorIndex==1&&numel(outSymbols)>=3
                arcRingWidth=v.mResource.mTheta(18)*v.mResource.mTheta(15);
                for i=1:3
                    outSymbols{i}.mScope.mS(3)=outSymbols{i}.mScope.mS(3)-arcRingWidth;
                    outSymbols{i}.mScope.mT(3)=outSymbols{i}.mScope.mT(3)+arcRingWidth;
                    outSymbols{i}=outSymbols{i}.computeTopDividingLevel();                    
                end
            end
            
            v.mResource.mNodes(end+1:end+numel(outSymbols))=outSymbols;
        end
        
        
        
        %         function produce(v)
        %
        %             numChildren=3;
        %             prefixes=cell(1,numChildren);
        %             prefixes{1}='absolute';
        %             prefixes{2}='absolute';
        %             prefixes{3}='floating';
        %
        %             sizes=zeros(1,numChildren);
        %             sizes(1)=0.5*v.xArc+0.5*v.xWallArc;
        %             sizes(2)=v.xWallArc;
        %             sizes(3)=1;
        %
        %             p0=0.5*(v.xWallArc+v.xArc);
        %             symbols=cell(1,numChildren);
        %             symbols{1}=WallWindowWallRule(v.mResource,v.mScope,v.zWinUpper);
        %             symbols{2}=BoxRule(v.mResource,v.mScope);
        %             symbols{3}=TileRule(v.mResource,v.mScope,p0,v.zWinUpper);
        %
        %             outSymbols=v.splitNoRepeat(1,prefixes,sizes,symbols);
        %             v.mResource.mNodes(end+1:end+numel(outSymbols))=outSymbols;
        %         end
        
        %
        %         function produce(v)
        %
        %             numChildren=2;
        %             prefixes=cell(1,numChildren);
        %             prefixes{1}='absolute';
        %             prefixes{2}='floating';
        %
        %             sizes=zeros(1,numChildren);
        %             sizes(1)=0.5*v.xArc+1.5*v.xWallArc;
        %             sizes(2)=1;
        %
        %             p0=0.5*(v.xWallArc+v.xArc);
        %             symbols=cell(1,numChildren);
        %             symbols{1}=TileRule(v.mResource,v.mScope,p0,v.zWinUpper);
        %             symbols{2}=TileRule(v.mResource,v.mScope,p0,v.zWinUpper);
        %
        %             outSymbols=v.splitNoRepeat(1,prefixes,sizes,symbols);
        %             v.mResource.mNodes(end+1:end+numel(outSymbols))=outSymbols;
        %         end
        
    end
    
    
end