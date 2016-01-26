function seq2vid()

workingDir = 'highway';
imageNames = dir(fullfile(workingDir,'input','*.jpg'));
imageNames = {imageNames.name}';


outputVideo = VideoWriter(fullfile(workingDir,strcat(dir,'.avi')));
outputVideo.FrameRate = 25;
open(outputVideo)
for ii = 1:length(imageNames)
   img = imread(fullfile(workingDir,'input',imageNames{ii}));
   writeVideo(outputVideo,img)
end
close(outputVideo)

end