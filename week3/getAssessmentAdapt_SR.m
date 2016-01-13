function [ P,RC,F1 ] = getAssessmentAdapt_SR(m,v,alpha,p,dir,range,th,Pixel,method)
% This function provides with an assessment of the model trained before, with  
% adaptability in each frame
TP = 0;
FP = 0;
TN = 0;
FN = 0;

% nameVideo = strcat('video-',dir,'-',method,'.avi');
% video = VideoWriter(nameVideo);
% video.FrameRate = 8;
% open(video)

for i=range,
    % Read files
    gt_frame = imread(strcat(dir,'/groundtruth/gt',sprintf('%06d',i),'.png'));
    frame = double((imread(strcat(dir,'/input/in',sprintf('%06d',i),'.jpg'))));
    frame_r = frame(:,:,1);
    frame_g = frame(:,:,2);
    frame_b = frame(:,:,3);
    
    m_r = m(:,:,1); m_g = m(:,:,2); m_b = m(:,:,3);
    v_r = v(:,:,1); v_g = v(:,:,2); v_b = v(:,:,3);
    
    
    
    % get the results from the model
    res_frame_r = abs(frame_r-m_r) >= alpha*(sqrt(v_r) + 2);
    res_frame_g = abs(frame_g-m_g) >= alpha*(sqrt(v_g) + 2);
    res_frame_b = abs(frame_b-m_b) >= alpha*(sqrt(v_b) + 2);
    res_frame = res_frame_r & res_frame_g & res_frame_b;
    
    % fill the task
    res_frame = imfill(res_frame,4,'holes');
    res_frame = bwareaopen(res_frame,Pixel);
    
    
%     figure(1)
%     subplot(2,2,1);
%     imshow(imread(strcat(dir,'/input/in',sprintf('%06d',i),'.jpg')));
%     title('Original Image')
%     
%     subplot(2,2,2);
%     imshow(res_frame)
%     title('Mask without Shadow Removing')
    
    
    res_frame = ShadowRemoval(frame, m, res_frame, th, method);
    
    
%     subplot(2,2,4);
%     imshow(res_frame)
%     title('Final Mask')   
    
    
    % adapt the model
    [ m,v ] = adaptModel_rgb(m,v,p,res_frame_r,res_frame_g,res_frame_b,frame);
            
    
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
    pause(0.001)
    
%     fotograma = getframe(gcf);
%     writeVideo(video,fotograma);
end;
P = TP/(TP+FP);
RC = TP/(TP+FN);
F1 = 2*(P*RC)/(P+RC);
% close(video)
end