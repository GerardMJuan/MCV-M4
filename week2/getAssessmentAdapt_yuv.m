function [ P,RC,F1 ] = getAssessmentAdapt_yuv(m_y, v_y, m_u, v_u, m_v, v_v,alpha,p,dir,~,range)
% This function provides with an assessment of the model trained before, with  
% adaptability in each frame
TP = 0;
FP = 0;
TN = 0;
FN = 0;
for i=range,
    % Read files
    gt_frame = imread(strcat(dir,'/groundtruth/gt',sprintf('%06d',i),'.png'));
    frame = double((imread(strcat(dir,'/input/in',sprintf('%06d',i),'.jpg'))));
    frame_r = frame(:,:,1);
    frame_g = frame(:,:,2);
    frame_b = frame(:,:,3);
    
    % get the results from the model
    res_frame_y = abs(frame_r-m_y) >= alpha*(sqrt(v_y) + 2);
    res_frame_u = abs(frame_g-m_u) >= alpha*(sqrt(v_u) + 2);
    res_frame_v = abs(frame_b-m_v) >= alpha*(sqrt(v_v) + 2);
    res_frame = res_frame_y | res_frame_u | res_frame_v;
    
    % adapt the model
    [m_y, v_y, m_u, v_u, m_v, v_v] = adaptModel_yuv(m_y, v_y, m_u, v_u, m_v, v_v,p,res_frame,frame);
    
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
end