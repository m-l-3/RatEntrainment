

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
After10_Data  = load(strcat(save_dir, 'After10days_Data', dataName, '.mat')).After10days_Data;
After20_Data  = load(strcat(save_dir, 'After20days_Data', dataName, '.mat')).After20days_Data;
After30_Data  = load(strcat(save_dir, 'After30days_Data', dataName, '.mat')).After30days_Data;

% *********************************************
% *************** cfg correction **************
% *********************************************
cfgCorrection


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
[~,~,After10_Spec] = calc_specgram(After10_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP,correctPow);
[~,~,After20_Spec] = calc_specgram(After20_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP,correctPow);
[~,~,After30_Spec] = calc_specgram(After30_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP,correctPow);
[BeforeTar_SpecArr] = makeArray(Before_Spec);
[After10Tar_SpecArr] = makeArray(After10_Spec);
[After20Tar_SpecArr] = makeArray(After20_Spec);
After20Tar_SpecArr(:,:,:,3:8,:) = After20Tar_SpecArr;
After20Tar_SpecArr(:,:,:,1:2,:) = nan;
[After30Tar_SpecArr] = makeArray(After30_Spec);
After30Tar_SpecArr(:,:,:,4:8,:) = After30Tar_SpecArr;
After30Tar_SpecArr(:,:,:,1:3,:) = nan;

iTarStd = 2; % 1:All, 2:Std, 3:Target
[~,~,Before_Spec] = calc_specgram(Before_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP,correctPow);
[~,~,After10_Spec] = calc_specgram(After10_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP,correctPow);
[~,~,After20_Spec] = calc_specgram(After20_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP,correctPow);
[t,f,After30_Spec] = calc_specgram(After30_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP,correctPow);
[BeforeStd_SpecArr] = makeArray(Before_Spec);
[After10Std_SpecArr] = makeArray(After10_Spec);
[After20Std_SpecArr] = makeArray(After20_Spec);
After20Std_SpecArr(:,:,:,3:8,:) = After20Std_SpecArr;
After20Std_SpecArr(:,:,:,1:2,:) = nan;
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


%% time-frequency representation of ERP
fRange = [2 13];
iSess = 1;
iRat = 1:8;
c_max = 4e-2;
f_sel = f>=fRange(1) & f<=fRange(2);

tTrim = time>=-300 & time<=1000;

[tTrim_mesh,f_mesh] = meshgrid(time(tTrim), f(f_sel));

