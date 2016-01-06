 function [ ] = NonRecGaussian(dir,dir_res,alpha)

% dir -> Location of the target images
% dir -> Location to save the segmentated images
% alpha -> Factor to accept or not a foreground pixel

if ~exist('alpha','var')
    alpha = 2.5;
end

files = ListFiles(dir);

NumFrames = size(files,1);

%----Transforming to Grayscale 

for i=1:NumFrames
    
    video(:,:,i) = rgb2gray(imread(strcat(dir,'/',files(i).name)));
    
        
end

%---Creating the Gaussians
NumFramesH = floor(NumFrames/2);

%GAUSS tensor of NxMx2, 1st layer -> means and 2nd layer -> desviations
GAUSS = zeros(size(video,1),size(video,2),2);

video50 = video(:,:,1:NumFramesH);
GAUSS(:,:,1) = mean(double(video50),3);
GAUSS(:,:,2) = std(double(video50),0,3);


for i=NumFramesH+1:NumFrames
    
    dif = abs(double(video(:,:,i))-GAUSS(:,:,1));
    mask = dif >= alpha*(GAUSS(:,:,2)+2);
    imwrite(mask,strcat(dir_res,'/',files(i).name),'Quality',100);
    
end


end






