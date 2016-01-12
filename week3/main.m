% Main Script


%% Task 4,5

[m1, v1] = trainModel('fall');
[m2, v2] = trainModel('highway');
[m3, v3] = trainModel('traffic');

% Iterate over different values of alpha and p
alpha = [linspace(0,40,40);linspace(0,65,40);linspace(0,20,40)];

for i = 1:size(alpha,2)
% Optimal parameters, get all 
[parb,Pb,FCb,F1b] = getAssessmentAdapt(m2,v2,alpha(1,i),0.2,'highway','Test_HighAdapt_',1200:1350);
recB(i) = FCb;
preB(i) = Pb;

[para,Pa,FCa,F1a] = getAssessmentAdapt(m1,v1,alpha(2,i),0.05,'fall','Test_FallAdapt_',1510:1560);
recA(i) = FCa;
preA(i) = Pa;

[parc,Pc,FCc,F1c] = getAssessmentAdapt(m3,v3,alpha(3,i),0.175,'traffic','Test_TraffAdapt_',1000:1050);
recC(i) = FCc;
preC(i) = Pc;

end

figure(3)
hold on
plot(recA,preA,'LineWidth',1.5)
plot(recB,preB,'LineWidth',1.5)
plot(recC,preC,'LineWidth',1.5)
title(sprintf('Precision vs Recall depending on \\alpha'))
ylabel('Precision')
xlabel('Recall')
grid
hold off
    
figure(3)
legend(sprintf('%s AUC %.4f','Fall',-trapz(recA,preA)),...
    sprintf('%s AUC %.4f','Highway',-trapz(recB,preB)),...
    sprintf('%s AUC %.4f','Traffic',-trapz(recC,preC)));
set(figure(3),'PaperPosition', [0 0 10 10]);
    set(figure(3),'PaperSize', [10 10])
saveas(figure(3),strcat('figures/','PRECvsREC-curves_no.png'))


