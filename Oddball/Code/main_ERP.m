clc; close all; clear;

addpath('./Functions')
addpath('./Functions/Visualization')
addpath('E:\SUT\Neuro-RA\OddBall_Proj\Data\Dataset\')
eeglab;

%% Load Data and PreProcess

clc;

% Before_Datasets = {'5', '1', '1402-09-09', '0'; ...
%                    '5', '1', '1402-09-11', '0'; ...
%             };
%         
% After_Datasets = {'5', '1', '1402-09-20', '0'; ...
%                   '5', '2', '1402-09-20', '0'; ...
%             };
        
% Before_Datasets = {'7', '1', '1402-12-02', '0'; ...
%                    '7', '2', '1402-12-02', '0'; ...
%                    '7', '3', '1402-12-02', '0'; ...
%             };
%         
% After_Datasets = {'7', '1', '1402-12-16', '0'; ...
%                   '7', '2', '1402-12-16', '0'; ...
%             };

% Before_Datasets = {'8', '1', '1403-01-29', '0'; ...
%                    '8', '2', '1403-01-29', '0'; ...
%             };
%         
% After10days_Datasets = {%'8', '1', '1403-02-11', '0'; ...
%                         '8', '2', '1403-02-11', '0'; ...
%             };
%         
% After20days_Datasets = {'8', '1', '1403-02-25', '0'; ...
%                         '8', '2', '1403-02-25', '0'; ...
%             };
        
% Before_Datasets = {'9', '1', '1403-02-25', '0'; ...
%                    '9', '2', '1403-02-25', '0'; ...
%             };
%         
% After10days_Datasets = {'9', '1', '1403-03-05', '0'; ...
%                         '9', '2', '1403-03-05', '0'; ...
%             };
%         
% After20days_Datasets = {%'9', '1', '1403-03-31', '0'; ...
%                         '9', '2', '1403-03-31', '0'; ...
%             };        
% 
% After30days_Datasets = {'9', '1', '1403-04-13', '0'; ...
%                         '9', '2', '1403-04-13', '0'; ...
%             };        
%         

% Before_Datasets = {'11', '1', '1403-03-05', '0'; ...
%                    '11', '2', '1403-03-05', '0'; ...
%             };
%         
% After10days_Datasets = {'11', '1', '1403-03-31', '0'; ...
%                         '11', '2', '1403-03-31', '0'; ...
%             };
%         
% After20days_Datasets = {'11', '1', '1403-04-13', '0'; ...
%                         '11', '2', '1403-04-13', '0'; ...
%             }; 
%         
% After30days_Datasets = {'11', '1', '1403-05-03', '0'; ...
%                         '11', '2', '1403-05-03', '0'; ...
%             }; 
%         
% After50days_Datasets = {'11', '1', '1403-05-27', '0'; ...
%                         '11', '2', '1403-05-27', '0'; ...
%             };         

% Before_Datasets = {'12', '1', '1403-03-05', '0'; ...
%                    '12', '2', '1403-03-05', '0'; ...
%             };
%         
% After10days_Datasets = {'12', '1', '1403-03-31', '0'; ...
%                         '12', '2', '1403-03-31', '0'; ...
%             };
%         
% After20days_Datasets = {'12', '1', '1403-04-13', '0'; ...
%                         '12', '2', '1403-04-13', '0'; ...
%             };
% 
% After30days_Datasets = {'12', '1', '1403-05-03', '0'; ...
%                         '12', '2', '1403-05-03', '0'; ...
%             };
        
% After40days_Datasets = {'12', '1', '1403-05-15', '0'; ...
%                         '12', '2', '1403-05-15', '0'; ...
%             };        

% Before_Datasets = {'13', '1', '1403-04-13', '0'; ...
%                    '13', '2', '1403-04-13', '0'; ...
%             };
%         
% After10days_Datasets = {'13', '1', '1403-05-03', '0'; ...
%                         '13', '2', '1403-05-03', '0'; ...
%             };
% 
% After20days_Datasets = {'13', '1', '1403-05-15', '0'; ...
%                         '13', '2', '1403-05-15', '0'; ...
%             };
% 
% After30days_Datasets = {'13', '1', '1403-05-27', '0'; ...
%                         '13', '2', '1403-05-27', '0'; ...
%             };
        
% Before_Datasets = {'14', '1', '1403-04-19', '0'; ...
%                    '14', '2', '1403-04-19', '0'; ...
%             };
%         
% After10days_Datasets = {'14', '1', '1403-05-03', '0'; ...
%                         '14', '2', '1403-05-03', '0'; ...
%             };
%         
% After20days_Datasets = {'14', '1', '1403-05-15', '0'; ...
%                         '14', '2', '1403-05-15', '0'; ...
%             };
%         
% After30days_Datasets = {'14', '1', '1403-05-27', '0'; ...
%                         '14', '2', '1403-05-27', '0'; ...
%             };        


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
    {'13', '1', '1403-04-13', '0'; ...
     '13', '2', '1403-04-13', '0';};
    {'14', '1', '1403-04-19', '0'; ...
     '14', '2', '1403-04-19', '0';};
    };
