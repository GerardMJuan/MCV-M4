function seq2vid(d)

workingDir = strcat('datasets\',d);
imageNames = dir(fullfile(workingDir,'input'));
imageNames = {imageNames.name}';


outputVideo = VideoWriter(fullfile('videos',strcat(d,'.avi')));
outputVideo.FrameRate = 30;
open(outputVideo)
for ii = 3:length(imageNames)
   img = imread(fullfile(workingDir,'input',imageNames{ii}));
   writeVideo(outputVideo,img)
end
close(outputVideo)

end