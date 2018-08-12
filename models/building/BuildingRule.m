classdef BuildingRule < CGARule

    methods
        
        function v=BuildingRule(resource,scope)            
            v=v@CGARule(resource,scope);
            v.mIsTerminal=false;
        end
        
        function produce(v)
            faces={'front','back'};
            scopes=v.comp(faces);
            scopes{1}.mS(1)=scopes{1}.mS(1)/2;
            scopes{1}.mT(1)=scopes{1}.mT(1)+scopes{1}.mS(1);
            
            scopes{2}.mS(1)=scopes{2}.mS(1)/2;
            scopes{2}.mT(1)=scopes{2}.mT(1)+scopes{2}.mS(1);
            scopes{2}.mT(2)=scopes{2}.mT(2)+v.mScope.mS(2);
            scopes{2}.reverse=-1;
                        
            frontFacade=FacadeRule(v.mResource,scopes{1});
            backFacade=FacadeRule(v.mResource,scopes{2});            
            
            v.mResource.mNodes{end+1}=frontFacade;
            v.mResource.mNodes{end+1}=backFacade;
        end         
  
    end
    
end