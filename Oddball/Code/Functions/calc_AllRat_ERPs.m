function [all_ERPs, target_ERPs, std_ERPs] = calc_AllRat_ERPs(Datasets, cfg)

    smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * cfg.fs_down;
    all_ERPs = zeros(cfg.n_ch, smple_num, size(Datasets, 1));
    target_ERPs = zeros(cfg.n_ch, smple_num, size(Datasets, 1));
    std_ERPs = zeros(cfg.n_ch, smple_num, size(Datasets, 1));

    for i=1:size(Datasets, 1)

        fprintf('Step %d / %d \n', i, size(Datasets, 1))

        Dataset = Datasets{i};
        All_Data = aggeregate_data(Dataset, cfg);

        all_ERPs(:,:,i) = mean(All_Data.All, 3);
        target_bootstrap = ERP_bootstrap(All_Data.target, cfg, size(All_Data.target, 3));
        target_ERPs(:,:,i) = mean(target_bootstrap, 3);
        std_ERPs(:,:,i) = mean(All_Data.std, 3, 'omitnan');

    end

end