% for rat 11, 12 : before = 03/18
% Rat 9: 

After10days_Datasets = { ...
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
    {'13', '1', '1403-05-03', '0'; ...
     '13', '2', '1403-05-03', '0';};
    {'14', '1', '1403-05-03', '0'; ...
     '14', '2', '1403-05-03', '0';};
    };

After20days_Datasets = { ...
    {'8', '1', '1403-02-25', '0'; ...
     '8', '2', '1403-02-25', '0';};
    {'9', '2', '1403-03-31', '0';
                                 };
    {'11', '1', '1403-04-13', '0'; ...
     '11', '2', '1403-04-13', '0';};
    {'12', '1', '1403-04-13', '0'; ...
     '12', '2', '1403-04-13', '0';};
    {'13', '1', '1403-05-15', '0'; ...
     '13', '2', '1403-05-15', '0';};
    {'14', '1', '1403-05-15', '0'; ...
     '14', '2', '1403-05-15', '0';};
    };


After30days_Datasets = { ...
    {'9', '1', '1403-04-13', '0'; ...
     '9', '2', '1403-04-13', '0';};
    {'11', '1', '1403-05-03', '0'; ...
     '11', '2', '1403-05-03', '0';};
    {'12', '1', '1403-05-03', '0'; ...
     '12', '2', '1403-05-03', '0';};
    {'13', '1', '1403-05-27', '0'; ...
     '13', '2', '1403-05-27', '0';};
    {'14', '1', '1403-05-27', '0'; ...
     '14', '2', '1403-05-27', '0';};
    };


ch_labels = {%["mPFC", "Hippo", "NAcc", "LGN"], ...
             ["Hippo", "Pulvinar(LP)", "DS(CPu)", "PFC"], ...
             };
         
fs = 250;         
cfg = struct(                                    ...
    'fs',               2000,                    ...
    'n',                1000,                    ...
    'n_ch',             length(ch_labels{1}),    ...
    'is_saving',        0,                       ...
    'epoch_t_start',    0.3,                     ...
    'y_range',          [-1 1],                  ...
    'epoch_time',       [0.3, 1],                ... 
    'prep_band',        [0.1, 30],               ... 
    'run_idx',          1,                       ...
    'is_downsample',    1,                       ...
    'fs_down',          250,                     ...
    'is_trZscr',        1,                       ...
    'is_baseline_corr', 1,                       ...
    'pre_norm', 'sig_Zscr'                           ...
);

%%

% List of all possible datasets
dataset_names = {'Before', 'After10days', 'After20days', 'After30days'};
all_datasets = {Before_Datasets, After10days_Datasets, After20days_Datasets, After30days_Datasets};
rng(100)

% Loop over each rat's datasets
for i = length(Before_Datasets)-1
    matched_data = cell(1, length(dataset_names));
    matched_data{1} = Before_Datasets{i}; % Before data is always present
    
    % Find matching datasets for After10days, After20days, etc.
    for j = 2:length(dataset_names)
        for k = 1:length(all_datasets{j})
            if strcmp(Before_Datasets{i}{1,1}, all_datasets{j}{k}{1,1})
                matched_data{j} = all_datasets{j}{k};
                break;
            end
        end
    end
    
%     visualize_rat_erp(cfg, fs, ch_labels, matched_data{:});
    visualize_rat_MMN(cfg, fs, ch_labels, matched_data{:});
    
end


%%
All_Data_before = aggeregate_data(Before_Datasets, cfg);
All_Data_after10days = aggeregate_data(After10days_Datasets, cfg);
All_Data_after20days = aggeregate_data(After20days_Datasets, cfg);
% All_Data_after30days = aggeregate_data(After30days_Datasets, cfg);
% All_Data_after40days = aggeregate_data(After40days_Datasets, cfg);
% All_Data_after50days = aggeregate_data(After50days_Datasets, cfg);

