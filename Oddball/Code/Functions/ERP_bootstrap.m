function ERPs = ERP_bootstrap(data, cfg, tr_num)

    ERPs = zeros(cfg.n_ch, size(data, 2), cfg.n);                             
    for j=1:cfg.n
        std_idx = randsample(size(data, 3), tr_num, true);
        ERPs(:,:,j) = squeeze(mean(data(:,:,std_idx), 3, 'omitnan'));
    end

end