close all;
clear all;
clc;

restoredefaultpath;
pmfRoot=pwd;
addpath(genpath(pmfRoot));
args=[];
args.model='cylinder';
args.numFittings=1;
args.data_resolution=0.6; % 0.6 is for quick evaluation. It is 0.2 in the paper.
args.resolution=args.data_resolution*0.3;
args.timeTol=3600*3; % in seconds
args.imperfection='real'; % can be: real, perfect, or gross
args.intensity=1;
assert(args.data_resolution>0);

if strcmp(args.imperfection,'real')
    args.resultFolder=[pmfRoot,'/output/cylinder/real'];
    cloud=pcread([pmfRoot,'/data/D7/D7.ply']);
    cloud=pcdownsample(cloud,'gridAverage',args.data_resolution);
    cloud=cloud.Location;
    dataCloud=cloud;
    args.translate=true;
else
    gm=GeoModeler(args);
    close;
    dataCloud=gm.getSyntheticData(args.imperfection,args.intensity,args.data_resolution);   
    if strcmp(args.imperfection,'perfect')
        args.resultFolder=[pmfRoot,'/output/cylinder/perfect'];
    else
        args.resultFolder=[pmfRoot,'/output/cylinder/',args.imperfection,'/',num2str(args.intensity)];
    end
end
args.data=dataCloud;
% figure;pcshow(dataCloud);title('data');

if 7~=exist(args.resultFolder,'dir');mkdir(args.resultFolder);end
args.logTime=datestr(now,'yymmdd-HHMMSS');
args.resultFileName=[args.resultFolder,'/',args.logTime,'.mat']

evols=cell(args.numFittings,1);

% parfor i=1:args.numFittings
for i=1:args.numFittings    
    gm=GeoModeler(args);
    rng(cputime*i);
    gm=gm.cuckooSearch();
    evols{i}=gm.mEvol;
    fprintf('\n');
end

save(args.resultFileName);
disp(['saved to ',args.resultFileName]);
