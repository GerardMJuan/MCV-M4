function [ m, v ] = trainModel_rgb(seq)
% This function trains a background segmentation model
% by using a range of images and modelling each pixel of the image
% as a three random, gaussian variable, one per channel.

% We create the structure where we will store the total sum for the variance
% and the mean

files = ListFiles(strcat(seq,'/input/'));
NumFrames = size(files,1);
NumFramesH = floor(NumFrames/2);
for i=1:NumFramesH
    frame = double(imread(strcat(seq,'/input/',files(i).name)));
    total_r(:,:,i) = frame(:,:,1);
    total_g(:,:,i) = frame(:,:,2);
    total_b(:,:,i) = frame(:,:,3);
end

m(:,:,1) = mean(total_r,3);
v(:,:,1) = var(total_r,0,3);

m(:,:,2) = mean(total_g,3);
v(:,:,2) = var(total_g,0,3);

m(:,:,3) = mean(total_b,3);
v(:,:,3) = var(total_b,0,3);


end

