alpha=3;
p=0.005;
space='yuv';
if space == 'rgb'
    [m_r, v_r, m_g, v_g, m_b, v_b] = trainModel_rgb('highway');
    [Pb,FCb,F1b] = getAssessmentAdapt_rgb(m_r, v_r, m_g, v_g, m_b, v_b,alpha,p,'highway','Test_HighAdapt_',1200:1350);
    display(F1b)
end
if space == 'yuv'
    [m_y, v_y, m_u, v_u, m_v, v_v] = trainModel_yuv('highway');
    [Pb,FCb,F1b] = getAssessmentAdapt_yuv(m_y, v_y, m_u, v_u, m_v, v_v,alpha,p,'highway','Test_HighAdapt_',1200:1350);
    display(F1b)
end