obj = VideoReader('Not_Stabilized.mp4');
vid = readframe(obj);
frames = obj.NumberOfFrames;
for x = 1 : frames
    imwrite(vid(:,:,:,x),strcat('custom_video/frame-',num2str(x),'.tif'));
end