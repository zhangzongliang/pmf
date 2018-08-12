function img=make_square_image(imname)
% clc;clear;close all;

% imname='digits/0/img001-001';
inputname=strcat(imname,'.png');
outputname=strcat(imname,'_square.png');
im=imread(inputname);
[s1,s2,~]=size(im);
white=im(1,1,:);
for i=1:3;
    white(i)=255;
end
top=s1;bottom=1;left=s2;right=1;
for i=1:s1
    for j=1:s2
        %first figure
        if ~isequal(white,im(i,j,:))
            top=min(i,top);
            left=min(j,left);
            bottom=max(i,bottom);
            right=max(j,right);
        end
    end
end


newim=im(top:bottom,left:right,:);
% imwrite(newim,outputname);

x=rgb2gray(newim);
[d1,d2]=size(x);
% d_pad=floor(max(d1,d2)/4);
d_pad=50;
if d1>d2;
    x_pad=padarray(x,[d_pad,floor(d_pad+(d1-d2)/2)],255);
else
    x_pad=padarray(x,[floor(d_pad+(d2-d1)/2),d_pad],255);
end

y=imresize(x_pad,[105,105]);
y(y<128)=1;
y(y>=128)=0;
z=logical(y);
img=z;
% imshow(img)
imwrite(img,outputname);
end