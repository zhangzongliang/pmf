clc;clear;close all;

use_precomputed = true; % (yes/no) use pre-computed results?

load('items_classification_pmf','cell_train','cell_test','cell_test_grossOutlier1');
lib = loadlib;

results=cell(20,2);
gross=1;
for irun=1:1;
    results{irun,1}=zeros(20,21);
    results{irun,2}=cell(20,2);
    for itest=3:3;
        img_test = cell_test{irun}{itest}.img;        
        subplot(2,2,1);imshow(img_test);title('clean');
        results{irun,2}{itest,1}=img_test;
        img_test=cell_test_grossOutlier1{irun}{itest}.img;
        subplot(2,2,2);imshow(img_test);title('noisy');            
        results{irun,2}{itest,2}=img_test;
        scores=zeros(1,20);
        for itrain=14:14;
            
            % load previous model fit
            fn_fit_train = fullfile('model_fits',makestr('run',irun,'_train',itrain,'_G'));
            load(fn_fit_train,'G');
            K = length(G.models); % add image to model class (removed to save memory)
            for i=1:K
                G.models{i}.I = G.img;
            end
            subplot(2,2,3);imshow(G.img);title('initial');
            % refit models to new image
            K=1;
            Mbest = cell(K,1);
            fit_score = nan(K,1);
            prior_score = G.scores;
            for i=1:K
                %fprintf(1,'re-fitting parse %d of %d\n',i,K);
                [Mbest{i},fscore] = FitNewExemplar(img_test,G.samples_type{i},lib,true,false);
                fit_score(i) = fscore;
            end
            itrain
            fscore
            subplot(2,2,4);imshow(Mbest{1}.pimg);title('final');
            % save output structure
            pair = struct;
            pair.Mbest = Mbest;
            pair.fit_score = fit_score;
            pair.prior_score = prior_score;
            scores(itrain)=max(pair.fit_score);
            
        end;
        
        
        [~,I]=max(scores);
        fprintf(['\nirun=',num2str(irun),' itest=',num2str(itest), ' proposed=',num2str(I)]);
        results{irun,1}(itest,1:20)=scores;
        results{irun,1}(itest,21)=I;
        save(['results_bpl_gross',num2str(gross),'.mat'],'results');
    end;
end;

save(['results_bpl_gross',num2str(gross),'.mat'],'results');

%%% precompute, including type level score

% for irun=1:20;
%     results{irun,1}=zeros(20,21);
%     for itest=1:20;
%         
%         scores=zeros(1,20);
%         for itrain=1:20;
%             
%             fn_refit_test = fullfile('model_refits',makestr('run',irun,'_fit_train' ,itrain,'_to_image_test',itest));
%             if ~exist([fn_refit_test,'.mat'],'file')
%                 fprintf(1,'Please download pre-computed model results to use this feature. Program quiting...\n');
%                 return
%             end
%             load(fn_refit_test,'pair');
%             scores(itrain)=max(pair.fit_score);
%         end;
%         
%         
%         [~,I]=max(scores);
%         fprintf(['\nirun=',num2str(irun),' itest=',num2str(itest), ' proposed=',num2str(I)]);
%         results{irun,1}(itest,1:20)=scores;
%         results{irun,1}(itest,21)=I;
%         
%     end;
% end;