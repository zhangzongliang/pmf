function v=generate(v,theta)

v.mResource.mTheta=theta;
v.mResource.mNodes={};
v.mResource.mTerminals={};
start=StartRule(v.mResource,ShapeScope());
v.mResource.mNodes{end+1}=start;

% lv=3;
% count=1;
% cs=distinguishable_colors(100,[0,0,0;1,1,1]);

while numel(v.mResource.mNodes)~=0
    node=v.mResource.mNodes{1};    
    if node.mIsTerminal
%         if node.mScope.derivationLevel<=lv
%             node.mScope.c=cs(count,:);
%             count=count+1;
%         end
        v.mResource.mTerminals{end+1}=node;
    else
%         if node.mScope.derivationLevel==lv
%             node.mScope.c=cs(count,:);
%             count=count+1;
%         end
        node.produce();        
    end
    v.mResource.mNodes=v.mResource.mNodes(2:end);
end

end