% Team 3 Week 2
% Main Script


%% Task 1
% PLACEHOLDER

%% Task 2
% PLACEHOLDER

%% Task 3
% PLACEHOLDER

%% Task 4
% PLACEHOLDER

%% Task 5


[m1, v1] = trainModel('fall');
[m2, v2] = trainModel('highway');
[m3, v3] = trainModel('traffic');

% Iterate over different values of alpha and p
i = 1;
j = 1;
w1 = zeros(length(0.25:0.25:10),length(0.25:0.25:1));
w2 = zeros(length(0.25:0.25:10),length(0.25:0.25:1));
w3 = zeros(length(0.25:0.25:10),length(0.25:0.25:1));

for alpha = 0.25:0.25:10
    for p = 0.25:0.25:1
        
        [Pa,FCa,F1a] = getAssessmentAdapt(m1,v1,alpha,p,'fall','Test_FallAdapt_',1510:1560);
        [Pb,FCb,F1b] = getAssessmentAdapt(m2,v2,alpha,p,'highway','Test_HighAdapt_',1200:1350);
        [Pc,FCc,F1c] = getAssessmentAdapt(m3,v3,alpha,p,'traffic','Test_TraffAdapt_',1000:1050);
        
        w1(i,j) = F1a;
        w2(i,j) = F1b;
        w3(i,j) = F1c;
        
        i = i + 1;
        % Save each result onto a file
    end
    j = j + 1;
    i = 1;
end
%dlmwrite('fall/results.txt',w1,'-append','delimiter',' ','precision','%.3f');
%dlmwrite('highway/results.txt',w2,'-append','delimiter',' ','precision','%.3f');
%dlmwrite('traffic/results.txt',w3,'-append','delimiter',' ','precision','%.3f');

% Read the results
%results1 = dlmread('fall/results.txt');
%results2 = dlmread('highway/results.txt');
%results3 = dlmread('traffic/results.txt');

% Compute a surface between alpha, p and F1 to visualize the evolution of
% F1 and find the maxima:

% X: p Y: alpha

figure
surf(0.25:0.25:10,0.25:0.25:1,w1);
figure;
surf(0.25:0.25:10,0.25:0.25:1,w2);
figure;
surf(0.25:0.25:10,0.25:0.25:1,w3);


