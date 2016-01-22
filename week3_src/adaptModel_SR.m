function [ m, v ] = adaptModel_SR(m,v,p,res_frame_r,res_frame_g,res_frame_b,frame)
% Adapts the model for the new processed frame

    m_r = m(:,:,1); m_g = m(:,:,2); m_b = m(:,:,3);
    v_r = v(:,:,1); v_g = v(:,:,2); v_b = v(:,:,3);

    [dimX,dimY] = size(res_frame_r);
    for i=1:dimX
        for j=1:dimY
            % If it is background
            if (~res_frame_r(i,j))
                m_r(i,j) = p*frame(i,j) + (1-p)*m_r(i,j);
                v_r(i,j) = p*(frame(i,j)-m_r(i,j))^2 + (1-p)*v_r(i,j);
            end
            if (~res_frame_g(i,j))
                m_g(i,j) = p*frame(i,j) + (1-p)*m_g(i,j);
                v_g(i,j) = p*(frame(i,j)-m_g(i,j))^2 + (1-p)*v_g(i,j);
            end
            if (~res_frame_b(i,j))   
                m_b(i,j) = p*frame(i,j) + (1-p)*m_b(i,j);
                v_b(i,j) = p*(frame(i,j)-m_b(i,j))^2 + (1-p)*v_b(i,j);
            end 
        end
    end
    
    m = cat(3, m_r, m_g, m_b);
    v = cat(3, v_r, v_g, v_b);
end

