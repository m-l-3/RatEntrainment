clc; close all; clear;

addpath('./Functions')
addpath('./Functions/Visualization')
addpath('E:\SUT\Neuro-RA\OddBall_Proj\Data\Dataset\')
eeglab;

%% Load Data and PreProcess

clc;

Before_Datasets = { ...
%     {'5', '1', '1402-09-09', '0'; ...
%      '5', '1', '1402-09-11', '0';};
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
%     {'5', '1', '1402-09-20', '0'; ...
%      '5', '1', '1402-09-20', '0';};
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
    'prep_band',        [0.5, 12],               ... 
    'run_idx',          1,                       ...
    'is_downsample',    1,                       ...
    'fs_down',          250,                     ...
    'is_trZscr',        1,                       ...
    'is_baseline_corr', 1,                       ...
    'pre_norm', 'sig_Zscr'                           ...
);

%%
ERP_feature = 'P300';
[Before_all_ERPs_latency, Before_all_ERPs_peaks, ...
Before_target_ERPs_latency, Before_target_ERPs_peaks, ...
Before_std_ERPs_latency, Before_std_ERPs_peaks] = calc_AllRat_ERPs(Before_Datasets, cfg, ERP_feature);

[After10_all_ERPs_latency, After10_all_ERPs_peaks, ...
After10_target_ERPs_latency, After10_target_ERPs_peaks, ...
After10_std_ERPs_latency, After10_std_ERPs_peaks] = calc_AllRat_ERPs(After10days_Datasets, cfg, ERP_feature);

[After20_all_ERPs_latency, After20_all_ERPs_peaks, ...
After20_target_ERPs_latency, After20_target_ERPs_peaks, ...
After20_std_ERPs_latency, After20_std_ERPs_peaks] = calc_AllRat_ERPs(After20days_Datasets, cfg, ERP_feature);

[After30_all_ERPs_latency, After30_all_ERPs_peaks, ...
After30_target_ERPs_latency, After30_target_ERPs_peaks, ...
After30_std_ERPs_latency, After30_std_ERPs_peaks] = calc_AllRat_ERPs(After30days_Datasets, cfg, ERP_feature);

%%

% Example data
% array1 = Before_all_ERPs_latency{end-3}(2,:);
% array2 = After10_all_ERPs_latency{end-3}(2,:);
% array3 = After20_all_ERPs_latency{end-3}(2,:);
% array4 = After30_all_ERPs_latency{end-3}(2,:);

% array1 = Before_std_ERPs_latency{end-3}(2,:);
% array2 = After10_std_ERPs_latency{end-3}(2,:);
% array3 = After20_std_ERPs_latency{end-3}(2,:);
% array4 = After30_std_ERPs_latency{end-3}(2,:);

ch = 2;
% array1 = Before_target_ERPs_latency{end-1}(ch,:);
% array2 = After10_target_ERPs_latency{end-1}(ch,:);
% array3 = After20_target_ERPs_latency{end-1}(ch,:);
% array4 = After30_target_ERPs_latency{end-1}(ch,:);

array1 = Before_std_ERPs_peaks{end-0}(ch,:);
array2 = After10_std_ERPs_peaks{end-0}(ch,:);
array3 = After20_std_ERPs_peaks{end-0}(ch,:);
array4 = After30_std_ERPs_peaks{end-0}(ch,:);

% array1 = Before_std_ERPs_peaks{end-3}(4,:);
% array2 = Before_target_ERPs_peaks{end-3}(4,:);
% plotBoxPlotsWithPValues(array1, array2)

plotBoxPlotsWithPValues(array1, array2, array3, array4)
title(ch)

%%

colors = cbrewer('seq', 'Blues', 4);
% data = [array1; array2; array3; array4];
plotDataWithErrorBars(array1, array2, array3, array4, colors);
% ylim([150 300])


%% Lat.m

lat_cfg = struct( ...
    'sampRate', fs, 'fig', 0, 'peakWin', [151, 226]...
);
sgn = 1;
%%
Before_trials = prepare_trials(Before_Datasets, cfg);
After10_trials = prepare_trials(After10days_Datasets, cfg);
After20_trials = prepare_trials(After20days_Datasets, cfg);
After30_trials = prepare_trials(After30days_Datasets, cfg);

%%
Before_lat_res = calc_lat_peak_AllRats(Before_trials, lat_cfg, sgn);
After10_lat_res = calc_lat_peak_AllRats(After10_trials, lat_cfg, sgn);
After20_lat_res = calc_lat_peak_AllRats(After20_trials, lat_cfg, sgn);
After30_lat_res = calc_lat_peak_AllRats(After30_trials, lat_cfg, sgn);

%% Per Rat

figure;
colors = cbrewer('seq', 'Blues', 4);
lineColors = [0.5*ones(454,3) 0.7*ones(454,1)];
xticks = {'Before', 'After 10', 'After 20', 'After 30'};

ch_label = {%["mPFC", "Hippo", "NAcc", "LGN"], ...
             ["Hippo", "Pulvinar(LP)", "DS(CPu)", "PFC"], ...
             };
%%
% rat_no = [7, 8, 9, 11, 12, 13, 14];
rat_no = [12, 13, 14];
% rat_id = {[1,1], [2,2,1], [3,3,2,1], [4,4,3,2], [5,5,4,3], ...
%           [6,6,5,4], [7,7,6,5]};
rat_id = {[5,5,4,3], ...
          [6,6,5,4], [7,7,6,5]};
colors = cbrewer('seq', 'Blues', 4);
fields = fieldnames(Before_lat_res); % Get all main field names
subfields = {'maxPeaks', 'peakLat', 'areaLat'};
xticks_label = {'Before', 'After 10', 'After 20', 'After 30'};

for rat_i = 1% 1:length(rat_no)
    rat_idx = rat_id{rat_i};
    for field_i = 1:length(fields)
        field_name = fields{field_i};
%         subfields = fieldnames(Before_lat_res(rat_idx(1)).(field_name){1}); % Get subfield names
        for subfield_i = 1:length(subfields)
            subfield_name = subfields{subfield_i};
            figure('WindowState', 'maximized');
            sgtitle(sprintf('Rat %d - %s trials - %s ', rat_no(rat_i), field_name, subfield_name))
            for ch_i = 1:4
                subplot(2, 2, ch_i);
                rat_idx = rat_id{rat_i};
                array1 = Before_lat_res(rat_idx(1)).(field_name){ch_i}.(subfield_name);
                array2 = After10_lat_res(rat_idx(2)).(field_name){ch_i}.(subfield_name);
                if length(rat_idx) == 2
                    plotBoxPlotsWithPValues(array1, array2);
                elseif length(rat_idx) == 3
                    array3 = After20_lat_res(rat_idx(3)).(field_name){ch_i}.(subfield_name);
                    plotBoxPlotsWithPValues(array1, array2, array3);
                elseif length(rat_idx) == 4
                    array3 = After20_lat_res(rat_idx(3)).(field_name){ch_i}.(subfield_name);
                    array4 = After30_lat_res(rat_idx(4)).(field_name){ch_i}.(subfield_name);
                    plotDataWithErrorBars(array1, array2, array3, array4, colors, xticks_label);
                end
                title(ch_labels{1}{ch_i});
            end
            if cfg.is_saving
                save_fig(strcat('../Results/ERP_boxplots/Rat-', num2str(rat_no(rat_i)), '/'), ...
                         strcat(field_name, subfield_name))
            end
        end
    end
%     close all;
end

%%

rat_no = [7, 8, 9, 11, 12, 13, 14];
% rat_no = [12, 13, 14];
rat_id = {[1,1], [2,2,1], [3,3,2,1], [4,4,3,2], [5,5,4,3], ...
          [6,6,5,4], [7,7,6,5]};

array_all_1 = [];
array_all_2 = [];
array_all_3 = [];
array_all_4 = [];

% subfields = {'peakLat', 'areaLat'};

% subfields = {'maxPeaks'};
subfields = {'peakLat'};

for rat_i = 1:length(rat_no)
    rat_idx = rat_id{rat_i};
    for field_i = 1:length(fields)
        field_name = fields{field_i};
%         subfields = fieldnames(Before_lat_res(rat_idx(1)).(field_name){1}); % Get subfield names
        for subfield_i = 1:length(subfields)
            subfield_name = subfields{subfield_i};
%             figure('WindowState', 'maximized');
%             sgtitle(sprintf('Rat %d - %s trials - %s ', rat_no(rat_i), field_name, subfield_name))
            for ch_i = 1:4
%                 subplot(2, 2, ch_i);
                rat_idx = rat_id{rat_i};
                array1 = Before_lat_res(rat_idx(1)).(field_name){ch_i}.(subfield_name);
                array2 = After10_lat_res(rat_idx(2)).(field_name){ch_i}.(subfield_name);
                array_all_1 = [array_all_1; array1];
                array_all_2 = [array_all_2; array2];
                if length(rat_idx) == 2
%                     array_all_1 = [array_all_1, array1];
%                     array_all_2 = [array_all_2, array2];
% %                     plotBoxPlotsWithPValues(array1, array2);
                elseif length(rat_idx) == 3
                    array3 = After20_lat_res(rat_idx(3)).(field_name){ch_i}.(subfield_name);
%                     plotBoxPlotsWithPValues(array1, array2, array3);
                    array_all_3 = [array_all_3; array3];
                elseif length(rat_idx) == 4
                    array3 = After20_lat_res(rat_idx(3)).(field_name){ch_i}.(subfield_name);
                    array4 = After30_lat_res(rat_idx(4)).(field_name){ch_i}.(subfield_name);
%                     plotDataWithErrorBars(array1, array2, array3, array4, colors, xticks_label);
                    array_all_3 = [array_all_3; array3];
                    array_all_4 = [array_all_4; array4];
                end
                title(ch_labels{1}{ch_i});
            end
            if cfg.is_saving
                save_fig(strcat('../Results/ERP_boxplots/Rat-', num2str(rat_no(rat_i)), '/'), ...
                         strcat(field_name, subfield_name))
            end
        end
    end
%     close all;
end

%%
figure;
plotDataWithErrorBars(array_all_1, array_all_2, array_all_3, array_all_4, colors, xticks_label);

%%

figure;
histogram(array_all_1)

figure;
histogram(array_all_2)

figure;
histogram(array_all_3)

figure;
histogram(array_all_4)


figure;
histogram(array_all_1); hold on;
histogram(array_all_2)
histogram(array_all_3)
histogram(array_all_4)

%%

rat_no = [7, 8, 9, 11, 12, 13, 14];
% rat_no = [12, 13, 14];
rat_id = {[1,1], [2,2,1], [3,3,2,1], [4,4,3,2], [5,5,4,3], ...
          [6,6,5,4], [7,7,6,5]};
% rat_id = {[5,5,4,3], ...
%           [6,6,5,4], [7,7,6,5]};

fields = fieldnames(Before_lat_res); % Get all main field names
subfields = {'maxPeaks', 'peakLat', 'areaLat'};
results = struct(); % Structure to store results

for rat_i = 1:length(rat_no)
    for field_i = 1:length(fields)
        field_name = fields{field_i};
        for subfield_i = 1:length(subfields)
            subfield_name = subfields{subfield_i};
            for ch_i = 1:4
                rat_idx = rat_id{rat_i};
                array1 = Before_lat_res(rat_idx(1)).(field_name){ch_i}.(subfield_name);
                array2 = After10_lat_res(rat_idx(2)).(field_name){ch_i}.(subfield_name);

                % Initialize result fields if not already done
                if ~isfield(results, field_name)
                    results.(field_name) = struct();
                end
                if ~isfield(results.(field_name), subfield_name)
                    results.(field_name).(subfield_name) = struct('mean_before', [], 'mean_after10', [], 'mean_after20', [], 'mean_after30', []);
                end

                % Compute and store mean
                mean_before = mean(array1);
                mean_after10 = mean(array2);
                results.(field_name).(subfield_name).mean_before(rat_i, ch_i) = mean_before;
                results.(field_name).(subfield_name).mean_after10(rat_i, ch_i) = mean_after10;

                if length(rat_idx) == 3
                    array3 = After20_lat_res(rat_idx(3)).(field_name){ch_i}.(subfield_name);
                    mean_after20 = mean(array3);
                    results.(field_name).(subfield_name).mean_after20(rat_i, ch_i) = mean_after20;
                elseif length(rat_idx) == 4
                    array3 = After20_lat_res(rat_idx(3)).(field_name){ch_i}.(subfield_name);
                    array4 = After30_lat_res(rat_idx(4)).(field_name){ch_i}.(subfield_name);
                    mean_after20 = mean(array3);
                    mean_after30 = mean(array4);
                    results.(field_name).(subfield_name).mean_after20(rat_i, ch_i) = mean_after20;
                    results.(field_name).(subfield_name).mean_after30(rat_i, ch_i) = mean_after30;
                end
            end
        end
    end
end

%%

results = struct(); % Structure to store results

for rat_i = 1:length(rat_no)
    for field_i = 1:length(fields)
        field_name = fields{field_i};
        for subfield_i = 1:length(subfields)
            subfield_name = subfields{subfield_i};
            for ch_i = 1:4
                rat_idx = rat_id{rat_i};
                array1 = Before_lat_res(rat_idx(1)).(field_name){ch_i}.(subfield_name);
                array2 = After10_lat_res(rat_idx(2)).(field_name){ch_i}.(subfield_name);

                % Initialize result fields if not already done
                if ~isfield(results, field_name)
                    results.(field_name) = struct();
                end
                if ~isfield(results.(field_name), subfield_name)
                    results.(field_name).(subfield_name) = struct('median_before', [], 'median_after10', [], 'median_after20', [], 'median_after30', []);
                end

                % Compute and store median
                median_before = median(array1);
                median_after10 = median(array2);
                results.(field_name).(subfield_name).median_before(rat_i, ch_i) = median_before;
                results.(field_name).(subfield_name).median_after10(rat_i, ch_i) = median_after10;

                if length(rat_idx) == 3
                    array3 = After20_lat_res(rat_idx(3)).(field_name){ch_i}.(subfield_name);
                    median_after20 = median(array3);
                    results.(field_name).(subfield_name).median_after20(rat_i, ch_i) = median_after20;
                elseif length(rat_idx) == 4
                    array3 = After20_lat_res(rat_idx(3)).(field_name){ch_i}.(subfield_name);
                    array4 = After30_lat_res(rat_idx(4)).(field_name){ch_i}.(subfield_name);
                    median_after20 = median(array3);
                    median_after30 = median(array4);
                    results.(field_name).(subfield_name).median_after20(rat_i, ch_i) = median_after20;
                    results.(field_name).(subfield_name).median_after30(rat_i, ch_i) = median_after30;
                end
            end
        end
    end
end


%%

fields = fieldnames(results); % Get all main field names
subfields = {'maxPeaks', 'peakLat', 'areaLat'};

for field_i = 1:length(fields)
    field_name = fields{field_i};
    for subfield_i = 1:length(subfields)
        subfield_name = subfields{subfield_i};
        
        figure('WindowState', 'maximized');
        for ch_i = 1:4
            % Collect data from results struct
            mean_before = results.(field_name).(subfield_name).mean_before(:, ch_i);
            mean_after10 = results.(field_name).(subfield_name).mean_after10(:, ch_i);
            mean_after20 = [];
            mean_after30 = [];

            % Remove zeros from the data arrays
            mean_before(mean_before == 0) = [];
            mean_after10(mean_after10 == 0) = [];

            % Check if means for after20 and after30 exist and remove zeros
            if isfield(results.(field_name).(subfield_name), 'mean_after20')
                mean_after20 = results.(field_name).(subfield_name).mean_after20(:, ch_i);
                mean_after20(mean_after20 == 0) = [];
            end
            if isfield(results.(field_name).(subfield_name), 'mean_after30')
                mean_after30 = results.(field_name).(subfield_name).mean_after30(:, ch_i);
                mean_after30(mean_after30 == 0) = [];
            end
            
            % Create boxplot
            subplot(2, 2, ch_i);
            if isempty(mean_after20) && isempty(mean_after30)
                plotBoxPlotsWithPValues(mean_before, mean_after10);
            elseif isempty(mean_after30)
                plotBoxPlotsWithPValues(mean_before, mean_after10, mean_after20);
            else
                plotBoxPlotsWithPValues(mean_before, mean_after10, mean_after20, mean_after30);
            end
            title(sprintf('%s - %s - %s', ch_labels{1}{ch_i}, field_name, subfield_name));
        end
    end
end

%%

fields = fieldnames(results); % Get all main field names
subfields = {'maxPeaks', 'peakLat', 'areaLat'};
colors = cbrewer('seq', 'Blues', 4);

for field_i = 1:length(fields)
    field_name = fields{field_i};
    for subfield_i = 1:length(subfields)
        subfield_name = subfields{subfield_i};
        
        figure('WindowState', 'maximized');
        for ch_i = 1:4
            % Collect data from results struct
            mean_before = results.(field_name).(subfield_name).mean_before(:, ch_i);
            mean_after10 = results.(field_name).(subfield_name).mean_after10(:, ch_i);
            mean_after20 = [];
            mean_after30 = [];

            % Remove zeros from the data arrays
            mean_before(mean_before == 0) = [];
            mean_after10(mean_after10 == 0) = [];

            % Check if means for after20 and after30 exist and remove zeros
            if isfield(results.(field_name).(subfield_name), 'mean_after20')
                mean_after20 = results.(field_name).(subfield_name).mean_after20(:, ch_i);
                mean_after20(mean_after20 == 0) = [];
            end
            if isfield(results.(field_name).(subfield_name), 'mean_after30')
                mean_after30 = results.(field_name).(subfield_name).mean_after30(:, ch_i);
                mean_after30(mean_after30 == 0) = [];
            end
            
            % Create boxplot
            subplot(2, 2, ch_i);
            if isempty(mean_after20) && isempty(mean_after30)
                line_num = max([length(mean_before), length(mean_after10)]);
                lineColors = [0.5*rand(line_num,3) 0.7*ones(line_num,1)];
                xticks = {'Before', 'After 10'};
                plotDataWithErrorBars(mean_before, mean_after10, colors, lineColors, xticks);
            elseif isempty(mean_after30)
                line_num = max([length(mean_before), length(mean_after10), length(mean_after20)]);
                lineColors = [0.5*rand(line_num,3) 0.7*ones(line_num,1)];
                xticks = {'Before', 'After 10', 'After 20'};
                plotDataWithErrorBars(mean_before, mean_after10, mean_after20,colors, lineColors, xticks);
            else
                line_num = max([length(mean_before), length(mean_after10), length(mean_after20), length(mean_after30)]);
                lineColors = [0.5*rand(line_num,3) 0.7*ones(line_num,1)];
                xticks = {'Before', 'After 10', 'After 20', 'After 30'};
                plotDataWithErrorBars(mean_before, mean_after10, mean_after20, mean_after30, colors, lineColors, xticks);
            end
            title(sprintf('Mean - %s - %s - %s', ch_labels{1}{ch_i}, field_name, subfield_name));
        end
    end
end

%%

fields = fieldnames(results); % Get all main field names
subfields = {'maxPeaks', 'peakLat', 'areaLat'};
colors = cbrewer('seq', 'Blues', 4);

for field_i = 1:length(fields)
    field_name = fields{field_i};
    for subfield_i = 1:length(subfields)
        subfield_name = subfields{subfield_i};
        
        figure('WindowState', 'maximized');
        for ch_i = 1:4
            % Collect data from results struct
            mean_before = results.(field_name).(subfield_name).median_before(:, ch_i);
            mean_after10 = results.(field_name).(subfield_name).median_after10(:, ch_i);
            mean_after20 = [];
            mean_after30 = [];

            % Remove zeros from the data arrays
            mean_before(mean_before == 0) = [];
            mean_after10(mean_after10 == 0) = [];

            % Check if means for after20 and after30 exist and remove zeros
            if isfield(results.(field_name).(subfield_name), 'mean_after20')
                mean_after20 = results.(field_name).(subfield_name).median_after20(:, ch_i);
                mean_after20(mean_after20 == 0) = [];
            end
            if isfield(results.(field_name).(subfield_name), 'mean_after30')
                mean_after30 = results.(field_name).(subfield_name).median_after30(:, ch_i);
                mean_after30(mean_after30 == 0) = [];
            end
            
            % Create boxplot
            subplot(2, 2, ch_i);
            if isempty(mean_after20) && isempty(mean_after30)
                line_num = max([length(mean_before), length(mean_after10)]);
                lineColors = [0.5*rand(line_num,3) 0.7*ones(line_num,1)];
                xticks = {'Before', 'After 10'};
                plotDataWithErrorBars(mean_before, mean_after10, colors, lineColors, xticks);
            elseif isempty(mean_after30)
                line_num = max([length(mean_before), length(mean_after10), length(mean_after20)]);
                lineColors = [0.5*rand(line_num,3) 0.7*ones(line_num,1)];
                xticks = {'Before', 'After 10', 'After 20'};
                plotDataWithErrorBars(mean_before, mean_after10, mean_after20,colors, lineColors, xticks);
            else
                line_num = max([length(mean_before), length(mean_after10), length(mean_after20), length(mean_after30)]);
                lineColors = [0.5*rand(line_num,3) 0.7*ones(line_num,1)];
                xticks = {'Before', 'After 10', 'After 20', 'After 30'};
                plotDataWithErrorBars(mean_before, mean_after10, mean_after20, mean_after30, colors, lineColors, xticks);
            end
            title(sprintf('Median - %s - %s - %s', ch_labels{1}{ch_i}, field_name, subfield_name));
        end
    end
end

%%
for rat_i=1:length(rat_no)
   
    figure('WindowState', 'maximized');
    for ch_i=1:4    
        subplot(2,2,ch_i)
        rat_idx = rat_id{rat_i};
        array1 = Before_lat_res(rat_idx(1)).All{ch_i}.peakLat;
        array2 = After10_lat_res(rat_idx(2)).All{ch_i}.peakLat;
        if length(rat_idx) ==  2
            plotBoxPlotsWithPValues(array1, array2);
        elseif length(rat_idx) == 3
            array3 = After20_lat_res(rat_idx(3)).All{ch_i}.peakLat;
            plotBoxPlotsWithPValues(array1, array2, array3);
        elseif length(rat_idx) == 4
            array3 = After20_lat_res(rat_idx(3)).All{ch_i}.peakLat;
            array4 = After30_lat_res(rat_idx(4)).All{ch_i}.peakLat;
            plotBoxPlotsWithPValues(array1, array2, array3, array4);
        end
        title(ch_label{1}{i})
    end

end
      
figure;
for i=1:4
    
    subplot(2,2,i)
    array1 = Before_lat_res(end - rat_no).All{i}.peakLat;
    array2 = After10_lat_res(end - rat_no).All{i}.peakLat;
    array3 = After20_lat_res(end - rat_no).All{i}.peakLat;
    array4 = After30_lat_res(end - rat_no).All{i}.peakLat;
    plotBoxPlotsWithPValues(array1, array2, array3, array4);
    title(ch_label{1}{i})
    
end

%%

rat_no = 2; 
for i=[1,2,3,4]
    
    subplot(2,2,i)
    array1 = Before_lat_res(end - rat_no).All{i}.areaLat;
    array2 = After10_lat_res(end - rat_no).All{i}.areaLat;
    array3 = After20_lat_res(end - rat_no).All{i}.areaLat;
    array4 = After30_lat_res(end - rat_no).All{i}.areaLat;
    histogram(array1); hold on;
%     histogram(array2);
%     histogram(array3);
    histogram(array2); hold off;
    title(ch_label{1}{i})
    
end

%%

for i=1:num_rats
    
end


%%
fields = fieldnames(Before_lat_res); % Get all main field names

rat_no = [7, 8, 9, 11, 12, 13, 14];
% rat_no = [12, 13, 14];
rat_id = {[1,1], [2,2,1], [3,3,2,1], [4,4,3,2], [5,5,4,3], ...
          [6,6,5,4], [7,7,6,5]};

subfields = {'peakLat', 'areaLat'};

% subfields = {'maxPeaks'};
% subfields = {'peakLat'};

aggreg_lat_res = cell(length(fields), length(subfields), 4);

for field_i = 1:length(fields)
    field_name = fields{field_i};
    for subfield_i = 1:length(subfields)
        subfield_name = subfields{subfield_i};
        for ch_i = 1:4
            array_all_1 = [];
            array_all_2 = [];
            array_all_3 = [];
            array_all_4 = [];
            for rat_i = 1:length(rat_no)
                rat_idx = rat_id{rat_i};
                array1 = Before_lat_res(rat_idx(1)).(field_name){ch_i}.(subfield_name);
                array2 = After10_lat_res(rat_idx(2)).(field_name){ch_i}.(subfield_name);
                array_all_1 = [array_all_1; array1];
                array_all_2 = [array_all_2; array2];
                if length(rat_idx) == 3
                    array3 = After20_lat_res(rat_idx(3)).(field_name){ch_i}.(subfield_name);
                    array_all_3 = [array_all_3; array3];
                elseif length(rat_idx) == 4
                    array3 = After20_lat_res(rat_idx(3)).(field_name){ch_i}.(subfield_name);
                    array4 = After30_lat_res(rat_idx(4)).(field_name){ch_i}.(subfield_name);
                    array_all_3 = [array_all_3; array3];
                    array_all_4 = [array_all_4; array4];
                end
            end
            aggreg_lat_res{field_i, subfield_i, ch_i} = struct(...
                'Before', array_all_1, 'After10', array_all_2, ...
                'After20', array_all_3, 'After30', array_all_4);
        end
    end
end

%%
fields = fieldnames(Before_lat_res); % Get all main field names
subfields = {'peakLat', 'areaLat'};

is_connectLine = 0;
colors = cbrewer('seq', 'Blues', 4);
n = 7;
lineColors = 0.7*ones(n, 4); % Initialize an array to hold the colors
for i = 1:n
    hue = (i - 1) / n; % Evenly spaced hues
    rgb = hsv2rgb([hue, 1, 1]); % Convert HSV to RGB
    lineColors(i, 1:3) = rgb; % Convert to 0-255 range
end

xticks_label = {'Before', 'After 10', 'After 20', 'After 30'};

for field_i = 1:length(fields)
    field_name = fields{field_i};
    for subfield_i = 1:length(subfields)
        subfield_name = subfields{subfield_i};
        for ch_i = 1:4
            temp_data = aggreg_lat_res{field_i, subfield_i, ch_i};
            figure('WindowState', 'maximized');
            sgtitle(strcat(field_name, '-', subfield_name, '-', ch_labels{1}{ch_i}))
            plotDataWithErrorBars(is_connectLine, colors, lineColors, xticks_label, ...
                    temp_data.Before, temp_data.After10, temp_data.After20, temp_data.After30);
            if cfg.is_saving
               save_path = '../Results\Single_trials\ERP_barplots/';
               save_fig(save_path, strcat(field_name, '-', subfield_name, '-', ch_labels{1}{ch_i}))
            end
        end
    end
end

%%

for field_i = 1:length(fields)
    field_name = fields{field_i};
    for subfield_i = 1:length(subfields)
        subfield_name = subfields{subfield_i};
        for ch_i = 1:4
            temp_data = aggreg_lat_res{field_i, subfield_i, ch_i};
            figure('WindowState', 'maximized');
            sgtitle(strcat(field_name, '-', subfield_name, '-', ch_labels{1}{ch_i}))
            histogram(temp_data.Before); hold on;
            histogram(temp_data.After10)
            histogram(temp_data.After20)
            histogram(temp_data.After30); hold off;
            legend('Before', 'After10', 'After20', 'After30')
        end
    end
end

%%  Functions

function out = prepare_trials(Datasets, cfg)

    out = cell(size(Datasets, 1), 1);
        
    for i=1:size(Datasets, 1)
        
        Dataset = Datasets{i};
        All_Data = aggeregate_data(Dataset, cfg);
        
        out{i} = All_Data;
                
    end

end

function results = calc_lat_peak_AllRats(data, lat_cfg, sgn)

    All =  cell(size(data, 1), 1);
    target = cell(size(data, 1), 1);
    std = cell(size(data, 1), 1);
        
    for i=1:size(data, 1)
        
        All_Data = data{i};
        
        All{i} = find_latency(All_Data.All, lat_cfg, sgn);
        target{i} = find_latency(All_Data.target, lat_cfg, sgn);
        std{i} = find_latency(All_Data.std, lat_cfg, sgn);
                
    end
    
    results = struct(...
        'All', All, ...
        'target', target, ...
        'std', std ...
    ); 

end


function out = calc_AllRat_ERPs(Datasets, cfg, ERP_feature)

    allRats_all_ERPs_latency = {};
    allRats_target_ERPs_latency = {};
    allRats_std_ERPs_latency = {};
    
    allRats_all_ERPs_peaks = {};
    allRats_target_ERPs_peaks = {};
    allRats_std_ERPs_peaks = {};

    for i=size(Datasets, 1)-2

        fprintf('Step %d / %d \n', i, size(Datasets, 1))

        Dataset = Datasets{i};
        All_Data = aggeregate_data(Dataset, cfg);

        rat_all_ERPs_latency = [];
        rat_target_ERPs_latency = [];
        rat_std_ERPs_latency = [];

        rat_all_ERPs_peaks = [];
        rat_target_ERPs_peaks = [];
        rat_std_ERPs_peaks = [];
        
        if ERP_feature == "P300"
            search_window = 151:226;  
            sign = 1;
        elseif ERP_feature == "N100"
    %         search_window = 170:200;
            search_window = 212:250;
            sign = -1;
        end
        
        for j=1:size(All_Data.All, 3)
            [peak, latency] = nanmax(sign * All_Data.All(:,search_window,j), [], 2); 
            if any(isnan(peak))
                continue
            end
            rat_all_ERPs_latency = [rat_all_ERPs_latency, latency+search_window(1)];
            rat_all_ERPs_peaks = [rat_all_ERPs_peaks, peak];
        end
        
        for j=1:size(All_Data.target, 3)
            [peak, latency] = nanmax(sign * All_Data.target(:,search_window,j), [], 2); 
            if any(isnan(peak))
                continue
            end
            rat_target_ERPs_latency = [rat_target_ERPs_latency, latency+search_window(1)];
            rat_target_ERPs_peaks = [rat_target_ERPs_peaks, peak];
        end
        
        for j=1:size(All_Data.std, 3)
            [peak, latency] = nanmax(sign * All_Data.std(:,search_window,j), [], 2); 
            if any(isnan(peak))
                continue
            end
            rat_std_ERPs_latency = [rat_std_ERPs_latency, latency+search_window(1)];
            rat_std_ERPs_peaks = [rat_std_ERPs_peaks, peak];
        end
        
        allRats_all_ERPs_latency{i} = rat_all_ERPs_latency;
        allRats_target_ERPs_latency{i} = rat_target_ERPs_latency;
        allRats_std_ERPs_latency{i} = rat_std_ERPs_latency;

        allRats_all_ERPs_peaks{i} = rat_all_ERPs_peaks;
        allRats_target_ERPs_peaks{i} = rat_target_ERPs_peaks;
        allRats_std_ERPs_peaks{i} = rat_std_ERPs_peaks;
    end
    
    out_ = struct(                            ...
        'All', allRats_all_ERPs_peaks,       ...
        'target', allRats_target_ERPs_peaks, ...
        'std', allRats_std_ERPs_peaks        ...
    );

end


% function plotBoxPlotsWithPValues(varargin)
%     % varargin: variable input arguments, each representing an array of data
%     numGroups = nargin;
%     combinedData = [];
%     group = [];
%     labels = cell(1, numGroups);
% 
%     % Combine data and create grouping variable
%     for i = 1:numGroups
%         array = varargin{i};
%         combinedData = [combinedData, array];
%         group = [group; repmat(i, length(array), 1)];
%         labels{i} = sprintf('Group %d', i);
%     end
% 
%     % Plot the box plot
%     figure;
%     boxplot(combinedData, group, 'Labels', labels);
%     ylabel('Values');
%     title('Box Plot with Significance Stars');
% 
%     % Calculate p-values and add significance stars
%     pairs = nchoosek(1:numGroups, 2);
%     pValues = zeros(size(pairs, 1), 1);
%     for k = 1:size(pairs, 1)
%         pValues(k) = ranksum(varargin{pairs(k, 1)}, varargin{pairs(k, 2)});
%     end
%     sigstar(num2cell(pairs, 2), pValues);
% 
%     % Display p-values
%     fprintf('P-values:\n');
%     for k = 1:size(pairs, 1)
%         fprintf('Group %d vs Group %d: %f\n', pairs(k, 1), pairs(k, 2), pValues(k));
%     end
% end

function plotBoxPlotsWithPValues(varargin)
    % varargin: variable input arguments, each representing an array of data
    numGroups = nargin;
    maxLen = max(cellfun(@length, varargin));  % Find the maximum length of the input arrays
    combinedData = [];
    group = [];
    labels = cell(1, numGroups);
    
    % Combine data and create grouping variable
    for i = 1:numGroups
        array = varargin{i};
        % Pad arrays with NaN to make them the same length
        paddedArray = NaN(maxLen, 1);
        paddedArray(1:length(array)) = array;
        combinedData = [combinedData; paddedArray];
        group = [group; repmat(i, maxLen, 1)];
        labels{i} = sprintf('Group %d', i);
    end
    
    % Plot the box plot
%     figure;
    boxplot(combinedData, group, 'Labels', labels);
    ylabel('Values');
    title('Box Plot with Significance Stars');
    
    % Calculate p-values and add significance stars
    pairs = nchoosek(1:numGroups, 2);
    pValues = zeros(size(pairs, 1), 1);
    for k = 1:size(pairs, 1)
        pValues(k) = ranksum(varargin{pairs(k, 1)}, varargin{pairs(k, 2)}, 'tail', 'right');
    end
    
    sigstar(num2cell(pairs, 2), pValues);
    
    % Display p-values
    fprintf('P-values:\n');
    for k = 1:size(pairs, 1)
        fprintf('Group %d vs Group %d: %f\n', pairs(k, 1), pairs(k, 2), pValues(k));
    end
end
