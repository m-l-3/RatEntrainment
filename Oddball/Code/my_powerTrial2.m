

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
    'prep_band',        [0.1, 100],               ... 
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
[After10days_Data] = aggeregate_perRatSess(After10days_Datasets, cfg);
[After20days_Data] = aggeregate_perRatSess(After20days_Datasets, cfg);
[After30days_Data] = aggeregate_perRatSess(After30days_Datasets, cfg);

%% Save

save_dir = '../Results/Signals/sigZscr_eeglab_trZscore_0.1-100Hz-1.5-2epoch/';

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

save_dir = '../Results/Signals/sigZscr_eeglab_trZscore_0.1-100Hz-1.5-2epoch/';

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
% After10_Data  = load(strcat(save_dir, 'After10days_Data', dataName, '.mat')).After10days_Data;
% After20_Data  = load(strcat(save_dir, 'After20days_Data', dataName, '.mat')).After20days_Data;
After30_Data  = load(strcat(save_dir, 'After30days_Data', dataName, '.mat')).After30days_Data;

% *********************************************
% *************** cfg correction **************
% *********************************************
cfgCorrection

%%
useClean = false;
params.tapers = [3 5];
params.pad = -1;
params.Fs = fs;
params.fpass = [0 90];
params.twin_len = 0.5;
params.twin_slip = 0.02;
params.freq_range = [3 12];
params.lBatch = 5;
params.lBatchStep = 5;

[bandPower_before,~] = power_batchCalculator(Before_Data,useClean,params,cfg);
[bandPower_after30,t] = power_batchCalculator(After30_Data,useClean,params,cfg);


%%
[bandPowerArr_before] = makeArray(bandPower_before);
bandPowerArr_after30 = NaN(size(bandPowerArr_before));
[bandPowerArr_after30(:,:,:,4:end,:)] = makeArray(bandPower_after30);


%% fit lme for correct statisitics (only for single session)
% === Parameters ===
iCh = 3;
iSess = 1;
t_trend = t >= 200 & t <= 800;
batchTrim = 1:32;
nRats = size(bandPowerArr_before, 4);
nBatches = length(batchTrim);

% === Prepare Data Table ===
data = table();
batchAll = [];
powerAll = [];
conditionAll = [];
ratAll = [];

for iRat = 1:nRats
    % Extract and average across time (within t_trend)
    pow_before = squeeze(mean(bandPowerArr_before(iCh, t_trend, batchTrim, iRat, iSess), [2 5], 'omitnan'));
    pow_after  = squeeze(mean(bandPowerArr_after30(iCh, t_trend, batchTrim, iRat, iSess), [2 5], 'omitnan'));

    % Stack data
    batchAll = [batchAll; batchTrim(:); batchTrim(:)];
    powerAll = [powerAll; pow_before(:); pow_after(:)];
    conditionAll = [conditionAll; repmat({'Before'}, nBatches, 1); repmat({'After30'}, nBatches, 1)];
    ratAll = [ratAll; repmat(iRat, 2 * nBatches, 1)];
end

% Create table
data.batch = batchAll;
data.thetaPower = powerAll;
data.condition = categorical(conditionAll);  % Categorical fixed effect
data.rat = categorical(ratAll);              % Random effect

% === Fit Linear Mixed-Effects Model ===
% Model: thetaPower ~ batch * condition + (1 + batch | rat)
valid = ~isnan(data.thetaPower);
data_clean = data(valid, :);
lme = fitlme(data_clean, 'thetaPower ~ batch * condition + (1 + batch | rat)');


% === Display Results ===
disp(lme);
disp(anova(lme));

% Optional: Check interaction
% 'batch:condition' term tests if slopes differ between Before and After30

%% fit lme for correct statisitics
% === Parameters ===
iCh = 3;
t_trend = t >= 200 & t <= 800;
batchTrim = 1:32;
nRats = size(bandPowerArr_before, 4);
nBatches = length(batchTrim);

% === Prepare Table ===
data = table();
batchAll = [];
powerAll = [];
conditionAll = [];
sessionAll = [];
ratAll = [];

for iRat = 1:nRats
    for iSess = 1:2
        % Mean theta power over t_trend
        pow_before = squeeze(mean(bandPowerArr_before(iCh, t_trend, batchTrim, iRat, iSess), 2, 'omitnan'));
        pow_after  = squeeze(mean(bandPowerArr_after30(iCh, t_trend, batchTrim, iRat, iSess), 2, 'omitnan'));

        batchAll = [batchAll; batchTrim(:); batchTrim(:)];
        powerAll = [powerAll; pow_before(:); pow_after(:)];
        conditionAll = [conditionAll; repmat({'Before'}, nBatches, 1); repmat({'After30'}, nBatches, 1)];
        sessionAll = [sessionAll; repmat({sprintf('Session%d', iSess)}, 2*nBatches, 1)];
        ratAll = [ratAll; repmat(iRat, 2*nBatches, 1)];
    end
end

% Create table
data.batch = batchAll;
data.thetaPower = powerAll;
data.condition = categorical(conditionAll);
data.session = categorical(sessionAll);
data.rat = categorical(ratAll);

% Remove missing
valid = ~isnan(data.thetaPower);
data_clean = data(valid, :);
% data_before = data_clean(data_clean.condition=='Before', :);

% === Fit LME ===
lme = fitlme(data_clean, ...
    'thetaPower ~ batch * condition * session + (1 + batch | rat)');

% === Display results ===
disp(lme);
disp(anova(lme));  % Type III ANOVA (default)

% Optional: Confidence intervals for fixed effects
% ci = coefCI(lme);
% disp(array2table(ci, 'VariableNames', {'LowerCI','UpperCI'}, ...
%     'RowNames', lme.CoefficientNames));

%% heatmap of trial and time
iCh = 3;
iSess = 1;
t_idx = t>=-300 & t<=1000;
batchTrim = 1:120; 

