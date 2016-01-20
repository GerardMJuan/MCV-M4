function [  ] = stable( dir_input,dir_gt,dir_output,Block_Size,Search_Area,coord )

% STABLE a function that takes as references the first frame of the
% sequence ande stabilize the rest of the sequence.
% dir_input: folder of the sequence
% dir_output: folder where the results are saved
% dir_gt: folder of the groundtruth
% Block_Size: Size of the reference block
% Search_Area: Range where the alghorithm search for the correspondent
% block.
% coord : Top Left corner of the reference block



% nameVideo = strcat('video.avi');
% video = VideoWriter(nameVideo);
% video.FrameRate = 8;
% open(video)


files = ListFiles(dir_input);
I1_o = imread(strcat(dir_input,'/',files(1).name));
I1_gt = imread(strcat(dir_gt,'/gt',files(1).name(3:end-3),'png'));

I1_o = I1_o(Search_Area:end-Search_Area,Search_Area:end-Search_Area,:);
I1_gt = I1_gt(Search_Area:end-Search_Area,Search_Area:end-Search_Area,:);
imwrite(I1_o,strcat(dir_output,'/input/',files(1).name))
imwrite(I1_gt,strcat(dir_output,'/groundtruth/gt',files(1).name(3:end-3),'png'))

for i=2:size(files,1);
    I1_o = imread(strcat(dir_input,'/',files(1).name));
    I2_o = imread(strcat(dir_input,'/',files(i).name));
    I2_gt = imread(strcat(dir_gt,'/gt',files(i).name(3:end-3),'png'));
    
    I1 = rgb2gray(I1_o);
    I2 = rgb2gray(I2_o);
    
    % Top-Left Corner of the source window 50/150
    x2 = coord(1);
    y2 = coord(2);
    
	% Give the center of the correspondent bolck on that frame
    [x1, y1] = searchCenter(x2, y2, I1, I2, Block_Size, Search_Area);
    d = [x2-x1, y2-y1];
    
	% Align frames
    frame = zeros(size(I2_o,1)+2*Search_Area,size(I2_o,2)+2*Search_Area,3);
    frame_gt = zeros(size(I2_o,1)+2*Search_Area,size(I2_o,2)+2*Search_Area);
    
	
    frame(Search_Area-d(2)+1:Search_Area+size(I2,1)-d(2),...
        Search_Area-d(1)+1:Search_Area+size(I2,2)-d(1),:)=I2_o;
    frame_gt(Search_Area-d(2)+1:Search_Area+size(I2,1)-d(2),...
        Search_Area-d(1)+1:Search_Area+size(I2,2)-d(1))=I2_gt;
    
    % Crop frame to delete black padding
    
    frame = frame(2*Search_Area:end-2*Search_Area,2*Search_Area:end-2*Search_Area,:);
    frame_gt = frame_gt(2*Search_Area:end-2*Search_Area,2*Search_Area:end-2*Search_Area);


%     figure(1)
%     subplot(1,2,1)
%     imshow(I2_o)
%     title('Original Source')
%     
%     subplot(1,2,2)
%     imshow(uint8(frame))
%     title('Stabilized Sequence')
%         
    imwrite(uint8(frame),strcat(dir_output,'/input/',files(i).name))
    imwrite(uint8(frame_gt),strcat(dir_output,'/groundtruth/gt',files(i).name(3:end-3),'png'))

%     fotograma = getframe(figure(1));
%     writeVideo(video,fotograma);
    
    pause(0.001)
end

% close(video)

end