% Define figure dimensions in inches
figWidth = 5;  % Width in inches (e.g., single-column width)
figHeight = 2; % Height in inches
ch_names = ["CA1", "LP", "DS", "mPFC"];
for iCh=1:4
    % Create figure with specified size
    figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);
    
    % Define the number of rows and columns
    rows = 2;
    cols = 4;
    
    % Create a tiled layout with no padding or spacing
    t = tiledlayout(rows, cols, 'TileSpacing', 'compact', 'Padding', 'compact');
    
    ax(1) = nexttile;
    img = squeeze(mean(BeforeStd_SpecArr(tTrim,f_sel,iCh,iRat,iSess), [4 5],'omitnan'));
    pcolor(tTrim_mesh,f_mesh,img'); shading interp; colormap jet
    xline(0,'LineWidth',1.5)
    clim([0 c_max])
    title("Before");
    ylabel("STD", 'FontSize', 6, 'FontWeight','bold')

    ax(2) = nexttile;
    img = squeeze(mean(After10Std_SpecArr(tTrim,f_sel,iCh,iRat,iSess), [4 5],'omitnan'));
    pcolor(tTrim_mesh,f_mesh,img'); shading interp; colormap jet
    xline(0,'LineWidth',1.5)
    clim([0 c_max])
    title("After10");

    ax(3) = nexttile;
    img = squeeze(mean(After20Std_SpecArr(tTrim,f_sel,iCh,iRat,iSess), [4 5],'omitnan'));
    pcolor(tTrim_mesh,f_mesh,img'); shading interp; colormap jet
    xline(0,'LineWidth',1.5)
    clim([0 c_max])
    title("After20");

    ax(4) = nexttile;
    img = squeeze(mean(After30Std_SpecArr(tTrim,f_sel,iCh,iRat,iSess), [4 5],'omitnan'));
    pcolor(tTrim_mesh,f_mesh,img'); shading interp; colormap jet
    xline(0,'LineWidth',1.5)
    clim([0 c_max])
    title("After30");

    ax(5) = nexttile;
    img = squeeze(mean(BeforeTar_SpecArr(tTrim,f_sel,iCh,iRat,iSess), [4 5],'omitnan'));
    pcolor(tTrim_mesh,f_mesh,img'); shading interp; colormap jet
    xline(0,'LineWidth',1.5)
    clim([0 c_max])
    ylabel("DEV", 'FontSize', 6, 'FontWeight','bold')

    ax(6) = nexttile;
    img = squeeze(mean(After10Tar_SpecArr(tTrim,f_sel,iCh,iRat,iSess), [4 5],'omitnan'));
    pcolor(tTrim_mesh,f_mesh,img'); shading interp; colormap jet
    xline(0,'LineWidth',1.5)
    clim([0 c_max])

    ax(7) = nexttile;
    img = squeeze(mean(After20Tar_SpecArr(tTrim,f_sel,iCh,iRat,iSess), [4 5],'omitnan'));
    pcolor(tTrim_mesh,f_mesh,img'); shading interp; colormap jet
    xline(0,'LineWidth',1.5)
    clim([0 c_max])

    ax(8) = nexttile;
    img = squeeze(mean(After30Tar_SpecArr(tTrim,f_sel,iCh,iRat,iSess), [4 5],'omitnan'));
    pcolor(tTrim_mesh,f_mesh,img'); shading interp; colormap jet
    xline(0,'LineWidth',1.5)
    clim([0 c_max])

    
    % % assign color bar to one tile 
    % cb = colorbar(); 
    % % To position the colorbar as a global colorbar representing
    % % all tiles, 
    % cb.Layout.Tile = 'east';
    % cb.Label.String = '\DeltaPAC (observed - surrogate)';
    % cb.FontSize = 6;
    
    xlabel(t, 'Time (ms)', 'FontSize', 6);
    ylabel(t, 'Frequency (Hz)', 'FontSize', 6);

    sgtitle(ch_names(iCh), 'FontSize', 6, 'FontWeight','bold')
    
    % Set font size for all axes in the current figure
    set(findall(gcf, 'Type', 'axes'), 'FontSize', 6);
    
    
    % Tight layout to minimize white space
    set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));
    
    % Export figure as a vector-based PDF with high resolution
    fig_dir = fullfile("../Figures","evokedCwt_timeFreq_"+ch_names(iCh)+".pdf");
%     exportgraphics(gcf, fig_dir, 'ContentType', 'vector', 'Resolution', 300);
end

%% fig colorbar
% Create a new figure with specified size (in inches)
figure('Units', 'inches', 'Position', [1, 1, 3, 0.5]);  % wider since horizontal

% Create an invisible axes
ax = axes('Position', [0.1, 0.6, 0.8, 0.3], 'Visible', 'off');

% Set the colormap and color limits
colormap(jet);       % You can choose any colormap you prefer
caxis([0, c_max]);   % Set the color axis limits

% Add a horizontal colorbar
cb = colorbar('southoutside');  % <-- horizontal orientation
cb.Position = [0.2, 0.6, 0.6, 0.2];  % [left, bottom, width, height]

% Customize the colorbar title
cb.Label.String = 'Evoked spectral power (a.u.)';
cb.Label.FontSize = 6;
cb.Label.FontWeight = 'bold';
cb.Label.Rotation = 0;  % keep horizontal
cb.Label.HorizontalAlignment = 'center';
cb.Label.VerticalAlignment = 'top';  % place label above bar

% (Optional) Custom tick labels
% cb.Ticks = linspace(0, c_max, 5);
% cb.TickLabels = {'Low', '0.25', '0.5', '0.75', 'High'};

% Export as vector PDF
fig_dir = fullfile("../Figures",'evokedCwt_timeFreq_colorbar.pdf');
% exportgraphics(gcf, fig_dir, 'ContentType', 'vector', 'Resolution', 300);


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

