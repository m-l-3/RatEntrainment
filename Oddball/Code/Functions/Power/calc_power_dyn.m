function power_dyn = calc_power_dyn(signal, cfg, freq_band, is_pnorm)
    
    s_range = cfg.interval+1 : cfg.step : length(signal);
    start_idx = cfg.interval;
    end_idx = 0;
    
    p_norm_factor = bandpower(signal(1:cfg.epoch_t_start*cfg.fs), cfg.fs, freq_band);
    
    power_dyn = [];
    for s = s_range

        window_idx = s-start_idx : s-end_idx-1;

        power = bandpower(signal(window_idx), cfg.fs, freq_band);
        if is_pnorm
            power_dyn = [power_dyn, (power-p_norm_factor)/p_norm_factor];
        else
            power_dyn = [power_dyn, power];
        end
    end
end