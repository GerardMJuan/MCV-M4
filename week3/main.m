% Main Script


%% Task 1

[m1, v1] = trainModel('fall');
[m2, v2] = trainModel('highway');
[m3, v3] = trainModel('traffic');

% Iterate over different values of alpha and p
alpha = [linspace(0,40,40);linspace(0,65,40);linspace(0,20,40)];

for i = 1:size(alpha,2)
% Optimal parameters, get all 
[parb,Pb,FCb,F1b,~] = getAssessmentAdapt(m2,v2,alpha(1,i),0.2,'highway','Test_HighAdapt_',1200:1350,1);
recB(i) = FCb;
preB(i) = Pb;

[para,Pa,FCa,F1a,~] = getAssessmentAdapt(m1,v1,alpha(2,i),0.05,'fall','Test_FallAdapt_',1510:1560,1);
recA(i) = FCa;
preA(i) = Pa;

[parc,Pc,FCc,F1c,~] = getAssessmentAdapt(m3,v3,alpha(3,i),0.175,'traffic','Test_TraffAdapt_',1000:1050,1);
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

% Task 2
j = 0;
for P=20:10:200
    j = j + 1;
    for i = 1:size(alpha,2)
        % Optimal parameters, get all
        [parb,Pb,FCb,F1b] = getAssessmentAdapt(m2,v2,alpha(1,i),0.2,'highway','Test_HighAdapt_',1200:1350,P);
        recB(i) = FCb;
        preB(i) = Pb;
        
        [para,Pa,FCa,F1a] = getAssessmentAdapt(m1,v1,alpha(2,i),0.05,'fall','Test_FallAdapt_',1510:1560,P);
        recA(i) = FCa;
        preA(i) = Pa;
        
        [parc,Pc,FCc,F1c] = getAssessmentAdapt(m3,v3,alpha(3,i),0.175,'traffic','Test_TraffAdapt_',1000:1050,P);
        recC(i) = FCc;
        preC(i) = Pc;
    end
    aucB(j) = -trapz(recB,preB);
    aucA(j) = -trapz(recA,preA);
    aucC(j) = -trapz(recC,preC);
    
end
    
% Task 6
 for i = 1:size(alpha,2)
[parb,Pb,FCb,F1b,Qb] = getAssessmentAdapt(m2,v2,alpha(1,i),0.2,'highway','Test_HighAdapt_',1200:1350,1);
F1ScoreB(i) = F1b;
QWeightB(i) = Qb;

[para,Pa,FCa,F1a,Qa] = getAssessmentAdapt(m1,v1,alpha(2,i),0.05,'fall','Test_FallAdapt_',1510:1560,1);
F1ScoreA(i) = F1a;
QWeightA(i) = Qa;

[parc,Pc,FCc,F1c,Qc] = getAssessmentAdapt(m3,v3,alpha(3,i),0.175,'traffic','Test_TraffAdapt_',1000:1050,1);
F1ScoreC(i) = F1c;
QWeightC(i) = Qc;

 end

figure(1)
hold on
plot(F1ScoreB,alpha(1,:),'LineWidth',1.5)
plot(QWeightB,alpha(1,:),'LineWidth',1.5)
title(sprintf('Evolution of F1 and Fbeta Measure respect to alpha, highway sequence'))
ylabel('Value of Measure')
xlabel('alpha')
grid
hold off

figure(2)
hold on
plot(F1ScoreA,alpha(2,:),'LineWidth',1.5)
plot(QWeightA,alpha(2,:),'LineWidth',1.5)
title(sprintf('Evolution of F1 and Fbeta Measure respect to alpha, fall sequence'))
ylabel('Value of Measure')
xlabel('alpha')
grid
hold off

figure(3)
hold on
plot(F1ScoreC,alpha(3,:),'LineWidth',1.5)
plot(QWeightC,alpha(3,:),'LineWidth',1.5)
title(sprintf('Evolution of F1 and Fbeta Measure respect to alpha, traffic sequence'))
ylabel('Value of Measure')
xlabel('alpha')
grid
hold off

