function t=setModel(t,train)
assert(isa(train,'MotorProgramFit'));
t.mTrainModel=train.copy();
t.mTempModel=train.copy();
t=t.modelToTheta(train);
t.mTrainScore=t.computeScore(t.mTrainTheta);
%obj.mTrainScore=CPD.score_image(obj.mDataImage,obj.mTrainModel.pimg);
%matCloud=obj.imageTo3DCloud(obj.mTrainModel.pimg);
%pcwrite(matCloud,'mTrainModel.ply','PLYFormat','binary');
end