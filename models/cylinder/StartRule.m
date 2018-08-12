classdef StartRule < CGARule
    
    methods
        
        function v=StartRule(resource,scope)
            v=v@CGARule(resource,scope);
            v.mIsTerminal=false;
            assert(numel(v.mResource.mTheta)==7);            
        end
        
        function produce(v)            
            cylinder=CylinderRule(v.mResource,v.mScope);            
            v.mResource.mNodes{end+1}=cylinder;
        end
        
    end
    
    methods (Static)
        
        function [x0,lb,ub,xd]=prior()
            lb=[]; % lower bound
            ub=[]; % upper bound            
            xd={}; % names of parameters
            
            maxShift=30;
            maxRadius=10;
            maxHeight=20;
            
            xd{1}='locationX';
            lb(1)=-maxShift;
            ub(1)=maxShift;
            
            xd{2}='locationY';
            lb(2)=-maxShift;
            ub(2)=maxShift;
            
            xd{3}='locationZ';
            lb(3)=-maxShift;
            ub(3)=maxShift;
            
            xd{4}='radius';
            lb(4)=0.01;
            ub(4)=maxRadius;
            
            xd{5}='start';
            lb(5)=0;
            ub(5)=2*pi;
            
            xd{6}='length';
            lb(6)=0.01;
            ub(6)=2*pi;          
            
            xd{7}='height';
            lb(7)=0.2;
            ub(7)=maxHeight;
            
            x0=[0,0,0,5,0.5*pi,1.5*pi,10]; % default value
%             x0=lb;
%             x0=lb+(ub-lb)/2.0;
%             x0= [0.3054,1.4174, -12.6015, 5.0822,    0.7603, 1.2753, 9.7542];
%             x0=[0.2672;1.1238;-12.9347;5.2945;0.2820;2.4238;11.8165];
            
            assert(all(lb<=ub));
        end
        
    end
    
    
end


