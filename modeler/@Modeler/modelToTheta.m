function obj=modelToTheta(obj,M,list_sid)

if ~exist('list_sid','var')
    list_sid = 1:M.ns;
end

% count the number of parameters

ntot=4; % affine parameters , ink_ncon, and rotation
for i=list_sid
    ntot = ntot + 2; % for position
    ntot = ntot + numel(M.S{i}.shapes_token);
    ntot = ntot + numel(M.S{i}.invscales_token);
    %ntot = ntot + numel(M.S{i}.angles_token);
    ntot = ntot + numel(M.S{i}.invscales_token);% i.e. angles
    R = M.S{i}.R;
    if ~isempty(R) && strcmp(R.type,'mid')
        ntot = ntot + 1;
    end
end


obj.mThetaDescription=cell(ntot,1);
obj.mTrainTheta = zeros(ntot,1);
obj.mLb = -inf(ntot,1);
obj.mUb = inf(ntot,1);
count = 1;

% margin of error for inequalities
ee=1e-4;

obj.mThetaDescription{count}='ink_ncon';
obj.mTrainTheta(count)=M.parameters.ink_ncon;
obj.mLb(count) = 0;
obj.mUb(count) = obj.mMaxInk;

count = count + 1;

obj.mThetaDescription{count}='mAngle';
obj.mTrainTheta(count)=M.parameters.mAngle;
obj.mLb(count) = -obj.mMaxGlobalRotation;
obj.mUb(count) = obj.mMaxGlobalRotation;
obj.mSpecificParam=count;
count = count + 1;


%             % pixel noise
%             theta(count) = M.epsilon;
%             lb(count) = M.parameters.min_epsilon;
%             ub(count) = M.parameters.max_epsilon;
%             count = count + 1;
%
%             % image blur
%             theta(count) = M.blur_sigma;
%             lb(count) = M.parameters.min_blur_sigma;
%             ub(count) = M.parameters.max_blur_sigma;
%             count = count + 1;




assert(obj.mMaxGlobalScale>=1);
assert(obj.mMaxLocalScale>=1);

% affine warp
x = count:count+1;
obj.mTrainTheta(x) = M.A(1:2);
%obj.mTrainTheta(x) = [0;0];
%max_scale = M.parameters.max_affine_scale_change;
%max_scale = obj.mMaxScale;
%max_shift = M.parameters.max_affine_shift_change;
%lb(x) = [1/max_scale; 1/max_scale; -max_shift; -max_shift];
%ub(x) = [max_scale; max_scale; max_shift; max_shift];
obj.mLb(x)=1/obj.mMaxGlobalScale;
obj.mUb(x)=obj.mMaxGlobalScale;
%             obj.mLb(x)=[-1.0;-1.0];
%             obj.mUb(x)=[1.0;1.0];
obj.mThetaDescription(x)={'global scale'};
count=count+2;

for i=list_sid
    
    stk = M.S{i};
    
    % stroke position
    x=count:count+1;
    if 1==i;
        %                     obj.mTrainTheta(x)=stk.pos_token;
        %                     obj.mLb(x)=[0;-M.parameters.imsize(2)]+ee;
        %                     obj.mUb(x)=[M.parameters.imsize(1);0]-ee;
        obj.mTrainTheta(x)=[0;0];
        obj.mLb(x)=[-obj.mMaxGlobalShift;-obj.mMaxGlobalShift];
        obj.mUb(x)=[obj.mMaxGlobalShift;obj.mMaxGlobalShift];
    else
        obj.mTrainTheta(x)=[0;0];
        obj.mLb(x)=[-obj.mMaxLocalShift;-obj.mMaxLocalShift];
        obj.mUb(x)=[obj.mMaxLocalShift;obj.mMaxLocalShift];
    end
    
    obj.mThetaDescription(x)={['pos_token of stk_',num2str(i)]};
    count=count+2;
    
    
    % sub-stroke shapes (token)
    nn = numel(stk.shapes_token);
    x = count:count+nn-1;
    obj.mTrainTheta(x) = stk.shapes_token;
    obj.mLb(x)=obj.mTrainTheta(x)-obj.mControl;
    obj.mUb(x)=obj.mTrainTheta(x)+obj.mControl;
    
    obj.mThetaDescription(x)={['controls of stk_',num2str(i)]};
    count = count + nn;
    
    
    
    % sub-stroke scales (token)
    nn = numel(stk.invscales_token);
    x = count:count+nn-1;
    %theta(x) = stk.invscales_token;
    %obj.mTrainTheta(x) = zeros(nn,1);
    obj.mTrainTheta(x) = ones(nn,1);
    %obj.mLb(x) = -1+ee;
    %obj.mUb(x) = 1-ee;
    obj.mLb(x)=1/obj.mMaxLocalScale;
    obj.mUb(x)=obj.mMaxLocalScale;
    obj.mThetaDescription(x)={['scale(s) of stk_',num2str(i)]};
    count = count + nn;
    
    % sub-stroke angles (token)
    if isempty(stk.angles_token)
        stk.angles_token=zeros(size(stk.invscales_token));
    end
    nn = numel(stk.angles_token);
    x = count:count+nn-1;
    obj.mTrainTheta(x) = stk.angles_token;
    %theta(x) = zeros(nn,1);
    obj.mLb(x) = -obj.mMaxLocalRotation;
    obj.mUb(x) = obj.mMaxLocalRotation;
    obj.mThetaDescription(x)={['rotate angle(s) of stk_',num2str(i)]};
    count = count + nn;
    
    % eval_spot_token
    if ~isempty(stk.R) && strcmp(stk.R.type,'mid')
        obj.mTrainTheta(count) = stk.R.eval_spot_token;
        ncpt = size(stk.shapes_token,1);
        %[~,obj.mLb(count),obj.mUb(count)] = bspline_gen_s(ncpt,1);
        obj.mLb(count)=2; obj.mUb(count)=2;
        obj.mThetaDescription(count)={['eval_spot_token of stk_',num2str(i)]};
        count = count + 1;
    end
end

assert(numel(obj.mTrainTheta)==ntot);

obj.mVariables=[];
for i=1:numel(obj.mTrainTheta)
    if obj.mLb(i)<obj.mUb(i)
        obj.mVariables=[obj.mVariables;i];
    elseif obj.mLb(i)>obj.mUb(i)
        assert(false);
    end
end
end