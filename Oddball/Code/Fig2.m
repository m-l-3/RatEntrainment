clc; 
clear;
% close all;

addpath(genpath('./Functions'))

cfgReference

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

iRat = 6;
[Before_ERP, Before_Trials, ~] = calc_ERP_forSingleRat(Before_Data,cfg,useClean, iRat);
iRat = iRat-3;
[After30_ERP, After30_Trials, time] = calc_ERP_forSingleRat(After30_Data,cfg,useClean, iRat);

%% for myself
iCh=3;

[cmap] = cbrewer('seq','OrRd',29);
ctar_before = cmap(14,:);
ctar_after30 = cmap(26,:);
cstd_before = cmap(12,:);
cstd_after30 = cmap(24,:);

figure
subplot(221)
stdshade(squeeze(Before_Trials.target(iCh,:,:))',0.4,ctar_before,time)
hold on
stdshade(squeeze(After30_Trials.target(iCh,:,:))',0.4,ctar_after30,time)
xline(0)
legend('Before', 'After30')
xlim([-300 1000])
ylim([-.5 2])
title('DEV')

subplot(222)
stdshade(squeeze(Before_Trials.std(iCh,:,:))',0.4,cstd_before,time)
hold on
stdshade(squeeze(After30_Trials.std(iCh,:,:))',0.4,cstd_after30,time)
xline(0)
legend('Before', 'After30')
xlim([-300 1000])
ylim([-.5 2])
title('STD')

subplot(223)
stdshade(squeeze(Before_Trials.target(iCh,:,:))',0.4,ctar_before,time)
hold on
stdshade(squeeze(Before_Trials.std(iCh,:,:))',0.4,cstd_before,time)
xline(0)
legend('DEV', 'STD')
xlim([-300 1000])
ylim([-.5 2])
title('Before')

subplot(224)
stdshade(squeeze(After30_Trials.target(iCh,:,:))',0.4,ctar_after30,time)
hold on
stdshade(squeeze(After30_Trials.std(iCh,:,:))',0.4,cstd_after30,time)
xline(0)
legend('DEV', 'STD')
xlim([-300 1000])
ylim([-.5 2])
title('After30')

%% erp for best representative
iCh=3;
state = "target";
[cmap] = cbrewer('seq','OrRd',29);
ctar_before = cmap(14,:);
ctar_after30 = cmap(26,:);
cstd_before = cmap(12,:);
cstd_after30 = cmap(24,:);

% Define figure dimensions in inches
figWidth = 2.5;  % Width in inches (e.g., single-column width)
figHeight = 1; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);
hold on

t_idx = time>=-300 & time<=1000;
if(state=="target")
    stdshade(squeeze(Before_Trials.target(iCh,t_idx,:))',0.4,ctar_before,time(t_idx))
    stdshade(squeeze(After30_Trials.target(iCh,t_idx,:))',0.4,ctar_after30,time(t_idx))
    my_title = "DEV";
else
    stdshade(squeeze(Before_Trials.std(iCh,t_idx,:))',0.4,cstd_before,time(t_idx))
    stdshade(squeeze(After30_Trials.std(iCh,t_idx,:))',0.4,cstd_after30,time(t_idx))
    my_title = "STD";
end
xline(0,'LineWidth', 1)
xline(200,'LineWidth', 1)
xlim([-350 1050])
ylim([-.5 2])
% ylim([-.2 .8])

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
title(my_title, 'FontName', 'Helvetica', 'FontSize', 6,'FontWeight', 'bold')

% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'ERP_',my_title,'Rat12.pdf'), 'ContentType', 'vector', 'Resolution', 300);
% exportgraphics(gcf, strcat(fig_dir,'ERP_',my_title,'all.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%% P3 over batch of trials for best representative
iRat = 6;
iCh = 3;
useClean = true;
lBatch = 40;
lBatchStep = 5;

[cmap] = cbrewer('seq','OrRd',29);
ctar_before = cmap(14,:);
ctar_after30 = cmap(26,:);
cstd_before = cmap(12,:);
cstd_after30 = cmap(24,:);

state = "target";
if(state=="target")
    c1 = ctar_before;
    c2 = ctar_after30;
    my_title = "DEV";
    legend_state = 'off';
else
    c1 = cstd_before;
    c2 = cstd_after30;
    my_title = "STD";
    legend_state = 'on';
end
sz = 5;

params.lBatch = lBatch;
params.lBatchStep = lBatchStep;
params.fs = fs;

w = 200;
% t_offset_before = [NaN 512 508 468 460 500 472 524];
% t_offset_after30 = [NaN NaN NaN 452 444 464 472 488];

t_offset_before = [NaN 500 500 500 500 500 500 500];
t_offset_after30 = [NaN NaN NaN 500 500 500 500 500];



% Define figure dimensions in inches
figWidth = 2.4;  % Width in inches (e.g., single-column width)
figHeight = 2; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);

params.t_range = [t_offset_before(iRat)-w t_offset_before(iRat)+w];
[P3amp_Before, P3lat_Before] = p3_batchPeakFinder(Before_Data,useClean,params,cfg,state,iRat);
params.t_range = [t_offset_after30(iRat)-w t_offset_after30(iRat)+w];
[P3amp_After30, P3lat_After30] = p3_batchPeakFinder(After30_Data,useClean,params,cfg,state,iRat-3);

% Sample grouped data
x = [P3lat_Before(iCh,:)'; P3lat_After30(iCh,:)'];
y = [P3amp_Before(iCh,:)'; P3amp_After30(iCh,:)'];
group = [repmat({'Before'}, length(P3lat_Before(iCh,:)), 1); repmat({'After30'}, length(P3lat_After30(iCh,:)), 1)];

% Create grouped scatter plot with marginal histograms
scatterhist(x, y, 'Group', group, 'Kernel', 'on', ...
    'Location', 'SouthWest', 'Direction', 'out', ...
    'Style', 'bar', 'legend', legend_state, ...
    'Color', [c1;c2], 'LineStyle', {'-', '-'}, ...
    'LineWidth', [1, 1], 'Marker', '.', 'MarkerSize', [sz, sz]);

if(state=="std")
    lgd = findobj(gcf, 'Type', 'Legend'); 
    % Remove the legend box
    set(lgd, 'Box', 'off');
    % Customize font and position
    set(lgd, 'FontName', 'Helvetica', 'FontSize', 6, 'Location', 'northeast');
end


% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
% xlim([t_offset_after30(iRat)-w-50 t_offset_before(iRat)+w+50])
ylim([0.001 3.8])
xlabel('Peak latency (ms)', 'FontSize', 6);
ylabel('Peak amplitude (a.u.)', 'FontSize', 6);
% title(my_title, 'FontName', 'Helvetica', 'FontSize', 6,'FontWeight', 'bold')
% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'ERP_P3_2Dscatter_',my_title,'_Rat12.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%% for P3 statistics

iCh = 3;
useClean = true;
lBatch = 40;
lBatchStep = 15;


params.lBatch = lBatch;
params.lBatchStep = lBatchStep;
params.fs = fs;

w = 200;
% t_offset_before = [NaN 512 508 468 460 500 472 524];
% t_offset_after30 = [NaN NaN NaN 452 444 464 472 488];

t_offset_before = [NaN 500 500 500 500 500 500 500];
t_offset_after30 = [NaN NaN NaN 500 500 500 500 500];

lat_before_tar = NaN(8,1);
amp_before_tar = NaN(8,1);
lat_before_std = NaN(8,1);
amp_before_std = NaN(8,1);
lat_after30_tar = NaN(8,1);
amp_after30_tar = NaN(8,1);
lat_after30_std = NaN(8,1);
amp_after30_std = NaN(8,1);

state = "target";
for iRat=1:8
    if(isnan(t_offset_before(iRat)))
        continue
    end
    params.t_range = [t_offset_before(iRat)-w t_offset_before(iRat)+w];
    [P3amp_Before, P3lat_Before] = p3_batchPeakFinder(Before_Data,useClean,params,cfg,state,iRat);
    lat_before_tar(iRat) = median(P3lat_Before(iCh,:),'omitnan');
    amp_before_tar(iRat) = median(P3amp_Before(iCh,:),'omitnan');
    
    if(isnan(t_offset_after30(iRat)))
        continue
    end
    params.t_range = [t_offset_after30(iRat)-w t_offset_after30(iRat)+w];
    [P3amp_After30, P3lat_After30] = p3_batchPeakFinder(After30_Data,useClean,params,cfg,state,iRat-3);
    lat_after30_tar(iRat) = median(P3lat_After30(iCh,:),'omitnan');
    amp_after30_tar(iRat) = median(P3amp_After30(iCh,:),'omitnan');
end

state = "std";
for iRat=1:8
    if(isnan(t_offset_before(iRat)))
        continue
    end
    params.t_range = [t_offset_before(iRat)-w t_offset_before(iRat)+w];
    [P3amp_Before, P3lat_Before] = p3_batchPeakFinder(Before_Data,useClean,params,cfg,state,iRat);
    lat_before_std(iRat) = median(P3lat_Before(iCh,:),'omitnan');
    amp_before_std(iRat) = median(P3amp_Before(iCh,:),'omitnan');
    
    if(isnan(t_offset_after30(iRat)))
        continue
    end
    params.t_range = [t_offset_after30(iRat)-w t_offset_after30(iRat)+w];
    [P3amp_After30, P3lat_After30] = p3_batchPeakFinder(After30_Data,useClean,params,cfg,state,iRat-3);
    lat_after30_std(iRat) = median(P3lat_After30(iCh,:),'omitnan');
    amp_after30_std(iRat) = median(P3amp_After30(iCh,:),'omitnan');
end

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
% y1 = amp_before_std;
% y2 = amp_before_tar;
% y3 = amp_after30_std;
% y4 = amp_after30_tar;

y1 = lat_before_std;
y2 = lat_before_tar;
y3 = lat_after30_std;
y4 = lat_after30_tar;

% Define figure dimensions in inches
figWidth = 1.4;  % Width in inches (e.g., single-column width)
figHeight = 2; % Height in inches

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
addSignificanceStar(x(1), x(2), 550, h, p, true)

[h,p] = ttest(y3, y4)
addSignificanceStar(x(3), x(4), 550, h, p, true)

[h,p] = ttest(y2, y4)
addSignificanceStar(x(2), x(4), 550, h, p, true)

[h,p] = ttest(y1, y3)
addSignificanceStar(x(1), x(3), 550, h, p, true)

% Axes and labels
xticks(x);
xticklabels({"STD","DEV","STD","DEV"});
xtickangle(45); 

% lgd = legend({"","Before","","After30"});
% 
% set(lgd, 'Box', 'off');
% % Customize font and position
% set(lgd, 'FontName', 'Helvetica', 'FontSize', 4, 'Location', 'northwest');


% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 5, 'LineWidth', 1);
xlim([min(x)-barWidth max(x)+barWidth])
ylim([350 600])
% ylabel('Peak amplitude (a.u.)', 'FontSize', 6);
ylabel('Peak latency (ms)', 'FontSize', 6);

% title(my_title, 'FontName', 'Helvetica', 'FontSize', 6,'FontWeight', 'bold')
% Remove the top and right borders
set(gca, 'box', 'off');


% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'ERP_P3Amp_bar_perRat.pdf'), 'ContentType', 'vector', 'Resolution', 300);
% exportgraphics(gcf, strcat(fig_dir,'ERP_P3Lat_bar_perRat.pdf'), 'ContentType', 'vector', 'Resolution', 300);



%%
% Sample grouped data
x = [lat_before_tar; lat_after30_tar];
y = [amp_before_tar; amp_after30_tar];
group = [repmat({'Before'}, length(lat_before_tar), 1); repmat({'After30'}, length(lat_after30_tar), 1)];

% Create grouped scatter plot with marginal histograms
scatterhist(x, y, 'Group', group, 'Kernel', 'overlay', ...
    'Location', 'SouthEast', 'Direction', 'out', ...
    'Style', 'bar', 'Legend', 'on', ...
    'Color', [c1;c2], 'LineStyle', {'-', '-'}, ...
    'LineWidth', [1, 1], 'Marker', '.', 'MarkerSize', [sz, sz]);



%% table setup
% trend over batch of trials

useClean = true;
lBatch = 40;
lBatchStep = 15;

params.t_range = [300 700];
params.lBatch = lBatch;
params.lBatchStep = lBatchStep;
params.fs = fs;

state = "std";
[P3_Before] = p3_batchPeakFinder_table(Before_Data,Before_Datasets,useClean,params,cfg,state);
[P3_After30] = p3_batchPeakFinder_table(After30_Data,After30days_Datasets,useClean,params,cfg,state);

P3_Before.Session = repmat("Before",height(P3_Before),1);
P3_After30.Session = repmat("After30",height(P3_After30),1);


P3 = cat(1, P3_Before, P3_After30);

%% P3 scatter hist for all rats 
T = P3;

T.Rat = categorical(T.Rat);
T.Session = categorical(T.Session);
T.Block = categorical(T.Block);
T.Session = reordercats(T.Session, {'Before', 'After30'});

iCh = 3;

[cmap] = cbrewer('seq','OrRd',29);
ctar_before = cmap(14,:);
ctar_after30 = cmap(26,:);
cstd_before = cmap(12,:);
cstd_after30 = cmap(24,:);

if(state=="target")
    c1 = ctar_before;
    c2 = ctar_after30;
    my_title = "DEV";
    legend_state = 'off';
else
    c1 = cstd_before;
    c2 = cstd_after30;
    my_title = "STD";
    legend_state = 'on';
end
sz = 5;

% Define figure dimensions in inches
figWidth = 2.4;  % Width in inches (e.g., single-column width)
figHeight = 2; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);


% Sample grouped data
x = T.P3Lat(:,iCh);
y = T.P3Amp(:,iCh);
group = T.Session;

% Create grouped scatter plot with marginal histograms
scatterhist(x, y, 'Group', group, 'Kernel', 'on', ...
    'Location', 'SouthWest', 'Direction', 'out', ...
    'Style', 'bar', 'Legend', legend_state, ...
    'Color', [c1;c2], 'LineStyle', {'-', '-'}, ...
    'LineWidth', [1, 1], 'Marker', '.', 'MarkerSize', [sz, sz]);


lgd = findobj(gcf, 'Type', 'Legend');

% Remove the legend box
set(lgd, 'Box', 'off');

% Customize font and position
set(lgd, 'FontName', 'Helvetica', 'FontSize', 6, 'Location', 'northeast');

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
% xlim([250 750])
ylim([-.5 3.3])
xlabel('Peak latency (ms)', 'FontSize', 6);
ylabel('Peak amplitude', 'FontSize', 6);
title(my_title, 'FontName', 'Helvetica', 'FontSize', 6,'FontWeight', 'bold')
% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
exportgraphics(gcf, strcat(fig_dir,'ERP_P3_2Dscatter_',my_title,'_allRats.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%%
















































%% compensating rats' offset

useClean = true;
bootStrap = false;

t_offset_before = [NaN NaN NaN 440 452 504 464 452];
t_offset_after30 = [420 444 464 468 420];
winLen = 400; % ms

[Before_ERP, time_before] = calc_offsetERP_perRat(Before_Data,cfg,useClean, bootStrap, t_offset_before, winLen);
[After30_ERP, time_after30] = calc_offsetERP_perRat(After30_Data,cfg,useClean, bootStrap, t_offset_after30, winLen);

%%
iCh=3;
xlim_range = [0 1000];
ylim_range = [-.2 .8];
figure
subplot(221)
stdshade(squeeze(Before_ERP.target(iCh,:,:))',0.4,'b',time_before)
hold on
stdshade(squeeze(After30_ERP.target(iCh,:,:))',0.4,'m',time_after30)
xline(0)
legend('Before', 'After30')
xlim(xlim_range)
ylim(ylim_range)
title('DEV')

subplot(222)
stdshade(squeeze(Before_ERP.std(iCh,:,:))',0.4,'b',time_before)
hold on
stdshade(squeeze(After30_ERP.std(iCh,:,:))',0.4,'m',time_after30)
xline(0)
legend('Before', 'After30')
xlim(xlim_range)
ylim(ylim_range)
title('STD')

subplot(223)
stdshade(squeeze(Before_ERP.target(iCh,:,:))',0.4,'b',time_before)
hold on
stdshade(squeeze(Before_ERP.std(iCh,:,:))',0.4,'m',time_before)
xline(0)
legend('DEV', 'STD')
xlim(xlim_range)
ylim(ylim_range)
title('Before')

subplot(224)
stdshade(squeeze(After30_ERP.target(iCh,:,:))',0.4,'b',time_after30)
hold on
stdshade(squeeze(After30_ERP.std(iCh,:,:))',0.4,'m',time_after30)
xline(0)
legend('DEV', 'STD')
xlim(xlim_range)
ylim(ylim_range)
title('After30')
