function [ m_y, v_y, m_u, v_u, m_v, v_v ] = trainModel_yuv(seq)
% This function trains a background segmentation model
% by using a range of images and modelling each pixel of the image
% as a three random, gaussian variable, one per channel.

% We create the structure where we will store the total sum for the variance
% and the mean

files = ListFiles(strcat(seq,'/input/'));
NumFrames = size(files,1);
NumFramesH = floor(NumFrames/2);
for i=1:NumFramesH
    frame = double(rgb2yuv(imread(strcat(seq,'/input/',files(i).name))));
    total_y(:,:,i) = frame(:,:,1);
    total_u(:,:,i) = frame(:,:,2);
    total_v(:,:,i) = frame(:,:,3);
end

m_y = mean(total_y,3);
v_y = var(total_y,0,3);

m_u = mean(total_u,3);
v_u = var(total_u,0,3);

m_v = mean(total_v,3);
v_v = var(total_v,0,3);


end

