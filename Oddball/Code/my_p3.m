clc; 
clear;
% close all;

addpath(genpath('./Functions'))
addpath("D:\Documents\SUT Ph.D\Research\Matlab codes\eeglab2023.1")
addpath('D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Dataset\')
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
    'is_downsample',    0,                       ...
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
useClean = true;
bootStrap = false;

[Before_ERP, Before_Trials, ~] = calc_ERP_perAll(Before_Data, cfg, useClean, bootStrap);
% [After10_ERP, After10_Trials, ~] = calc_ERP_perAll(After10_Data, cfg, useClean, bootStrap);
% [After20_ERP, After20_Trials, ~] = calc_ERP_perAll(After20_Data, cfg, useClean, bootStrap);
[After30_ERP, After30_Trials, time] = calc_ERP_perAll(After30_Data, cfg, useClean, bootStrap);


%%
iCh = 3;
beforSum = squeeze(cumsum(Before_Trials.all(iCh,:,:),2));
after30Sum = squeeze(cumsum(After30_Trials.all(iCh,:,:),2));

[maxVal_before, maxIdx_before] = max(beforSum,[],1);
[maxVal_after30, maxIdx_after30] = max(after30Sum,[],1);

figure
scatter(time(maxIdx_before), maxVal_before);
hold on
scatter(time(maxIdx_after30), maxVal_after30);


%% over batch of trials

useClean = true;
lBatch = 30;
lBatchStep = 1;

params.t_range = [425 550];
params.lBatch = lBatch;
params.lBatchStep = lBatchStep;
params.fs = fs;
state = "target";
iRat = 4:8;

t_offset_before = [NaN NaN NaN 440 452 504 464 452];
t_offset_after30 = [420 444 464 468 420];

[P3amp_Before, P3lat_Before] = p3_batchPeakFinder(Before_Data,useClean,params,cfg,state,  iRat);
[P3amp_After30, P3lat_After30] = p3_batchPeakFinder(After30_Data,useClean,params,cfg,state, iRat-3);

%% panel A figs
% P3 scatters

iCh = 3;
[cmap] = cbrewer('seq','OrRd',20);
c1 = cmap(10,:);
c2 = cmap(end-2,:);
sz = 4;

% Define figure dimensions in inches
figWidth = 2;  % Width in inches (e.g., single-column width)
figHeight = 2; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);

s1 = scatter(P3lat_Before(iCh,:), P3amp_Before(iCh,:), sz, 'filled', 'MarkerFaceColor', c1, 'MarkerEdgeColor', 'k', 'DisplayName', 'D0');
hold on
s2 = scatter(P3lat_After30(iCh,:), P3amp_After30(iCh,:), sz, 'filled', 'MarkerFaceColor', c2, 'MarkerEdgeColor', 'k', 'DisplayName', 'D0');
s1.MarkerEdgeAlpha = 0.05;  % Edge transparency (0 = fully transparent, 1 = opaque)
s1.MarkerFaceAlpha = 0.4; 
s2.MarkerEdgeAlpha = 0.05;  % Edge transparency (0 = fully transparent, 1 = opaque)
s2.MarkerFaceAlpha = 0.4; 

hLeg = legend();

% Remove the legend box
set(hLeg, 'Box', 'off');

% Customize font and position
set(hLeg, 'FontName', 'Helvetica', 'FontSize', 6, 'Location', 'northeast');

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
xlim([params.t_range(1)-0.05 params.t_range(2)+0.05])
xlabel('Peak latency (ms)', 'FontSize', 6);
ylabel('Peak amplitude', 'FontSize', 6);

% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'ERP_P3_2Dscatter.pdf'), 'ContentType', 'vector', 'Resolution', 300);


%% panel A figs
% P3 scater+histograms

iCh = 3;
[cmap] = cbrewer('seq','OrRd',20);
c1 = cmap(10,:);
c2 = cmap(end-2,:);
sz = 10;
nBin = [50 50];

% Define figure dimensions in inches
figWidth = 4;  % Width in inches (e.g., single-column width)
figHeight = 4; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);


% Sample grouped data
x = [P3lat_Before(iCh,:)'; P3lat_After30(iCh,:)'];
y = [P3amp_Before(iCh,:)'; P3amp_After30(iCh,:)'];
group = [repmat({'D0'}, length(P3lat_Before(iCh,:)), 1); repmat({'D30'}, length(P3lat_After30(iCh,:)), 1)];

% Create grouped scatter plot with marginal histograms
scatterhist(x, y, 'Group', group, 'Kernel', 'overlay', ...
    'Location', 'SouthEast', 'Direction', 'out', ...
    'Style', 'bar', 'Legend', 'on', ...
    'Color', [c1;c2], 'LineStyle', {'-', '-'}, ...
    'LineWidth', [1, 1], 'Marker', '.', 'MarkerSize', [sz, sz]);


lgd = findobj(gcf, 'Type', 'Legend');

% Remove the legend box
set(lgd, 'Box', 'off');

% Customize font and position
set(lgd, 'FontName', 'Helvetica', 'FontSize', 6, 'Location', 'northeast');

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
xlim([params.t_range(1)-50 params.t_range(2)+50])
% ylim([-.5 2.5])
xlabel('Peak latency (ms)', 'FontSize', 6);
ylabel('Peak amplitude', 'FontSize', 6);

% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'ERP_P3_2Dscatter.pdf'), 'ContentType', 'vector', 'Resolution', 300);


%% trend over batch of trials

useClean = true;
lBatch = 60;
lBatchStep = 1;

