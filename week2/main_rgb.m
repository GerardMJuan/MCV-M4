alpha=3;
p=0.05;

[m_r, v_r, m_g, v_g, m_b, v_b] = trainModel_rgb('highway');
[Pb,FCb,F1b] = getAssessmentAdapt_rgb(m_r, v_r, m_g, v_g, m_b, v_b,alpha,p,'highway','Test_HighAdapt_',1200:1350);