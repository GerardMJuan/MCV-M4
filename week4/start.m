%Load the targe frames
A = imread('data_stereo_flow/training/image_0/000045_10.png');
B = imread('data_stereo_flow/training/image_0/000045_11.png');

%Set params
Block_Size = 16;
Search_Area = 5;

%Estimate Motion
flow = optFlow(A,B,Block_Size,Search_Area);