function [All_Data, rmv_trials] = aggeregate_data2(Datasets_name, cfg)

    All_Data = struct(...
        'All',    [], ...
        'std',    [], ...
        'target', []  ...
        );
    
    for i=1:size(Datasets_name, 1)
            
        [data, ~, rmv_trials, norm_factor, sequence] = load_data(Datasets_name{i,1}, Datasets_name{i,2}, ...
                                          Datasets_name{i,3}, Datasets_name{i,4});
        [~, prep_data, rmv_trials] = preprocess_eeglab(cfg.epoch_time, data, norm_factor, cfg.prep_band, ...
                                           rmv_trials, cfg.fs, cfg.is_downsample, cfg.fs_down, ...
                                           cfg.is_trZscr, cfg.is_baseline_corr, cfg.pre_norm, cfg.is_trRej, sequence);

        if Datasets_name{i,1} == "5"  
            % HC is channel 2 in rat 5 -> replace to channel 1
            prep_data.standard(1,:,:) = prep_data.standard(2,:,:);
            prep_data.target(1,:,:) = prep_data.target(2,:,:);
            prep_data.all(1,:,:) = prep_data.all(2,:,:);

            prep_data.standard(2,:,:) = NaN;
            prep_data.target(2,:,:) = NaN;
            prep_data.all(2,:,:) = NaN;
            prep_data.standard(3,:,:) = NaN;
            prep_data.target(3,:,:) = NaN;
            prep_data.all(3,:,:) = NaN;
        end
        
        % Baseline + All other sessions: Ch 3 is disconnected and has no power delivery
        %(can't be used)
        if Datasets_name{i,1} == "5" && Datasets_name{i,3} == "1402-09-20"
       
                prep_data.standard(3,:,:) = NaN;
                prep_data.target(3,:,:) = NaN;
                prep_data.all(3,:,:) = NaN;
      
        end

        % Ch 2: No power delivery - possible disconnection - can't be used
        if Datasets_name{i,1} == "8" && Datasets_name{i,3} == "1403-02-04" ...
                && Datasets_name{i,4} == "1"
                prep_data.standard(2,:,:) = NaN;
                prep_data.target(2,:,:) = NaN;
                prep_data.all(2,:,:) = NaN;
      
        end

        if Datasets_name{i,1} == "11" && Datasets_name{i,3} == "1403-03-31"
       
                prep_data.standard(2,:,:) = NaN;
                prep_data.target(2,:,:) = NaN;
                prep_data.all(2,:,:) = NaN;
      
        end
                              

        All_Data(i,1).All    = prep_data.all;
        All_Data(i,1).std    = prep_data.standard;
        All_Data(i,1).target = prep_data.target;
        All_Data(i,1).all_cleanTr = prep_data.all_cleanTr;
        All_Data(i,1).std_cleanTr = prep_data.std_cleanTr;
        All_Data(i,1).target_cleanTr = prep_data.target_cleanTr;
        All_Data(i,1).std_labels  = prep_data.std_labels;
        All_Data(i,1).target_labels  = prep_data.target_labels;
        All_Data(i,1).changed_labels  = prep_data.changed_labels;
        All_Data(i,1).unChanged_labels  = prep_data.unChanged_labels;

    end

end