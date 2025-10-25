clc; 
clear;
% close all;

addpath(genpath('./Functions'))
addpath("D:\Documents\SUT Ph.D\Research\Matlab codes\eeglab2023.1")
addpath('D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Dataset\')
addpath(genpath("D:\Documents\SUT Ph.D\Research\Matlab codes\chronux_2_12"));

% eeglab

%% Load Data and PreProcess

clc;

Before_Datasets = { ...
    {'5', '1', '1402-09-09', '0'; ...
     '5', '1', '1402-09-11', '0';};
    {'7', '1', '1402-12-02', '0'; ...
     '7', '2', '1402-12-02', '0'; ...
     '7', '3', '1402-12-02', '0';};
    {'8', '1', '1403-01-29', '0'; ...
     '8', '2', '1403-01-29', '0'; ...
     '8', '3', '1403-01-29', '0';};
    {'9', '1', '1403-02-25', '0'; ...
     '9', '2', '1403-02-25', '0';};
    {'11', '1', '1403-03-05', '0'; ... % which one?
     '11', '2', '1403-03-05', '0'; ...
     '11', '1', '1403-03-16', '0'; ...
     '11', '2', '1403-03-16', '0';};
    {'12', '1', '1403-03-05', '0'; ... % which one?
     '12', '2', '1403-03-05', '0'; ...
     '12', '1', '1403-03-16', '0'; ...
     '12', '2', '1403-03-16', '0';};
    {'13', '1', '1403-04-13', '0'; ...
     '13', '2', '1403-04-13', '0';};
    {'14', '1', '1403-04-19', '0'; ...
     '14', '2', '1403-04-19', '0';};
    };

After10days_Datasets = { ...
    {'5', '1', '1402-09-20', '0'};...
    {'7', '1', '1402-12-16', '0'; ...
     '7', '2', '1402-12-16', '0';};
    {'8', '1', '1403-02-11', '0'; ... % trigers are incorrect at the end due to 32k sr and file overload
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
    {'9', '1', '1403-03-31', '0'; ...
     '9', '2', '1403-03-31', '0'; };
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
    'epoch_t_start',    1.5,                     ...
    'y_range',          [-1 1],                  ...
    'epoch_time',       [1.5, 2],                ... 
    'prep_band',        [1, 30],               ... 
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

%% aggregate all data per rat and per sesseion separately

[Before_Data] = aggeregate_perRatSess(Before_Datasets, cfg);
% [After10days_Data] = aggeregate_perRatSess(After10days_Datasets, cfg);
% [After20days_Data] = aggeregate_perRatSess(After20days_Datasets, cfg);
[After30days_Data] = aggeregate_perRatSess(After30days_Datasets, cfg);

%% Save


save_dir = '../Results/Signals/sigZscr_eeglab_trZscore_0.1-30Hz-0.3-1.5epoch/';
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
    
%     dataName = strcat(dataName1, dataName2, dataName3, dataName4);
    dataName = strcat(dataName3, dataName2, dataName1, dataName4);
    
    save(strcat(save_dir, 'Before_Data', dataName, '.mat'), 'Before_Data', 'cfg')
    save(strcat(save_dir, 'After10days_Data', dataName, '.mat'), 'After10days_Data', 'cfg')
    save(strcat(save_dir, 'After20days_Data', dataName, '.mat'), 'After20days_Data', 'cfg')
    save(strcat(save_dir, 'After30days_Data', dataName, '.mat'), 'After30days_Data', 'cfg')

end

%% LOAD Data if available instead

save_dir = '../Results/Signals/sigZscr_eeglab_trZscore_0.1-30Hz-1.5-2epoch/';

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
    
% dataName = strcat(dataName1, dataName2, dataName3, dataName4);
dataName = strcat(dataName3, dataName2, dataName1, dataName4);

Before_Data   = load(strcat(save_dir, 'Before_Data', dataName, '.mat')).Before_Data;
After10_Data  = load(strcat(save_dir, 'After10days_Data', dataName, '.mat')).After10days_Data;
After20_Data  = load(strcat(save_dir, 'After20days_Data', dataName, '.mat')).After20days_Data;
After30_Data  = load(strcat(save_dir, 'After30days_Data', dataName, '.mat')).After30days_Data;


% *********************************************
% *************** cfg correction **************
% *********************************************
% cfgCorrection

%%
useClean = true;
bootStrap = false;

[Before_ERP, ~] = calc_ERP_perRat(Before_Data, cfg, useClean, bootStrap);
% [After10_ERP, ~] = calc_ERP_perRat(After10_Data, cfg, useClean, bootStrap);
% [After20_ERP, ~] = calc_ERP_perRat(After20_Data, cfg, useClean, bootStrap);
[After30_ERP, time] = calc_ERP_perRat(After30_Data, cfg, useClean, bootStrap);

%%
iCh=3;

figure
stdshade(squeeze(Before_ERP.target(iCh,:,:) - Before_ERP.std(iCh,:,:))',0.4,'b',time)
hold on
% stdshade(squeeze(After10_ERP.changed(iCh,:,:) - After10_ERP.unChanged(iCh,:,:))',0.4,'r',time)
% stdshade(squeeze(After20_ERP.changed(iCh,:,:) - After20_ERP.unChanged(iCh,:,:))',0.4,'g',time)
stdshade(squeeze(After30_ERP.target(iCh,:,:) - After30_ERP.std(iCh,:,:))',0.4,'m',time)
xline(0)
legend('Before', 'After10', 'After20', 'After30')

%%
iCh=3;

figure
stdshade(squeeze(After30_ERP.std(iCh,:,:))',0.4,'b',time)
hold on
stdshade(squeeze(After30_ERP.target(iCh,:,:))',0.4,'m',time)
xline(0)
legend('Std.', 'Target')
xlim([200 800])
%%
iCh=3;

figure
stdshade(squeeze(Before_ERP.all(iCh,:,:))',0.4,'b',time)
hold on
stdshade(squeeze(After30_ERP.all(iCh,:,:))',0.4,'m',time)
xline(0)
legend('Before', 'After30')
xlim([200 800])

%% representing rats in paired format std/tar(solid) before/after(thick)

iCh=3;

figure
plot(time, squeeze(Before_ERP.target(iCh,:,:))')
hold on
set(gca,'ColorOrderIndex',1)
plot(time, squeeze(Before_ERP.std(iCh,:,:))', '--')

set(gca,'ColorOrderIndex',1)
plot(time,NaN(size(time))), plot(time,NaN(size(time))), plot(time,NaN(size(time))) 
plot(time, squeeze(After30_ERP.target(iCh,:,:))',LineWidth=2)
hold on
set(gca,'ColorOrderIndex',1)
plot(time,NaN(size(time))), plot(time,NaN(size(time))), plot(time,NaN(size(time))) 
plot(time, squeeze(After30_ERP.std(iCh,:,:))', '--',LineWidth=2)

xlim([200 800])
%%

useClean = true;
bootStrap = false;

[Before_ERP, Before_Trials, ~] = calc_ERP_perAll(Before_Data, cfg, useClean, bootStrap);
% [After10_ERP, After10_Trials, ~] = calc_ERP_perAll(After10_Data, cfg, useClean, bootStrap);
% [After20_ERP, After20_Trials, ~] = calc_ERP_perAll(After20_Data, cfg, useClean, bootStrap);
[After30_ERP, After30_Trials, time] = calc_ERP_perAll(After30_Data, cfg, useClean, bootStrap);

%% panel A figs
% erp all. before after30 in same plot

iCh=3;
[cmap] = cbrewer('seq','OrRd',29);
c_before = cmap(13,:);
c_after30 = cmap(25,:);

% Define figure dimensions in inches
figWidth = 2.5;  % Width in inches (e.g., single-column width)
figHeight = 1; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);

t_idx = time>=-300 & time<=1000;
stdshade(squeeze(Before_Trials.all(iCh,t_idx,:))',0.4,c_before,time(t_idx))
hold on
stdshade(squeeze(After30_Trials.all(iCh,t_idx,:))',0.4,c_after30,time(t_idx))
xline(0,'LineWidth', 1)
xline(200,'LineWidth', 1)
xlim([-350 1050])
ylim([-.1 0.4])

yl = ylim;
% --- Add gray box behind plot and axes ---
stimBox = fill([0 200 200 0], ...
               [yl(1) yl(1) yl(2) yl(2)], ...
               [0.9 0.9 0.9], ...
               'EdgeColor', 'none', ...
               'FaceAlpha', 1, ...
               'HandleVisibility', 'off');  % <- not shown in legend

% --- Send patch to back (visually) ---
uistack(stimBox, 'bottom');

% --- Draw axes and ticks on top of patch ---
ax = gca;
ax.Layer = 'top';

% Remove the legend box
hLeg = legend('Before', 'After30');
hLeg.ItemTokenSize = [10 10];
set(hLeg, 'Box', 'off');

% Customize font and position
set(hLeg, 'FontName', 'Helvetica', 'FontSize', 6, 'Location', 'northeast');

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
xlabel('Time (ms)', 'FontSize', 6);
ylabel('ERP (a.u.)', 'FontSize', 6);


% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'ERP_grandAvg.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%% panel A figs
% erp std/tar for before

iCh=1;
[cmap] = cbrewer('div','PiYG',11);

% Define figure dimensions in inches
figWidth = 3;  % Width in inches (e.g., single-column width)
figHeight = 1; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);

t_idx = time>=-300 & time<=1000;
stdshade(squeeze(Before_Trials.target(iCh,t_idx,:))',0.4,cmap(2,:),time(t_idx))
hold on
stdshade(squeeze(Before_Trials.std(iCh,t_idx,:))',0.4,cmap(end-1,:),time(t_idx))
xline(0,'LineWidth', 1.5)
xlim([-350 1050])
% hLeg = legend('Dev.', 'Freq.');
% 
% % Remove the legend box
% set(hLeg, 'Box', 'off');
% 
% % Customize font and position
% set(hLeg, 'FontName', 'Helvetica', 'FontSize', 8, 'Location', 'northeast');

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
% xlabel('X-axis Label', 'FontSize', 8);
ylabel('ERP', 'FontSize', 6);

h = title('D0', 'FontSize', 6);
h.Units = 'normalized';
h.Position(2) = 0.8; % Adjust the vertical position (0 to 1)

% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'ERP_tarStd_before.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%% panel A figs
% erp std/tar for after30

iCh = 1;
[cmap] = cbrewer('div','PiYG',11);

% Define figure dimensions in inches
figWidth = 3;  % Width in inches (e.g., single-column width)
figHeight = 1; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);

t_idx = time>=-300 & time<=1000;
stdshade(squeeze(After30_Trials.target(iCh,t_idx,:))',0.4,cmap(2,:),time(t_idx))
hold on
stdshade(squeeze(After30_Trials.std(iCh,t_idx,:))',0.4,cmap(end-1,:),time(t_idx))
xline(0,'LineWidth', 1.5)
xlim([-350 1050])
hLeg = legend('DEV', 'STD');

% Remove the legend box
set(hLeg, 'Box', 'off');

% Customize font and position
set(hLeg, 'FontName', 'Helvetica', 'FontSize', 6, 'Location', 'northeast');

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
% xlabel('X-axis Label', 'FontSize', 8);
ylabel('ERP', 'FontSize', 6);

h = title('D30', 'FontSize', 6);
h.Units = 'normalized';
h.Position(2) = 0.8; % Adjust the vertical position (0 to 1)

% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'ERP_tarStd_after30.pdf'), 'ContentType', 'vector', 'Resolution', 300);


%% panel A figs
% theta power of ERP
iCh = 3;
params.tapers = [3 5];
params.pad = -1;
params.Fs = fs;
params.fpass = [0 90];
params.trialave = 0;

total_dur = cfg.epoch_time(1) + cfg.epoch_time(2);
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * fs;

twin_len = 0.5;
win_len = twin_len*fs;
twin_slip = 0.02;
win_slip = twin_slip*fs;

n_win = round((total_dur-twin_len)/twin_slip + 1);
t_seg = (-cfg.epoch_time(1)+twin_len/2:twin_slip:cfg.epoch_time(2)-twin_len/2) * 1000;

[Before_Spec_target,~,~]=mtspecgramc(squeeze(Before_ERP.target(iCh,:,:)), [twin_len twin_slip], params);
[Before_Spec_std,~,~]=mtspecgramc(squeeze(Before_ERP.std(iCh,:,:)), [twin_len twin_slip], params);
[After30_Spec_target,~,~]=mtspecgramc(squeeze(After30_ERP.target(iCh,:,:)), [twin_len twin_slip], params);
[After30_Spec_std,t,f]=mtspecgramc(squeeze(After30_ERP.std(iCh,:,:)), [twin_len twin_slip], params);

freq_range = [4 8];
f_sel = f>=freq_range(1) & f<=freq_range(2);

bandPow_before_target = squeeze(mean(Before_Spec_target(:,f_sel,:),2,'omitnan'));
bandPow_before_std = squeeze(mean(Before_Spec_std(:,f_sel,:),2,'omitnan'));
bandPow_after30_target = squeeze(mean(After30_Spec_target(:,f_sel,:),2,'omitnan'));
bandPow_after30_std = squeeze(mean(After30_Spec_std(:,f_sel,:),2,'omitnan'));

bandPow_before_diff = bandPow_before_target - bandPow_before_std;
bandPow_after30_diff = bandPow_after30_target - bandPow_after30_std;

%trim
bandPow_before_diff = bandPow_before_diff(t_seg>=-300 & t_seg<=1000,:,:);
bandPow_after30_diff = bandPow_after30_diff(t_seg>=-300 & t_seg<=1000,:,:);
t_seg = t_seg(t_seg>=-300 & t_seg<=1000);

% baseline removal
bandPow_before_diffNorm = (bandPow_before_diff - mean(bandPow_before_diff(t_seg<=0,:,:)))./std(bandPow_before_diff(t_seg<=0,:,:));
bandPow_after30_diffNorm = (bandPow_after30_diff - mean(bandPow_after30_diff(t_seg<=0,:,:)))./std(bandPow_after30_diff(t_seg<=0,:,:));


[cmap] = cbrewer('seq','OrRd',20);

% Define figure dimensions in inches
figWidth = 3;  % Width in inches (e.g., single-column width)
figHeight = 2; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);

stdshade(bandPow_before_diffNorm', 0.4,cmap(10,:),t_seg)
hold on
stdshade(bandPow_after30_diffNorm', 0.4,cmap(end-2,:),t_seg)
xline(0,'LineWidth', 1.5)
xlim([-350 1050])
hLeg = legend('D0', 'D30');

% Remove the legend box
set(hLeg, 'Box', 'off');

% Customize font and position
set(hLeg, 'FontName', 'Helvetica', 'FontSize', 6, 'Location', 'northeast');

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
xlabel('Time (ms)', 'FontSize', 6);
ylabel('Normalized theta power (a.u.)', 'FontSize', 6);

% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'ERP_thetaPow_Diff.pdf'), 'ContentType', 'vector', 'Resolution', 300);


%% panel B figs
% erp all. before after30 in same plot

iCh=4;
[cmap] = cbrewer('seq','OrRd',20);

% Define figure dimensions in inches
figWidth = 3;  % Width in inches (e.g., single-column width)
figHeight = 1; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);

t_idx = time>=-300 & time<=1000;
stdshade(squeeze(Before_Trials.all(iCh,t_idx,:))',0.4,cmap(10,:),time(t_idx))
hold on
stdshade(squeeze(After30_Trials.all(iCh,t_idx,:))',0.4,cmap(end-2,:),time(t_idx))
xline(0,'LineWidth', 1.5)
xlim([-350 1050])
hLeg = legend('D0', 'D30');

% Remove the legend box
set(hLeg, 'Box', 'off');

% Customize font and position
set(hLeg, 'FontName', 'Helvetica', 'FontSize', 6, 'Location', 'best');

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
xlabel('Time (ms)', 'FontSize', 6);
ylabel('ERP', 'FontSize', 6);

% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'ERPmPFC_all.pdf'), 'ContentType', 'vector', 'Resolution', 300);
