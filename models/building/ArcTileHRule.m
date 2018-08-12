classdef ArcTileHRule < CGARule
    
    properties (Access=public)
        p
        %     //mParams[0]: zWinArc (absolute)
        %     //mParams[1]: zArc (absolute)
        %     //mParams[2]: zWallBottom (absolute)
        %     //mParams[3]: xWallArc (absolute)
        %     //mParams[4]: xArc (absolute)
    end
    
    methods
        
        function v=ArcTileHRule(resource,scope,p)
            v=v@CGARule(resource,scope);
            v.p=p;
            v.mIsTerminal=false;
        end
        
        function produce(v)
            assert(numel(v.p)==5);
            numChildren=4;
            prefixes=cell(1,numChildren);
            prefixes{1}='absolute';
            prefixes{2}='absolute';
            prefixes{3}='absolute';
            prefixes{4}='floating';
            
            sizes=zeros(1,numChildren);
            sizes(1)=v.p(4);
            sizes(2)=v.p(5);
            sizes(3)=v.p(4);
            sizes(4)=1;
            
           
            symbols=cell(1,numChildren);
            symbols{1}=BoxRule(v.mResource,v.mScope);
            %symbols{2}=ArcTileRule(v.mResource,v.mScope,v.p(1:3));
            symbols{2}=ArcRule(v.mResource,v.mScope,v.p(1:3));
            symbols{3}=BoxRule(v.mResource,v.mScope);
            symbols{4}=BoxRule(v.mResource,v.mScope);
            
            outSymbols=v.splitNoRepeat(1,prefixes,sizes,symbols);
            if numel(outSymbols)==4
                extru=v.mResource.mTheta(16)*v.mScope.reverse;
                outSymbols{4}.mScope.mT(2)=outSymbols{4}.mScope.mT(2)-extru;
            end
            arcRingWidth=v.mResource.mTheta(18)*v.mResource.mTheta(15);
            if numel(outSymbols)>=4 
                test1=outSymbols{1}.mScope.mS(1)-arcRingWidth;
                outSymbols{1}.mScope.mS(1)=max(outSymbols{1}.mScope.mS(1)-arcRingWidth,0);
                outSymbols{1}.mScope.mS(3)=outSymbols{1}.mScope.mS(3)+arcRingWidth;
                outSymbols{1}=outSymbols{1}.computeTopDividingLevel(); 
                test2=outSymbols{3}.mScope.mS(1)-arcRingWidth;
                outSymbols{3}.mScope.mS(1)=max(outSymbols{3}.mScope.mS(1)-arcRingWidth,0);
                outSymbols{3}.mScope.mS(3)=outSymbols{3}.mScope.mS(3)+arcRingWidth;
                outSymbols{3}.mScope.mT(1)=outSymbols{3}.mScope.mT(1)+arcRingWidth;
                outSymbols{3}=outSymbols{3}.computeTopDividingLevel(); 
            end
                        
            arc=outSymbols{2};
            arc.mScope.mS(1)=arc.mScope.mS(1)+2*arcRingWidth;
            arc.mScope.mS(3)=arc.mScope.mS(3)+arcRingWidth;
            arc.mScope.mT(1)=arc.mScope.mT(1)-arcRingWidth;
            arc=arc.computeTopDividingLevel();
            outSymbols{2}=arc;
            v.mResource.mNodes(end+1:end+numel(outSymbols))=outSymbols;
        end
        
    end
    
    
end