params.t_range = [300 700];
params.lBatch = lBatch;
params.lBatchStep = lBatchStep;
params.fs = fs;

[P3amp_Before, P3lat_Before] = p3_batchPeakFinder_perSess(Before_Data,useClean,params,cfg);
% [P3amp_After10, P3lat_After10] = p3_batchPeakFinder_perSess(After10_Data,useClean,params,cfg);
% [P3amp_After20, P3lat_After20] = p3_batchPeakFinder_perSess(After20_Data,useClean,params,cfg);
[P3amp_After30, P3lat_After30] = p3_batchPeakFinder_perSess(After30_Data,useClean,params,cfg);

[P3amp_BeforeArr] = makeArray(P3amp_Before);
% [P3amp_After10Arr] = makeArray(P3amp_After10);
% [P3amp_After20Arr] = makeArray(P3amp_After20);
[P3amp_After30Arr] = makeArray(P3amp_After30);
[P3lat_BeforeArr] = makeArray(P3lat_Before);
[P3lat_After30Arr] = makeArray(P3lat_After30);

%%
iCh = 3;
iSess = 1;

figure
dataIn = P3lat_BeforeArr;
plot(squeeze(dataIn(iCh,:,:,1)))
set(gca,'ColorOrderIndex',1)
hold on
plot(squeeze(mean(dataIn(iCh,:,:,1),[3 4],'omitnan')), 'k')

plot(squeeze(dataIn(iCh,:,:,2)),'--')
plot(squeeze(mean(dataIn(iCh,:,:,2),[3 4],'omitnan')), '--k')
%%

figure
plot(squeeze(mean(P3amp_BeforeArr(iCh,:,5,4),[ 4],'omitnan')), 'b')
hold on
% plot(squeeze(mean(P3amp_After10Arr(iCh,:,:,:),[3 4],'omitnan')), 'r')
% plot(squeeze(mean(P3amp_After20Arr(iCh,:,:,:),[3 4],'omitnan')), 'g')
% plot(squeeze(mean(P3amp_After30Arr(iCh,:,:,:),[3 4],'omitnan')), 'm')

%%
figure
plot(squeeze(mean(P3amp_BeforeArr(iCh,:,:,1),[3 4],'omitnan')), 'k')
hold on
plot(squeeze(mean(P3amp_BeforeArr(iCh,:,:,2),[3 4],'omitnan')), '--k')

plot(squeeze(mean(P3amp_BeforeArr(iCh,:,:,1:2),[3 4],'omitnan')), 'r')

%% panel B figs
% trend of p3
time = 1:size(P3amp_After30Arr,2);
iCh = 3;
[cmap] = cbrewer('seq','OrRd',20);

% Define figure dimensions in inches
figWidth = 2.5;  % Width in inches (e.g., single-column width)
figHeight = 3; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);

stdshade(squeeze(reshape(P3amp_BeforeArr(iCh,:,:,[1]),length(time),[]))',0.4,cmap(10,:),time)
hold on
stdshade(squeeze(reshape(P3amp_BeforeArr(iCh,:,:,[2]),length(time),[]))',0.4,cmap(end-2,:),time)
hLeg = legend('D0', 'D30');

% Remove the legend box
set(hLeg, 'Box', 'off');

% Customize font and position
set(hLeg, 'FontName', 'Helvetica', 'FontSize', 6, 'Location', 'northeast');

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
xlabel('# Trial', 'FontSize', 6);
% xlim([-10 190])
ylabel('Peak amplitude', 'FontSize', 6);

% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'P3amp_trend.pdf'), 'ContentType', 'vector', 'Resolution', 300);


%% table setup
% trend over batch of trials

useClean = true;
lBatch = 30;
lBatchStep = 1;

params.t_range = [300 700];
params.lBatch = lBatch;
params.lBatchStep = lBatchStep;
params.fs = fs;

state = "all";
[P3_Before] = p3_batchPeakFinder_table(Before_Data,Before_Datasets,useClean,params,cfg,state);
[P3_After10] = p3_batchPeakFinder_table(After10_Data,After10days_Datasets,useClean,params,cfg,state);
[P3_After20] = p3_batchPeakFinder_table(After20_Data,After20days_Datasets,useClean,params,cfg,state);
[P3_After30] = p3_batchPeakFinder_table(After30_Data,After30days_Datasets,useClean,params,cfg,state);

P3_Before.Session = repmat("Before",height(P3_Before),1);
P3_After10.Session = repmat("After10",height(P3_After10),1);
P3_After20.Session = repmat("After20",height(P3_After20),1);
P3_After30.Session = repmat("After30",height(P3_After30),1);

% P3amp = cat(1, P3amp_Before, P3amp_After30);
P3 = cat(1, P3_Before, P3_After10, P3_After20, P3_After30);

%%
T = P3;
T.ResponseCh = T.P3Amp(:, iCh);
% T.ResponseCh = T.P3Lat(:, iCh);


iCh = 3;

T.Rat = categorical(T.Rat);
T.Session = categorical(T.Session);
T.Block = categorical(T.Block);
T.Session = reordercats(T.Session, {'Before', 'After10', 'After20', 'After30'});

% filtering
% T = T(T.Block == 'Block1' | T.Block == 'Block2', :);
% T = T(T.Rat ~= 'Rat5' , :);

% T = rmmissing(T, 'DataVariables', {'ResponseCh'});

%%
lme = fitlme(T, ...
    'ResponseCh ~ Session + (1|Rat) + (1|Rat:Session) + (1|Rat:Session:Block)');


% Display results
disp(lme);
