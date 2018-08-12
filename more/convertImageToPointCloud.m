% function cloud=convertImageToPointCloud(image)
% ind=find(image==1);
% [x,y]=ind2sub(size(image),ind);
% pad=zeros(numel(x),1);
% % cloud=[x,y,pad];
% cloud=[y,x,pad];
% pcwrite(pointCloud(cloud),'cloud.ply','PLYFormat','binary');
% end

% converse Y variable
% original bayesian program learning (the science paper)
function cloud=convertImageToPointCloud(image,fileName)
ind=find(image==1);
[x,y]=ind2sub(size(image),ind);
pad=zeros(numel(x),1);
newy=1-x;
newx=y-1;
cloud=[newx,newy,pad];
% pcwrite(pointCloud(cloud),fileName,'PLYFormat','ascii');
pcwrite_float(cloud,fileName)

% % replace property double to float
% % Read txt into cell A
% fid = fopen(fileName,'r');
% i = 1;
% tline = fgetl(fid);
% A{i} = tline;
% while ischar(tline)
%     i = i+1;
%     tline = fgetl(fid);
%     A{i} = tline;
% end
% fclose(fid);
% 
% % Change cell A
% A{4}='property float x';
% A{5}='property float y';
% A{6}='property float z';
% 
% % Write cell A into txt
% fid = fopen(fileName, 'w');
% for i = 1:numel(A)
%     if A{i+1} == -1
%         fprintf(fid,'%s', A{i});
%         break
%     else
%         fprintf(fid,'%s\n', A{i});
%     end
% end

end

function pcwrite_float(cloud,fileName)
fid = fopen(fileName, 'w');
fprintf(fid,'ply\n');
fprintf(fid,'format ascii 1.0\n');
fprintf(fid,'element vertex %d\n',size(cloud,1));
fprintf(fid,'property float x\n');
fprintf(fid,'property float y\n');
fprintf(fid,'property float z\n');
fprintf(fid,'end_header\n');
for i=1:size(cloud,1);
    fprintf(fid,'%.4f %.4f %.4f\n',cloud(i,:));
end
fclose(fid);
end
















