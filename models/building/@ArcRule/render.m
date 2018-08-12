function v=render(v)
% v=render@CGARule(v);
xWallArc=v.mResource.mTheta(15);
arcRingWidth=v.mResource.mTheta(18)*xWallArc;
arcExtru=v.mResource.mTheta(17)*v.mScope.reverse;
%arcExtru=0;
axisA=3;
axisB=1;

s0=v.mScope.mS(1)-2*arcRingWidth;
%s2=v.mScope.mS(3);
s2=v.params(2);
assert(s2>0);
[level,v]=v.computeDividingLevel();

if s0>2*s2
    r=(s2^2+(s0^2)/4)/(2*s2);
    assert(r>0);
    alpha=asin(s0/(2*r));
    arcArea=alpha*r*r-0.5*s0*(r-s2);
    centerX=s0/2;
    centerZ=s2-r;
else
    r=s0/2;
    arcArea=0.25*2*pi*r*r;
    centerX=s0/2;
    centerZ=s2-r;  
    alpha=pi/2;
end
windowArea=arcArea+v.params(1)*s0;
area=v.mScope.mS(1)*v.mScope.mS(3)-windowArea;
assert(area>=0);
v.mResource.measure=v.mResource.measure+area;

%level=level+2;
i=(1/2^(level(1)+1):1/2^level(1):1)';
x=v.mScope.mS(1)*i;

i=(1/2^(level(2)+1):1/2^level(2):1);
j=v.mScope.mS(3)*i;

numZ=numel(j);
j=repmat(j,numel(x),1);

cloud=repmat(x,numZ,1);
y=zeros(size(cloud));
cloud=[cloud,y,j(:)];
%centerX=R;centerZ=R;
centerX=centerX+arcRingWidth;
centerZ=centerZ+v.params(1)+v.params(3);
cloud=v.filter(cloud,r,arcRingWidth,centerX,centerZ,alpha,-arcExtru,v.params(3));

tform=v.get3DTransformationMatrix(v.mScope.mR,v.mScope.mT);
%                 cloud=v.transform(cloud,tform);
%                 v.mResource.mCloud=[v.mResource.mCloud;cloud];

cloud=pctransform(pointCloud(cloud),tform);
v.mResource.mCloud=[v.mResource.mCloud;cloud.Location];


vs=draw(r,arcRingWidth,centerX,centerZ,alpha,-arcExtru,v.params(3));
for i=1:numel(vs)
    cloud=pctransform(pointCloud(vs{i}),tform);
    firstVertex=size(v.mResource.vertexes,1)+1;
    v.mResource.vertexes=[v.mResource.vertexes;cloud.Location];
    v.mResource.faces{end+1}=firstVertex:size(v.mResource.vertexes,1);
    v.mResource.colors=[v.mResource.colors;v.mScope.c];
end

end

function vs=draw(r,delta,centerX,centerZ,alpha,extru,zBottom)
R=r+delta;
x0=centerX;
x1=centerX+r*sin(alpha);
x1_=centerX-r*sin(alpha);
x2=x1+delta; 
x2_=centerX-r*sin(alpha)-delta;
x2_minus_x0=x2-x0;
x2_minus_x0=min(x2_minus_x0,R);
beta=acos(x2_minus_x0/R);

t=linspace(pi/2-alpha,pi/2+alpha,20);
%T=flip(t);
T=linspace(pi-beta,beta,23);

x=centerX+r*cos(t);
z=centerZ+r*sin(t);
zi=max(R^2-(r*sin(alpha)+delta)^2,0);
zi=zi^0.5+centerZ;
x=[x2 x2 x1 x x1_ x2_ x2_];
z=[zi 0 0 z 0 0 zi];

X=centerX+R*cos(T);
Z=centerZ+R*sin(T);

x=[x X]';
z=[z Z]';

y=zeros(size(x))+extru;
ring=[x y z];

x=[x1;x1;x1_;x1_];
z=[0;zBottom;zBottom;0];
y=zeros(size(x));
bottom=[x y z];

x=X';
z=Z';
x=[x;x2;x2_];
z=[z;centerZ+R;centerZ+R];
y=zeros(size(x));
corner=[x y z];


vs=cell(3,1);
vs{1}=ring;vs{2}=corner;vs{3}=bottom;
end




