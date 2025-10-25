% clc; close all; clear;

addpath('./Functions')
addpath('./Functions/Visualization')
addpath('./Functions/PAC')
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
    };

After20days_Datasets = { ...
    {%'8', '1', '1403-02-25', '0'; ...
     '8', '2', '1403-02-25', '0';}%;
%     {'9', '1', '1403-04-13', '0'; ...
%      '9', '2', '1403-04-13', '0';};
%     {'11', '1', '1403-04-13', '0'; ...
%      '11', '2', '1403-04-13', '0';};
%     {'12', '1', '1403-04-13', '0'; ...
%      '12', '2', '1403-04-13', '0';};
    };

ch_labels = {%["mPFC", "Hippo", "NAcc", "LGN"], ...
             ["Hippo", "Pulvinar(LP)", "DS(CPu)", "PFC"], ...
             };
         
fs = 2000;         
cfg = struct(                              ...
    'fs',               2000,                    ...
    'n',                100,                    ...
    'n_ch',             length(ch_labels{1}),     ...
    'is_saving',        0,                     ...
    'epoch_t_start',    0.5,                   ...
    'y_range',          [-1 1],            ...
    'epoch_time',       [0.5, 1],              ... 
    'prep_band',        [1 300],               ... 
    'run_idx',          1,                      ...
    'is_downsample',    0,                      ...
    'fs_down',          250,                     ...
    'selected_chs',     1:4,                  ...
    'comodu_lowBand',   [5, 13],                ...
    'comodu_highBand',  [20, 90],                ...
    'nbins',            18,                      ...
    'nperm',            50,                        ...
    'interval',         0.5 * fs,               ...
    'w_step',           0.1 * fs               ...
);

%% 

smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * cfg.fs;
% Before_all_ERPs = zeros(cfg.n_ch, smple_num, size(Before_Datasets, 1));
% Before_target_ERPs = zeros(cfg.n_ch, smple_num, size(Before_Datasets, 1));
% Before_std_ERPs = zeros(cfg.n_ch, smple_num, size(Before_Datasets, 1));
% 
% for i=1:size(Before_Datasets, 1)
%    
%     Dataset = Before_Datasets{i};
%     
%     All_Data = aggeregate_data(Dataset, cfg);
%     
%     if Dataset{1,1} == '5'
%         % "mPFC", "Hippo", "NAcc", "LGN"
%         All_ERP = mean(All_Data.All, 3);
%         target_bootstrap = ERP_bootstrap(All_Data.target, cfg, size(All_Data.target, 3));
%         target_ERP = mean(target_bootstrap, 3);
%         std_ERP = mean(All_Data.std, 3);
%         Before_all_ERPs(:,:,i) = [All_ERP(2,:); NaN(size(All_ERP(2,:))); ...
%                                  NaN(size(All_ERP(2,:))); All_ERP(2,:)];
%         Before_target_ERPs(:,:,i) = [target_ERP(2,:); NaN(size(target_ERP(2,:))); ...
%                                  NaN(size(target_ERP(2,:))); target_ERP(2,:)];
%         Before_std_ERPs(:,:,i) = [std_ERP(2,:); NaN(size(std_ERP(2,:))); ...
%                                  NaN(size(std_ERP(2,:))); std_ERP(2,:)];
%     else
%         Before_all_ERPs(:,:,i) = mean(All_Data.All, 3);
%         target_bootstrap = ERP_bootstrap(All_Data.target, cfg, size(All_Data.target, 3));
%         Before_target_ERPs(:,:,i) = mean(target_bootstrap, 3);
%         Before_std_ERPs(:,:,i) = mean(All_Data.std, 3);
%     end
% end
% 
% After10days_all_ERPs = zeros(cfg.n_ch, smple_num, size(After10days_Datasets, 1));
% After10days_target_ERPs = zeros(cfg.n_ch, smple_num, size(After10days_Datasets, 1));
% After10days_std_ERPs = zeros(cfg.n_ch, smple_num, size(After10days_Datasets, 1));
% 
% for i=1:size(After10days_Datasets, 1)
%    
%     Dataset = After10days_Datasets{i};
%     
%     All_Data = aggeregate_data(Dataset, cfg);
%     
%     if Dataset{1,1} == '5'
%         % "mPFC", "Hippo", "NAcc", "LGN"
%         All_ERP = mean(All_Data.All, 3);
%         target_bootstrap = ERP_bootstrap(All_Data.target, cfg, size(All_Data.target, 3));
%         target_ERP = mean(target_bootstrap, 3);
%         std_ERP = mean(All_Data.std, 3);
%         After10days_all_ERPs(:,:,i) = [All_ERP(2,:); NaN(size(All_ERP(2,:))); ...
%                                  NaN(size(All_ERP(2,:))); All_ERP(2,:)];
%         After10days_target_ERPs(:,:,i) = [target_ERP(2,:); NaN(size(target_ERP(2,:))); ...
%                                  NaN(size(target_ERP(2,:))); target_ERP(2,:)];
%         After10days_std_ERPs(:,:,i) = [std_ERP(2,:); NaN(size(std_ERP(2,:))); ...
%                                  NaN(size(std_ERP(2,:))); std_ERP(2,:)];
%     else
%         After10days_all_ERPs(:,:,i) = mean(All_Data.All, 3);
%         target_bootstrap = ERP_bootstrap(All_Data.target, cfg, size(All_Data.target, 3));
%         After10days_target_ERPs(:,:,i) = mean(target_bootstrap, 3);
%         After10days_std_ERPs(:,:,i) = mean(All_Data.std, 3);
%     end
%     
% end

