classdef FacadeRule < CGARule
    
    properties (Access=public)

    end
    
    methods
        
        function v=FacadeRule(resource,scope)
            v=v@CGARule(resource,scope);            
            %v.mIsTerminal=true;
            v.mIsTerminal=false;
        end
        
        function produce(v)
            
            zWallBottom=v.mResource.mTheta(7);
            zWinArc=v.mResource.mTheta(8);
            zWallUpper=v.mResource.mTheta(9);
            zWinUpper=v.mResource.mTheta(10);
            zArc=v.mResource.mTheta(11);
            
            zGf=zWallBottom+zWinArc+zArc;
            zFl=zWinUpper+zWallUpper;
            assert(zGf>0);
            numChildren=2;
            prefixes=cell(1,numChildren);
            prefixes{1}='absolute';
            prefixes{2}='absolute';
            
            sizes=zeros(1,numChildren);
            sizes(1)=zGf;
            sizes(2)=zFl;
            
            symbols=cell(1,numChildren);
            symbols{1}=GroundFloorRule(v.mResource,v.mScope,zWinArc,zArc,zWallBottom);
            symbols{2}=FloorRule(v.mResource,v.mScope,zWinUpper);
            
            box=BoxRule(v.mResource,v.mScope);
            %box=WindowRule(v.mResource,v.mScope);
            outSymbols=splitRepeat(v,3,prefixes,sizes,symbols,2,box);            
            
            if (numel(outSymbols)>=numChildren)&&(isa(outSymbols{end},'BoxRule'))
                extru=v.mResource.mTheta(16)*v.mScope.reverse;
                outSymbols{end}.mScope.mT(2)=outSymbols{end}.mScope.mT(2)-extru;
            end
                        
            if numel(outSymbols)>=numChildren
                if isa(outSymbols{2},'BoxRule')
                    arcRingWidth=v.mResource.mTheta(18)*v.mResource.mTheta(15);
                    outSymbols{2}.mScope.mS(3)=max(outSymbols{2}.mScope.mS(3)-arcRingWidth,0);
                    outSymbols{2}.mScope.mT(3)=outSymbols{2}.mScope.mT(3)+arcRingWidth;
                    outSymbols{2}=outSymbols{2}.computeTopDividingLevel();
                elseif isa(outSymbols{2},'FloorRule')
                    outSymbols{2}.mScope.floorIndex=1;
                else
                    assert(false);
                end
            end
            
            v.mResource.mNodes(end+1:end+numel(outSymbols))=outSymbols;
            
        end        
        
    end
    
    methods (Static)             

        
    end
    
end