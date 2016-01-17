function [ flow ] = optFlow( A,B,Block_Size,Search_Area )
%OPTFLOW Summary of this function goes here
%   Detailed explanation goes here

%For each block we need to compute displacement
for h_step = 0:(floor(size(A,1)/Block_Size)-1)
    for w_step = 0:(floor(size(A,2)/Block_Size)-1)
        %Compute block coordinates upper left corner
        x = 1 + w_step*Block_Size;
        y = 1 + h_step*Block_Size;
        %Get reference block from A
        input_block = A(x:x+Block_Size,y:y+Block_Size);
        %Test on near positions in B
        %TODO - TEST POSITIONS and get the one with best MSE
        %Assume all pixels in the block move in the same way
        %TODO - Apply best displacement vector to all pixels in the block.
    end
end
end

