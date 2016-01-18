function [ flow ] = optFlow( A,B,Block_Size,S_range )
%OPTFLOW Function that implements an optical flow estimation by block
%matching, with Backwards motion estimation 
%   A: first image
%   B: second image
%   Block_size: size of the block (Normally 16 pixels
%   S_range: Range of the search area

% We create a Margin for A
A = padarray(A,[Block_Size, Block_Size]);

% Number of blocks
nB_x = (floor(size(B,1)/Block_Size));
nB_y = (floor(size(B,2)/Block_Size));

% First dimension is the v (x) vector, second is the u (y) vector
flow = ones(size(A,1),size(A,2),3);
%For each block we need to compute displacement
    for w_step = 0:nB_x-1
        for h_step = 0:nB_y-1
            %Compute block coordinates upper left corner
            x = 1 + w_step*Block_Size;
            y = 1 + h_step*Block_Size;
            %Get reference block from B (we are doing backwards motion
            %estimation)

            % Block to search
            iB = B(x:x+Block_Size,y:y+Block_Size);

            % Search area
            % We add Block_Size for the padding, we only search in the
            % pixels of the original image
            sA = A(Block_Size+x-S_range:Block_Size+x+2*S_range,Block_Size+y-S_range:Block_Size+y+2*S_range);

            % Search for biggest MSE in the search area
            % It returns the position of the block in A where the similarity is
            % bigger
            [i, j] = blocksearch(sA,iB,Block_Size);
            
            % we need to save the vector we just created in the format of
            % an optical flow. Every pixel in the block behaves similarly,
            % so:
            flow(i:i+Block_Size ,j:j+Block_Size,1) = x - i; 
            flow(i:i+Block_Size ,j:j+Block_Size,2) = j - y;
        end
    end
    
    % We remove the padding of the flow
    flow = flow(1+Block_Size:end-Block_Size,1+Block_Size:end-Block_Size,:);
end


% Compare both blocks and return the MSE
function [x, y] = blocksearch(sA, iB, Bsize)
    iB = reshape(iB, [size(iB,1)*size(iB,2), 1]);
    x = 0;        
    y = 0;
    minDist = inf;
    for i = 1:size(sA,1)-Bsize
        for j = 1:size(sA,2)-Bsize
            % Get the block to compare
            iA = sA(i:i+Bsize,j:j+Bsize);
            iA = reshape(iA, [size(iA,1)*size(iA,2), 1]);
            
            % Compare the two blocks
            minDist_aux = sqrt(sum((iA - iB) .^ 2));
            
            % Get coordinates if better
            if (minDist_aux < minDist)
                minDist = minDist_aux;
                x = i;
                y = j;
            end
        end
    end
end
