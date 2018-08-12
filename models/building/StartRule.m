classdef StartRule < CGARule
    
    methods
        
        function v=StartRule(resource,scope)
            v=v@CGARule(resource,scope);
            v.mIsTerminal=false;
            assert(numel(v.mResource.mTheta)==18);            
        end
        
        function produce(v)            
            rZ=v.mResource.mTheta(1);
            translate=v.mResource.mTheta(2:4);
            xBu=v.mResource.mTheta(5);
            yBu=0;
            zBu=v.mResource.mTheta(6);
            
            scope=v.mScope;
            scope=scope.r([0,0,rZ]).t(translate(:)').s([xBu,yBu,zBu]);
            building=BuildingRule(v.mResource,scope);
            
            v.mResource.mNodes{end+1}=building;
        end
        
    end
    
    methods (Static)
        
        function [x0,lb,ub,xd]=prior()
            lb=[]; % lower bounds
            ub=[]; % upper bounds
            xd={}; % parameter names
            x0=[]; % default values of parameters
            c=0;            
            c=c+1; xd{c}='rZ'; x0(c)=23.3797; lb(c)=0; ub(c)=45; %1 
            c=c+1; xd{c}='tX'; x0(c)=7.3966; lb(c)=4; ub(c)=10;  %2
            c=c+1; xd{c}='tY'; x0(c)=2.1192; lb(c)=0;  ub(c)=5;  %3
            c=c+1; xd{c}='tZ'; x0(c)=1.8905;lb(c)=0;  ub(c)=5;  %4
            c=c+1; xd{c}='xBu'; x0(c)=21.6516; lb(c)=15; ub(c)=25;   %5
            c=c+1; xd{c}='zBu'; x0(c)=12.3116; lb(c)=10; ub(c)=20;    %6
            c=c+1; xd{c}='zWallBottom'; x0(c)=0.9618; lb(c)=0.1; ub(c)=2.0; %7
            c=c+1; xd{c}='zWinArc'; x0(c)=1.7156; lb(c)=1.0; ub(c)=3.0; %8
            c=c+1; xd{c}='zWallUpper'; x0(c)=2.1663; lb(c)=1.0; ub(c)=3.0; %9
            c=c+1; xd{c}='zWinUpper'; x0(c)=2.1663; lb(c)=1.0; ub(c)=3.0; %10
            c=c+1; xd{c}='zArc'; x0(c)=0.8213; lb(c)=0.1; ub(c)=2.0;  %11
            c=c+1; xd{c}='xWallOuter'; x0(c)=1.7175; lb(c)=0.5; ub(c)=2.5;  %12
            c=c+1; xd{c}='xWin'; x0(c)=1.4611; lb(c)=1.0; ub(c)=3.0;  %13
            c=c+1; xd{c}='xArc'; x0(c)=3.2302; lb(c)=2.0; ub(c)=4.0;  %14
            c=c+1; xd{c}='xWallArc'; x0(c)=0.8555;lb(c)=0.1; ub(c)=2.0;  %15
            c=c+1; xd{c}='extru'; x0(c)=0.5; lb(c)=0; ub(c)=0.9;  %16
            c=c+1; xd{c}='arcExtru'; x0(c)=0.2; lb(c)=0; ub(c)=0.5;  %17
            c=c+1; xd{c}='arcRingWidth'; x0(c)=0.5; lb(c)=0.01; ub(c)=0.8;  %18
            
            %x0=lb+(ub-lb)/2.0;
            x0=lb;

            assert(all(x0>=lb));
            assert(all(x0<=ub));
        end
        
    end
    
    
end