bandPowerArr2plot = bandPowerArr_after30;
[t_mesh,trial_mesh] = meshgrid(t(t_idx), batchTrim);
img = squeeze(mean(bandPowerArr2plot(iCh, t_idx, batchTrim, :, iSess),[4 5],'omitnan'));

% Define figure dimensions in inches
figWidth = 1.8;  % Width in inches (e.g., single-column width)
figHeight = 1.2; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);
ax = gca;

pcolor(t_mesh,trial_mesh,img'); shading flat; colormap jet
xline(0,'LineWidth',1.5)
% xlim([-100 1000])
ylim([1 batchTrim(end)])
clim([0 2e-2])

% Add colorbar on the right
c = colorbar();

% Label the colorbar
% c.Label.String = 'Evoked theta power (a.u.)';
% c.Label.FontSize = 6;
% c.Label.FontName = 'Helvetica';
% c.Label.Rotation = 90;
% c.Label.HorizontalAlignment = 'center';
% c.Label.Position(1) = -1;  % Adjust label to the left
% 
% % Set tick label font
% c.FontSize = 5;
% c.FontName = 'Helvetica';

% ✅ Set scientific notation to 10^-2
% c.Ruler.Exponent = -2;

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
ylabel('Batch number', 'FontSize', 6);
xlabel('Time (ms)', 'FontSize', 6);


% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));
view([90 90])
% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'evokedThetaPow_cwt_timeTrialTrend.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%%
iCh = 3;
t_idx = t>=300 & t<=700;
smooth = 0;

% figure
% hold on
% plot(1:length(temp),reshape(temp, length(temp),[]))

iSess = 1;
temp = squeeze(mean(bandPowerArr_before(iCh, t_idx, :, :, iSess),[2 5],'omitnan'));
stdshade(reshape(temp, length(temp),[])', 0.4, c_before,1:length(temp),smooth)
iSess = 1;
temp = squeeze(mean(bandPowerArr_after30(iCh, t_idx, :, :, iSess),[2 5],'omitnan'));
stdshade(reshape(temp, length(temp),[])', 0.4, c_after30,1:length(temp),smooth)

% temp = squeeze(mean(bandPowerArr_after30(iCh, t_idx, :, :, iSess),2,'omitnan'));
% stdshade(reshape(temp, length(temp),[])', 0.4, 'm',1:length(temp),smooth)

title('After30')
legend('Block1', 'Block2')

%% fit trend
iSess = 2;
t_idx = t>=200 & t<=800;
batchTrim = 1:120; 
iCh = 3;

trend1 = squeeze(mean(bandPowerArr_before(iCh, t_idx, batchTrim, :, iSess),[2 4 5],'omitnan'));
trend2 = squeeze(mean(bandPowerArr_after30(iCh, t_idx, batchTrim, :, iSess),[2 4 5],'omitnan'));

% Fit linear trend lines
p1 = polyfit(batchTrim, trend1, 1);  % p1(1): slope, p1(2): intercept
p2 = polyfit(batchTrim, trend2, 1);

% Evaluate the fitted lines
fit1 = polyval(p1, batchTrim);
fit2 = polyval(p2, batchTrim);


nBoot = 1000;

% Preallocate
bootSlope1 = zeros(nBoot,1);
bootIntercept1 = zeros(nBoot,1);
bootSlope2 = zeros(nBoot,1);
bootIntercept2 = zeros(nBoot,1);
x1 = batchTrim';
x2 = batchTrim';

% Bootstrapping for each condition
for i = 1:nBoot
    idx1 = randsample(length(x1), length(x1), true);
    idx2 = randsample(length(x2), length(x2), true);
    
    p1 = polyfit(x1(idx1), trend1(idx1), 1);
    p2 = polyfit(x2(idx2), trend2(idx2), 1);
    
    bootSlope1(i) = p1(1);
    bootIntercept1(i) = p1(2);
    
    bootSlope2(i) = p2(1);
    bootIntercept2(i) = p2(2);
end

% Get mean and confidence bounds
xq = linspace(min(x1), max(x1), 100)';
yFit1 = bootSlope1 .* xq' + bootIntercept1;
yFit2 = bootSlope2 .* xq' + bootIntercept2;

meanFit1 = mean(yFit1);
ci1 = prctile(yFit1, [2.5 97.5]);

meanFit2 = mean(yFit2);
ci2 = prctile(yFit2, [2.5 97.5]);

[cmap] = cbrewer('seq','OrRd',29);
c_before = cmap(13,:);
c_after30 = cmap(25,:);

% Define figure dimensions in inches
figWidth = 1.2;  % Width in inches (e.g., single-column width)
figHeight = 2; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);
ax = gca;
hold on

lw = 1.5;
% Plot original trends and their linear fits
plot(batchTrim, trend1, 'Color', c_before, 'LineWidth', lw, 'DisplayName', 'Before');
plot(batchTrim, trend2, 'Color', c_after30, 'LineWidth', lw, 'DisplayName', 'After30');

plot(batchTrim, fit1, '-', 'Color', c_before, 'LineWidth', lw);
plot(batchTrim, fit2, '-', 'Color', c_after30, 'LineWidth', lw);

% Plot shaded CI for condition 1
fill([xq; flipud(xq)], [ci1(1,:)'; flipud(ci1(2,:)')], c_before, 'EdgeColor','none', 'FaceAlpha',0.4);

% Plot shaded CI for condition 2
fill([xq; flipud(xq)], [ci2(1,:)'; flipud(ci2(2,:)')], c_after30, 'EdgeColor','none', 'FaceAlpha',0.4);

xlim([min(batchTrim)-5 max(batchTrim)+5])
% Remove the legend box
hLeg = legend('Before', 'After30');
hLeg.ItemTokenSize = [10 10];
set(hLeg, 'Box', 'off');

% Customize font and position
set(hLeg, 'FontName', 'Helvetica', 'FontSize', 6, 'Location', 'best');

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
ylabel('Evoked theta power (a.u.)', 'FontSize', 6);
xlabel('Batch number', 'FontSize', 6);
ax.YAxis.Exponent = -2;


% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'evokedThetaPow_cwt_trendTrail.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%% fit trend and heatmap of trial and time stacked
% Settings
iCh = 3;
iSess = 1;
t_idx = t >= -300 & t <= 1000;
t_trend = t >= 200 & t <= 800;
batchTrim = 1:120;
nBoot = 1000;
cmax = .02;
% 1. Prepare trend data
trend1 = squeeze(mean(bandPowerArr_before(iCh, t_trend, batchTrim, :, iSess), [2 4 5], 'omitnan'));
trend2 = squeeze(mean(bandPowerArr_after30(iCh, t_trend, batchTrim, :, iSess), [2 4 5], 'omitnan'));

% Fit linear trend lines
p1 = polyfit(batchTrim, trend1, 1);
p2 = polyfit(batchTrim, trend2, 1);
fit1 = polyval(p1, batchTrim);
fit2 = polyval(p2, batchTrim);

% Bootstrapping
bootSlope1 = zeros(nBoot,1); bootIntercept1 = zeros(nBoot,1);
bootSlope2 = zeros(nBoot,1); bootIntercept2 = zeros(nBoot,1);
x1 = batchTrim'; x2 = batchTrim';

for i = 1:nBoot
    idx1 = randsample(length(x1), length(x1), true);
    idx2 = randsample(length(x2), length(x2), true);
    pp1 = polyfit(x1(idx1), trend1(idx1), 1);
    pp2 = polyfit(x2(idx2), trend2(idx2), 1);
    bootSlope1(i) = pp1(1); bootIntercept1(i) = pp1(2);
    bootSlope2(i) = pp2(1); bootIntercept2(i) = pp2(2);
end

xq = linspace(min(x1), max(x1), 100)';
yFit1 = bootSlope1 .* xq' + bootIntercept1;
yFit2 = bootSlope2 .* xq' + bootIntercept2;
meanFit1 = mean(yFit1); ci1 = prctile(yFit1, [2.5 97.5]);
meanFit2 = mean(yFit2); ci2 = prctile(yFit2, [2.5 97.5]);

[cmap] = cbrewer('seq','OrRd',29);
c_before = cmap(13,:);
c_after30 = cmap(25,:);

% 2. Prepare heatmaps
[t_mesh, batch_mesh] = meshgrid(t(t_idx)/1000, batchTrim);
img1 = squeeze(mean(bandPowerArr_before(iCh, t_idx, batchTrim, :, iSess), [4 5], 'omitnan'));
img2 = squeeze(mean(bandPowerArr_after30(iCh, t_idx, batchTrim, :, iSess), [4 5], 'omitnan'));

% 3. Create stacked plots with shared x-axis and common colorbar
figWidth = 1.7;
figHeight = 4;  % Combined height
fig = figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);


% A. First row: heatmap (Before)
ax1 = subplot(18,10,[2:8 12:18 22:28 32:38]);
pcolor(t_mesh, batch_mesh, img1'); shading flat; colormap jet
xline(0, 'LineWidth', 1.5)
xlabel('Time (s)', 'FontSize', 6);
title('Before', 'FontSize', 6);
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
ylim([min(batchTrim) max(batchTrim)])
clim([0 cmax])
view([90 90])
set(gca, 'YTick', [10 30 50 70 90 110], 'YTickLabel', {});

% B. Second row: heatmap (After30)
ax2 = subplot(18,10,[52:58 62:68 72:78 82:88]);
pcolor(t_mesh, batch_mesh, img2'); shading flat; colormap jet
xline(0, 'LineWidth', 1.5)
xlabel('Time (s)', 'FontSize', 6);
title('After30', 'FontSize', 6);
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
ylim([min(batchTrim) max(batchTrim)])
clim([0 cmax])
view([90 90])
set(gca, 'YTick', [10 30 50 70 90 110], 'YTickLabel', {});

% A-B. Common colorbar on the right
% cb = colorbar(ax2, 'Position', [ax2.Position(1)+ax2.Position(3)*1.15, ax2.Position(2), 0.03, ax1.Position(2)-ax2.Position(2)+ax2.Position(4)]);  % Adjust position as needed
% cb.Label.String = 'Evoked theta power (a.u.)';
% cb.Label.FontName = 'Helvetica';
% cb.Label.Rotation = 90;
% cb.Label.Position(1) = -2.2;
% cb.Ruler.Exponent = -2;
% cb.FontSize = 6;
% cb.FontName = 'Helvetica';

% C. Third row: trend plot
ax3 = subplot(18,10,[102:108 112:118 122:128 132:138 142:148 152:158 162:168 172:178]); hold on
plot(batchTrim, trend1, 'Color', c_before, 'LineWidth', 1.5);
plot(batchTrim, trend2, 'Color', c_after30, 'LineWidth', 1.5);
plot(batchTrim, fit1, '-', 'Color', c_before, 'LineWidth', 1.5);
plot(batchTrim, fit2, '-', 'Color', c_after30, 'LineWidth', 1.5);
fill([xq; flipud(xq)], [ci1(1,:)'; flipud(ci1(2,:)')], c_before, 'EdgeColor','none', 'FaceAlpha',0.4);
fill([xq; flipud(xq)], [ci2(1,:)'; flipud(ci2(2,:)')], c_after30, 'EdgeColor','none', 'FaceAlpha',0.4);
xlim([min(batchTrim)-5 max(batchTrim)+5])
xlabel('Batch number', 'FontSize', 6);
ylim([0 .02])
% ylabel('Evoked theta power (a.u.)', 'FontSize', 6);
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
hLeg = legend({'Before', 'After30'}, 'Box', 'off', 'FontSize', 6, 'FontName', 'Helvetica');
hLeg.ItemTokenSize = [10 10];
set(gca, 'XTick', [10 30 50 70 90 110], 'XTickLabel', {'10','30','50', '70', '90', '110'});
ax3.YAxis.Exponent = -2;

