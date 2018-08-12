clc;clear;close all;
addpath(genpath('~/code/bpl'));
numClasses=10;
numTrains=1000;
premodels=cell(numClasses,numTrains);
trainFolder='~/code/science_rcn-master/data/MNIST/training';
iRun=1;
fprintf('\nRun%d Training...\n',iRun);
verbose=true;
for iClass=1:numClasses;
    imfolder=dir(fullfile(trainFolder,num2str(iClass-1)));
    if verbose;
        fprintf('\nRun%d Class%d: ',iRun,iClass);
    end
    for iTrain=1:numTrains
        modelWithName=[];
        imFullName=imfolder(2+iTrain);
        %imFullName=imfolder(2+(iRun-1)*numTrains+iTrain);
        modelWithName.imname=imFullName.name;
        img=imread(fullfile(trainFolder,num2str(iClass-1),modelWithName.imname));
        img=imresize(img,[65,65]);
        img=padarray(img,[20,20]);
        img(img<128)=0;
        img(img>=128)=1;
        img=logical(img);
        
        modelWithName.model=fit_motorprograms(img,1,false,true,false);
        premodels{iClass,iTrain}=modelWithName;
        if verbose
            fprintf(1,'Train%d ',iTrain);
        end
    end
end
save('~/code/bpl/pmf/premodels.mat');