After20days_all_ERPs = zeros(cfg.n_ch, smple_num, size(After20days_Datasets, 1));
After20days_target_ERPs = zeros(cfg.n_ch, smple_num, size(After20days_Datasets, 1));
After20days_std_ERPs = zeros(cfg.n_ch, smple_num, size(After20days_Datasets, 1));

for i=1:size(After20days_Datasets, 1)
   
    Dataset = After20days_Datasets{i};
    
    All_Data = aggeregate_data(Dataset, cfg);
    
    if Dataset{1,1} == '5'
        % "mPFC", "Hippo", "NAcc", "LGN"
        All_ERP = mean(All_Data.All, 3);
        target_bootstrap = ERP_bootstrap(All_Data.target, cfg, size(All_Data.target, 3));
        target_ERP = mean(target_bootstrap, 3);
        std_ERP = mean(All_Data.std, 3);
        After20days_all_ERPs(:,:,i) = [All_ERP(2,:); NaN(size(All_ERP(2,:))); ...
                                 NaN(size(All_ERP(2,:))); All_ERP(2,:)];
        After20days_target_ERPs(:,:,i) = [target_ERP(2,:); NaN(size(target_ERP(2,:))); ...
                                 NaN(size(target_ERP(2,:))); target_ERP(2,:)];
        After20days_std_ERPs(:,:,i) = [std_ERP(2,:); NaN(size(std_ERP(2,:))); ...
                                 NaN(size(std_ERP(2,:))); std_ERP(2,:)];
    else
        After20days_all_ERPs(:,:,i) = mean(All_Data.All, 3);
        target_bootstrap = ERP_bootstrap(All_Data.target, cfg, size(All_Data.target, 3));
        After20days_target_ERPs(:,:,i) = mean(target_bootstrap, 3);
        After20days_std_ERPs(:,:,i) = mean(All_Data.std, 3);
    end
    
end

%%

avg_data = mean(Before_all_ERPs, 3, 'omitnan');
labels = ch_labels{1};
save_path = '../Results/PAC_comodu/MI_method/CWT/Before_Entr/All_trials/';
Before_all_PACs_CWT = cell(length(cfg.selected_chs), length(cfg.selected_chs));
for i = cfg.selected_chs
    for j = cfg.selected_chs
        
        fig_title = strcat('PAC Comodu dynamic - all trials - Before - ', labels(i), '-to-', labels(j));
        disp(fig_title)
        [Before_all_PAC_Comodu,~,~] = gen_PAC_comodu_dyn(avg_data(i,:), avg_data(j,:), ...
                                     cfg, fig_title, save_path);
        Before_all_PACs_CWT{i,j} = Before_all_PAC_Comodu;
        close all;
    end
