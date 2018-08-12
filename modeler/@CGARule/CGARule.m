classdef CGARule < Rule
    
    properties (Access=public)
        mScope;
    end
    
    methods
        outSymbols=splitRepeat(v,axis,prefixes,sizes,symbols,repetitousIndex,boxSymbol);
        outSymbols=splitNoRepeat(v,axis,prefixes,sizes,symbols)
        v=render(v);
        scopes=comp(v,faces);
        
        
        function v=CGARule(resource,scope)
            v.mResource=resource;
            v.mScope=scope;
            v.mScope.derivationLevel=v.mScope.derivationLevel+1;
            v=v.computeTopDividingLevel();
        end
        
        function v=computeTopDividingLevel(v)
            v.mTopLevel=zeros(2,1);
            level=log2(1+v.mScope.mS(1)/v.mResource.mResolution);
            v.mTopLevel(1)=floor(level);
            level=log2(1+v.mScope.mS(3)/v.mResource.mResolution);
            v.mTopLevel(2)=floor(level);
            assert(all(v.mTopLevel>=0));
        end
                
        function v=render2DScope(v,axis,translate,shapeScope)
            axisA=mod(axis+1,3);
            axisB=mod(axis+2,3);
            translation=[0,0,0];
            switch axis
                case 0
                    translation=shapeScope.mT+[translate*shapeScope.mS(1),0,0];
                case 1
                    translation=shapeScope.mT+[0,translate*shapeScope.mS(2),0];
                case 2
                    translation=shapeScope.mT+[0,0,translate*shapeScope.mS(3)];
            end
            %             tmp=translation(1);
            %             translation(1)=translation(2);
            %             translation(2)=tmp;
            tform=v.get3DTransformationMatrix(shapeScope.mR,translation);
            vets=v.getVertexes(axisA+1,axisB+1,shapeScope.mS,tform);
            v.mResource.vertexes=vets;
        end
        
        function v=render3DScope(v,sc)
            if all(sc.mS>0)
                assert(false);
            elseif sc.mS(1)==0
                v=v.render2DScope(0,false,sc);
            elseif sc.mS(2)==0
                v=v.render2DScope(1,false,sc);
            elseif sc.mS(3)==0
                v=v.render2DScope(2,false,sc);
            end
        end
                
        
        
    end
    
    methods (Static)
        
        function tform=get3DTransformationMatrix(r,t)
            x=t(1);
            y=t(2);
            if x==0&&y==0
                b=0;
            else
                if x>=0&&y>=0
                    b=atan(y/x);
                elseif x<=0&&y>=0
                    b=pi+atan(y/x);
                elseif x<=0&&y<=0
                    b=pi+atan(y/x);
                elseif x>=0&&y<=0
                    b=2*pi+atan(y/x);
                else
                    assert(false);
                end
            end
            a=pi*r(3)/180+b;
            c=(x^2+y^2)^0.5;
            t(1)=c*cos(a);
            t(2)=c*sin(a);            
            
            rz=rotz(-r(3));            
            rotation=rz;
            transformation=zeros(4,4);
            transformation(1:3,1:3)=rotation;
            transformation(4,1:3)=t;
            %transformation(1:3,4)=t';
            transformation(4,4)=1;
            %tform=transformation;
            tform=affine3d(transformation);
        end
        
        function cloud=transform(cloud,mv)
            n=size(cloud,1);
            pad=ones(n,1);
            cloud=[cloud,pad];
            cloud=(mv*cloud')';
            cloud=cloud(:,1:3);
        end
        
                
        function verts=getVertexes(A,B,S,tform)
            points=zeros(4,3);
            points(2,B)=S(B);
            points(3,A)=S(A); points(3,B)=S(B);
            points(4,A)=S(A);
            verts=pctransform(pointCloud(points),tform);
        end
        
    end
    
end