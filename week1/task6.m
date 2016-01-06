%Download binaries and update path if needed.
gt_dir='results-changedetect/groundtruth';
res_dir='results-changedetect/highway';

desMax = 25;
%Get assessment parameters for Test A and Test B.
results = desync(gt_dir,res_dir,desMax,1201:1400);

plot(0:25,results)
ylabel('F1 Score')
xlabel('#desync frames')
axis([0 25 0 1])
grid on
