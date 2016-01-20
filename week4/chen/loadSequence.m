function sequence = loadSequence(sequence)
%% function sequence = loadSequence(sequence
%% Purpose : load original video sequence
%% INPUT : sequence -- structure
%% OUTPUT : sequence -- structure
%% Author : T. Chen
%% Date : 02/24/2000
%%
%% Assign local variables
seq = sequence.name;
files = ListFiles(strcat(seq,'/input/'));
NumFrames = size(files,1);
NumFramesH = floor(NumFrames/2);

for i=1:NumFramesH
    frame = double(rgb2yiq(imread(strcat(seq,'/input/',files(i).name))));
    originalYPlane(:,:,i) = frame(:,:,1);
    originalIPlane(:,:,i) = frame(:,:,2);
    originalQPlane(:,:,i) = frame(:,:,3);
end

sequence.originalYPlane = originalYPlane;
sequence.originalIPlane = originalIPlane;
sequence.originalQPlane = originalQPlane;
