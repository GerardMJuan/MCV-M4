clc,clear

alpha=3.75;
p=0.175;

th = struct('alpha', 0.4, 'beta', 0.6, 'tS', 0.1, 'tH', 0.5);

dataset = 'highway';
switch dataset
    case 'traffic'
        range = 1001:1050;
        pixel = 290;
    case 'fall'
        range = 1510:1560;
        pixel = 230;
    case 'highway'
        range = 1201:1350;
        pixel = 20;
end
        
% Choose between 'rg_s' or 'hsv'
method = 'hsv';

[ m, v ] = trainModel_rgb(dataset);
[Pb,FCb,F1b] = getAssessmentAdapt_rgb(m,v,alpha,p,dataset,range,th,pixel,method);
display(F1b)


