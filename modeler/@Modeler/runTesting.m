function T=runTesting(iRun,numTests,models,iTestClass,iTest,testFolder,argsModeler,verbose)

[numClasses,numTrains]=size(models);
T.scores=zeros(numClasses,numTrains);
T.bestImages=cell(numClasses,numTrains);
T.bestThetas=cell(numClasses,numTrains);
T.times=cell(numClasses,numTrains);
T.wrong=0;
T.recommended=iTestClass;
imfolder=dir(fullfile(testFolder,num2str(iTestClass-1)));
imname=imfolder(2+(iRun-1)*numTests+iTest);
T.imname=imname.name;

img=imread(fullfile(testFolder,num2str(iTestClass-1),T.imname));
if 3==numel(size(img))
    img=rgb2gray(img);
end

img=imresize(img,[65,65]);
img=padarray(img,[20,20]);
img(img<128)=0;
img(img>=128)=1;
img=logical(img);
img_test=img;

trainClasses=[iTestClass,1:iTestClass-1,iTestClass+1:numClasses];

for iTrainClass_=1:numel(trainClasses)
    iTrainClass=trainClasses(iTrainClass_);
    
    for iTrain=1:numTrains
        model=models{iTrainClass,iTrain}.model;
        Mfit=MotorProgramFit(model.samples_type{1});
        Mfit.A=[1;1;0;0];
        Mfit.parameters.ink_ncon=3;
        Mfit.parameters.mAngle=0;        
        
        modeler=Modeler(argsModeler);
        modeler=modeler.setData(img_test);
        modeler=modeler.setModel(Mfit);
        
        subplot(1,3,1);imshow(img_test);title('data');
        subplot(1,3,2);imshow(modeler.mTrainModel.pimg);title('initialModel');
        drawnow;
        modeler=modeler.fitting();        
                
        T.scores(iTrainClass,iTrain)=modeler.mBestScore;
        
        if verbose
            if iTrain==1
                fprintf(1,'\nRun%d Test%d TestClass%d TrainClass%d: ',...
                    iRun,iTest,iTestClass,iTrainClass);
            else
                fprintf(' ');
            end
            fprintf(1,'%.2f',modeler.mBestScore);
        end
        
        fittedImage=modeler.mBestModel.pimg;
        subplot(1,3,3);imshow(fittedImage);title('finalModel');
        drawnow;
        
        fittedImage(fittedImage<0.5)=0;
        fittedImage(fittedImage>=0.5)=1;
        fittedImage=logical(fittedImage);
        T.bestImages{iTrainClass,iTrain}=fittedImage;
        T.bestThetas{iTrainClass,iTrain}=modeler.mBestTheta;
        T.times{iTrainClass,iTrain}=modeler.mTime;
        
        if max(T.scores(iTrainClass,:))>max(T.scores(iTestClass,:))
            T.wrong=1;
            T.recommended=iTrainClass;
            if verbose
                fprintf(' WRONG!!!!!!!!!!!!!');
            else
                fprintf(' Test%d-Class%d-WRONG!',iTestClass,iTrainClass);
            end
            return;
        end
        
    end
    
    
end
end