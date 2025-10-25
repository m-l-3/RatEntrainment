clc; close all; clear;

addpath(genpath('./Functions'))
addpath("D:\Documents\SUT Ph.D\Research\Matlab codes\eeglab2023.1")
addpath('D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Dataset\')
eeglab

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
    'pre_norm', 'sig_Zscr',                      ...
    'is_trRej',         0                        ...
);

if(cfg.is_downsample)
    fs = cfg.fs_down;
else
    fs = cfg.fs;
end

%% 

[Before_all_ERPs, Before_target_ERPs, Before_std_ERPs] = ...
        calc_AllRat_ERPs(Before_Datasets, cfg);

[After10days_all_ERPs, After10days_target_ERPs, After10days_std_ERPs] = ...
        calc_AllRat_ERPs(After10days_Datasets, cfg);
    
[After20days_all_ERPs, After20days_target_ERPs, After20days_std_ERPs] = ...
        calc_AllRat_ERPs(After20days_Datasets, cfg);

[After30days_all_ERPs, After30days_target_ERPs, After30days_std_ERPs] = ...
        calc_AllRat_ERPs(After30days_Datasets, cfg);

%% Save ERPs

Before_ERP = struct( ...
    'All', Before_all_ERPs, ...
    'target', Before_target_ERPs, ...
    'std',  Before_std_ERPs ...
);

After10_ERP = struct(   ...
    'All', After10days_all_ERPs, ...
    'target', After10days_target_ERPs, ...
    'std',  After10days_std_ERPs    ...
);

After20_ERP = struct(   ...
    'All', After20days_all_ERPs, ...
    'target', After20days_target_ERPs, ...
    'std',  After20days_std_ERPs    ...
);

After30_ERP = struct(   ...
    'All', After30days_all_ERPs, ...
    'target', After30days_target_ERPs, ...
    'std',  After30days_std_ERPs    ...
);

save_dir = '../Results/Grand_Avg/Signals/sigZscr_eeglab_trZscore_0.1-30Hz/';
if cfg.is_saving
    
    dataName1 = '';
    if cfg.is_trZscr == 1
        dataName1 = '_trZscr';
    end

    dataName2 = '';
    if cfg.is_baseline_corr == 1
        dataName2 = '_BseL';
    end
    
    dataName3 = cfg.pre_norm;
    if cfg.pre_norm == "none"
        dataName3 = '';
    end
    
    dataName4 = "_fs"+string(cfg.fs);
    if cfg.is_downsample 
        dataName4 = "_fs"+string(cfg.fs_down);
    end
    
    dataName = strcat(dataName1, dataName2, dataName3, dataName4);
    
    save(strcat(save_dir, 'Before_ERP', dataName, '.mat'), 'Before_ERP')
    save(strcat(save_dir, 'After10days_ERP', dataName, '.mat'), 'After10_ERP')
    save(strcat(save_dir, 'After20days_ERP', dataName, '.mat'), 'After20_ERP')
    save(strcat(save_dir, 'After30days_ERP', dataName, '.mat'), 'After30_ERP')

end

%% LOAD Data if available instead

save_dir = '../Results/Grand_Avg/Signals/sigZscr_eeglab_trZscore_0.1-30Hz/';

dataName1 = '';
if cfg.is_trZscr == 1
    dataName1 = '_trZscr';
end

dataName2 = '';
if cfg.is_baseline_corr == 1
    dataName2 = '_BseL';
end
    
dataName3 = cfg.pre_norm;
if cfg.pre_norm == "none"
    dataName3 = '';
end
    
dataName4 = "_fs"+string(cfg.fs);
    if cfg.is_downsample 
        dataName4 = "_fs"+string(cfg.fs_down);
    end
    
dataName = strcat(dataName1, dataName2, dataName3, dataName4);

Before_ERP   = load(strcat(save_dir, 'Before_ERP', dataName, '.mat'), 'Before_ERP').Before_ERP;
After10_ERP  = load(strcat(save_dir, 'After10days_ERP', dataName, '.mat'), 'After10_ERP').After10_ERP;
After20_ERP  = load(strcat(save_dir, 'After20days_ERP', dataName, '.mat'), 'After20_ERP').After20_ERP;
After30_ERP  = load(strcat(save_dir, 'After30days_ERP', dataName, '.mat'), 'After30_ERP').After30_ERP;

