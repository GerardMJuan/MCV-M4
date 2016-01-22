% Main script for Assignments in Week 1 - Team 3

% Download binaries and update path if needed.
gt_dir='datasets/highway/groundtruth';
res_dir='datasets/testAB/highway';

% Task 1
% Get assessment parameters for Test A and Test B.
resultsA = getAssessment_w1(gt_dir,res_dir,'test_A_',1201:1400);
resultsB = getAssessment_w1(gt_dir,res_dir,'test_B_',1201:1400);
display(resultsA)
display(resultsB)

% Task 2
% No code!

% Task 3
[F1_A, TP_A, FP_A] = getAssesmentPerFrame_w1(gt_dir,res_dir,'test_A_',1201:1400);
[F1_B, TP_B, FP_B] = getAssesmentPerFrame_w1(gt_dir,res_dir,'test_B_',1201:1400);

% Task 4

% Load estimations
OP1 = flow_read('datasets/data_stereo_flow/Estimations/LKflow_000045_10.png');
OP2 = flow_read('datasets/data_stereo_flow/Estimations/LKflow_000157_10.png');

%Load Ground truth
GT1 = flow_read('datasets/data_stereo_flow/training/flow_occ/000045_10.png');
GT2 = flow_read('datasets/data_stereo_flow/training/flow_occ/000157_10.png');

[E1, mask1] = flow_error_map(GT1,OP1);
[E2, mask2] = flow_error_map(GT2,OP2);

MSE1 = sum(sum(E1)) / sum(sum(mask1));
MSE2 = sum(sum(E2)) / sum(sum(mask2));

% Task 5

% Compute Percentage of Erroenous Pixels
tau = 3;
PEPN1 = length(find(E1>tau))/length(find(mask1));
PEPN2 = length(find(E2>tau))/length(find(mask2));

% Task 6

dir='datasets/highway/groundtruth';
res_dir='datasets/testAB/highway';

desMax = 25;
%Get assessment parameters for Test A and Test B.
results = desync(dir,res_dir,desMax,1201:1400);

plot(0:25,results)
ylabel('F1 Score')
xlabel('#desync frames')
axis([0 25 0 1])
grid on

% Task 7
I1 = imread('datasets/data_stereo_flow/Estimations/LKflow_000045_10.png');
I2 = imread('datasets/data_stereo_flow/Estimations/LKflow_000045_10.png');

I1 = imresize(I1,0.2);
I2 = imresize(I2,0.2);

F1_u = (I1(:,:,1)-2^15)/64;
F1_v = (I1(:,:,2)-2^15)/64;

F2_u = (I2(:,:,1)-2^15)/64;
F2_v = (I2(:,:,2)-2^15)/64;

figure
quiver(F1_u,F1_v,'AutoScaleFactor',4);
figure
quiver(F2_u,F2_v,'AutoScaleFactor',4);