%% ERP

% Before
min_tr_num = min([size(All_Data_before.target, 3), ...
                     size(All_Data_after10days.target, 3), ...
                     size(All_Data_after20days.target, 3)]);%, ...
%                      size(All_Data_after30days.target, 3)]);%, ...
                     %size(All_Data_after50days.target, 3)]);

                 
before_target_trials = All_Data_before.target(:,:,randperm(size(All_Data_before.target, 3), min_tr_num)); 
after10days_target_trials = All_Data_after10days.target(:,:,randperm(size(All_Data_after10days.target, 3), min_tr_num)); 
after20days_target_trials = All_Data_after20days.target(:,:,randperm(size(All_Data_after20days.target, 3), min_tr_num)); 
% after30days_target_trials = All_Data_after30days.target(:,:,randperm(size(All_Data_after30days.target, 3), min_tr_num)); 
% after40days_target_trials = All_Data_after40days.target(:,:,randperm(size(All_Data_after40days.target, 3), min_tr_num)); 
% after50days_target_trials = All_Data_after50days.target(:,:,randperm(size(All_Data_after50days.target, 3), min_tr_num)); 

before_target_ERPs = ERP_bootstrap(before_target_trials, cfg, size(before_target_trials, 3));
after10days_target_ERPs = ERP_bootstrap(after10days_target_trials, cfg, size(after10days_target_trials, 3));
after20days_target_ERPs = ERP_bootstrap(after20days_target_trials, cfg, size(after20days_target_trials, 3));
% after30days_target_ERPs = ERP_bootstrap(after30days_target_trials, cfg, size(after30days_target_trials, 3));
% after40days_target_ERPs = ERP_bootstrap(after40days_target_trials, cfg, size(after40days_target_trials, 3));
% after50days_target_ERPs = ERP_bootstrap(after50days_target_trials, cfg, size(after50days_target_trials, 3));

%% Visualization

figure('WindowState', 'maximized');
smple_num = size(before_target_ERPs, 2);
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;

