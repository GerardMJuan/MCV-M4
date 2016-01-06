clc,clear

ListNames = {'highway','fall','traffic'}; % List of the datasets we use

% alpha = [0:0.5:10; 0:0.5:10; 0:0.5:10] % To TP,TN,FP,FN graphics
alpha = [linspace(0,30,15);linspace(0,60,15);linspace(0,15,15)]; % To Prec-Recall curve

% Inizialization of the variables
TP = zeros(1,size(alpha,2));
TN = zeros(1,size(alpha,2));
FP = zeros(1,size(alpha,2));
FN = zeros(1,size(alpha,2));
prec = zeros(1,size(alpha,2));
rec = zeros(1,size(alpha,2));
F1 = zeros(1,size(alpha,2));


for k=1:size(ListNames,2); % For all datasets which where asked
    
    name = ListNames{k};
    
    dir = strcat(name,'/input');          % Location of the original images
    res_dir = strcat(name,'-gauss');      % Location of the results
    gt_dir = strcat(name,'/groundtruth'); % Location of the groundtruth
    
    
    
    for i=1:size(alpha,2);
        
        fprintf('%i of %i \r',i,size(alpha(k,:),2)) 
        
        % Create our results
        NonRecGaussian(dir,res_dir,alpha(k,i)) 
        
        % Evaluate our results
        assessment = getAssessment(gt_dir,res_dir);
        
        TP(k,i) = assessment.TP;
        TN(k,i) = assessment.TN;
        FP(k,i) = assessment.FP;
        FN(k,i) = assessment.FN;
        prec(k,i) = assessment.prec;
        rec(k,i) = assessment.rec;
        F1(k,i) = assessment.F1;
    end
    
    % Plot the different curves
    figure(1)
    plot(alpha(k,:),TP(k,:),'LineWidth',1.5)
    hold on
    plot(alpha(k,:),TN(k,:),'LineWidth',1.5); plot(alpha(k,:),FP(k,:),'LineWidth',1.5)
    plot(alpha(k,:),FN(k,:),'LineWidth',1.5)
    title(sprintf('%s \n TP TN FP FN',name))
    ylabel('#')
    xlabel('\alpha value')
    legend('TP','TN','FP','FN')
    grid
    hold off
    set(figure(1),'PaperPosition', [0 0 8 8]);
    set(figure(1),'PaperSize', [8 8])
    saveas(figure(1),strcat('figures/',name,'-TP_TN_FP_FN.png'))
    
    figure(2)
    plot(alpha(k,:),F1(k,:),'LineWidth',1.5)
    title(sprintf('%s \n F1vs\\alpha',name))
    ylabel('F1-measure')
    xlabel('\alpha value')
    grid
    set(figure(2),'PaperPosition', [0 0 8 8]);
    set(figure(2),'PaperSize', [8 8])
    saveas(figure(2),strcat('figures/',name,'-F1meausre.png'))
    
    
    figure(3)
    hold on
    plot(rec(k,:),prec(k,:),'LineWidth',1.5)
    title(sprintf('Precision vs Recall depending on \\alpha'))
    ylabel('Precision')
    xlabel('Recall')
    grid
    hold off
    
    fprintf('%s completed. \n',name)
end

figure(3)
legend(sprintf('%s AUC %.2f',ListNames{1},-trapz(rec(1,:),prec(1,:))),...
    sprintf('%s AUC %.2f',ListNames{2},-trapz(rec(2,:),prec(2,:))),...
    sprintf('%s AUC %.2f',ListNames{3},-trapz(rec(3,:),prec(3,:))));
set(figure(3),'PaperPosition', [0 0 10 10]);
    set(figure(3),'PaperSize', [10 10])
saveas(figure(3),strcat('figures/','PRECvsREC-curves.png'))