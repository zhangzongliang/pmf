function res=resolution(D)
tree=KDTreeSearcher(D);
[~,dists]=knnsearch(tree,D,'k',2);
res=min(dists(:,2));
% res=Inf;
% for i=1:size(D,1)
%     p=D(i,:);
%     D_=D([1:i-1,i+1:end],:);
%     tree=KDTreeSearcher(D_);
%     [~,dists]=knnsearch(tree,p);
%     res=min(res,dists);
% end
end