% Create an invisible axes to hold the "south" title
han = axes(fig, 'Visible', 'off', 'Position', [0 0 1 1]);
han.XLim = [0 1]; han.YLim = [0 1];
% Get midpoint of ax3 in normalized figure units
ax3_midX = ax3.Position(1) + ax3.Position(3)/2;

% Add bottom-aligned text horizontally aligned with ax3 x-label
text(han, ax3_midX, 0.005, 'Block1', ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'bottom', ...
    'FontWeight', 'bold', ...
    'FontSize', 6, ...
    'FontName', 'Helvetica');

% Tight layout
set(ax1, 'Box', 'off');
set(ax2, 'Box', 'off');
set(ax3, 'Box', 'off');
set(gcf, 'PaperPositionMode', 'auto');

% Export (vector format)
% exportgraphics(gcf, '../Figures/evokedTheta_timeTrial_Stacked_block1.pdf', 'ContentType', 'vector', 'Resolution', 300);

%%
% Assume you have vectors like this:
% x_all: concatenated batch indices for both conditions
% y_all: concatenated theta power values
% g: grouping variable (0 for condition 1, 1 for condition 2)
x1 = batchTrim';
x2 = batchTrim';

y1 = trend1(:);
y2 = trend2(:);

x_all = [x1; x2];
y_all = [y1; y2];
g = [zeros(size(x1)); ones(size(x2))];  % group labels: 0 = cond1, 1 = cond2

% Create interaction term
X = [ones(size(x_all)), x_all, g, x_all .* g];

% Fit linear model: y = β0 + β1*x + β2*g + β3*(x*g)
b = X \ y_all;

% Hypothesis: is the interaction term (b(4)) significant?
y_pred = X * b;
residuals = y_all - y_pred;

