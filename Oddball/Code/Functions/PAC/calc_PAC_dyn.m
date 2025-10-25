function [s, PAC_dyn] = calc_PAC_dyn(data, ch1, ch2, fs, interval, ...
                                w_step, theta_band, gamma_band, window_type, nbins, nperm, PAC_method)

    sig1 = data(ch1, :);
    sig2 = data(ch2, :);
    
    if PAC_method == "MVL"
        PAC = tfInTrialGram(sig1, sig2, fs, interval,w_step, ...
                            theta_band, gamma_band, window_type);
    elseif PAC_method == "MI"
        PAC = tfInTrialGram_MI(sig1, sig2, fs, interval, w_step, theta_band, ...
                            gamma_band, window_type, nbins, nperm);
 
    end
    PAC_dyn = mean(PAC.table, 2);
    s = PAC.s;
    
end