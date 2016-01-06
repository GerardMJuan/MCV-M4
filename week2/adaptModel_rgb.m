function [ m_r, v_r, m_g, v_g, m_b, v_b ] = adaptModel_rgb(m_r,v_r,m_g,v_g,m_b,v_b,p,res_frame,frame)
% Adapts the model for the new processed frame

    [dimX,dimY] = size(res_frame);
    for i=1:dimX
        for j=1:dimY
            % If it is background
            if (~res_frame(i,j))
                m_r(i,j) = p*frame(i,j) + (1-p)*m_r(i,j);
                v_r(i,j) = p*(frame(i,j)-m_r(i,j))^2 + (1-p)*v_r(i,j);
                
                m_g(i,j) = p*frame(i,j) + (1-p)*m_g(i,j);
                v_g(i,j) = p*(frame(i,j)-m_g(i,j))^2 + (1-p)*v_g(i,j);
                
                m_b(i,j) = p*frame(i,j) + (1-p)*m_b(i,j);
                v_b(i,j) = p*(frame(i,j)-m_b(i,j))^2 + (1-p)*v_b(i,j);
            end 
        end
    end
end

