function [ m, v ] = adaptModel_w3(m,v,p,res_frame,frame)
% Adapts the model for the new processed frame

    [dimX,dimY] = size(res_frame);
    for i=1:dimX
        for j=1:dimY
            % If it is background
            if (~res_frame(i,j))
                m(i,j) = p*frame(i,j) + (1-p)*m(i,j);
                v(i,j) = p*(frame(i,j)-m(i,j))^2 + (1-p)*v(i,j);
            end 
        end
    end
end

