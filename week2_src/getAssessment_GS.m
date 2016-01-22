function [ assessment ] = getAssessment_GS( gt_dir, Sequence, T1, T2 )
% This function gets basic assessment parameters
% comparing provided ground truth and obtained results.
% Key:
% 0 : Static
% 50 : Hard shadow
% 85 : Outside region of interest
% 170 : Unknown motion (usually around moving objects, due to semi-transparency and motion blur)
% 255 : Motion
TP = 0;
FP = 0;
TN = 0;
FN = 0;

res_files = ListFiles(gt_dir);

for i=T1:T2,
    % Read files
     gt_frame = (imread(strcat(gt_dir,'/',res_files(i).name)));
    res_frame = logical(Sequence(:,:,i))*255;
    %Get dimensions of frame
    [dimX,dimY] = size(gt_frame);
    %For each pixel
    for px_i=1:dimX,
        for px_j=1:dimY,
            %If its POSITIVE and had to be POSITIVE it's TRUE POSITIVE
            if (gt_frame(px_i,px_j) == 255 && (res_frame(px_i,px_j) == 255));
                TP = TP + 1;
            %If its POSITIVE and had to be NEGATIVE it's FALSE POSITIVE
            elseif (gt_frame(px_i,px_j) <= 50) && (res_frame(px_i,px_j) == 255);
                FP = FP + 1;
            %If its NEGATIVE and had to be NEGATIVE it's TRUE NEGATIVE
            elseif (gt_frame(px_i,px_j) <= 50) && (res_frame(px_i,px_j) == 0);
                TN = TN + 1;
            %If its NEGATIVE and had to be POSITIVE it's FALSE NEGATIVE
            elseif (gt_frame(px_i,px_j) == 255) && (res_frame(px_i,px_j) == 0);
                FN = FN + 1;
            end;
        end;
    end;
end;
prec = TP/(TP+FP);
rec = TP/(TP+FN);
F1 = 2*(prec*rec)/(prec+rec);
assessment = struct('TP',TP,'FP',FP,'TN',TN,'FN',FN,'prec',prec,'rec',rec,'F1',F1);
end