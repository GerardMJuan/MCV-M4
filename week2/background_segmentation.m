function [ res ] = background_segmentation(m, v, alpha, frame)
% Perform a segmentation of the image between background and foreground
% using the gaussian model defined by (m,v). 
% 1: Foreground
% 0: Background

res = abs(frame-m) >= alpha*(v + 2)
end

