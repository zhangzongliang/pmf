function v=render(v)

%rule=class(v)
%=v.mScope

%v=v.render3DScope(v.mScope);
axis=1; % y axis
axisA=mod(axis+1,3);
axisB=mod(axis+2,3);

[level,v]=v.computeDividingLevel();

i=(1/2^(level(1)+1):1/2^level(1):1)';
x=v.mScope.mS(1)*i;
%y=zeros(size(x));

i=(1/2^(level(2)+1):1/2^level(2):1);
j=v.mScope.mS(3)*i;
numZ=numel(j);
j=repmat(j,numel(x),1);

%cloud=[x,y];
cloud=repmat(x,numZ,1);
y=zeros(size(cloud));
cloud=[cloud,y,j(:)];

tform=v.get3DTransformationMatrix(v.mScope.mR,v.mScope.mT);

% cloud=v.transform(cloud,tform);
% v.mResource.mCloud=[v.mResource.mCloud;cloud];


cloud=pctransform(pointCloud(cloud),tform);
v.mResource.mCloud=[v.mResource.mCloud;cloud.Location];
v.mResource.measure=v.mResource.measure+v.mScope.mS(1)*v.mScope.mS(3);

vets=v.getVertexes(axisA+1,axisB+1,v.mScope.mS,tform);
vets=vets.Location;
firstVertex=size(v.mResource.vertexes,1)+1;
v.mResource.vertexes=[v.mResource.vertexes;vets];
v.mResource.faces{end+1}=firstVertex:size(v.mResource.vertexes,1);
v.mResource.colors=[v.mResource.colors;v.mScope.c];
end



