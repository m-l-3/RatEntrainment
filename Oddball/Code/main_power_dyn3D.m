clc; clear; close all;

addpath('./Functions')
addpath('./Functions/Visualization')
addpath('./Functions/Power')
addpath('E:\SUT\Neuro-RA\OddBall_Proj\Data\Dataset\')
eeglab;

%%

fs = 2000;         
cfg = struct(                              ...
    'fs',               2000,                    ...
    'n',                100,                    ...
    'n_ch',             4,     ...
    'is_saving',        1,                     ...
    'epoch_t_start',    0.3,                   ...
    'y_range',          [-1 1],            ...
    'epoch_time',       [0.3, 1],              ... 
    'prep_band',        [1 300],               ... 
    'run_idx',          1,                      ...
    'is_downsample',    0,                      ...
    'fs_down',          250                     ...
);

ch_labels = ["Hippo", "Pulvinar(LP)", "DS(CPu)", "PFC"];

src_dir = "E:\SUT\Neuro-RA\OddBall_Proj\Data\Dataset";
listing = dir(strcat(src_dir, '\*Block*-1403-05-03-*'));
Datasets = {listing.name};      

is_saving = 1;

freq_bands = {[6, 10], [15, 30], [30, 50], [70, 100]};

cfg.interval = 0.3 * fs;
cfg.step = 0.1 * cfg.interval;

%%


for i=1:length(Datasets)
    
    tokens = regexp(Datasets{i}, 'Rat(\d+)-Block(\d+)-(\d{4}-\d{2}-\d{2})-novelty(\d+)', 'tokens');
    Dataset_info = tokens{1};
    
    if str2num(Dataset_info{1}) < 9 || str2num(Dataset_info{1}) == 10 || i < 4
        disp('continued..')
        continue;
    end
    
    disp(['Starting: ', Dataset_info]);
    
    [data, ~, rmv_trials, norm_factor] = load_data(Dataset_info{1}, Dataset_info{2}, ...
                                                   Dataset_info{3}, Dataset_info{4});

    [~, prep_data] = preprocess_power(cfg.epoch_time, data, norm_factor, ...
                                          cfg.prep_band, rmv_trials, cfg.fs, ...
                                          cfg.is_downsample, cfg.fs_down);

    All_trials = zeros(size(prep_data.target, 1), size(prep_data.target, 2), ...
                       length(prep_data.trial_labels));
    All_trials(:,:,prep_data.trial_labels) = prep_data.target;
    All_trials(:,:,~prep_data.trial_labels) = prep_data.standard;
    
    save_dir = strcat('../Results/Pow_dyn/3D/Rat-', Dataset_info{1}, ...
                      '/Block', Dataset_info{2}, '-', Dataset_info{3}, '/');
    for chi=1:4
        for fbandi=1:length(freq_bands)
            
            figTitle = strcat('Power dyn - Rat ', Dataset_info{1}, '-', ...
                               Dataset_info{2}, '-', Dataset_info{3}, 'fband - ', num2str(freq_bands{fbandi}), ...
                               ' - ', ch_labels(chi));
            plot_3d_powDyn(squeeze(All_trials(chi, :, :)), freq_bands{fbandi}, cfg, figTitle)
            
            if is_saving
                save_fig(strcat(save_dir, ch_labels(chi), '/'), figTitle)
            end
            
        end
    end
    
    close all;

end