for i=1:4
    subplot(4,2,2*(i-1)+1);
    stdshade(squeeze(before_target_ERPs(i,:,:))',0.4, 'b', time); hold on;
    stdshade(squeeze(after10days_target_ERPs(i,:,:))',0.4, 'r', time);
    stdshade(squeeze(after20days_target_ERPs(i,:,:))',0.4, 'g', time);
%     stdshade(squeeze(after30days_target_ERPs(i,:,:))',0.4, 'm', time); 
%     stdshade(squeeze(after40days_target_ERPs(i,:,:))',0.4, 'k', time); hold off;
%     stdshade(squeeze(after50days_target_ERPs(i,:,:))',0.4, 'k', time); hold off;
    title(strcat('Rat', num2str(Before_Datasets{1,1}), ' - Target trials - ', ch_labels{1}(i)))
    legend('Before', 'After 10days', 'After 20days')%, 'After 30days')%, 'After 50days')
%     legend('Before', 'After 10days')
    
    subplot(4,2,2*i);
    stdshade(squeeze(All_Data_before.std(i,:,:))',0.4, 'b', time); hold on;
    stdshade(squeeze(All_Data_after10days.std(i,:,:))',0.4, 'r', time);
    stdshade(squeeze(All_Data_after20days.std(i,:,:))',0.4, 'g', time);
%     stdshade(squeeze(All_Data_after30days.std(i,:,:))',0.4, 'm', time); 
%     stdshade(squeeze(All_Data_after40days.std(i,:,:))',0.4, 'k', time); hold off;
%     stdshade(squeeze(All_Data_after50days.std(i,:,:))',0.4, 'k', time); hold off;
    title(strcat('Rat', num2str(Before_Datasets{1,1}), ' - std trials - ', ch_labels{1}(i)))
    legend('Before', 'After 10days', 'After 20days')%, 'After 30days')%, 'After 50days')
%     legend('Before', 'After 10days')
end

if cfg.is_saving
    save_fig(strcat('../Results/Rat-', num2str(Before_Datasets{1,1}),'/'), ...
                    strcat('Rat', num2str(Before_Datasets{1,1}),'-ERPs_all_result-prep_band-', num2str(cfg.prep_band(end))))
end



%% Functions

function visualize_rat_erp(cfg, fs, ch_labels, varargin)
    % varargin contains the datasets in the order: Before, After10days, After20days, etc.
    dataset_names = {'Before', 'After10days', 'After20days', 'After30days', 'After40days', 'After50days'};
    all_data = struct();
    
    % Aggregate data if the dataset exists
    for i = 1:length(varargin)
        if ~isempty(varargin{i})
            all_data.(dataset_names{i}) = aggeregate_data(varargin{i}, cfg);
        end
    end
    
    % Find the minimum number of trials across all available datasets
    min_tr_num = inf;
    fields = fieldnames(all_data);
    for i = 1:length(fields)
        min_tr_num = min(min_tr_num, size(all_data.(fields{i}).target, 3));
    end
    
    % Extract trials and compute ERPs
    erp_data = struct();
    for i = 1:length(fields)
        trials = all_data.(fields{i}).target(:,:,randperm(size(all_data.(fields{i}).target, 3), min_tr_num));
        erp_data.(fields{i}) = ERP_bootstrap(trials, cfg, size(trials, 3));
    end
    
    % Visualization
    figure('WindowState', 'maximized');
    smple_num = size(erp_data.Before, 2);
    time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;
    
    colors = {'b', 'r', 'g', 'm', 'k', 'c'};
    for i = 1:4
        subplot(4, 2, 2*(i-1)+1);
        hold on;
        legends = {};
        for j = 1:length(fields)
            stdshade(squeeze(erp_data.(fields{j})(i,:,:))', 0.4, colors{j}, time);
            legends{end+1} = dataset_names{j};
        end
        title(strcat('Rat', num2str(varargin{1}{1,1}), ' - Target trials - ', ch_labels{1}(i)));
        legend(legends);
        
        subplot(4, 2, 2*i);
        hold on;
        for j = 1:length(fields)
            stdshade(squeeze(all_data.(fields{j}).std(i,:,:))', 0.4, colors{j}, time);
        end
        title(strcat('Rat', num2str(varargin{1}{1,1}), ' - std trials - ', ch_labels{1}(i)));
        legend(legends);
    end
    
    if cfg.is_saving
        save_fig(strcat('../Results/Rat-', num2str(varargin{1}{1,1}),'/'), ...
                 strcat('Rat', num2str(varargin{1}{1,1}), '-ERPs_all_result-prep_band-', num2str(cfg.prep_band(end))));
    end
    
end



function visualize_rat_MMN(cfg, fs, ch_labels, varargin)
    % varargin contains the datasets in the order: Before, After10days, After20days, etc.
    dataset_names = {'Before', 'After10days', 'After20days', 'After30days', 'After40days', 'After50days'};
    all_data = struct();
    
    % Aggregate data if the dataset exists
    for i = 1:length(varargin)
        if ~isempty(varargin{i})
            all_data.(dataset_names{i}) = aggeregate_data(varargin{i}, cfg);
        end
    end
    
    % Find the minimum number of trials across all available datasets
    min_tr_num = inf;
    fields = fieldnames(all_data);
    for i = 1:length(fields)
        min_tr_num = min(min_tr_num, size(all_data.(fields{i}).target, 3));
    end
    
    % Extract trials and compute ERPs
    erp_data = struct();
    for i = 1:length(fields)
        trials = all_data.(fields{i}).target(:,:,randperm(size(all_data.(fields{i}).target, 3), min_tr_num));
        erp_data.(fields{i}) = ERP_bootstrap(trials, cfg, size(trials, 3));
    end
    
    % Visualization
    figure('WindowState', 'maximized');
    smple_num = size(erp_data.Before, 2);
    time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;
    
    for i = 1:4
        subplot(2, 2, i);
        hold on;
        legends = {};
        for j = 1:length(fields)
            sig = mean(squeeze(erp_data.(fields{j})(i,:,:)), 2, 'omitnan') ...
                - mean(squeeze(all_data.(fields{j}).std(i,:,:)), 2, 'omitnan');
            plot(time, sig, 'linewidth', 2)
            legends{end+1} = dataset_names{j};
        end
        title(strcat('Rat', num2str(varargin{1}{1,1}), ' - MMN - ', ch_labels{1}(i)));
        legend(legends);
        
    end
    
    if cfg.is_saving
        save_fig(strcat('../Results/MMN/Rat-', num2str(varargin{1}{1,1}),'/'), ...
                 strcat('Rat', num2str(varargin{1}{1,1}), '-ERPs_all_result-prep_band-', num2str(cfg.prep_band(end))));
    end
    
end
