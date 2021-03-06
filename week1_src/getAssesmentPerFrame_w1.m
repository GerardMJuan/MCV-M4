function [ F1, TP_v, FP_v ] = getAssesmentPerFrame_w2( gt_dir, res_dir, test_prefix, range )
% This function gets basic assessment parameters
% comparing provided ground truth and obtained results.
% Key:
% 0 : Static
% 50 : Hard shadow
% 85 : Outside region of interest
% 170 : Unknown motion (usually around moving objects, due to semi-transparency and motion blur)
% 255 : Motion

F1 = zeros(size(range));
TP_v = zeros(size(range));
FP_v = zeros(size(range));
j = 1;

for i=range,
    TP = 0;
    FP = 0;
    TN = 0;
    FN = 0;
    % Read files
    gt_frame = imread(strcat(gt_dir,'/','gt',sprintf('%06d',i),'.png'));
    res_frame = imread(strcat(res_dir,'/',test_prefix,sprintf('%06d',i),'.png'));
    %Get dimensions of frame
    [dimX,dimY] = size(gt_frame);
    %For each pixel
    for px_i=1:dimX,
        for px_j=1:dimY,
            %If its POSITIVE and had to be POSITIVE it's TRUE POSITIVE
            if (gt_frame(px_i,px_j) == 255 && (res_frame(px_i,px_j) == 1));
                TP = TP + 1;
            %If its POSITIVE and had to be NEGATIVE it's FALSE POSITIVE
            elseif (gt_frame(px_i,px_j) < 255) && (res_frame(px_i,px_j) == 1);
                FP = FP + 1;
            %If its NEGATIVE and had to be NEGATIVE it's TRUE NEGATIVE
            elseif (gt_frame(px_i,px_j) < 255) && (res_frame(px_i,px_j) == 0);
                TN = TN + 1;
            %If its NEGATIVE and had to be POSITIVE it's FALSE NEGATIVE
            elseif (gt_frame(px_i,px_j) == 255) && (res_frame(px_i,px_j) == 0);
                FN = FN + 1;
            end;
        end;
    end;
    prec = TP/(TP+FP);  
    rec = TP/(TP+FN);
    F1(j) = 2*(prec*rec)/(prec+rec);
    TP_v(j) = TP;
    FP_v(j) = TP + FP;
    j = j + 1;
end;

end