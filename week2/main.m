% Team 3 Week 2
% Main Script

%% Task 1,2,3
start.m

%% Task 4,5

[m1, v1] = trainModel('fall');
[m2, v2] = trainModel('highway');
[m3, v3] = trainModel('traffic');

% Iterate over different values of alpha and p
i = 1;
j = 1;
w1 = zeros(length(0.25:0.25:10),length(0.025:0.025:1));
w2 = zeros(length(0.25:0.25:10),length(0.025:0.025:1));
w3 = zeros(length(0.25:0.25:10),length(0.025:0.025:1));

% Optimization
for alpha = 0.25:0.25:10
    for p = 0.025:0.025:1
        
        [~,~,~,F1a] = getAssessmentAdapt(m1,v1,alpha,p,'fall','Test_FallAdapt_',1510:1560);
        [~,~,~,F1b] = getAssessmentAdapt(m2,v2,alpha,p,'highway','Test_HighAdapt_',1200:1350);
        [~,~,~,F1c] = getAssessmentAdapt(m3,v3,alpha,p,'traffic','Test_TraffAdapt_',1000:1050);
        
        w1(i,j) = F1a;
        w2(i,j) = F1b;
        w3(i,j) = F1c;
        
        i = i + 1;
        % Save each result onto a file
    end
    j = j + 1;
    i = 1;
end

% Figure generation
figure
surf(0.25:0.25:10,0.025:0.025:1,w1);
figure;
surf(0.25:0.25:10,0.025:0.025:1,w2);
figure;
surf(0.25:0.25:10,0.025:0.025:1,w3);

% Optimal parameters, get all 
[parb,Pb,FCb,F1b] = getAssessmentAdapt(m2,v2,2.75,0.2,'highway','Test_HighAdapt_',1200:1350);
[para,Pa,FCa,F1a] = getAssessmentAdapt(m1,v1,3.25,0.05,'fall','Test_FallAdapt_',1510:1560);
[parc,Pc,FCc,F1c] = getAssessmentAdapt(m3,v3,3.75,0.175,'traffic','Test_TraffAdapt_',1000:1050);

