function [PAC_mat, f_high, f_low] = calc_PAC_mat(sig1, sig2, f_theta, f_gamma, Fs)

    w1 = nf_cwt(sig1,Fs, max(f_gamma)); 
    w2 = nf_cwt(sig2,Fs, max(f_gamma));
    
    [PAC_mat, f_high, f_low] = tfMVL(w1, w2, f_gamma, f_theta, 1:length(sig1));

end