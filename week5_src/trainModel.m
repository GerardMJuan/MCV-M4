function [m, v] = trainModel(seq,trainF)
% This function trains a background segmentation model
% by using a range of images and modelling each pixel of the image
% as a random, gaussian variable

% We create the structure where we will store the total sum for the variance
% and the mean

files = ListFiles(seq);
NumFrames = size(files,1);
NumFramesH = floor(NumFrames*trainF);

for i=1:NumFramesH;
    total(:,:,i) = double(rgb2gray(imread(strcat(seq,'/',files(i).name))));
end

m = mean(total,3);
v = var(total,0,3);

end

