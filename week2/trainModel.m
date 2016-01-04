function [m, v] = trainModel(seq, r1,r2)
% This function trains a background segmentation model
% by using a range of images and modelling each pixel of the image
% as a random, gaussian variable

% We create the structure where we will store the total sum for the variance
% and the mean
total = im2double(rgb2gray(imread(strcat(seq,'/','input/in',sprintf('%06d',r1),'.jpg'))));

for i=r1+1:r2
    frame = im2double(rgb2gray(imread(strcat(seq,'/','input/in',sprintf('%06d',i),'.jpg'))));
    total = cat(3,total,frame);
end

m = mean(total,3);
v = var(total,0,3);

