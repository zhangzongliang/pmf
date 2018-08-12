clc;clear;close all;
irun = 7; % run index (1...20)
itrain = 1; % training item index (1...20)
itest = 1; % test item index (1...20)

motorprogramFileName=['/home/zzl/code/bpl/bpl/classification/model_fits/run',...
    num2str(irun),'_train',num2str(itrain),'_G.mat'];
load(motorprogramFileName);
load('items_classification','cell_train','cell_test');

% img=G.models{1}.pimg;
% figure;imshow(img);
% img_train = cell_train{irun}{itrain}.img;
% img_test = cell_test{irun}{itest}.img;
% figure;imshow(img_train);
% figure;imshow(img_test);

for irun=1:20;
    for i=1:20;
        img=cell_test{irun}{i}.img;
        T = thinner(img); % get thinned image
        cloudFolder=['procedural_model_fitting/point_clouds/run',...
            num2str(irun)];
        mkdir(cloudFolder);
        cloudFileName=[cloudFolder,'/test',num2str(i),'.ply'];
        convertImageToPointCloud(T,cloudFileName);
        
        motorprogramFileName=['/home/zzl/code/bpl/bpl/classification/model_fits/run'...
            ,num2str(irun),'_test',num2str(i),'_G.mat'];
        load(motorprogramFileName);
        
        img=G.models{1}.pimg;
        imageFolder=['procedural_model_fitting/images/run',num2str(irun)];
        mkdir(imageFolder);
        imageFileName=[imageFolder,'/test',num2str(i),'.png'];
        imwrite(img,imageFileName);
        
        parameterFolder=['procedural_model_fitting/model_parameters/run',...
            num2str(irun)];
        mkdir(parameterFolder);
        parameterFileName=[parameterFolder,'/test',num2str(i),'.txt'];
        write_motorprogram_to_file(G.models{1},parameterFileName);
        
    end
    
    for i=1:20;
        img=cell_train{irun}{i}.img;
        T = thinner(img); % get thinned image
        cloudFolder=['procedural_model_fitting/point_clouds/run',...
            num2str(irun)];
        mkdir(cloudFolder);
        cloudFileName=[cloudFolder,'/train',num2str(i),'.ply'];
        convertImageToPointCloud(T,cloudFileName);
        
        motorprogramFileName=['/home/zzl/code/bpl/bpl/classification/model_fits/run'...
            ,num2str(irun),'_train',num2str(i),'_G.mat'];
        load(motorprogramFileName);
        
        img=G.models{1}.pimg;
        imageFolder=['procedural_model_fitting/images/run',num2str(irun)];
        mkdir(imageFolder);
        imageFileName=[imageFolder,'/train',num2str(i),'.png'];
        imwrite(img,imageFileName);
        
        parameterFolder=['procedural_model_fitting/model_parameters/run',...
            num2str(irun)];
        mkdir(parameterFolder);
        parameterFileName=[parameterFolder,'/train',num2str(i),'.txt'];
        write_motorprogram_to_file(G.models{1},parameterFileName);
        
    end
end


% for i=1:20;
%     img=cell_train{irun}{i}.img;
%     T = thinner(img); % get thinned image
%     cloudFileName=['procedural_model_fitting/point_clouds/run',...
%         num2str(irun),'_train',num2str(i),'.ply'];
%     convertImageToPointCloud(T,cloudFileName);
% end
%
% for i=1:20;
%     motorprogramFileName=['/home/zzl/code/bpl/bpl/classification/model_fits/run'...
%         ,num2str(irun),'_train',num2str(i),'_G.mat'];
%     load(motorprogramFileName);
%     img=G.models{1}.pimg;
%     figure;imshow(img);
%     parameterFileName=['procedural_model_fitting/model_parameters/run',...
%         num2str(irun),'_train',num2str(i),'.txt'];
%     write_motorprogram_to_file(G.models{1},parameterFileName);
% end