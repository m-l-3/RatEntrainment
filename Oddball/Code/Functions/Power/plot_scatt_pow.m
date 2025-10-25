function p_value = plot_scatt_pow(trials, window_idx, fband, cfg)
    
    power_scatt_window = [];
    
    for i=1:size(trials, 2)
        signal = trials(:,i);
        p_norm_factor = bandpower(signal(1:cfg.epoch_t_start*cfg.fs), cfg.fs, fband);
        power = bandpower(signal(window_idx), cfg.fs, fband);
        power_scatt_window = [power_scatt_window; (power-p_norm_factor)/p_norm_factor];
    end

    x = 1:length(power_scatt_window);
    y = power_scatt_window;
    scatter(x, y); hold on;

    mdl = fitlm(x, y);
    plot(x, mdl.Fitted, 'r-');

    slope = mdl.Coefficients.Estimate(2);
    p_value = mdl.Coefficients.pValue(2);
    
    x_limits = xlim;
    y_limits = ylim;
    annotation_text = sprintf('Slope: %f\np-value: %f', slope, p_value);
    text(x_limits(2), y_limits(2), annotation_text, ...
        'FontSize', 10, 'Color', 'blue', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');

end