end
save(strcat(save_path, 'Before_all_PACs_CWT.mat'), 'Before_all_PACs_CWT');

%%

avg_data = mean(Before_target_ERPs, 3, 'omitnan');
labels = ch_labels{1};
save_path = '../Results/PAC_comodu/MI_method/CWT/Before_Entr/target_trials/';
Before_target_PACs_CWT = cell(length(cfg.selected_chs), length(cfg.selected_chs));
for i = cfg.selected_chs
    for j = cfg.selected_chs
        
        fig_title = strcat('PAC Comodu dynamic - target trials - Before - ', labels(i), '-to-', labels(j));
        disp(fig_title)
        [Before_target_PAC_Comodu,~,~] = gen_PAC_comodu_dyn(avg_data(i,:), avg_data(j,:), ...
                                     cfg, fig_title, save_path);
        Before_target_PACs_CWT{i,j} = Before_target_PAC_Comodu;
        close all;
    end
end
save(strcat(save_path, 'Before_target_PACs_CWT.mat'), 'Before_target_PACs_CWT');

%%

avg_data = mean(Before_std_ERPs, 3, 'omitnan');
labels = ch_labels{1};
save_path = '../Results/PAC_comodu/MI_method/CWT/Before_Entr/std_trials/';
Before_std_PACs_CWT = cell(length(cfg.selected_chs), length(cfg.selected_chs));
for i = cfg.selected_chs
    for j = cfg.selected_chs
        
        fig_title = strcat('PAC Comodu dynamic - std trials - Before - ', labels(i), '-to-', labels(j));
        disp(fig_title)
        [Before_std_PAC_Comodu,~,~] = gen_PAC_comodu_dyn(avg_data(i,:), avg_data(j,:), ...
                                     cfg, fig_title, save_path);
        Before_std_PACs_CWT{i,j} = Before_std_PAC_Comodu;
        close all;
    end
end
save(strcat(save_path, 'Before_std_PACs_CWT.mat'), 'Before_std_PACs_CWT');

%%

avg_data = mean(After10days_all_ERPs, 3, 'omitnan');
labels = ch_labels{1};
save_path = '../Results/PAC_comodu/MI_method/CWT/After10_Entr/All_trials/';
After10days_all_PACs_CWT = cell(length(cfg.selected_chs), length(cfg.selected_chs));
for i = cfg.selected_chs
    for j = cfg.selected_chs
        
        fig_title = strcat('PAC Comodu dynamic - all trials - After 10 days - ', labels(i), '-to-', labels(j));
        disp(fig_title)
        [After10days_all_PAC_Comodu,~,~] = gen_PAC_comodu_dyn(avg_data(i,:), avg_data(j,:), ...
                                     cfg, fig_title, save_path);
        After10days_all_PACs_CWT{i,j} = After10days_all_PAC_Comodu;
        close all;
    end
end
save(strcat(save_path, 'After10days_all_PACs_CWT.mat'), 'After10days_all_PACs_CWT');

%%

avg_data = mean(After10days_target_ERPs, 3, 'omitnan');
labels = ch_labels{1};
save_path = '../Results/PAC_comodu/MI_method/CWT/After10_Entr/target_trials/';
After10days_target_PACs_CWT = cell(length(cfg.selected_chs), length(cfg.selected_chs));
for i = cfg.selected_chs
    for j = cfg.selected_chs
        
        fig_title = strcat('PAC Comodu dynamic - target trials - - After 10 days - ', labels(i), '-to-', labels(j));
        disp(fig_title)
        [After10days_target_PAC_Comodu,~,~] = gen_PAC_comodu_dyn(avg_data(i,:), avg_data(j,:), ...
                                     cfg, fig_title, save_path);
        After10days_target_PACs_CWT{i,j} = After10days_target_PAC_Comodu;
        close all;
    end
