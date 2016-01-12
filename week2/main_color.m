alpha=3.75;
p=0.175;
space='rgb';
if space == 'rgb'
    [m_r, v_r, m_g, v_g, m_b, v_b] = trainModel_rgb('traffic');
    [Pb,FCb,F1b] = getAssessmentAdapt_rgb(m_r, v_r, m_g, v_g, m_b, v_b,alpha,p,'traffic','Test_HighAdapt_',1000:1050);
    display(F1b)
end
space = 'yuv';
if space == 'yuv'
    [m_y, v_y, m_u, v_u, m_v, v_v] = trainModel_yuv('traffic');
    [Pb,FCb,F1b] = getAssessmentAdapt_yuv(m_y, v_y, m_u, v_u, m_v, v_v,alpha,p,'traffic','Test_HighAdapt_',1000:1050);
    display(F1b)
end