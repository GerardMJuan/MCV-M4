function [par,P,RC,F1 ] = getAssessmentAdapt_w2(m,v,alpha,p,dir,~,range)
% This function provides with an assessment of the model trained before, with  
% adaptability in each frame
TP = 0;
FP = 0;
TN = 0;
FN = 0;
for i=range,
    % Read files
    gt_frame = imread(strcat(dir,'/groundtruth/gt',sprintf('%06d',i),'.png'));
    frame = double(rgb2gray(imread(strcat(dir,'/input/in',sprintf('%06d',i),'.jpg'))));
    
    % get the results from the model
    res_frame = abs(frame-m) >= alpha*(sqrt(v) + 2);
    
    % adapt the model
    [m,v] = adaptModel_w2(m,v,p,res_frame,frame);
    
    %Get dimensions of frame
    [dimX,dimY] = size(gt_frame);
    %For each pixel
    for px_i=1:dimX,
        for px_j=1:dimY,
            gt = gt_frame(px_i,px_j);
            res = res_frame(px_i,px_j);
            %If its FOREGROUND and had to be FOREGROUND it's TRUE POSITIVE
            if (gt == 255 && (res));
                TP = TP + 1;
            %If its FOREGROUND and had to be BACKGROUND it's FALSE POSITIVE
            elseif (gt == 0 || gt == 50) && (res);
                FP = FP + 1;
            %If its BACKGROUND and had to be BACKGROUND it's TRUE NEGATIVE
            elseif (gt == 0 || gt == 50) && (~res);
                TN = TN + 1;
            %If its BACKGROUND and had to be FOREGROUND it's FALSE NEGATIVE
            elseif (gt == 255) && (~res);
                FN = FN + 1;
            end;
        end;
    end;
end;
P = TP/(TP+FP);
RC = TP/(TP+FN);
F1 = 2*(P*RC)/(P+RC);
par = struct('TP',TP,'FP',FP,'TN',TN,'FN',FN);
end