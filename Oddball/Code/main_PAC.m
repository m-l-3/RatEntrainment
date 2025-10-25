clc; close all; clear;

addpath('./Functions')
addpath('./Functions/PAC')
addpath('./Functions/Visualization')
addpath('E:\SUT\Neuro-RA\OddBall_Proj\Data\Dataset\')
eeglab;

%% Load Data and PreProcess

clc;

Before_Datasets = { ...
    {'5', '1', '1402-09-09', '0'; ...
     '5', '1', '1402-09-11', '0';};
    {'7', '1', '1402-12-02', '0'; ...
     '7', '2', '1402-12-02', '0'; ...
     '7', '3', '1402-12-02', '0';};
    {'8', '1', '1403-01-29', '0'; ...
     '8', '2', '1403-01-29', '0';};
    {'9', '1', '1403-02-25', '0'; ...
     '9', '2', '1403-02-25', '0';};
    {'11', '1', '1403-03-05', '0'; ...
     '11', '2', '1403-03-05', '0';};
    {'12', '1', '1403-03-05', '0'; ...
     '12', '2', '1403-03-05', '0';};
    };
% for rat 11, 12 : before = 03/18
% Rat 9: 

After_Datasets = { ...
    {'5', '1', '1402-09-20', '0'; ...
     '5', '1', '1402-09-20', '0';};
    {'7', '1', '1402-12-16', '0'; ...
     '7', '2', '1402-12-16', '0';};
    {%'8', '1', '1403-02-11', '0'; ...
     '8', '2', '1403-02-11', '0';};
    {'9', '1', '1403-03-05', '0'; ...
     '9', '2', '1403-03-05', '0';};
    {'11', '1', '1403-03-31', '0'; ...
     '11', '2', '1403-03-31', '0';};
    {'12', '1', '1403-03-31', '0'; ...
     '12', '2', '1403-03-31', '0';};
    };


ch_labels = {%["mPFC", "Hippo", "NAcc", "LGN"], ...
             ["Hippo", "Pulvinar(LP)", "DS(CPu)", "PFC"], ...
             };
         
fs = 2000;         
cfg = struct(                              ...
    'fs',               2000,                    ...
    'n',                100,                    ...
    'n_ch',             length(ch_labels{1}),     ...
    'is_saving',        1,                     ...
    'epoch_t_start',    0.5,                   ...
    'y_range',          [-1 1],            ...
    'epoch_time',       [0.5, 1],              ... 
    'prep_band',        [1 300],               ... 
    'run_idx',          1,                      ...
    'is_downsample',    0,                      ...
    'fs_down',          250,                     ...
    'selected_chs',     [1,4],                  ...
    'comodu_lowBand',   [5, 13],                ...
    'comodu_highBand',   [20, 90],                ...
    'nbins',            18,                      ...
    'nperm',            100                     ...
);

%% 

smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * cfg.fs;
Before_all_ERPs = zeros(cfg.n_ch, smple_num, size(Before_Datasets, 1));
Before_target_ERPs = zeros(cfg.n_ch, smple_num, size(Before_Datasets, 1));
Before_std_ERPs = zeros(cfg.n_ch, smple_num, size(Before_Datasets, 1));

for i=1:size(Before_Datasets, 1)
   
    Dataset = Before_Datasets{i};
    
    All_Data = aggeregate_data(Dataset, cfg);
    
    if Dataset{1,1} == '5'
        % "mPFC", "Hippo", "NAcc", "LGN"
        All_ERP = mean(All_Data.All, 3);
        target_ERP = mean(All_Data.target, 3);
        std_ERP = mean(All_Data.std, 3);
        Before_all_ERPs(:,:,i) = [All_ERP(2,:); NaN(size(All_ERP(2,:))); ...
                                 NaN(size(All_ERP(2,:))); All_ERP(2,:)];
        Before_target_ERPs(:,:,i) = [target_ERP(2,:); NaN(size(target_ERP(2,:))); ...
                                 NaN(size(target_ERP(2,:))); target_ERP(2,:)];
        Before_std_ERPs(:,:,i) = [std_ERP(2,:); NaN(size(std_ERP(2,:))); ...
                                 NaN(size(std_ERP(2,:))); std_ERP(2,:)];
    else
        Before_all_ERPs(:,:,i) = mean(All_Data.All, 3);
        Before_target_ERPs(:,:,i) = mean(All_Data.target, 3);
        Before_std_ERPs(:,:,i) = mean(All_Data.std, 3);
    end
end

After_all_ERPs = zeros(cfg.n_ch, smple_num, size(After_Datasets, 1));
After_target_ERPs = zeros(cfg.n_ch, smple_num, size(After_Datasets, 1));
After_std_ERPs = zeros(cfg.n_ch, smple_num, size(After_Datasets, 1));

for i=1:size(After_Datasets, 1)
   
    Dataset = After_Datasets{i};
    
    All_Data = aggeregate_data(Dataset, cfg);
    
    if Dataset{1,1} == '5'
        % "mPFC", "Hippo", "NAcc", "LGN"
        All_ERP = mean(All_Data.All, 3);
        target_ERP = mean(All_Data.target, 3);
        std_ERP = mean(All_Data.std, 3);
        After_all_ERPs(:,:,i) = [All_ERP(2,:); NaN(size(All_ERP(2,:))); ...
                                 NaN(size(All_ERP(2,:))); All_ERP(2,:)];
        After_target_ERPs(:,:,i) = [target_ERP(2,:); NaN(size(target_ERP(2,:))); ...
                                 NaN(size(target_ERP(2,:))); target_ERP(2,:)];
        After_std_ERPs(:,:,i) = [std_ERP(2,:); NaN(size(std_ERP(2,:))); ...
                                 NaN(size(std_ERP(2,:))); std_ERP(2,:)];
    else
        After_all_ERPs(:,:,i) = mean(All_Data.All, 3);
        After_target_ERPs(:,:,i) = mean(All_Data.target, 3);
        After_std_ERPs(:,:,i) = mean(All_Data.std, 3);
    end
    
end

%% Before - All trials - Comodu - MVL

avg_data = mean(Before_all_ERPs, 3, 'omitnan');
labels = ch_labels{1};
for i = cfg.selected_chs
    for j = cfg.selected_chs
        sig1 = avg_data(i, 0.8*fs:end);
        sig2 = avg_data(j, 0.8*fs:end);
        [PAC_mat, f_high, f_low] = calc_PAC_mat(sig1, sig2, cfg.comodu_lowBand, ...
                                                cfg.comodu_highBand, fs);
        plot_comodulogram(PAC_mat, f_high, f_low)
        fig_title = strcat('All-trials-Before-Entr-PAC-comodu-', labels(i),'-to-',labels(j));
        title(fig_title)
        if cfg.is_saving
            save_path = '../Results/PAC_comodu/MVL_method/Before_Entr/All_trials/';
            save_fig(save_path, fig_title);
        end
    end
end

%% After - All trials - Comodu - MVL

avg_data = mean(After_all_ERPs, 3, 'omitnan');
labels = ch_labels{1};
for i = cfg.selected_chs
    for j = cfg.selected_chs
        sig1 = avg_data(i, 0.8*fs:end);
        sig2 = avg_data(j, 0.8*fs:end);
        [PAC_mat, f_high, f_low] = calc_PAC_mat(sig1, sig2, cfg.comodu_lowBand, ...
                                                cfg.comodu_highBand, fs);
        plot_comodulogram(PAC_mat, f_high, f_low)
        fig_title = strcat('All-trials-After-Entr-PAC-comodu-', labels(i),'-to-',labels(j));
        title(fig_title)
        if cfg.is_saving
            save_path = '../Results/PAC_comodu/MVL_method/After_Entr/All_trials/';
            save_fig(save_path, fig_title);
        end
    end
end


%% All trials - PAC dynamic - MVL

interval = 0.4 * fs -1;
w_step = 0.1 * fs;
window_type = 'causal';
theta_band = [4 8];
gamma_band = [35 45];
PAC_method = "MVL";

Before_avg_data = mean(Before_all_ERPs, 3, 'omitnan');
After_avg_data = mean(After_all_ERPs, 3, 'omitnan');

labels = ch_labels{1};
for i = cfg.selected_chs
    for j = cfg.selected_chs
        
        [~, Before_PAC_dyn] = calc_PAC_dyn(Before_avg_data, i, j, fs, interval, ...
                                w_step, theta_band, gamma_band, window_type, ...
                                cfg.nbins, cfg.nperm, PAC_method);
        
        [s, After_PAC_dyn] = calc_PAC_dyn(After_avg_data, i, j, fs, interval, ...
                                w_step, theta_band, gamma_band, window_type, ...
                                cfg.nbins, cfg.nperm, PAC_method);
        
        figure;
        tint = s / fs * 1000 - cfg.epoch_t_start*1000;
        
        plot(tint, Before_PAC_dyn, 'linewidth', 2); hold on;
        plot(tint, After_PAC_dyn, 'linewidth', 2); xline(0,'--');
        xlabel('time'); ylabel('PAC'); xlim([-200 1100]);
        legend('Before Entr', 'After Entr')
        fig_title = strcat('All-trials-PAC-dyn-', labels(i),'-to-',labels(j));
        title(fig_title)
        
        if cfg.is_saving
            save_path = '../Results/PAC_dyn/MVL_method/All_trials/';
            save_fig(save_path, fig_title);
        end
        
    end
end

%% Before - All trials - Comodu - MI

avg_data = mean(Before_all_ERPs, 3, 'omitnan');
labels = ch_labels{1};
for i = cfg.selected_chs
    for j = cfg.selected_chs
        sig1 = avg_data(i, 0.8*fs:end);
        sig2 = avg_data(j, 0.8*fs:end);
        [PAC_mat, f_high, f_low] = calc_PAC_mat_MI(sig1, sig2, cfg.comodu_lowBand, ...
                                                cfg.comodu_highBand, fs, cfg.nbins, cfg.nperm);
        plot_comodulogram(PAC_mat', f_high, f_low)
        fig_title = strcat('All-trials-Before-Entr-PAC-comodu-', labels(i),'-to-',labels(j));
        title(fig_title)
        if cfg.is_saving
            save_path = '../Results/PAC_comodu/MI_method/Before_Entr/All_trials/';
            save_fig(save_path, fig_title);
        end
    end
end

%% After - All trials - Comodu - MI

avg_data = mean(After_all_ERPs, 3, 'omitnan');
labels = ch_labels{1};
for i = cfg.selected_chs
    for j = cfg.selected_chs
        sig1 = avg_data(i, 0.8*fs:end);
        sig2 = avg_data(j, 0.8*fs:end);
        [PAC_mat, f_high, f_low] = calc_PAC_mat_MI(sig1, sig2, cfg.comodu_lowBand, ...
                                                cfg.comodu_highBand, fs, cfg.nbins, cfg.nperm);
        plot_comodulogram(PAC_mat', f_high, f_low)
        fig_title = strcat('All-trials-After-Entr-PAC-comodu-', labels(i),'-to-',labels(j));
        title(fig_title)
        if cfg.is_saving
            save_path = '../Results/PAC_comodu/MI_method/After_Entr/All_trials/';
            save_fig(save_path, fig_title);
        end
    end
end


%% All trials - PAC dynamic - MI

interval = 0.4 * fs -1;
w_step = 0.1 * fs;
window_type = 'causal';
theta_band = [4 8];
gamma_band = [35 45];
PAC_method = "MI";

Before_avg_data = mean(Before_all_ERPs, 3, 'omitnan');
After_avg_data = mean(After_all_ERPs, 3, 'omitnan');

labels = ch_labels{1};
for i = cfg.selected_chs
    for j = cfg.selected_chs
        
        [~, Before_PAC_dyn] = calc_PAC_dyn(Before_avg_data, i, j, fs, interval, ...
                                w_step, theta_band, gamma_band, window_type, ...
                                cfg.nbins, cfg.nperm, PAC_method);
        
        [s, After_PAC_dyn] = calc_PAC_dyn(After_avg_data, i, j, fs, interval, ...
                                w_step, theta_band, gamma_band, window_type, ...
                                cfg.nbins, cfg.nperm, PAC_method);
        
        figure;
        tint = s / fs * 1000 - cfg.epoch_t_start*1000;
        
        plot(tint, Before_PAC_dyn, 'linewidth', 2); hold on;
        plot(tint, After_PAC_dyn, 'linewidth', 2); xline(0,'--');
        xlabel('time'); ylabel('PAC'); xlim([-200 1100]);
        legend('Before Entr', 'After Entr')
        fig_title = strcat('All-trials-PAC-dyn-', labels(i),'-to-',labels(j));
        title(fig_title)
        
        if cfg.is_saving
            save_path = '../Results/PAC_dyn/MI_method/All_trials/';
            save_fig(save_path, fig_title);
        end
        
    end
end