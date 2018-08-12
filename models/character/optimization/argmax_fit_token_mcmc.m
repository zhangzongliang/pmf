function [maxscore,score0] = argmax_fit_token_mcmc(Mfit_init,lib)
% ARGMAX_FIT_TOKEN Fit a parse to an image, with token-level parameters
% only
% 
%  Mfit_init : instance of class MotorProgramFit
%
% Output:
%  scoreF : final score
%  score0 : initial score


    modeler=Modeler;
    modeler.data=3;
    % set up objective function
    Mfit = Mfit_init.copy();    

    % Set-up the optimization problem  
    [theta0,lb,ub] = model_to_vec_fit_token_mcmc(Mfit);    

    iterationBudget=1000;
    iteration=1;
    parent=theta0;
    score0=getscore(theta0,Mfit,lib);
    maxscore=score0;
    parentscore=score0;
    besttheta=parent;
    besttree=Mfit.copy();
    while iteration<iterationBudget;       
        child=modeler.reproduce(parent,lb,ub);
        childscore=getscore(child,Mfit,lib);
        acceptance=exp(childscore-parentscore);
        accepted=rand<acceptance;
        if accepted;
            parent=child;
            parentscore=childscore;
            if childscore>maxscore;
                maxscore=childscore
                besttheta=child;
                imshow(besttree.pimg);
            end
        end
        iteration=iteration+1;
    end   
    vec_to_model_fit_token(besttheta,Mfit_init);   
    scoreMP_fit(Mfit_init,lib);
    imshow(Mfit_init.pimg);
end

% fill the MotorProgram with parameters
% and then score
function score = getscore(theta,Mfit,lib)
    Qfit = Mfit.copy(); % we don't want to modify the shared MotorProgramFit base
    vec_to_model_fit_token(theta,Qfit);
    score = scoreMP_fit(Qfit,lib);    
    %minscore = -ll;
end