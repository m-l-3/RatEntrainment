function All_Data = aggeregate_data(Datasets_name, cfg)

    All_Data = struct(...
        'All',    [], ...
        'std',    [], ...
        'target', [],  ...
        'changed', [],  ...
        'unChanged', []  ...
        );
    
    for i=1:size(Datasets_name, 1)
            
        [data, ~, rmv_trials, norm_factor] = load_data(Datasets_name{i,1}, Datasets_name{i,2}, ...
                                          Datasets_name{i,3}, Datasets_name{i,4});
        [~, prep_data] = preprocess_eeglab(cfg.epoch_time, data, norm_factor, cfg.prep_band, ...
                                           rmv_trials, cfg.fs, cfg.is_downsample, cfg.fs_down, ...
                                           cfg.is_trZscr, cfg.is_baseline_corr, cfg.pre_norm);

        if Datasets_name{i,1} == "5"  
            % HC is channel 2 in rat 5 -> replace to channel 1
            prep_data.standard(1,:,:) = prep_data.standard(2,:,:);
            prep_data.target(1,:,:) = prep_data.target(2,:,:);
            prep_data.All(1,:,:) = prep_data.All(2,:,:);
            
            prep_data.standard(2,:,:) = NaN;
            prep_data.target(2,:,:) = NaN;
            prep_data.All(2,:,:) = NaN;
            prep_data.standard(3,:,:) = NaN;
            prep_data.target(3,:,:) = NaN;
            prep_data.All(3,:,:) = NaN;
        end
        
        % Baseline + All other sessions: Ch 3 is disconnected and has no power delivery
        %(can't be used)
        if Datasets_name{i,1} == "5" && Datasets_name{i,3} == "1402-09-20"
       
                prep_data.standard(3,:,:) = NaN;
                prep_data.target(3,:,:) = NaN;
                prep_data.All(3,:,:) = NaN;
      
        end
        
        % Ch 2: No power delivery - possible disconnection - can't be used
        if Datasets_name{i,1} == "8" && Datasets_name{i,3} == "1403-02-04" ...
           && Datasets_name{i,4} == "1"
       
                prep_data.standard(2,:,:) = NaN;
                prep_data.target(2,:,:) = NaN;
                prep_data.All(2,:,:) = NaN;
      
        end
        
        if Datasets_name{i,1} == "11" && Datasets_name{i,3} == "1403-03-31"
       
                prep_data.standard(2,:,:) = NaN;
                prep_data.target(2,:,:) = NaN;
                prep_data.All(2,:,:) = NaN;
      
        end
                                       
        All_Data.All     = cat(3, All_Data.All   , prep_data.All);
        All_Data.std     = cat(3, All_Data.std   , prep_data.standard);
        All_Data.target  = cat(3, All_Data.target, prep_data.target);
        All_Data.changed = cat(3, All_Data.changed, ...
                               prep_data.All(:,:,prep_data.changed_tr_label));
        All_Data.unChanged = cat(3, All_Data.unChanged, ...
                               prep_data.All(:,:,prep_data.unChanged_tr_label));
                           
    end

end