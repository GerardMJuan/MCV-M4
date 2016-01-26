dataset = 'traffic';

%Create video from the frames assuming 30fps
seq2vid(dataset);

%Track cars
multiObjectTracking1(dataset)