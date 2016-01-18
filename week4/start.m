% Load the targe frames (sequence 1)
A1 = imread('data_stereo_flow/training/image_0/000045_10.png');
A2 = imread('data_stereo_flow/training/image_0/000045_11.png');

% Load the targe frames (sequence 2)
B1 = imread('data_stereo_flow/training/image_0/000157_10.png');
B2 = imread('data_stereo_flow/training/image_0/000157_11.png');

% Load groundtruth
gt1 = flow_read('data_stereo_flow/training/flow_noc/000045_10.png');
gt2 = flow_read('data_stereo_flow/training/flow_noc/000157_10.png');

% Load Lucas-Kanade Estimations
LK1 = flow_read('data_stereo_flow/Estimations/LKflow_000045_10.png');
LK2 = flow_read('data_stereo_flow/Estimations/LKflow_000157_10.png');

%Set params
Block_Size = 16;
Search_Area = 16;

%Estimate Motion
flow1 = optFlow(A1,A2,Block_Size,Search_Area);
flow2 = optFlow(B1,B2,Block_Size,Search_Area);

% WE PROBABLY NEED TO DO A POST PROCESSING OF THE FLOW IF IT DOESNT WORK
% , LOOK AT README.TXT

% APPLY FLOW TO THE IMAGE TO VISUALIZE IT 
% TODO

% Calculate MMEN and PEPN

% Sequence 1
% Lucas-Kanade
[LK1_MSEN,LK1_PEPN] = flow_error(gt1,LK1,3);
% Our estimation
[A_MSEN,A_PEPN] = flow_error(gt1,flow1,3);

% Sequence 2
% Lucas-Kanade
[LK2_MSEN,LK2_PEPN] = flow_error(gt2,LK2,3);
% Our estimation
[B_MSEN,B_PEPN] = flow_error(gt2,flow2,3);


