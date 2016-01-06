function [ m_y, v_y, m_u, v_u, m_v, v_v ] = adaptModel_yuv(m_y,v_y,m_u,v_u,m_v,v_v,p,res_frame,frame)
% Adapts the model for the new processed frame

    [dimX,dimY] = size(res_frame);
    for i=1:dimX
        for j=1:dimY
            % If it is background
            if (~res_frame(i,j))
                m_y(i,j) = p*frame(i,j) + (1-p)*m_y(i,j);
                v_y(i,j) = p*(frame(i,j)-m_y(i,j))^2 + (1-p)*v_y(i,j);
                
                m_u(i,j) = p*frame(i,j) + (1-p)*m_u(i,j);
                v_u(i,j) = p*(frame(i,j)-m_u(i,j))^2 + (1-p)*v_u(i,j);
                
                m_v(i,j) = p*frame(i,j) + (1-p)*m_v(i,j);
                v_v(i,j) = p*(frame(i,j)-m_v(i,j))^2 + (1-p)*v_v(i,j);
            end 
        end
    end
end

