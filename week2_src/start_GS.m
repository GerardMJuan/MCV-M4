clc,clear

dir = 'highway/input';          % Location of the original images
gt_dir = 'highway/groundtruth'; % Location of the groundtruth
K = 3:6;
th=0.1:0.1:1;
LR = [0.005,0.01, 0.05, 0.1, 0.5];

T1 = 1050; %init value
T2 = 1350; %final value
T3 = 1201; %medium value
morpho = 0; %if mopho is 1 apply an opening
se = strel('square', 3);

files=ListFiles(dir);

for l = 1:length(LR)
    for j = 1:length(th)
        for k = 1:length(K)
            foregroundDetector = vision.ForegroundDetector('NumGaussians', K(k), 'NumTrainingFrames', 150,'LearningRate',LR(l),'MinimumBackgroundRatio',th(j));
            for i = T1:T2
                frame = rgb2gray(imread(strcat(dir,'/',files(i).name))); % read the next video frame
                foreground(:,:,i) = step(foregroundDetector, frame);
                if morpho
                    foreground(:,:,i) = imopen(foreground(:,:,i), se);
                end
            end
            assessment = getAssessment_GS(gt_dir,foreground, T3, T2);
            TP(k,j,l) = assessment.TP;
            TN(k,j,l) = assessment.TN;
            FP(k,j,l) = assessment.FP;
            FN(k,j,l) = assessment.FN;
            prec(k,j,l) = assessment.prec;
            rec(k,j,l) = assessment.rec;
            F1(k,j,l) = assessment.F1;
        end
    end
end