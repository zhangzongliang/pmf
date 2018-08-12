%clc;
clear;close all;


% irun = 9; % run index (1...20)
% itrain = 9; % training item index (1...20)
% itest = 9; % test item index (1...20)

iter=20000;
popSize=1;
control=15;
shift=30;

% load('items_classification','cell_train','cell_test');
% 
% cell_test_grossOutlier1=cell_test;
% gross=1;
% for irun=1:20;
%     for itest=1:20;
%         img_test = cell_test{irun}{itest}.img;
%         img_test=Modeler.addGrossOutliers(img_test,gross);
%         cell_test_grossOutlier1{irun}{itest}.img=img_test;
%     end
% end
% save('items_classification_pmf.mat','cell_train','cell_test','cell_test_grossOutlier1');

load('items_classification_pmf','cell_train','cell_test','cell_test_grossOutlier1');
lib = loadlib;

results=cell(20,3);
for irun=1:1:20;
    results{irun,1}=zeros(20,21);
    results{irun,2}=cell(20,20);
    wrong=0;
    for itest=1:1:20;        
        img_test_clean=cell_test{irun}{itest}.img;
        img_test = cell_test_grossOutlier1{irun}{itest}.img;        
        %figure;imshow(img_test);
        scores=zeros(1,20);
        trains=[itest,1:itest-1,itest+1:20];
        for itrain_=1:numel(trains);           
            itrain=trains(itrain_);
            img_train = cell_train{irun}{itrain}.img;           
                        
            % load previous model fit
            fn_fit_train = fullfile('model_fits',makestr('run',irun,'_train',itrain,'_G'));
            load(fn_fit_train,'G');
                        
            Mfit=MotorProgramFit(G.samples_type{1});
            Mfit.A=[1;1;0;0];
            Mfit.parameters.ink_ncon=2;

            modeler=Modeler();
            modeler.mIRun=irun;
            modeler.mITest=itest;
            modeler.mITrain=itrain;
            modeler.mPopulationSize=popSize;
            modeler.mIterationTol=iter;
            modeler.mControl=control;
            modeler.mShift=shift;
            modeler=modeler.setData(img_test);            
            modeler=modeler.setModel(Mfit);
            modeler=modeler.evolveV2();
            %modeler=modeler.cuckooSearch();

            scores(itrain)=modeler.mBestScore;
            %results{irun,2}{itest,itrain}=modeler;
            fprintf([num2str(modeler.mBestScore), ' ']);
            subplot(2,2,1);imshow(img_test_clean);title('clean');
            subplot(2,2,2);imshow(img_test);title('noisy');
            subplot(2,2,3);imshow(modeler.mTrainModel.pimg);title('initial');
            subplot(2,2,4);imshow(modeler.mBestModel.pimg);title('final');
            
            if itrain~=itest
                if scores(itrain)>scores(itest)
                    wrong=wrong+1;
                    break;
                end
            end
        end
        
        [~,I]=max(scores);                
        fprintf(['\nirun=',num2str(irun),' itest=',num2str(itest),...
            ' proposed=',num2str(I),' wrong=',num2str(wrong),'\n']);
        results{irun,1}(itest,1:20)=scores;
        results{irun,1}(itest,21)=I;
        results{irun,3}=wrong;
        save(['results_pmf_iter',num2str(iter),'_ctrl',num2str(control),...
            '_popSize',num2str(popSize),'.mat'],'results');
    end
end
save(['results_pmf_iter',num2str(iter),'_ctrl',num2str(control),...
    '_popsize',num2str(popSize),'.mat'],'results');