clc,clear


dir_input = 'traffic/input';
dir_gt = 'traffic/groundtruth';
dir_output = 'results';
Block_Size = 16;
Search_Area = 16;
coord = [50 150]; % Top-Left Corner of the source window 50/150

stable( dir_input,dir_gt,dir_output,Block_Size,Search_Area,coord )




%%% Second part, assesment
fprintf('Stabilization: DONE')

[m1, v1] = trainModel('traffic');
[m2, v2] = trainModel('results');
se = strel('disk',10);

alpha = [linspace(0,20,40);linspace(0,20,40)];
for i = 1:size(alpha,2)
% Optimal parameters, get all 
i
[para,Pa,FCa,F1a,~] = getAssessmentAdapt(m1,v1,alpha(2,i),0.175,'traffic',1000:1050,230,se);
recA(i) = FCa;
preA(i) = Pa;
F1A(i) = F1a;

[parb,Pb,FCb,F1b,~] = getAssessmentAdapt(m2,v2,alpha(1,i),0.175,'results',1000:1050,20,se);
recB(i) = FCb;
preB(i) = Pb;
F1B(i) = F1b;


end

figure(2)
hold on
plot(recA,preA,'LineWidth',1.5)
plot(recB,preB,'LineWidth',1.5)

title(sprintf('Precision vs Recall depending on \\alpha'))
ylabel('Precision')
xlabel('Recall')
grid
hold off
    
figure(2)
legend(sprintf('%s AUC %.4f','Source',-trapz(recA,preA)),...
    sprintf('%s AUC %.4f','Stabilized',-trapz(recB,preB)));
set(figure(2),'PaperPosition', [0 0 10 10]);
set(figure(2),'PaperSize', [10 10])
saveas(figure(2),strcat('figures/comparision_st.png'))

    