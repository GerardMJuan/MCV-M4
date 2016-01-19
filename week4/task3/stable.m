function [  ] = stable( dir_input,dir_gt,dir_output,Block_Size,Search_Area,coord )


files = ListFiles(dir_input);

for i=2:size(files,1);
    I1_o = imread(strcat(dir_input,'/',files(1).name));
    I2_o = imread(strcat(dir_input,'/',files(i).name));
    I2_gt = imread(strcat(dir_gt,'/gt',files(i).name(3:end-3),'png'));
    
    I1 = rgb2gray(I1_o);
    I2 = rgb2gray(I2_o);
    
    % Top-Left Corner of the source window 50/150
    x2 = coord(1);
    y2 = coord(2);
    
    [x1, y1] = searchCenter(x2, y2, I1, I2, Block_Size, Search_Area);
    d = [x2-x1, y2-y1];
    
    frame = zeros(size(I2_o,1)+2*Search_Area,size(I2_o,2)+2*Search_Area,3);
    frame_gt = zeros(size(I2_o,1)+2*Search_Area,size(I2_o,2)+2*Search_Area);
    
    frame(Search_Area-d(2)+1:Search_Area+size(I2,1)-d(2),...
        Search_Area-d(1)+1:Search_Area+size(I2,2)-d(1),:)=I2_o;
    frame_gt(Search_Area-d(2)+1:Search_Area+size(I2,1)-d(2),...
        Search_Area-d(1)+1:Search_Area+size(I2,2)-d(1))=I2_gt;
    
    % Crop frame
    
    frame = frame(2*Search_Area:end-2*Search_Area,2*Search_Area:end-2*Search_Area,:);
    frame_gt = frame_gt(2*Search_Area:end-2*Search_Area,2*Search_Area:end-2*Search_Area);
%     figure(1)
%     subplot(1,2,1)
%     imshow(I1_o)
%     rectangle('Position', [x1, y1, 16, 16],...
% 	'EdgeColor','g', 'LineWidth', 1)
%     
%     subplot(1,2,2)
%     imshow(I2_o)
%     rectangle('Position', [x2, y2, 16, 16],...
% 	'EdgeColor','g', 'LineWidth', 1)

%     figure(1)
%     subplot(1,2,1)
%     imshow(I2_o)
%     
%     subplot(1,2,2)
%     imshow(uint8(frame))
    
    imwrite(uint8(frame),strcat(dir_output,'/input/',files(i).name))
    imwrite(uint8(frame_gt),strcat(dir_output,'/groundtruth/gt',files(i).name(3:end-3),'png'))

    
    pause(0.001)
end



end