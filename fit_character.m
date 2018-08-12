
clc;clear;close all;
restoredefaultpath;
addpath(genpath(pwd));

args=[];

%  can be: perfect, bg_noise, boundary_box, box_occlusion, grid_lines, line_clutter, or line_deletion
args.imperfection='bg_noise'; 

args.usePretrain=false;
args.intensity=1;
args.verbose=true;
args.lambda=2.0;
args.numTrains=1; % 1-shot
args.numRuns=1; % 1 is for quick evaluation. It is 50 in the paper.
args.iterationTol=50; % 50 is for quick evaluation. It is 1000 in the paper.
args.fastTraining=true;% 'true' is for quick evaluation. It is 'false' in the paper.

% 1-shot
args.maxInk=6; % width
args.maxGlobalShift=60; % global location
args.maxLocalShift=2.5; % local location
args.maxGlobalScale=1.5; % affine
args.maxLocalScale=1.1; 
args.maxGlobalRotation=90;
args.maxLocalRotation=20;
args.control=5; % shape

assert(0==args.intensity||1==args.intensity||2==args.intensity);
if strcmp(args.imperfection,'perfect')
    testFolder = 'data/MNIST_mini/testing'
    resultFolder='output/character/perfect'
else
    testFolder = ['data/noisyMNIST_tests_mini/',...
        args.imperfection,'/',num2str(args.intensity)]
    resultFolder=['output/character/',args.imperfection,'/',num2str(args.intensity)]
end

if 7~=exist(resultFolder,'dir')
    mkdir(resultFolder);
end

%parpool('local',5);
verbose=args.verbose;

trainFolder='data/MNIST_mini/training';
logTime=datestr(now,'yyyymmdd-HHMMSS');
numRuns=args.numRuns;


numTrains=args.numTrains;

argsModeler=args;
args.logTime=logTime;
args


numTests=1;
numClasses=10;
Rs=cell(numRuns,1);

resultFileName=[resultFolder,'/pmf-',logTime,'.mat'];
wrongs=-Inf(numRuns,numTests);

usePretrain=args.usePretrain;
if usePretrain
    assert(false);
    load('data/premodels100.mat','premodels');
    premodels=premodels;
end

% parfor iRun=1:numRuns
for iRun=1:numRuns
    R=[];
    if usePretrain
        models=premodels(:,(iRun-1)*numTrains+1:iRun*numTrains);
    else
        models=cell(numClasses,numTrains);
        fprintf('\nRun%d Training...\n',iRun);
        for iClass=1:numClasses
            imfolder=dir(fullfile(trainFolder,num2str(iClass-1)));
            if verbose
                fprintf('\nRun%d Class%d: ',iRun,iClass);
            end
            for iTrain=1:numTrains
                modelWithName=[];
                imFullName=imfolder(2+(iRun-1)*numTrains+iTrain);
                modelWithName.imname=imFullName.name;              
                img=imread(fullfile(trainFolder,num2str(iClass-1),modelWithName.imname));
                img=imresize(img,[65,65]);
                img=padarray(img,[20,20]);
                img(img<128)=0;
                img(img>=128)=1;
                img=logical(img);
                
                modelWithName.model=fit_motorprograms(img,1,true,true,args.fastTraining);
                close all;
                models{iClass,iTrain}=modelWithName;
                if verbose
                    fprintf(1,'Train%d ',iTrain);
                end
            end
            
        end
        R.models=models;
        
    end
       
    args
    
    Ts=cell(numTests,numClasses);
    for iTest=1:numTests
        wrong=0;
        fprintf('\nRun%d Testing...\n',iRun);
        for iClass=1:numClasses
            T=Modeler.runTesting(iRun,numTests,models,iClass,iTest,testFolder,argsModeler,verbose);
            wrong=wrong+T.wrong;
            Ts{iTest,iClass}=T;
        end
        wrongs(iRun,iTest)=wrong;
        R.Ts=Ts;
        Rs{iRun}=R;
        
        args
        fprintf(['\niRun=',num2str(iRun),...
            ' iTest=',num2str(iTest),...
            ' wrongOfThisTest=',num2str(wrong),'\n\n']);
        
    end
    
end
args
wrongs_=wrongs(wrongs>-1);
accuracy=1-mean(wrongs_)/numClasses;
deviation=std(wrongs_,1)/numClasses;

fprintf(['\n\ndeviation=',num2str(deviation),...
    ' accuracy=',num2str(accuracy),'\n\n']);

save(resultFileName);
fprintf(['saved to ',resultFileName,'\n']);