%  ///////////// before 2018005
% function v=render(v)
% arcRingWidth=resource.mTheta(18);
% axisA=3;
% axisB=1;
% 
% s0=v.mScope.mS(1);
% %s2=v.mScope.mS(3);
% s2=v.params(2);
% assert(s2>0);
% level=v.computeDividingLevel();
% 
% angleResolution=0.05;
% r=1;alpha=90;area=0;
% areaRectangle=0;
% centerX=0;centerZ=0;
% 
% if s0>2*s2
%     r=(s2^2+(s0^2)/4)/(2*s2);
%     assert(r>0);
%     alpha=asin(s0/(2*r));
%     areaRectangle=s0*s2;
%     area=areaRectangle-alpha*r*r+0.5*s0*(r-s2);
%     area=max(area,0);
%     centerX=s0/2;
%     centerZ=s2-r;
% else
%     r=s0/2;
%     areaRectangle=2*r*r;
%     area=areaRectangle-0.25*2*pi*r*r;
%     area=max(area,0);
%     centerX=s0/2;
%     centerZ=s2-r;  
% end
% 
% 
% v.mResource.measure=v.mResource.measure+area;
% i=(1/2^(level(1)+1):1/2^level(1):1)';
% x=s0*i;
% 
% i=(1/2^(level(2)+1):1/2^level(2):1);
% j=s2*i;
% numZ=numel(j);
% j=repmat(j,numel(x),1);
% 
% cloud=repmat(x,numZ,1);
% y=zeros(size(cloud));
% cloud=[cloud,y,j(:)];
% 
% points=cloud;
% count=0;
% for i=1:size(cloud,1)
%     if cloud(i,axisA)>centerZ&&(cloud(i,axisA)-centerZ)^2+(cloud(i,axisB)-centerX)^2>r^2
%         count=count+1;
%         points(count,:)=cloud(i,:);
%     end
% end
% cloud=points(1:count,:);
% tform=v.get3DTransformationMatrix(v.mScope.mR,v.mScope.mT);
% %                 cloud=v.transform(cloud,tform);
% %                 v.mResource.mCloud=[v.mResource.mCloud;cloud];
% 
% cloud=pctransform(pointCloud(cloud),tform);
% v.mResource.mCloud=[v.mResource.mCloud;cloud.Location];
% 
% 
% R=r+arcRingWidth;
% tmpL=level(1)+2;
% i=(1/2^(tmpL+1):1/2^tmpL:1)';
% x=2*R*i;
% 
% %             i=(1/2^(level(2)+1):1/2^level(2):1);
% %             j=2*R*i;
% j=x';
% 
% numZ=numel(j);
% j=repmat(j,numel(x),1);
% 
% cloud=repmat(x,numZ,1);
% y=zeros(size(cloud))-1;
% cloud=[cloud,y,j(:)];
% centerX=R;centerZ=R;
% cloud=v.filter(cloud,r,arcRingWidth,centerX,centerZ,alpha);
% 
% tform=v.get3DTransformationMatrix(v.mScope.mR,v.mScope.mT);
% %                 cloud=v.transform(cloud,tform);
% %                 v.mResource.mCloud=[v.mResource.mCloud;cloud];
% 
% cloud=pctransform(pointCloud(cloud),tform);
% v.mResource.mCloud=[v.mResource.mCloud;cloud.Location];
% end
% 

% ////////////////20180508
% function v=render(v)
% % v=render@CGARule(v);
% xWallArc=v.mResource.mTheta(15);
% arcRingWidth=v.mResource.mTheta(18)*xWallArc;
% arcExtru=v.mResource.mTheta(17)*v.mScope.reverse;
% %arcExtru=0;
% axisA=3;
% axisB=1;
% 
% s0=v.mScope.mS(1)-2*arcRingWidth;
% %s2=v.mScope.mS(3);
% s2=v.params(2);
% assert(s2>0);
% [level,v]=v.computeDividingLevel();
% 
% angleResolution=0.05;
% r=1;alpha=pi/2;
% %area=0;
% areaRectangle=0;
% centerX=0;centerZ=0;
% arcArea=0;
% arcLeft=[];
% arcRight=[];
% if s0>2*s2
%     r=(s2^2+(s0^2)/4)/(2*s2);
%     assert(r>0);
%     alpha=asin(s0/(2*r));
%     areaRectangle=s0*s2;
%     arcArea=alpha*r*r-0.5*s0*(r-s2);
%     area=areaRectangle-arcArea;
%     %area=max(area,0);
%     centerX=s0/2;
%     centerZ=s2-r;
%    
% else
%     r=s0/2;
%     areaRectangle=2*r*r;
%     arcArea=0.25*2*pi*r*r;
%     area=areaRectangle-arcArea;
%     %area=max(area,0);
%     centerX=s0/2;
%     centerZ=s2-r;  
%     
%     
% end
% windowArea=arcArea+v.params(1)*s0;
% area=v.mScope.mS(1)*v.mScope.mS(3)-windowArea;
% assert(area>=0);
% v.mResource.measure=v.mResource.measure+area;
% 
% %level=level+2;
% i=(1/2^(level(1)+1):1/2^level(1):1)';
% x=v.mScope.mS(1)*i;
% 
% i=(1/2^(level(2)+1):1/2^level(2):1);
% j=v.mScope.mS(3)*i;
% 
% numZ=numel(j);
% j=repmat(j,numel(x),1);
% 
% cloud=repmat(x,numZ,1);
% y=zeros(size(cloud));
% cloud=[cloud,y,j(:)];
% %centerX=R;centerZ=R;
% centerX=centerX+arcRingWidth;
% centerZ=centerZ+v.params(1)+v.params(3);
% cloud=v.filter(cloud,r,arcRingWidth,centerX,centerZ,alpha,-arcExtru,v.params(3));
% 
% tform=v.get3DTransformationMatrix(v.mScope.mR,v.mScope.mT);
% %                 cloud=v.transform(cloud,tform);
% %                 v.mResource.mCloud=[v.mResource.mCloud;cloud];
% 
% cloud=pctransform(pointCloud(cloud),tform);
% v.mResource.mCloud=[v.mResource.mCloud;cloud.Location];
% end
