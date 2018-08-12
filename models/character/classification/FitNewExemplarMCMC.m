function [Mfit,score_fit] = FitNewExemplarMCMC(I,samples,lib,auto_affine,fit_affine_only)
% FitNewExemplar Fit samples of MotorProgram types 
% to a new image "I" of a new character
%
% Input
%   I : image
%   samples [K x 1 cell]: multiple MotorPrograms as output of MCMC on type-leve
%   parametrs
%   lib : 
%   auto_affine: initialize the affine warp automatically
%   fit_affine_only: fit only the affine warp parameters
%
% Output
%   Mfit: returns an object of type MotorProgramFit   
%
    if ~exist('auto_affine','var')
       auto_affine = true; 
    end
    if ~exist('fit_affine_only','var')
       fit_affine_only = false; 
    end

    Mfit = MotorProgramFit(samples);
    Mfit.I = I;
    
        
%     %//// begin of procedural model fitting
% %     close all;
%      figure;imshow(I);
%     data=imresize(I,0.5);
% %     figure;imshow(data);
%     ind=find(data==1);
%     [x,y]=ind2sub(size(data),ind);    
%     cloud=[x,y];
%     z=zeros(size(y));  
%     matCloud=pointCloud([cloud,z]);
%     pcwrite(matCloud,'data.ply','PLYFormat','ascii');
%     Mfit.mKDTree=KDTreeSearcher(cloud);
%     Mfit.mScoreType='mean_measure';
%     %/// end of procedural model fitting
    
    
    % initialize the affine warp
    if auto_affine
        UtilMP.set_affine_to_image(Mfit,I);
    end
    
%     % blur out the image before starting
%     Mfit.blur_sigma = Mfit.parameters.max_blur_sigma;
%     Mfit.epsilon = 1e-2;
    
    
    modeler=Modeler();
    modeler=modeler.setData(I);
    modeler=modeler.setModel(Mfit);
    modeler=modeler.evolve();
    
    
    if strcmp(Mfit.mScoreType,'mean_measure');
        score_fit = argmax_fit_token_mcmc(Mfit,lib);
        return;
    end
    % do the optimization
    if fit_affine_only % AFFINE
        argmax_fit_affine(Mfit,lib);
        score_fit = scoreMP_fit(Mfit,lib);
    else % REGULAR
        score_fit = argmax_fit_token(Mfit,lib);        
    end
    
end