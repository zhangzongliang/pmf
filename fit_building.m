clc;
clear all;
close all;

restoredefaultpath;
addpath(genpath(pwd));
rng('shuffle');
args=[];
args.logTime=datestr(now,'yyyymmdd-HHMMSS');
cloud=pcread('data/D11/D11.ply');
args.data=cloud.Location;
args.timeTol=3600*20;
args.model='building';
args.resolution=0.2*0.3;
args

v=GeoModeler(args);
v=v.cuckooSearch();
args

resultFolder=['output/',args.model];
if 7~=exist(resultFolder,'dir')
    mkdir(resultFolder);
end
resultFileName=[resultFolder,'/',args.logTime,'.mat'];
save(resultFileName);
fprintf(['saved to ',resultFileName,'\n']);
