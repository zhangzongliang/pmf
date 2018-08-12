% Demo of fitting a motor program to an image.
clc;clear;close all;
% Parameters
K = 5; % number of unique parses we want to collect
verbose = true; % describe progress and visualize parse?
include_mcmc = false; % run mcmc to estimate local variability?
fast_mode = true; % skip the slow step of fitting strokes to details of the ink?

if fast_mode
    fprintf(1,'Fast mode skips the slow step of fitting strokes to details of the ink.\n');
    warning_mode('Fast mode is for demo purposes only and was not used in paper results.');
end

load('Phi_img','img');
% load('cross_img','img');
K=rand(size(img))>0.9;
figure;imshow(K);
figure;imshow(img);
figure;imshow(img+K);
img=img+K;
% 
% B=imread('test_image.png');
% % B=imnoise(B,'gaussian',0,0.1);
% % B=imnoise(B,'salt & pepper',0.1);
% imshow(B);
% % x=rgb2gray(B);
% y=B;
% % y=imresize(B,[105,105]);
% y(y<128)=0;
% y(y>=128)=1;
% % imshow(y,[0,1]);
% z=logical(y);
% img=z;
% imshow(img);
% test=find(img==1);
% % img=make_square_image('ppgmf/english/Hnd/Img/Sample029/img029-007');
% % imshow(img);

    T = thinner(img); % get thinned image
    figure;imshow(T);
    convertImageToPointCloud(T);

G = fit_motorprograms(img,K,verbose,include_mcmc,fast_mode);