% Estimate standard error of interaction term
MSE = sum(residuals.^2) / (length(y_all) - size(X,2));
covB = MSE * inv(X' * X);
se_b3 = sqrt(covB(4,4));

tval = b(4) / se_b3;
df = length(y_all) - size(X,2);
pval = 2 * (1 - tcdf(abs(tval), df));

fprintf('Difference in slopes:\n');
fprintf('  Slope difference = %.4f\n', b(4));
fprintf('  t(%d) = %.2f, p = %.4f\n', df, tval, pval);


%% psd calculation (cwt or chronux or pmtm)

useERP = true;
useClean = true;
correctPow = false;
params.tapers = [3 5];
params.pad = -1;
params.Fs = fs;
params.fpass = [0 300];
params.trialave = true;
params.freqRangeCorrectin = [2 32];

twin_len = 2;
twin_slip = 0.05;

iTarStd = 3; % 1:All, 2:Std, 3:Target
[~,~,Before_Spec] = calc_specgram(Before_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP,correctPow);
[~,~,After30_Spec] = calc_specgram(After30_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP,correctPow);
[BeforeTar_SpecArr] = makeArray(Before_Spec);
[After30Tar_SpecArr] = makeArray(After30_Spec);
After30Tar_SpecArr(:,:,:,4:8,:) = After30Tar_SpecArr;
After30Tar_SpecArr(:,:,:,1:3,:) = nan;

iTarStd = 2; % 1:All, 2:Std, 3:Target
[~,~,Before_Spec] = calc_specgram(Before_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP,correctPow);
[t,f,After30_Spec] = calc_specgram(After30_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP,correctPow);
[BeforeStd_SpecArr] = makeArray(Before_Spec);
[After30Std_SpecArr] = makeArray(After30_Spec);
After30Std_SpecArr(:,:,:,4:8,:) = After30Std_SpecArr;
After30Std_SpecArr(:,:,:,1:3,:) = nan;

% iTarStd = 1; % 1:All, 2:Std, 3:Target
% [~,~,Before_Spec] = calc_specgram(Before_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP,correctPow);
% [t,f,After30_Spec] = calc_specgram(After30_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP,correctPow);
% [BeforeAll_SpecArr] = makeArray(Before_Spec);
% [After30All_SpecArr] = makeArray(After30_Spec);
% After30All_SpecArr(:,:,:,4:8,:) = After30All_SpecArr;
% After30All_SpecArr(:,:,:,1:3,:) = nan;

% time = (t-cfg.epoch_time(1))*1000;
time = t*1000;

%%

tb = time>=-100 & time <=0;
BeforeTar_SpecArr_bn = BeforeTar_SpecArr - mean(BeforeTar_SpecArr(tb,:,:,:,:),'omitnan');
BeforeStd_SpecArr_bn = BeforeStd_SpecArr - mean(BeforeStd_SpecArr(tb,:,:,:,:),'omitnan');
After30Tar_SpecArr_bn = After30Tar_SpecArr - mean(After30Tar_SpecArr(tb,:,:,:,:),'omitnan');
After30Std_SpecArr_bn = After30Std_SpecArr - mean(After30Std_SpecArr(tb,:,:,:,:),'omitnan');

% BeforeTar_SpecArr_n = BeforeTar_SpecArr ./ mean(BeforeTar_SpecArr(:,f<=100,:,:,:),2,'omitnan');
% BeforeStd_SpecArr_n = BeforeStd_SpecArr ./ mean(BeforeStd_SpecArr(:,f<=100,:,:,:),2,'omitnan');
% After30Tar_SpecArr_n = After30Tar_SpecArr ./ mean(After30Tar_SpecArr(:,f<=100,:,:,:),2,'omitnan');
% After30Std_SpecArr_n = After30Std_SpecArr ./ mean(After30Std_SpecArr(:,f<=100,:,:,:),2,'omitnan');

%%
fRange = [4 8];
iCh = 3;
f_sel = f>=fRange(1) & f<=fRange(2);
figure
stdshade(squeeze(mean(BeforeTar_SpecArr(:,f_sel,iCh,:,:),[2 5],'omitnan'))' - ...
     squeeze(mean(BeforeStd_SpecArr(:,f_sel,iCh,:,:),[2 5],'omitnan'))',0.4,'b',time)
hold on
stdshade(squeeze(mean(After30Tar_SpecArr(:,f_sel,iCh,:,:),[2 5],'omitnan'))' - ...
    squeeze(mean(After30Std_SpecArr(:,f_sel,iCh,:,:),[2 5],'omitnan'))',0.4,'m',time)

%% normalized theta power of ERP for Fig.2
fRange = [4 12];
iCh = 3;
iSess = 1:2;
iRat = 1:8;
smooth = 0;
f_sel = f>=fRange(1) & f<=fRange(2);

tTrim = time>=-300 & time<=1000;

state = "target";
[cmap] = cbrewer('seq','OrRd',29);
ctar_before = cmap(14,:);
ctar_after30 = cmap(26,:);
cstd_before = cmap(12,:);
cstd_after30 = cmap(24,:);

% Define figure dimensions in inches
figWidth = 1.4;  % Width in inches (e.g., single-column width)
figHeight = 1; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);
hold on
ax = gca;

if(state=="target")
    stdshade(squeeze(mean(BeforeTar_SpecArr_bn(tTrim,f_sel,iCh,iRat,iSess),[2 5],'omitnan'))',0.4,ctar_before,time(tTrim),smooth)
    stdshade(squeeze(mean(After30Tar_SpecArr_bn(tTrim,f_sel,iCh,iRat,iSess),[2 5],'omitnan'))',0.4,ctar_after30,time(tTrim),smooth)
    my_title = "DEV";
    xlabel('Time (ms)', 'FontSize', 6);
    ax.YAxis.Exponent = -2;
else
    stdshade(squeeze(mean(BeforeStd_SpecArr_bn(tTrim,f_sel,iCh,iRat,iSess),[2 5],'omitnan'))',0.4,cstd_before,time(tTrim),smooth)
    stdshade(squeeze(mean(After30Std_SpecArr_bn(tTrim,f_sel,iCh,iRat,iSess),[2 5],'omitnan'))',0.4,cstd_after30,time(tTrim),smooth)
    my_title = "STD";
    xlabel('         ', 'FontSize', 6);
    ax.YAxis.Exponent = -3;
    ylim([-0.0006 0.0099])
end
xline(0,'LineWidth', 1)

xlim([-350 1050])
% ylim([-.5 2])


% Remove the legend box
% hLeg = legend('Before', 'After30');
% hLeg.ItemTokenSize = [10 10];
% set(hLeg, 'Box', 'off');
% 
% % Customize font and position
% set(hLeg, 'FontName', 'Helvetica', 'FontSize', 6, 'Location', 'best');

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
ylabel('Evoked theta power (a.u.)', 'FontSize', 6);
title(my_title, 'FontName', 'Helvetica', 'FontSize', 6,'FontWeight', 'bold')

% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'evokedThetaPow_cwt_',my_title,'.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%% normalized theta power in same figure vertically stacked
fRange = [3 12];
iCh = 3;
iSess = 1;
iRat = 1:8;
smooth = 0;
f_sel = f >= fRange(1) & f <= fRange(2);
tTrim = time >= -300 & time <= 1000;

% Colors
[cmap] = cbrewer('seq','OrRd',29);
ctar_before = cmap(14,:);
ctar_after30 = cmap(26,:);
cstd_before = cmap(12,:);
cstd_after30 = cmap(24,:);

% Figure setup
figWidth = 1.4;
figHeight = 2;
fig = figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);


% --- Top panel: Standard
subplot(2,1,1);
stdshade(squeeze(mean(BeforeStd_SpecArr(tTrim,f_sel,iCh,iRat,iSess),[2 5],'omitnan'))', 0.4, cstd_before, time(tTrim), smooth);
hold on;
stdshade(squeeze(mean(After30Std_SpecArr(tTrim,f_sel,iCh,iRat,iSess),[2 5],'omitnan'))', 0.4, cstd_after30, time(tTrim), smooth);
xline(0, 'k', 'LineWidth', 1);
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
set(gca, 'XTickLabel', []);
set(gca, 'box', 'off');
title('STD', 'FontName', 'Helvetica', 'FontSize', 6, 'FontWeight', 'bold');
xlim([-350 1050]);
ax1 = gca;
ax1.YAxis.Exponent = -3;
% Remove the legend box
hLeg = legend('Before', 'After30');
hLeg.ItemTokenSize = [10 10];
set(hLeg, 'Box', 'off');

% Customize font and position
set(hLeg, 'FontName', 'Helvetica', 'FontSize', 5, 'Location', 'best');


% --- Bottom panel: Target
subplot(2,1,2);
stdshade(squeeze(mean(BeforeTar_SpecArr(tTrim,f_sel,iCh,iRat,iSess),[2 5],'omitnan'))', 0.4, ctar_before, time(tTrim), smooth);
hold on;
stdshade(squeeze(mean(After30Tar_SpecArr(tTrim,f_sel,iCh,iRat,iSess),[2 5],'omitnan'))', 0.4, ctar_after30, time(tTrim), smooth);
xline(0, 'k', 'LineWidth', 1);
xlabel('Time (ms)', 'FontSize', 6);
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
set(gca, 'box', 'off');
title('DEV', 'FontName', 'Helvetica', 'FontSize', 6, 'FontWeight', 'bold');
xlim([-350 1050]);
ax2 = gca;
ax2.YAxis.Exponent = -2;

% Common y-axis label
han = axes(fig, 'visible', 'off'); 
han.YLabel.Visible = 'on';
ylabel(han, ['Evoked' char(160) 'theta' char(160) 'power (a.u.)'], ...
    'FontSize', 6, 'FontName', 'Helvetica');

% Export as PDF
fig_dir = '../Figures/';
% exportgraphics(gcf, fullfile(fig_dir, 'evokedThetaPow_cwt_STD_DEV.pdf'), 'ContentType', 'vector', 'Resolution', 300);


%% psd of ERP 
tRange = [-100 1000];
iCh = 3;
iSess = 1:2;
tRange = [-1100 2000];
iCh = 3;
iSess = 1:2;
t_sel = time>=tRange(1) & time<=tRange(2);

state = "target";
[cmap] = cbrewer('seq','OrRd',29);
ctar_before = cmap(14,:);
ctar_after30 = cmap(26,:);
cstd_before = cmap(12,:);
cstd_after30 = cmap(24,:);

% Define figure dimensions in inches
figWidth = 1.4;  % Width in inches (e.g., single-column width)
figHeight = 2; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);
hold on
ax = gca;

if(state=="target")
    stdshade(squeeze(mean(BeforeTar_SpecArr(t_sel,:,iCh,:,iSess),[1 5],'omitnan'))',0.4,ctar_before,f)
    stdshade(squeeze(mean(After30Tar_SpecArr(t_sel,:,iCh,:,iSess),[1 5],'omitnan'))',0.4,ctar_after30,f)
    my_title = "DEV";
    ylabel('            ', 'FontSize', 6);
    ax.YAxis.Exponent = -2;
else
    stdshade(squeeze(mean(BeforeStd_SpecArr(t_sel,:,iCh,:,iSess),[1 5],'omitnan'))',0.4,cstd_before,f)
    stdshade(squeeze(mean(After30Std_SpecArr(t_sel,:,iCh,:,iSess),[1 5],'omitnan'))',0.4,cstd_after30,f)
    my_title = "STD";
    ylabel('Evoked spectral power (a.u.)', 'FontSize', 6);
    ax.YAxis.Exponent = -3;
end

xlim([2 45])

% ylim([0 1.2e-2])

% Remove the legend box
hLeg = legend('Before', 'After30');
hLeg.ItemTokenSize = [10 10];
set(hLeg, 'Box', 'off');

% Customize font and position
set(hLeg, 'FontName', 'Helvetica', 'FontSize', 6, 'Location', 'northeast');

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
xlabel('Frequency (Hz)', 'FontSize', 6);
 

title(my_title, 'FontName', 'Helvetica', 'FontSize', 6,'FontWeight', 'bold')

% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'evokedCwtSpec_',my_title,'.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%% psd of ERP horizontaly stacked
tRange = [200 800];
iCh = 4;
iSess = 1;
iRat = 1:8;
t_sel = time >= tRange(1) & time <= tRange(2);

[cmap] = cbrewer('seq','OrRd',29);
ctar_before = cmap(14,:);
ctar_after30 = cmap(26,:);
cstd_before = cmap(12,:);
cstd_after30 = cmap(24,:);

figWidth = 3.2;  % Wider to fit two plots side by side
figHeight = 2;

figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);

% ------------------ STD subplot (left) ------------------
subplot(1,2,1)
stdshade(squeeze(mean(BeforeStd_SpecArr(t_sel,:,iCh,iRat,iSess),[1 5],'omitnan'))', 0.4, cstd_before, f);
hold on
stdshade(squeeze(mean(After30Std_SpecArr(t_sel,:,iCh,iRat,iSess),[1 5],'omitnan'))', 0.4, cstd_after30, f);
xlim([2 45])
title('STD', 'FontName', 'Helvetica', 'FontSize', 6, 'FontWeight', 'bold')
ylabel('Evoked spectral power (a.u.)', 'FontSize', 6)
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1)
xlabel('Frequency (Hz)', 'FontSize', 6)
hLeg = legend('Before', 'After30');
hLeg.ItemTokenSize = [10 10];
set(hLeg, 'Box', 'off');
set(gca, 'box', 'off')
ax1 = gca;
ax1.YAxis.Exponent = -3;

% ------------------ DEV subplot (right) ------------------
subplot(1,2,2)
stdshade(squeeze(mean(BeforeTar_SpecArr(t_sel,:,iCh,iRat,iSess),[1 5],'omitnan'))', 0.4, ctar_before, f);
hold on
stdshade(squeeze(mean(After30Tar_SpecArr(t_sel,:,iCh,iRat,iSess),[1 5],'omitnan'))', 0.4, ctar_after30, f);
xlim([2 45])
title('DEV', 'FontName', 'Helvetica', 'FontSize', 6, 'FontWeight', 'bold')
xlabel('Frequency (Hz)', 'FontSize', 6)
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1)
set(gca, 'box', 'off')
ax2 = gca;
ax2.YAxis.Exponent = -2;
% Hide y-label but preserve layout spacing
ylabel(' ', 'Visible', 'off')

% Tight layout to reduce white space
set(gcf, 'Color', 'w');
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'evokedCwtSpec_STD_DEV_horizontal.pdf'), 'ContentType', 'vector', 'Resolution', 300);


%% psd of ERP vertically stacked
tRange = [200 800];
iCh = 3;
iSess = 1;
iRat = 1:8;
t_sel = time >= tRange(1) & time <= tRange(2);

[cmap] = cbrewer('seq','OrRd',29);
ctar_before = cmap(14,:);
ctar_after30 = cmap(26,:);
cstd_before = cmap(12,:);
cstd_after30 = cmap(24,:);

figWidth = 2;  % Wider to fit two plots side by side
figHeight = 4;

fig = figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);

% ------------------ STD subplot (left) ------------------
subplot(2,1,1)
stdshade(squeeze(mean(BeforeStd_SpecArr(t_sel,:,iCh,iRat,iSess),[1 5],'omitnan'))', 0.4, cstd_before, f);
hold on
stdshade(squeeze(mean(After30Std_SpecArr(t_sel,:,iCh,iRat,iSess),[1 5],'omitnan'))', 0.4, cstd_after30, f);
xlim([2 45])
title('STD', 'FontName', 'Helvetica', 'FontSize', 6, 'FontWeight', 'bold')
% ylabel('Evoked spectral power (a.u.)', 'FontSize', 6)
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1)
% xlabel('Frequency (Hz)', 'FontSize', 6)
hLeg = legend('Before', 'After30');
hLeg.ItemTokenSize = [10 10];
set(hLeg, 'Box', 'off');
set(gca, 'box', 'off')
ax1 = gca;
ax1.YAxis.Exponent = -3;

% ------------------ DEV subplot (right) ------------------
subplot(2,1,2)
stdshade(squeeze(mean(BeforeTar_SpecArr(t_sel,:,iCh,iRat,iSess),[1 5],'omitnan'))', 0.4, ctar_before, f);
hold on
stdshade(squeeze(mean(After30Tar_SpecArr(t_sel,:,iCh,iRat,iSess),[1 5],'omitnan'))', 0.4, ctar_after30, f);
xlim([2 45])
title('DEV', 'FontName', 'Helvetica', 'FontSize', 6, 'FontWeight', 'bold')
xlabel('Frequency (Hz)', 'FontSize', 6)
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1)
set(gca, 'box', 'off')
ax2 = gca;
ax2.YAxis.Exponent = -2;

% Common y-axis label
han = axes(fig, 'visible', 'off'); 
han.YLabel.Visible = 'on';
ylabel(han, ['Evoked' char(160) 'spectral' char(160) 'power (a.u.)'], ...
    'FontSize', 6, 'FontName', 'Helvetica');

% Tight layout to reduce white space
set(gcf, 'Color', 'w');
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'evokedCwtSpec_STD_DEV_vertical.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%% bar plot tar/std, before/after30 vertical

fRange = [4 12]; %Hz
tRange = [-100 1000]; %ms
iCh = 3;
iSess = 1:2;
fRange = [3 12]; %Hz
tRange = [200 800]; %ms
iCh = 3;
iSess = 1;

t_sel = time>=tRange(1) & time<=tRange(2);
f_sel = f>=fRange(1) & f<=fRange(2);

groupSpacing = 0.7;
interSpacing = 0;
barWidth = 0.3;
[cmap] = cbrewer('seq','OrRd',29);
ctar_before = cmap(14,:);
ctar_after30 = cmap(26,:);
cstd_before = cmap(12,:);
cstd_after30 = cmap(24,:);


x = []; % x-positions of bars
for g = 1:2
    base = (g - 1) * groupSpacing;
    x = [x, base + [-barWidth/2-interSpacing, barWidth/2+interSpacing]];
end

y1 = squeeze(mean(BeforeStd_SpecArr(t_sel,f_sel,iCh,:,iSess),[1 2 5],'omitnan'));
y2 = squeeze(mean(BeforeTar_SpecArr(t_sel,f_sel,iCh,:,iSess),[1 2 5],'omitnan'));
y3 = squeeze(mean(After30Std_SpecArr(t_sel,f_sel,iCh,:,iSess),[1 2 5],'omitnan'));
y4 = squeeze(mean(After30Tar_SpecArr(t_sel,f_sel,iCh,:,iSess),[1 2 5],'omitnan'));

% Define figure dimensions in inches
figWidth = 1.4;  % Width in inches (e.g., single-column width)
figHeight = 1.5; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);
hold on

barWidth = barWidth*0.9;
bar(x(1), nanmean(y1), barWidth, 'FaceColor', cstd_before, 'EdgeColor', cstd_before);
bar(x(2), nanmean(y2), barWidth, 'FaceColor', ctar_before, 'EdgeColor', ctar_before);
bar(x(3), nanmean(y3), barWidth, 'FaceColor', cstd_after30, 'EdgeColor', cstd_after30);
bar(x(4), nanmean(y4), barWidth, 'FaceColor', ctar_after30, 'EdgeColor', ctar_after30);

errorbar(x(1), nanmean(y1), nanstd(y1) / sqrt(sum(~isnan(y1))), 'k', 'LineWidth', 1, 'CapSize', 3);
errorbar(x(2), nanmean(y2), nanstd(y2) / sqrt(sum(~isnan(y2))), 'k', 'LineWidth', 1, 'CapSize', 3);
errorbar(x(3), nanmean(y3), nanstd(y3) / sqrt(sum(~isnan(y3))), 'k', 'LineWidth', 1, 'CapSize', 3);
errorbar(x(4), nanmean(y4), nanstd(y4) / sqrt(sum(~isnan(y4))), 'k', 'LineWidth', 1, 'CapSize', 3);

markers = ['x','o','s','d','^','v','>','<','p','h','+','*']; % enough for 12 rats

barWidth = barWidth*.7;
markerSize = 2;
lw = 0.5;
for i=1:8
    x_sample = linspace(x(1)-barWidth/2,x(1)+barWidth/2,numel(y1));
    plot(x_sample(i), ...
        y1(i), markers(i), 'Color', 'k', 'MarkerFaceColor', cstd_before,'MarkerSize', markerSize, 'LineWidth', lw);
    x_sample = linspace(x(2)-barWidth/2,x(2)+barWidth/2,numel(y2));
    plot(x_sample(i), ...
        y2(i), markers(i), 'Color', 'k', 'MarkerFaceColor', ctar_before,'MarkerSize', markerSize, 'LineWidth', lw);
    x_sample = linspace(x(3)-barWidth/2,x(3)+barWidth/2,numel(y3));
    plot(x_sample(i), ...
        y3(i), markers(i), 'Color', 'k', 'MarkerFaceColor', cstd_after30,'MarkerSize', markerSize, 'LineWidth', lw);
    x_sample = linspace(x(4)-barWidth/2,x(4)+barWidth/2,numel(y4));
    plot(x_sample(i), ...
        y4(i), markers(i), 'Color', 'k', 'MarkerFaceColor', ctar_after30,'MarkerSize', markerSize, 'LineWidth', lw);
end

[h,p] = ttest(y1, y2)
addSignificanceStar(x(1), x(2), 0.015, h, p, true)

[h,p] = ttest(y3, y4)
addSignificanceStar(x(3), x(4), 0.015, h, p, true)

[h,p] = ttest(y2, y4)
addSignificanceStar(x(2), x(4), 0.017, h, p, true)

[h,p] = ttest(y1, y3)
addSignificanceStar(x(1), x(3), 0.017, h, p, true)

% Axes and labels
xticks(x);
xticklabels({"STD","DEV","STD","DEV"});
xtickangle(45); 


% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 5, 'LineWidth', 1);
xlim([min(x)-barWidth max(x)+barWidth])
ax = gca;
ax.YAxis.Exponent = -2;
ylabel('Evoked theta power (a.u.)', 'FontSize', 6);

% title(my_title, 'FontName', 'Helvetica', 'FontSize', 6,'FontWeight', 'bold')
% Remove the top and right borders
set(gca, 'box', 'off');


% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'evokedThetaPow_cwt_bar_perRat.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%% bar plot tar/std, before/after30 horizontal
% Setup
fRange = [3 12]; %Hz
tRange = [200 800]; %ms
iCh = 3;
iSess = 1;

t_sel = time >= tRange(1) & time <= tRange(2);
f_sel = f >= fRange(1) & f <= fRange(2);

groupSpacing = 0.7;
interSpacing = 0;
barHeight = 0.3;

[cmap] = cbrewer('seq', 'OrRd', 29);
ctar_before = cmap(14,:);
ctar_after30 = cmap(26,:);
cstd_before = cmap(12,:);
cstd_after30 = cmap(24,:);

y = [];  % y-positions of bars
for g = 1:2
    base = (g - 1) * groupSpacing;
    y = [y, base + [-barHeight/2 - interSpacing, barHeight/2 + interSpacing]];
end

% Data
d1 = squeeze(mean(BeforeStd_SpecArr(t_sel, f_sel, iCh, :, iSess), [1 2 5], 'omitnan'));
d2 = squeeze(mean(BeforeTar_SpecArr(t_sel, f_sel, iCh, :, iSess), [1 2 5], 'omitnan'));
d3 = squeeze(mean(After30Std_SpecArr(t_sel, f_sel, iCh, :, iSess), [1 2 5], 'omitnan'));
d4 = squeeze(mean(After30Tar_SpecArr(t_sel, f_sel, iCh, :, iSess), [1 2 5], 'omitnan'));

% Figure
figWidth = 3.5;
figHeight = 1;
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]); hold on;

barHeight = barHeight * 0.9;

% Bars (horizontal)
barh(y(1), nanmean(d1), barHeight, 'FaceColor', cstd_before, 'EdgeColor', cstd_before);
barh(y(2), nanmean(d2), barHeight, 'FaceColor', ctar_before, 'EdgeColor', ctar_before);
barh(y(3), nanmean(d3), barHeight, 'FaceColor', cstd_after30, 'EdgeColor', cstd_after30);
barh(y(4), nanmean(d4), barHeight, 'FaceColor', ctar_after30, 'EdgeColor', ctar_after30);

% Error bars
errorbar(nanmean(d1), y(1), nanstd(d1)/sqrt(sum(~isnan(d1))), 'horizontal', 'k', 'LineWidth', 1, 'CapSize', 3);
errorbar(nanmean(d2), y(2), nanstd(d2)/sqrt(sum(~isnan(d2))), 'horizontal', 'k', 'LineWidth', 1, 'CapSize', 3);
errorbar(nanmean(d3), y(3), nanstd(d3)/sqrt(sum(~isnan(d3))), 'horizontal', 'k', 'LineWidth', 1, 'CapSize', 3);
errorbar(nanmean(d4), y(4), nanstd(d4)/sqrt(sum(~isnan(d4))), 'horizontal', 'k', 'LineWidth', 1, 'CapSize', 3);

% Per-rat markers
barHeight = barHeight * 0.7;
markerSize = 2;
lw = 0.5;
markers = ['x','o','s','d','^','v','>','<','p','h','+','*'];

for i = 1:8
    y_sample = linspace(y(1) - barHeight/2, y(1) + barHeight/2, numel(d1));
    plot(d1(i), y_sample(i), markers(i), 'Color', 'k', 'MarkerFaceColor', cstd_before, 'MarkerSize', markerSize, 'LineWidth', lw);
    
    y_sample = linspace(y(2) - barHeight/2, y(2) + barHeight/2, numel(d2));
    plot(d2(i), y_sample(i), markers(i), 'Color', 'k', 'MarkerFaceColor', ctar_before, 'MarkerSize', markerSize, 'LineWidth', lw);
    
    y_sample = linspace(y(3) - barHeight/2, y(3) + barHeight/2, numel(d3));
    plot(d3(i), y_sample(i), markers(i), 'Color', 'k', 'MarkerFaceColor', cstd_after30, 'MarkerSize', markerSize, 'LineWidth', lw);
    
    y_sample = linspace(y(4) - barHeight/2, y(4) + barHeight/2, numel(d4));
    plot(d4(i), y_sample(i), markers(i), 'Color', 'k', 'MarkerFaceColor', ctar_after30, 'MarkerSize', markerSize, 'LineWidth', lw);
end

% Statistical significance (⚠️ You must update or disable `addSignificanceStar`)
[h, p] = ttest(d1, d2); % Before
[h, p] = ttest(d3, d4); % After
[h, p] = ttest(d2, d4); % DEV change
[h, p] = ttest(d1, d3); % STD change
% ⚠️ Comment or adapt these lines:
% addSignificanceStar(x1, x2, yLevel, h, p, true);

% Axis settings
yticks(y);
yticklabels({"STD", "DEV", "STD", "DEV"});
set(gca, 'FontName', 'Helvetica', 'FontSize', 5, 'LineWidth', 1);
ylim([min(y) - barHeight, max(y) + barHeight]);
xlabel('Evoked theta power (a.u.)', 'FontSize', 6);
ax = gca;
ax.XAxis.Exponent = -2;
set(gca, 'box', 'off');

% Export
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir, 'evokedThetaPow_cwt_bar_horizontal.pdf'), ...
%     'ContentType', 'vector', 'Resolution', 300);
