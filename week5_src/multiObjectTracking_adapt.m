function multiObjectTracking_adapt()

% Create System objects used for reading video, detecting moving objects,
% and displaying the results.

seq = 'highway/input';
trainF = 0.1;
files = ListFiles(seq);
NumFrames = size(files,1);
NumFramesH = floor(NumFrames*trainF);

kFrame = NumFramesH;
kVel = 0;
fps = 29;
M = [];
videoSaving = true;

if videoSaving
    nameVideo = strcat(seq(1:3),'.avi');
    video = VideoWriter(nameVideo);
    video.FrameRate = 16;
    open(video)
end

speedV = [];

% SR = false; % Shadow removal

obj = setupSystemObjects();


tracks = initializeTracks(); % Create an empty array of tracks.


[modelMean, modelVariance] = trainModel(seq,trainF);

nextId = 1; % ID of the next track

% Detect moving objects, and track them across video frames.
while kFrame<=size(files,1);
    kVel = kVel+1;
    frame = readFrame();
    [centroids, bboxes, mask, modelMean, modelVariance] = detectObjects(frame,modelMean,modelVariance);
    predictNewLocationsOfTracks();
    [assignments, unassignedTracks, unassignedDetections] = ...
        detectionToTrackAssignment();
    
    updateAssignedTracks();
    updateUnassignedTracks();
    deleteLostTracks();
    createNewTracks();
    
    displayTrackingResults();
    
    kFrame = kFrame + 1;
end

if videoSaving
    close(video)
