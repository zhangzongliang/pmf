function v=setData(v,data)
v.mResource.mDataCloud=data;
v.mDataKdtree=KDTreeSearcher(v.mResource.mDataCloud);
v.widget=pcshow(v.mResource.mDataCloud,[0,0,0],'MarkerSize',1,'Parent',v.widget);
%v.widget=pcshow(v.mResource.mDataCloud,'Parent',v.widget);
%title(v.widget,'data');
if v.translate
    v.mResource.mTranslation=min(data)+0.5*(max(data)-min(data));
else
    v.mResource.mTranslation=[0,0,0];
end
