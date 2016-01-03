%Download binaries and update path if needed.
dir='results-changedetect/groundtruth';

desMax = 25;
%Get assessment parameters for Test A and Test B.
results = desync(dir,desMax,1201:1400);

plot(0:25,results)
ylabel('F1 Score')
xlabel('#desync frames')
axis([0 25 0 1])
grid on
