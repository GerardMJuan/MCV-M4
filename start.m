%Download binaries and update path if needed.
gt_dir='highway/groundtruth';
res_dir='results/highway';

%Get assessment parameters for Test A and Test B.
resultsA = getAssessment(gt_dir,res_dir,'test_A_',1201:1400);
resultsB = getAssessment(gt_dir,res_dir,'test_B_',1201:1400);
display(resultsA)
display(resultsB)