%% Plots

Before_all_ERPs = Before_ERP.all;
After10days_all_ERPs = After10_ERP.all;
After20days_all_ERPs = After20_ERP.all;
After30days_all_ERPs = After30_ERP.all;

Before_target_ERPs = Before_ERP.target;
After10days_target_ERPs = After10_ERP.target;
After20days_target_ERPs = After20_ERP.target;
After30days_target_ERPs = After30_ERP.target;

Before_std_ERPs = Before_ERP.std;
After10days_std_ERPs = After10_ERP.std;
After20days_std_ERPs = After20_ERP.std;
After30days_std_ERPs = After30_ERP.std;

%%

figure('WindowState', 'maximized');
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * cfg.fs_down;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;

for i=1:4   
    subplot(2,2,i);
    stdshade(squeeze(Before_all_ERPs(i,:,2:end))',0.4, 'b', time); hold on;
    stdshade(squeeze(After10days_all_ERPs(i,:,2:end))',0.4, 'r', time);
    stdshade(squeeze(After20days_all_ERPs(i,:,:))',0.4, 'g', time);
    stdshade(squeeze(After30days_all_ERPs(i,:,:))',0.4, 'm', time); hold off;
    title(strcat(' - All trials - ', ch_labels{1}(i)))
    legend('Before', 'After 10days', 'After 20days', 'After 30days')
end
if cfg.is_saving
    save_fig('../Results/Grand_Avg/', strcat('All_trials-prep_band-', num2str(cfg.prep_band(end))))
end

figure('WindowState', 'maximized');
for i=1:4   
    subplot(2,2,i);
    stdshade(squeeze(Before_target_ERPs(i,:,2:end))',0.4, 'b', time); hold on;
    stdshade(squeeze(After10days_target_ERPs(i,:,2:end))',0.4, 'r', time);
    stdshade(squeeze(After20days_target_ERPs(i,:,:))',0.4, 'g', time);
    stdshade(squeeze(After30days_target_ERPs(i,:,:))',0.4, 'm', time); hold off;
    title(strcat(' - Target trials - ', ch_labels{1}(i)))
    legend('Before', 'After 10days', 'After 20days', 'After 30days')
end
if cfg.is_saving
    save_fig('../Results/Grand_Avg/', strcat('Target_trials-prep_band-', num2str(cfg.prep_band(end))))
end

figure('WindowState', 'maximized');
for i=1:4   
    subplot(2,2,i);
    stdshade(squeeze(Before_std_ERPs(i,:,2:end))',0.4, 'b', time); hold on;
    stdshade(squeeze(After10days_std_ERPs(i,:,2:end))',0.4, 'r', time);
    stdshade(squeeze(After20days_std_ERPs(i,:,:))',0.4, 'g', time);
    stdshade(squeeze(After30days_std_ERPs(i,:,:))',0.4, 'm', time); hold off;
    title(strcat(' - Std trials - ', ch_labels{1}(i)))
    legend('Before', 'After 10days', 'After 20days', 'After 30days')
end
if cfg.is_saving
    save_fig('../Results/Grand_Avg/', strcat('std_trials-prep_band-', num2str(cfg.prep_band(end))))
end

%% per before/after

figure('WindowState', 'maximized');
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * cfg.fs_down;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;

for i=1:4   
    subplot(2,2,i);
    stdshade(squeeze(After30days_target_ERPs(i,:,:))',0.4, [0.4940 0.1840 0.5560], time); hold on;
    stdshade(squeeze(After30days_std_ERPs(i,:,:))',0.4, [0.8500 0.3250 0.0980], time); hold off;
    title(strcat(' - After30 - ', ch_labels{1}(i)))
    legend('Target', 'Std.')
end
if cfg.is_saving
    save_fig('../Results/Grand_Avg/', strcat('After30-prep_band-', num2str(cfg.prep_band(end))))
end

%% per channel

% figure('WindowState', 'maximized');
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * cfg.fs_down;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;
iCh = 3;
subplot(4,1,1);
stdshade(squeeze(Before_target_ERPs(iCh,:,2:end))',0.4, [0.4940 0.1840 0.5560], time); hold on;
stdshade(squeeze(Before_std_ERPs(iCh,:,2:end))',0.4, [0.8500 0.3250 0.0980], time); hold off;
title(strcat(' - Before - ', ch_labels{1}(iCh)))
legend('Target', 'Std.','Location','best')
subplot(4,1,2);
stdshade(squeeze(After10days_target_ERPs(iCh,:,2:end))',0.4, [0.4940 0.1840 0.5560], time); hold on;
stdshade(squeeze(After10days_std_ERPs(iCh,:,2:end))',0.4, [0.8500 0.3250 0.0980], time); hold off;
title(strcat(' - After10 - ', ch_labels{1}(iCh)))
legend('Target', 'Std.','Location','best')
subplot(4,1,3);
stdshade(squeeze(After20days_target_ERPs(iCh,:,:))',0.4, [0.4940 0.1840 0.5560], time); hold on;
stdshade(squeeze(After20days_std_ERPs(iCh,:,:))',0.4, [0.8500 0.3250 0.0980], time); hold off;
title(strcat(' - After20 - ', ch_labels{1}(iCh)))
legend('Target', 'Std.','Location','best')
subplot(4,1,4);
stdshade(squeeze(After30days_target_ERPs(iCh,:,:))',0.4, [0.4940 0.1840 0.5560], time); hold on;
stdshade(squeeze(After30days_std_ERPs(iCh,:,:))',0.4, [0.8500 0.3250 0.0980], time); hold off;    
title(strcat(' - After30 - ', ch_labels{1}(iCh)))
legend('Target', 'Std.','Location','best')
xlabel('Time (sec)');

if cfg.is_saving
    set(gcf,'Units','Inches');
    set(gcf,'PaperPosition',[0 0 4 9],'PaperUnits','Inches','PaperSize',[4, 9])
    save_fig('../Results/Grand_Avg/', strcat(ch_labels{1}(iCh),'-prep_band-', num2str(cfg.prep_band(end))))
end

%% LDA (abolghasemi)
iRat = 7;
iCh = 3;

std_ERPs = Before_std_ERPs;
target_ERPs = Before_target_ERPs;

smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * cfg.fs_down;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;

twin_len = 0.1;
win_len = twin_len*fs;
twin_slip = 0.04;
win_slip = twin_slip*fs;
n_win = round((cfg.epoch_time(1)+cfg.epoch_time(2)-twin_len)/twin_slip + 1);
t_seg = [-cfg.epoch_time(1)+twin_len/2:twin_slip:cfg.epoch_time(2)-twin_len/2];

stdERP_seg = [];
targetERP_seg = [];
acc = [];
for iWin=1:n_win
    stdSeg = std_ERPs(:,(iWin-1)*win_slip+1:(iWin-1)*win_slip+win_len, :);
    stdERP_seg = cat(4,stdERP_seg,stdSeg);

    tarSeg = target_ERPs(:,(iWin-1)*win_slip+1:(iWin-1)*win_slip+win_len, :);
    targetERP_seg = cat(4,targetERP_seg,tarSeg);

    X = [squeeze(tarSeg(iCh,:,iRat))'; squeeze(stdSeg(iCh,:,iRat))']; % Feature vector  
    Y = [ones(win_len,1); zeros(win_len,1)];  % Class labels  
    % Fitting the LDA model  
    ldaModel = fitcdiscr(X, Y); 
    Y_pred = predict(ldaModel,X);
    acc = [acc, sum(Y==Y_pred)/win_len/2];

end

dpa = abs(mean(targetERP_seg,2)-mean(stdERP_seg,2))./(sqrt((std(targetERP_seg,0,2).^2 + std(stdERP_seg,0,2).^2)/2));
dpa = squeeze(dpa);


figure
subplot(4,1,1)
plot(time, std_ERPs(iCh,:,iRat),LineWidth=2)
hold on
plot(time, target_ERPs(iCh,:,iRat),LineWidth=2)
xline(0,LineWidth=2)
legend('Std', 'Target');
title('Before - Rat13')

subplot(4,1,3)
plot(t_seg*1000, squeeze(dpa(iCh,iRat,:)),LineWidth=2)
hold on
% xline(0,LineWidth=2)
% ylabel("d_a^{'}");

subplot(4,1,4)
plot(t_seg*1000, acc,LineWidth=2)
hold on
% xline(0,LineWidth=2)
% ylabel("LDA Acc.");


std_ERPs = After10days_std_ERPs;
target_ERPs = After10days_target_ERPs;
iRat = iRat;


stdERP_seg = [];
targetERP_seg = [];
acc = [];
for iWin=1:n_win
    stdSeg = std_ERPs(:,(iWin-1)*win_slip+1:(iWin-1)*win_slip+win_len, :);
    stdERP_seg = cat(4,stdERP_seg,stdSeg);

    tarSeg = target_ERPs(:,(iWin-1)*win_slip+1:(iWin-1)*win_slip+win_len, :);
    targetERP_seg = cat(4,targetERP_seg,tarSeg);

    X = [squeeze(tarSeg(iCh,:,iRat))'; squeeze(stdSeg(iCh,:,iRat))']; % Feature vector  
    Y = [ones(win_len,1); zeros(win_len,1)];  % Class labels  
    % Fitting the LDA model  
    ldaModel = fitcdiscr(X, Y); 
    Y_pred = predict(ldaModel,X);
    acc = [acc, sum(Y==Y_pred)/win_len/2];

end

dpa = abs(mean(targetERP_seg,2)-mean(stdERP_seg,2))./(sqrt((std(targetERP_seg,0,2).^2 + std(stdERP_seg,0,2).^2)/2));
dpa = squeeze(dpa);


subplot(4,1,2)
plot(time, std_ERPs(iCh,:,iRat),LineWidth=2)
hold on
plot(time, target_ERPs(iCh,:,iRat),LineWidth=2)
xline(0,LineWidth=2)
legend('Std', 'Target');
title('After10 - Rat13')

subplot(4,1,3)
plot(t_seg*1000, squeeze(dpa(iCh,iRat,:)),LineWidth=2)
hold on
xline(0,LineWidth=2)
ylabel("d_a^{'}");
legend('Before', 'After10')

subplot(4,1,4)
plot(t_seg*1000, acc,LineWidth=2)
hold on
xline(0,LineWidth=2)
ylabel("LDA Acc.");
legend('Before', 'After10')


xlabel('Time (ms)')
%%
samp_1 = squeeze(target_ERPs (iCh,:,iRat))';
samp_2 = squeeze(std_ERPs (iCh,:,iRat))';
% Sample data  
X = [samp_1; samp_2]; % Feature vector  
Y = [ones(size(samp_1)); zeros(size(samp_1))];  % Class labels  

% Fitting the LDA model  
ldaModel = fitcdiscr(X, Y);  

% Displaying the coefficients  
disp(ldaModel);  

confusionmat(Y,predict(ldaModel,X))

%%  MMN

figure('WindowState', 'maximized');
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * cfg.fs_down;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;

for i=1:4   
    subplot(2,2,i);
    stdshade(squeeze(Before_target_ERPs(i,:,2:end) - Before_std_ERPs(i,:,2:end))',0.4, 'b', time); hold on;
    stdshade(squeeze(After10days_target_ERPs(i,:,2:end) - After10days_std_ERPs(i,:,2:end))',0.4, 'r', time);
    stdshade(squeeze(After20days_target_ERPs(i,:,2:end) - After20days_std_ERPs(i,:,2:end))',0.4, 'g', time);
    stdshade(squeeze(After30days_target_ERPs(i,:,2:end) - After30days_std_ERPs(i,:,2:end))',0.4, 'm', time); hold off;
    title(strcat(' - MMN - ', ch_labels{1}(i)))
    legend('Before', 'After 10days', 'After 20days', 'After 30days')
end
if cfg.is_saving
    save_fig('../Results/Grand_Avg/MMN/', strcat('MMN-prep_band-', num2str(cfg.prep_band(end))))
end


%% Grand avg with seperated rats ERPS

time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;
plot_gavg_allRat(Before_all_ERPs, time, ch_labels, 'All rats grand average ERPs - Before - all trials')
save_fig('../Results/Grand_Avg/', 'All rats grand average ERPs - Before - all trials')
plot_gavg_allRat(Before_target_ERPs, time, ch_labels, 'All rats grand average ERPs - Before - target trials')
save_fig('../Results/Grand_Avg/', 'All rats grand average ERPs - Before - target trials')
plot_gavg_allRat(Before_std_ERPs, time, ch_labels, 'All rats grand average ERPs - Before - std trials')
save_fig('../Results/Grand_Avg/', 'All rats grand average ERPs - Before - std trials')
plot_gavg_allRat(After10days_all_ERPs, time, ch_labels, 'All rats grand average ERPs - After 10 days - all trials')
save_fig('../Results/Grand_Avg/', 'All rats grand average ERPs - After 10 days - all trials')
plot_gavg_allRat(After10days_target_ERPs, time, ch_labels, 'All rats grand average ERPs - After 10 days - target trials')
save_fig('../Results/Grand_Avg/', 'All rats grand average ERPs - After 10 days - target trials')
plot_gavg_allRat(After10days_std_ERPs, time, ch_labels, 'All rats grand average ERPs - After 10 days - std trials')
save_fig('../Results/Grand_Avg/', 'All rats grand average ERPs - After 10 days - std trials')

%%
plot_gavg_allRat(After20days_all_ERPs, time, ch_labels, 'All rats grand average ERPs - After 20 days - all trials')
save_fig('../Results/Grand_Avg/', 'All rats grand average ERPs - After 20 days - all trials')
plot_gavg_allRat(After20days_target_ERPs, time, ch_labels, 'All rats grand average ERPs - After 20 days - target trials')
save_fig('../Results/Grand_Avg/', 'All rats grand average ERPs - After 20 days - target trials')
plot_gavg_allRat(After20days_std_ERPs, time, ch_labels, 'All rats grand average ERPs - After 20 days - std trials')
save_fig('../Results/Grand_Avg/', 'All rats grand average ERPs - After 20 days - std trials')

%%

plot_gavg_allRat(After30days_all_ERPs, time, ch_labels, 'All rats grand average ERPs - After 30 days - all trials')
save_fig('../Results/Grand_Avg/', 'All rats grand average ERPs - After 30 days - all trials')
plot_gavg_allRat(After30days_target_ERPs, time, ch_labels, 'All rats grand average ERPs - After 30 days - target trials')
save_fig('../Results/Grand_Avg/', 'All rats grand average ERPs - After 30 days - target trials')
plot_gavg_allRat(After30days_std_ERPs, time, ch_labels, 'All rats grand average ERPs - After 30 days - std trials')
save_fig('../Results/Grand_Avg/', 'All rats grand average ERPs - After 30 days - std trials')

%% Latency and Peak

trialtype = 2;      % all || target || std
ERP_feature = 'N100';

% Before all trials
[HC_Before_all_peaks, HC_Before_all_latency] = proc_ERP(squeeze(Before_ERP{trialtype,2}(1,:,:)), ERP_feature);
[Pulv_Before_all_peaks, Pulv_Before_all_latency] = proc_ERP(squeeze(Before_ERP{trialtype,2}(2,:,:)), ERP_feature);
[DS_Before_all_peaks, DS_Before_all_latency] = proc_ERP(squeeze(Before_ERP{trialtype,2}(3,:,:)), ERP_feature);
[PFC_Before_all_peaks, PFC_Before_all_latency] = proc_ERP(squeeze(Before_ERP{trialtype,2}(4,:,:)), ERP_feature);

% After 10 all trials
[HC_After10_all_peaks, HC_After10_all_latency] = proc_ERP(squeeze(After10_ERP{trialtype,2}(1,:,:)), ERP_feature);
[Pulv_After10_all_peaks, Pulv_After10_all_latency] = proc_ERP(squeeze(After10_ERP{trialtype,2}(2,:,:)), ERP_feature);
[DS_After10_all_peaks, DS_After10_all_latency] = proc_ERP(squeeze(After10_ERP{trialtype,2}(3,:,:)), ERP_feature);
[PFC_After10_all_peaks, PFC_After10_all_latency] = proc_ERP(squeeze(After10_ERP{trialtype,2}(4,:,:)), ERP_feature);

% After 20 all trials
[HC_After20_all_peaks, HC_After20_all_latency] = proc_ERP(squeeze(After20_ERP{trialtype,2}(1,:,:)), ERP_feature);
[Pulv_After20_all_peaks, Pulv_After20_all_latency] = proc_ERP(squeeze(After20_ERP{trialtype,2}(2,:,:)), ERP_feature);
[DS_After20_all_peaks, DS_After20_all_latency] = proc_ERP(squeeze(After20_ERP{trialtype,2}(3,:,:)), ERP_feature);
[PFC_After20_all_peaks, PFC_After20_all_latency] = proc_ERP(squeeze(After20_ERP{trialtype,2}(4,:,:)), ERP_feature);



%% Bar plots

star_loc = 1;
% star_loc = 270;

data = [HC_Before_all_latency(3:end); ...
        HC_After10_all_latency(3:end); ...
        HC_After20_all_latency; ...
        HC_After20_all_latency]';

% data = [PFC_Before_all_peaks(3:end); ...
%         PFC_After10_all_peaks(3:end); ...
%         PFC_After20_all_peaks]';

% data = [HC_Before_all_peaks([3:end-2, end]); ...
%         HC_After10_all_peaks([3:end-2, end]); ...
%         HC_After20_all_peaks([1:end-2, end])]';

colors = cbrewer('seq', 'Blues', 4);

plotDataWithErrorBars(data, colors);


%% Latency.m

clc
lat_cfg = struct( ...
    'sampRate', fs, 'fig', 1, 'peakWin', [151, 226]...
);
ch = 3;
sgn = 1;

Before_avgs = permute(Before_target_ERPs(:,:,2:end) - Before_std_ERPs(:,:,2:end), [3, 1, 2]);
[Before_res,lat_cfgNew] = latency(lat_cfg,Before_avgs(:,ch,:),sgn);
title('Before')

After10_avgs = permute(After10days_target_ERPs(:,:,2:end) - After10days_std_ERPs(:,:,2:end), [3, 1, 2]);
[After10_res,~] = latency(lat_cfg,After10_avgs(:,ch,:),sgn);
title('After 10')

After20_avgs = permute(After20days_target_ERPs(:,:,:) - After20days_std_ERPs(:,:,:), [3, 1, 2]);
[After20_res,~] = latency(lat_cfg,After20_avgs(:,ch,:),sgn);
title('After 20')

After30_avgs = permute(After30days_target_ERPs(:,:,:) - After30days_std_ERPs(:,:,:), [3, 1, 2]);
[After30_res,~] = latency(lat_cfg,After30_avgs(:,ch,:),sgn);
title('After 30')

%%

lat_cfg = struct( ...
    'sampRate', fs, 'fig', 1, 'peakWin', [151, 226]...
);
sgn = 1;

% data = Before_target_ERPs(:,:,2:end);
% Before_lat = find_latency(data, lat_cfg, sgn);
% 
% data = After10days_target_ERPs(:,:,2:end);
% After10_lat = find_latency(data, lat_cfg, sgn);
% 
% data = After20days_target_ERPs(:,:,2:end);
% After20_lat = find_latency(data, lat_cfg, sgn);
% 
% data = After30days_target_ERPs(:,:,:);
% After30_lat = find_latency(data, lat_cfg, sgn);

data = Before_std_ERPs(:,:,2:end);
Before_lat = find_latency(data, lat_cfg, sgn);

data = After10days_std_ERPs(:,:,2:end);
After10_lat = find_latency(data, lat_cfg, sgn);

data = After20days_std_ERPs(:,:,:);
After20_lat = find_latency(data, lat_cfg, sgn);

data = After30days_std_ERPs(:,:,:);
After30_lat = find_latency(data, lat_cfg, sgn);

%%

colors = cbrewer('seq', 'Blues', 4);
figure;
for ch_i=1:4
   
    subplot(2,2,ch_i)
    plotDataWithErrorBars(Before_lat{ch_i}.areaLat', After10_lat{ch_i}.areaLat', ...
        After20_lat{ch_i}.areaLat', After30_lat{ch_i}.areaLat', colors);
    title(ch_labels{1}{ch_i})
    
end
sgtitle('Area Lat - Target sig')

figure;
for ch_i=1:4
    subplot(2,2,ch_i)
    plotDataWithErrorBars(Before_lat{ch_i}.peakLat', After10_lat{ch_i}.peakLat', ...
        After20_lat{ch_i}.peakLat', After30_lat{ch_i}.peakLat', colors);
    title(ch_labels{1}{ch_i})    
end
sgtitle('Peak Lat - Target sig')

figure;
for ch_i=1:4
    subplot(2,2,ch_i)
    plotDataWithErrorBars(Before_lat{ch_i}.onset', After10_lat{ch_i}.onset', ...
        After20_lat{ch_i}.onset', After30_lat{ch_i}.onset', colors);
    title(ch_labels{1}{ch_i})    
end
sgtitle('Onset - Target sig')

figure;
for ch_i=1:4
    subplot(2,2,ch_i)
    plotDataWithErrorBars(Before_lat{ch_i}.offset', After10_lat{ch_i}.offset', ...
        After20_lat{ch_i}.offset', After30_lat{ch_i}.offset', colors);
    title(ch_labels{1}{ch_i})    
end
sgtitle('Offset - Target sig')

figure;
for ch_i=1:4
    subplot(2,2,ch_i)
    plotDataWithErrorBars(Before_lat{ch_i}.peakAmp', After10_lat{ch_i}.peakAmp', ...
        After20_lat{ch_i}.peakAmp', After30_lat{ch_i}.peakAmp', colors);
    title(ch_labels{1}{ch_i})    
end
sgtitle('Mean Peak Amp - Target sig')

figure;
for ch_i=1:4
    subplot(2,2,ch_i)
    plotDataWithErrorBars(Before_lat{ch_i}.maxPeaks', After10_lat{ch_i}.maxPeaks', ...
        After20_lat{ch_i}.maxPeaks', After30_lat{ch_i}.maxPeaks', colors);
    title(ch_labels{1}{ch_i})
end
sgtitle('Peak Amp - Target sig')


%%
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * cfg.fs_down;
time_arr = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;

lat_cfg = struct( ...
    'sampRate', fs, 'fig', 1, 'peakWin', [151, 226], 'timeFormat', 's'...
);
sgn = 1;

data = Before_target_ERPs(:,:,2:end) - Before_std_ERPs(:,:,2:end);
Before_lat = find_latency(data, lat_cfg, sgn);

data = After10days_target_ERPs(:,:,2:end) - After10days_std_ERPs(:,:,2:end);
After10_lat = find_latency(data, lat_cfg, sgn);
sum(isnan(data), 'all')

data = After20days_target_ERPs(:,:,:) - After20days_std_ERPs(:,:,:);
After20_lat = find_latency(data, lat_cfg, sgn);
sum(isnan(data), 'all')

data = After30days_target_ERPs(:,:,:) - After30days_std_ERPs(:,:,:);
After30_lat = find_latency(data, lat_cfg, sgn);

%%

colors = cbrewer('seq', 'Blues', 4);
n = 7;
lineColors = 0.7*ones(n, 4); % Initialize an array to hold the colors
for i = 1:n
    hue = (i - 1) / n; % Evenly spaced hues
    rgb = hsv2rgb([hue, 1, 1]); % Convert HSV to RGB
    lineColors(i, 1:3) = rgb; % Convert to 0-255 range
end

xticks = {'Before', 'After 10', 'After 20', 'After 30'};

figure('WindowState', 'maximized');
for ch_i=1:4
   
    subplot(2,2,ch_i)
    plotDataWithErrorBars(1, colors, lineColors, xticks, ...
        time_arr(round(Before_lat{ch_i}.areaLat))', time_arr(round(After10_lat{ch_i}.areaLat))', ...
        time_arr(round(After20_lat{ch_i}.areaLat))', time_arr(round(After30_lat{ch_i}.areaLat))');
    title(ch_labels{1}{ch_i})
    
end
sgtitle('50% Area Latency - Deviant signal (Target - Std)')

if cfg.is_saving
    save_path = '../Results/Grand_Avg/BarPlots/';
    print(gcf,strcat(save_path, 'AreaLat-DevSig-ms.png'),'-dpng','-r300');
end

%%
figure('WindowState', 'maximized');
for ch_i=1:4
    subplot(2,2,ch_i)
    plotDataWithErrorBars(Before_lat{ch_i}.peakLat', After10_lat{ch_i}.peakLat', ...
        After20_lat{ch_i}.peakLat', After30_lat{ch_i}.peakLat', colors, lineColors, xticks);
    title(ch_labels{1}{ch_i})    
end
sgtitle('Peak Latency - Deviant signal (Target - Std)')

figure('WindowState', 'maximized');
for ch_i=1:4
    subplot(2,2,ch_i)
    plotDataWithErrorBars(Before_lat{ch_i}.onset', After10_lat{ch_i}.onset', ...
        After20_lat{ch_i}.onset', After30_lat{ch_i}.onset', colors, lineColors, xticks);
    title(ch_labels{1}{ch_i})    
end
sgtitle('Onset - Diff sig')

figure('WindowState', 'maximized');
for ch_i=1:4
    subplot(2,2,ch_i)
    plotDataWithErrorBars(Before_lat{ch_i}.offset', After10_lat{ch_i}.offset', ...
        After20_lat{ch_i}.offset', After30_lat{ch_i}.offset', colors, lineColors, xticks);
    title(ch_labels{1}{ch_i})    
end
sgtitle('Offset - Diff sig')

figure('WindowState', 'maximized');
for ch_i=1:4
    subplot(2,2,ch_i)
    plotDataWithErrorBars(Before_lat{ch_i}.peakAmp', After10_lat{ch_i}.peakAmp', ...
        After20_lat{ch_i}.peakAmp', After30_lat{ch_i}.peakAmp', colors, lineColors, xticks);
    title(ch_labels{1}{ch_i})    
end
sgtitle('Mean Peak Amp - Diff sig')

%%
figure('WindowState', 'maximized');
for ch_i=1:4
    subplot(2,2,ch_i)
    plotDataWithErrorBars(1, colors, lineColors, xticks, ...
        Before_lat{ch_i}.maxPeaks', After10_lat{ch_i}.maxPeaks', ...
        After20_lat{ch_i}.maxPeaks', After30_lat{ch_i}.maxPeaks');
    title(ch_labels{1}{ch_i})
end
sgtitle('Peak Amp - Deviant signal (Target - Std)')

if cfg.is_saving
    save_path = '../Results/Grand_Avg/BarPlots/';
    print(gcf,strcat(save_path, 'peakAmp-DevSig.png'),'-dpng','-r300');
end

%% Functions

function plot_gavg_allRat(data, time, ch_labels, fig_title)

    figure('WindowState', 'maximized');    
    for i=1:4

        subplot(2,2,i); hold on;
        for j=1:size(data(i,:,:), 3)
            plot(time, data(i,:,j))
        end
        plot(time, mean(data(i,:,:), 3, 'omitnan'), 'k', 'linewidth', 2);
        xline(0, '--', 'linewidth', 2)
        title(ch_labels{1}(i))
        if size(data, 3) == 6
            legend('Rat 8', 'Rat 9', 'Rat 11', 'Rat 12', 'Rat 13', 'Rat 14', 'avg')
        elseif size(data, 3) == 5
            legend('Rat 9', 'Rat 11', 'Rat 12', 'Rat 13', 'Rat 14', 'avg')
        elseif i==2 || i==3
            legend('', 'Rat 7', 'Rat 8', 'Rat 9', 'Rat 11', 'Rat 12', ...
                   'Rat 13', 'Rat 14', 'avg');
        else
            legend('Rat 5', 'Rat 7', 'Rat 8', 'Rat 9', 'Rat 11', 'Rat 12', ...
                   'Rat 13', 'Rat 14','avg');
        end
    end
%     hL = 
%     newPosition = [0.47, 0.45, 0.1, 0.1]; % [left, bottom, width, height]
%     set(hL, 'Position', newPosition, 'Units', 'normalized');
    sgtitle(fig_title)

end


function out = find_latency(data, cfg, sgn)

    out = cell(1,4);
    for ch_i=1:size(data,1)
       
        new_data = permute(data, [3, 1, 2]);
        [res,lat_cfgNew] = latency(cfg,new_data(:,ch_i,:),sgn);
        
        max_Peaks = NaN(1, length(res.peakLat));
        for row = 1:length(res.peakLat)
            max_Peaks(row) = new_data(row, ch_i, res.peakLat(row));
        end
        
        res.maxPeaks = max_Peaks;
        out{ch_i} = res;
        
    end

end