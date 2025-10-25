function [PAC_mats, f_high, f_low] = gen_PAC_comodu_dyn(sig1, sig2, cfg, fig_title, save_path)

    t_end = cfg.interval : cfg.w_step : length(sig1);
    t_start = (0 : cfg.w_step : length(sig1) - cfg.interval)+1;
    
    PAC_mats = [];
    
    videoFile = strcat(save_path, fig_title, '.mp4'); % Specify the output video file name
    if exist(save_path, 'dir') ~= 7
        mkdir(save_path);
    end
    v = VideoWriter(videoFile, 'MPEG-4');
    v.FrameRate = 1/2;
    open(v);
    
    for i=1:length(t_start)
        
        [PAC, f_high, f_low] = calc_PAC_mat_MI(sig1(t_start(i):t_end(i)), ...
               sig2(t_start(i):t_end(i)), cfg.comodu_lowBand, ...
               cfg.comodu_highBand, cfg.fs, cfg.nbins, cfg.nperm);
        PAC_mats = cat(3, PAC_mats, PAC);
        
        plot_comodulogram(PAC', f_high, f_low, [0, 150])
        title({fig_title}, {strcat(num2str((t_start(i)-1)/2 - cfg.epoch_t_start*1000), ...
                     '(ms) to', num2str(t_end(i)/2 - cfg.epoch_t_start*1000), '(ms)')})
        if cfg.is_saving
           save_fig(save_path, strcat(fig_title, '-', num2str((t_start(i)-1)/2), 'to', num2str(t_end(i)/2)))
           
           frame = getframe(gcf);
           img = frame2im(frame);

           writeVideo(v, img);
           
        end
        fprintf('window %d / %d\n', i, length(t_start))
    end
    
    close(v)

end