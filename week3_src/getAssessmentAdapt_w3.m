function [par,P,RC,F1,Q] = getAssessmentAdapt_w3(m,v,alpha,p,dir,~,range,Pixel,SE)
% This function provides with an assessment of the model trained before, with  
% adaptability in each frame
TP = 0;
FP = 0;
TN = 0;
FN = 0;
FG = 0;
GT = 0;
k = 1;
for i=range,
    % Read files
    gt_frame = imread(strcat(dir,'/groundtruth/gt',sprintf('%06d',i),'.png'));
    frame = double(rgb2gray(imread(strcat(dir,'/input/in',sprintf('%06d',i),'.jpg'))));
    
    % get the results from the model
    res_frame = abs(frame-m) >= alpha*(sqrt(v) + 2);

    % (week 3 task 1) fill the task
    res_frame = imfill(res_frame,8,'holes');
    res_frame = bwareaopen(res_frame,Pixel);
    res_frame = imclose(res_frame,SE);
    % adapt the model
    [m,v] = adaptModel_w3(m,v,p,res_frame,frame);

    %Get dimensions of frame
    [dimX,dimY] = size(gt_frame);
    %Standard evaluation of the image
    %For each pixel
    for px_i=1:dimX,
        for px_j=1:dimY,
            gt = gt_frame(px_i,px_j);
            res = res_frame(px_i,px_j);
            %If its FOREGROUND and had to be FOREGROUND it's TRUE POSITIVE
            if (gt == 255 && (res));
                TP = TP + 1;
                FG(k) = 1;
                GT(k) = 1;
                k = k + 1;
            %If its FOREGROUND and had to be BACKGROUND it's FALSE POSITIVE
            elseif (gt == 0 || gt == 50) && (res);
                FP = FP + 1;
                FG(k) = 1;
                GT(k) = 0;
                k = k + 1;
            %If its BACKGROUND and had to be BACKGROUND it's TRUE NEGATIVE
            elseif (gt == 0 || gt == 50) && (~res);
                TN = TN + 1;
                FG(k) = 0;
                GT(k) = 0;
                k = k + 1;
            %If its BACKGROUND and had to be FOREGROUND it's FALSE NEGATIVE
            elseif (gt == 255) && (~res);
                FN = FN + 1;
                FG(k) = 0;
                GT(k) = 1;
                k = k + 1;
            end;
        end;
    end;
end;

P = TP/(TP+FP);
RC = TP/(TP+FN);
F1 = 2*(P*RC)/(P+RC);
par = struct('TP',TP,'FP',FP,'TN',TN,'FN',FN);
Q = WFb(double(FG),logical(GT));
if(isnan(P))
    P = 0;
end
if(isnan(RC))
    RC = 0;
end
end