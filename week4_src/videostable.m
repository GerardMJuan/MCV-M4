dir = 'NotStabilized';
files = ListFiles(dir);
for i = 1:size(files)
    frames(i).im = double(rgb2gray(imread(strcat(dir,'/',files(i).name))));
end

roi = zeros(size(frames(1).im));
roi(1164:1767,702:988,:) = 1;

[motion, stable] = videostabilize(frames, roi, 1);

for i = 1:212
    imshow(uint8(stable(i).im));
    pause(0.01);
end