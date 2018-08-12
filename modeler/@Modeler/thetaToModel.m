function obj=thetaToModel(obj,theta,M,list_sid)

if ~exist('list_sid','var')
    list_sid = 1:M.ns;
end

% pixel noise
M.epsilon=1e-4;

% image blur
M.blur_sigma=0.5;

count=1;


M.parameters.ink_ncon=theta(count);
count=count+1;

% rotation angle
M.parameters.mAngle=theta(count);
count=count+1;


% affine warp
x=count:count+1;
%M.A(1:2)=obj.mMaxGlobalScale.^vec(theta(x));
M.A(1:2)=vec(theta(x));
%M.A(3:4)=[0;0];
count=count+2;

for i=list_sid
    
    % stroke position
    x = count:count+1;
    if 1==i;
        M.A(3:4)=vec(theta(x));
        %globalShift=vec(theta(x))';
        globalShift=[0,0];
        M.S{i}.pos_token=obj.mTrainModel.S{i}.pos_token+globalShift;
        %M.S{i}.pos_token=vec(theta(x))';
        %shift=M.S{i}.pos_token-obj.mTrainModel.S{i}.pos_token;
    else
        M.S{i}.pos_token=obj.mTrainModel.S{i}.pos_token+globalShift+vec(theta(x))';
    end
    count = count+2;
    
    % sub-stroke shapes (token)
    nn = numel(M.S{i}.shapes_token);
    x = count:count+nn-1;
    M.S{i}.shapes_token = reshape(theta(x),size(M.S{i}.shapes_token));
    count = count + nn;
    
    % sub-stroke scales (token)
    nn = numel(M.S{i}.invscales_token);
    x = count:count+nn-1;
    %scales=obj.mMaxLocalScale.^theta(x).*obj.mTrainModel.S{i}.invscales_token;
    scales=theta(x).*obj.mTrainModel.S{i}.invscales_token;
    M.S{i}.invscales_token = reshape(scales,size(M.S{i}.invscales_token));
    %M.S{i}.invscales_token = reshape(theta(x),size(M.S{i}.invscales_token));
    count = count + nn;
    
    % sub-stroke angles (token)
    nn = numel(M.S{i}.angles_token);
    x = count:count+nn-1;
    M.S{i}.angles_token = reshape(theta(x),size(M.S{i}.angles_token));
    %M.S{i}.invscales_token = reshape(theta(x),size(M.S{i}.invscales_token));
    count = count + nn;
    
    % eval_spot_token
    if ~isempty(M.S{i}.R) && strcmp(M.S{i}.R.type,'mid')
        M.S{i}.R.eval_spot_token = theta(count);
        count = count + 1;
    end
end

end