end



    function obj = setupSystemObjects()
        % Initialize Video I/O
        % Create objects for reading a video from a file, drawing the tracked
        % objects in each frame, and playing the video.
        
        
        
        % Create two video players, one to display the video,
        % and one to display the foreground mask.
        obj.videoPlayer = vision.VideoPlayer('Position', [20, 400, 700, 400]);
        obj.maskPlayer = vision.VideoPlayer('Position', [740, 400, 700, 400]);
        
        
        
        
        % Connected groups of foreground pixels are likely to correspond to moving
        % objects.  The blob analysis System object is used to find such groups
        % (called 'blobs' or 'connected components'), and compute their
        % characteristics, such as area, centroid, and the bounding box.
        
        obj.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
            'AreaOutputPort', true, 'CentroidOutputPort', true, ...
            'MinimumBlobArea', 400);
    end


    function tracks = initializeTracks()
        % create an empty array of tracks
        tracks = struct(...
            'id', {}, ...
            'bbox', {}, ...
            'oldbbox', {}, ...
            'kalmanFilter', {}, ...
            'age', {}, ...
            'totalVisibleCount', {}, ...
            'consecutiveInvisibleCount', {});
    end


    function frame = readFrame()
        frame = imread(strcat(seq,'/',files(kFrame).name));
    end


    function [centroids, bboxes, mask, modelMean, modelVariance] = detectObjects(frame,modelMean,modelVariance)
        
        switch seq
            case 'highway/input'
                alpha = 2.75;
                p = 0.2;
            case 'traffic_stable/input'
                alpha = 3.75;
                p = 0.175;
            case 'velocity/input'
                alpha = 3.75;
                p = 0.175;
            otherwise
                alpha = 4;
                p = 0.175;
        end
        
        
        Pixel = 20;
        se = strel('disk',8);
        th = struct('alpha', 0.4, 'beta', 0.6, 'tS', 0.1, 'tH', 0.5);
        
        % Detect foreground.
        
        [mask, modelMean, modelVariance] = foregroundAdapt(modelMean, modelVariance, alpha, p, frame, Pixel, se);
        
        
        
        % Perform blob analysis to find connected components.
        [~, centroids, bboxes] = obj.blobAnalyser.step(mask);
    end


    function predictNewLocationsOfTracks()
        for i = 1:length(tracks)
            bbox = tracks(i).bbox;
            
            
            tracks(i).oldbbox = tracks(i).bbox;
            
            % Predict the current location of the track.
            predictedCentroid = predict(tracks(i).kalmanFilter);
            
            % Shift the bounding box so that its center is at
            % the predicted location.
            predictedCentroid = int32(predictedCentroid) - bbox(3:4) / 2;
            tracks(i).bbox = [predictedCentroid, bbox(3:4)];
        end
    end


    function [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignment()
        
        nTracks = length(tracks);
        nDetections = size(centroids, 1);
        
        % Compute the cost of assigning each detection to each track.
        cost = zeros(nTracks, nDetections);
        for i = 1:nTracks
            cost(i, :) = distance(tracks(i).kalmanFilter, centroids);
        end
        
        % Solve the assignment problem.
        costOfNonAssignment = 20;
        [assignments, unassignedTracks, unassignedDetections] = ...
            assignDetectionsToTracks(cost, costOfNonAssignment);
    end



    function updateAssignedTracks()
        numAssignedTracks = size(assignments, 1);
        for i = 1:numAssignedTracks
            trackIdx = assignments(i, 1);
            detectionIdx = assignments(i, 2);
            centroid = centroids(detectionIdx, :);
            bbox = bboxes(detectionIdx, :);
            
            % Correct the estimate of the object's location
            % using the new detection.
            correct(tracks(trackIdx).kalmanFilter, centroid);
            
            % Replace predicted bounding box with detected
            % bounding box.
            tracks(trackIdx).bbox = bbox;
            
            % Update track's age.
            tracks(trackIdx).age = tracks(trackIdx).age + 1;
            
            % Update visibility.
            tracks(trackIdx).totalVisibleCount = ...
                tracks(trackIdx).totalVisibleCount + 1;
            tracks(trackIdx).consecutiveInvisibleCount = 0;
        end
    end


    function updateUnassignedTracks()
        for i = 1:length(unassignedTracks)
            ind = unassignedTracks(i);
            tracks(ind).age = tracks(ind).age + 1;
            tracks(ind).consecutiveInvisibleCount = ...
                tracks(ind).consecutiveInvisibleCount + 1;
        end
    end

    function deleteLostTracks()
        if isempty(tracks)
            return;
        end
        
        invisibleForTooLong = 3;
        ageThreshold = 8;
        
        % Compute the fraction of the track's age for which it was visible.
        ages = [tracks(:).age];
        totalVisibleCounts = [tracks(:).totalVisibleCount];
        visibility = totalVisibleCounts ./ ages;
        
        % Find the indices of 'lost' tracks.
        lostInds = (ages < ageThreshold & visibility < 0.60) | ...
            [tracks(:).consecutiveInvisibleCount] >= invisibleForTooLong;
        
        % Delete lost tracks.
        tracks = tracks(~lostInds);
    end


    function createNewTracks()
        centroids = centroids(unassignedDetections, :);
        bboxes = bboxes(unassignedDetections, :);
        
        for i = 1:size(centroids, 1)
            
            centroid = centroids(i,:);
            bbox = bboxes(i, :);
            
            % Create a Kalman filter object.
            kalmanFilter = configureKalmanFilter('ConstantVelocity', ...
                centroid, [200, 50], [100, 25], 100);
            
            % Create a new track.
            newTrack = struct(...
                'id', nextId, ...
                'bbox', bbox, ...
                'oldbbox', bbox, ...
                'kalmanFilter', kalmanFilter, ...
                'age', 1, ...
                'totalVisibleCount', 1, ...
                'consecutiveInvisibleCount', 0);
            
            % Add it to the array of tracks.
            tracks(end + 1) = newTrack;
            
            % Increment the next id.
            nextId = nextId + 1;
        end
    end


    function displayTrackingResults()
        % Convert the frame and the mask to uint8 RGB.
        frame = im2uint8(frame);
        mask = uint8(repmat(mask, [1, 1, 3])) .* 255;
        
        minVisibleCount = 3;
        
        if ~isempty(tracks)
            
            % Noisy detections tend to result in short-lived tracks.
            % Only display tracks that have been visible for more than
            % a minimum number of frames.
            reliableTrackInds = ...
                [tracks(:).totalVisibleCount] > minVisibleCount;
            reliableTracks = tracks(reliableTrackInds);
            
            % Display the objects. If an object has not been detected
            % in this frame, display its predicted bounding box.
            if ~isempty(reliableTracks)
                % Get bounding boxes.
                bboxes = cat(1, reliableTracks.bbox);
                
                
                oldbboxes = cat(1, reliableTracks.oldbbox);
                x_1 = double(bboxes(:,1)+bboxes(:,3));
                y_1 = double(bboxes(:,2)+bboxes(:,4));
                
                x_2 = double(oldbboxes(:,1)+oldbboxes(:,3));
                y_2 = double(oldbboxes(:,2)+oldbboxes(:,4));
                
                dPx = sqrt((x_2-x_1).^2+(y_2-y_1).^2);
                
                % Length of pixel correspondent to 4.5 meters
                switch seq
                    case 'highway/input'
                        conversor = 0.0005.*y_2.^2-0.003*y_2+3.861; % Highway
                    case 'dia'
                        conversor = 0.0009.*y_2.^2+0.094*y_2+3.964; % Dia and night
                    case 'night'
                        conversor = 0.0009.*y_2.^2+0.094*y_2+3.964; % Dia and night
                    case 'traffic_stable/input'
                        conversor = 0.37172*y_2+41.488; % Traffic (adjust with just two points)
                    case 'velocity/input'
                        conversor = -0.2747*x_2+96.1; % velocity (adjust with just two points)
                end
                
                dKm = 4.5./conversor.*dPx/1000;
                dt = 1/fps/3600;
                
                speed = dKm./dt;
                kVel = 0;
                
                
                units = 'km/h';
                label_speed = strcat(num2str(speed,'%0.1f'),units);
                % Get ids.
                ids = int32([reliableTracks(:).id]);
                
                speedV = [speedV speed'];
                M = [M ids];
                uni = unique(M);
                list = 1:1:size(uni,2);
                tam = size(ids,2)-1;
                ids = list(end-tam:end);
                
                % Create labels for objects indicating the ones for
                % which we display the predicted rather than the actual
                % location.
                labels = cellstr(int2str(ids'));
                predictedTrackInds = ...
                    [reliableTracks(:).consecutiveInvisibleCount] > 0;
                isPredicted = cell(size(labels));
                isPredicted(predictedTrackInds) = {' predicted'};
                labels = strcat(labels, ' | ', label_speed, ' |  ', isPredicted);
                %labels = strcat(labels, isPredicted);
                %labels = 'Coche';
                
                
                               
                % Draw the objects on the frame.
                frame = insertObjectAnnotation(frame, 'rectangle', ...
                    bboxes, labels);
                
                % Draw the objects on the mask.
                mask = insertObjectAnnotation(mask, 'rectangle', ...
                    bboxes, labels);
            end
        end
        
        % Display the mask and the frame.
        obj.maskPlayer.step(mask);
        obj.videoPlayer.step(frame);
        
        if (kFrame==size(files,1));
            fprintf('Total of cars:             %i\n', size(unique(M),2))
            fprintf('Mean speed of the road:    %.1f km/h\n', mean(speedV))
        end
        
        if videoSaving
            figure(1)
            subplot(1,2,1);
            imshow(frame);
            title('Source')
            
            subplot(1,2,2);
            imshow(mask)
            title('Mask generated')
            
            frameVideo = getframe(gcf);
            writeVideo(video,frameVideo);
        end

    end

end