end
save(strcat(save_path, 'After10days_target_PACs_CWT.mat'), 'After10days_target_PACs_CWT');

%%

avg_data = mean(After10days_std_ERPs, 3, 'omitnan');
labels = ch_labels{1};
save_path = '../Results/PAC_comodu/MI_method/CWT/After10_Entr/std_trials/';
After10days_std_PACs_CWT = cell(length(cfg.selected_chs), length(cfg.selected_chs));
for i = cfg.selected_chs
    for j = cfg.selected_chs
        
        fig_title = strcat('PAC Comodu dynamic - std trials - After 10 days - ', labels(i), '-to-', labels(j));
        disp(fig_title)
        [After10days_std_PAC_Comodu,~,~] = gen_PAC_comodu_dyn(avg_data(i,:), avg_data(j,:), ...
                                     cfg, fig_title, save_path);
        After10days_std_PACs_CWT{i,j} = After10days_std_PAC_Comodu;
        close all;
    end
end
save(strcat(save_path, 'After10days_std_PACs_CWT.mat'), 'After10days_std_PACs_CWT');


%%

avg_data = mean(After20days_all_ERPs, 3, 'omitnan');
labels = ch_labels{1};
save_path = '../Results/PAC_comodu/MI_method/CWT/After20_Entr/All_trials/';
After20days_all_PACs_CWT = cell(length(cfg.selected_chs), length(cfg.selected_chs));
for i = cfg.selected_chs
    for j = cfg.selected_chs
        
        fig_title = strcat('PAC Comodu dynamic - all trials - After 20 days - ', labels(i), '-to-', labels(j));
        disp(fig_title)
        [After20days_all_PAC_Comodu,~,~] = gen_PAC_comodu_dyn(avg_data(i,:), avg_data(j,:), ...
                                     cfg, fig_title, save_path);
        After20days_all_PACs_CWT{i,j} = After20days_all_PAC_Comodu;
        close all;
    end
end
save(strcat(save_path, 'After20days_all_PACs_CWT.mat'), 'After20days_all_PACs_CWT');

%%

avg_data = mean(After20days_target_ERPs, 3, 'omitnan');
labels = ch_labels{1};
save_path = '../Results/PAC_comodu/MI_method/CWT/After20_Entr/target_trials/';
After20days_target_PACs_CWT = cell(length(cfg.selected_chs), length(cfg.selected_chs));
for i = cfg.selected_chs
    for j = cfg.selected_chs
        
        fig_title = strcat('PAC Comodu dynamic - target trials - - After 20 days - ', labels(i), '-to-', labels(j));
        disp(fig_title)
        [After20days_target_PAC_Comodu,~,~] = gen_PAC_comodu_dyn(avg_data(i,:), avg_data(j,:), ...
                                     cfg, fig_title, save_path);
        After20days_target_PACs_CWT{i,j} = After20days_target_PAC_Comodu;
        close all;
    end
end
save(strcat(save_path, 'After20days_target_PACs_CWT.mat'), 'After20days_target_PACs_CWT');

%%

avg_data = mean(After20days_std_ERPs, 3, 'omitnan');
labels = ch_labels{1};
save_path = '../Results/PAC_comodu/MI_method/CWT/After20_Entr/std_trials/';
After20days_std_PACs_CWT = cell(length(cfg.selected_chs), length(cfg.selected_chs));
for i = cfg.selected_chs
    for j = cfg.selected_chs
        
        fig_title = strcat('PAC Comodu dynamic - std trials - After 20 days - ', labels(i), '-to-', labels(j));
        disp(fig_title)
        [After20days_std_PAC_Comodu,~,~] = gen_PAC_comodu_dyn(avg_data(i,:), avg_data(j,:), ...
                                     cfg, fig_title, save_path);
        After20days_std_PACs_CWT{i,j} = After20days_std_PAC_Comodu;
        close all;
    end
end
save(strcat(save_path, 'After20days_std_PACs_CWT.mat'), 'After20days_std_PACs_CWT');
