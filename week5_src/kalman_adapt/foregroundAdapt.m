function [res_frame, m, v] = foregroundAdapt(m,v,alpha,p,frame,Pixel,SE)
% This function provides with an assessment of the model trained before, with
% adaptability in each frame

frame = double(rgb2gray(frame));

% get the results from the model
res_frame = abs(frame-m) >= alpha*(sqrt(v) + 2);

% (week 3 task 1) fill the task
res_frame = imfill(res_frame,8,'holes');
res_frame = bwareaopen(res_frame,Pixel);
res_frame = imclose(res_frame,SE);

% adapt the model
[m,v] = adaptModel(m,v,p,res_frame,frame);

end