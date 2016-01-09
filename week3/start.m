clc,clear

dir = 'fall/input';          % Location of the original images
gt_dir = 'fall/groundtruth'; % Location of the groundtruth
K = 3;

%Highway optimal
%th=0.4;
%LR = 0.01;
%Fall optimal
th=0.5;
LR = 0.05;
%Traffic optimal
% th=0.6;
% LR = 0.05;

conn = 4;

%Highway range
%T1 = 1050; %init value
%T2 = 1350; %final value
%T3 = 1200; %medium value

%Fall range
T1 = 1460; %init value
T2 = 1560; %final value
T3 = 1510; %medium value

%Traffic range
% T1 = 950; %init value
% T2 = 1560; %final value
% T3 = 1000; %medium value

files=ListFiles(dir);

foregroundDetector = vision.ForegroundDetector('NumGaussians', K, 'NumTrainingFrames', 150,'LearningRate',LR,'MinimumBackgroundRatio',th);
    for i = T1:T2
        frame = rgb2gray(imread(strcat(dir,'/',files(i).name))); % read the next video frame
        foreground(:,:,i) = step(foregroundDetector, frame);
        foreground(:,:,i) = imfill(foreground(:,:,i),conn,'holes');
    end
            assessment = getAssessment_GS(gt_dir,foreground, T3, T2);