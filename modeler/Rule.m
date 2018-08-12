classdef Rule
    
%     properties (Constant)
%         mResource=Resource();
%     end    

    properties (Access=public)
        mTopLevel=0;
        mResource;
        mIsTerminal=false;
        topSamplingLevelAllReached=true;
        ancestors={};
    end
    methods
        
        function v=Rule()
        end
        
        function v=setParameters(v)
            assert(false);
        end
        
        function v=render(v)
            assert(false);
        end
        
        function [level,v]=computeDividingLevel(v)           
            
            level=v.mTopLevel;                       
            sug=v.mResource.mCurrSamplingLevel;
            if sug<0||all(sug>=v.mTopLevel)
                %v.mResource.mTopSamplingLevelAllReached=true;
                v.topSamplingLevelAllReached=true;
            else
                level(sug<v.mTopLevel)=sug;
                %v.mResource.mTopSamplingLevelAllReached=false;
                v.topSamplingLevelAllReached=false;
            end
            
%             topReached=false(size(v.mTopLevel));
%             for i=1:numel(v.mTopLevel)
%                 if sug<v.mTopLevel(i)&&sug>-1
%                     level(i)=sug;
%                 else
%                     topReached(i)=true;
%                     level(i)=v.mTopLevel(i);
%                 end
%             end
%             if all(topReached)
%                 Rule.mResource.mTopSamplingLevelAllReached=true;
%             end
            
        end
        
        
%         function level=computeDividingLevel(v)
%             sug=v.mResource.mCurrSamplingLevel;
%             if sug>-1&&sug<v.mTopLevel
%                 level=sug;
%             else
%                 v.mResource.mTopSamplingLevelAllReached=true;
%                 level=v.mTopLevel;
%             end
%         end
        
        function v=computeTopDividingLevel(v)
            assert(false);
        end
        
        
    end
    
    methods (Static)
        function [x0,lb,ub,xd]=getHyperParameters()
            assert(false);
        end
    end
end


















