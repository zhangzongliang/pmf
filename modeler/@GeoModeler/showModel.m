function v=showModel(v,theta,color)
cla(v.widget);
if numel(v.mResource.mDataCloud>0)
    v.widget=pcshow(v.mResource.mDataCloud,[0,0,0],'MarkerSize',3,'Parent',v.widget);
end
v=v.renderModel(theta);
hold on;
if numel(v.mResource.vertexes)>0
    patch(v.widget,'vertices',v.mResource.vertexes,'faces',getFaces(v.mResource.faces),...
        'FaceColor','flat','FaceVertexCData',v.mResource.colors,'linestyle','-');
else
    v.widget=pcshow(v.mResource.mCloud,color,'MarkerSize',6,'Parent',v.widget);
end
title(v.widget,num2str(v.mBestScore));
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
%view(v.widget,10,20);
drawnow;
end

function fs=getFaces(f)
maxf=0;
for i=1:numel(f)
    maxf=max(maxf,numel(f{i}));
end

fs=NaN(numel(f),maxf);
for i=1:numel(f)
    fv=f{i};
    fs(i,1:numel(fv))=fv;   
end
end