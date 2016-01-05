clc,clear

dir = 'highway/input';          % Location of the original images
res_dir = 'highway-1gauss';      % Location of the results
gt_dir = 'highway/groundtruth'; % Location of the groundtruth

alpha = 0:0.5:10;
TP = zeros(1,size(alpha,2));
TN = zeros(1,size(alpha,2));
FP = zeros(1,size(alpha,2));
FN = zeros(1,size(alpha,2));
prec = zeros(1,size(alpha,2));
rec = zeros(1,size(alpha,2));
F1 = zeros(1,size(alpha,2));

for i=1:size(alpha,2);
    clc
    fprintf('%i of %i',i,size(alpha,2))
    NonRecGaussian(dir,res_dir,alpha(i))
    assessment = getAssessment(gt_dir,res_dir);
    TP(i) = assessment.TP;
    TN(i) = assessment.TN;
    FP(i) = assessment.FP;
    FN(i) = assessment.FN;
    prec(i) = assessment.prec;
    rec(i) = assessment.rec;
    F1(i) = assessment.F1;
end

clc
figure(1)
plot(alpha,TP)
hold on
plot(alpha,TN); plot(alpha,FP); plot(alpha,FN)
title(sprintf('Highway \n TP TN FP FN'))
ylabel('#')
xlabel('\alpha value')
legend('TP','TN','FP','FN')
grid
hold off

figure(2)
plot(alpha,F1)
title(sprintf('Highway \n F1vs?'))
ylabel('F1-measure')
xlabel('\alpha value')
grid


figure(3)
plot(rec,prec)
title(sprintf('Highway \n Precision vs Recall depending on ? \n (AUC %.2f)',...
    -trapz(rec,prec)))
ylabel('Precision')
xlabel('Recall')
grid