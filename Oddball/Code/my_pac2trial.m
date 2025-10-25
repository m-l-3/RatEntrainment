clc; 
clear;

addpath(genpath('./Functions'))

% path_res = ("D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Results\"); 
path_res = ("H:\rat_mojtaba\Results\"); 

cfgReference


%% load pacs (trial)

useSingle = true;
path = path_res + "PAC_trialSwap\";
[PAC_Before, tout, famp_out, fph_out] = pacLoader(Before_Datasets,path,"Before",useSingle);
[PAC_After30, tout, famp_out, fph_out] = pacLoader(After30days_Datasets,path,"After30",useSingle);

temp = {};
temp{1,1}=PAC_Before{6,1}{1,3};
temp{1,2}=PAC_Before{6,1}{1,4};
PAC_Before{6,1} = [];
PAC_Before{6,1} = temp;

%%
save_dir = '../Results/Signals/sigZscr_eeglab_trZscore_0.1-300Hz-1.5-2epoch/';

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

params.lBatch = 40;
params.lBatchStep = 15;

params.famp_out = famp_out;
params.fph_out = fph_out;
params.fph_range = [6 10];
params.famp_range = [30 50];
params.tout = tout;
params.t_range = [0 1];

ch1= 3;
ch2 =3;
state = "all";
PacBand_Before = NaN(8,1);
figure
for iRat=1:8
    [pac_band_before] = pac_band_batchAvg(PAC_Before,Before_Data,useClean,params,state,iRat);
    PacBand_Before(iRat) = median(pac_band_before(ch1,ch2,:),3,'omitnan');
    plot(squeeze(pac_band_before(ch1,ch2,:)))
    hold on
end

PacBand_After30= NaN(8,1);
figure
for iRat=4:8
    [pac_band_after30] = pac_band_batchAvg(PAC_After30,After30_Data,useClean,params,state,iRat-3);
    PacBand_After30(iRat) = median(pac_band_after30(ch1,ch2,:),3,'omitnan');
    plot(squeeze(pac_band_after30(ch1,ch2,:)))
    hold on
end

%% bar plot
[cmap] = cbrewer('seq','OrRd',29);
c_before = cmap(14,:);
c_after30 = cmap(26,:);

y1 = PacBand_Before;
y2 = PacBand_After30;
x = [1 2];
barWidth = 1;

% Define figure dimensions in inches
figWidth = 1.4;  % Width in inches (e.g., single-column width)
figHeight = 2; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);
hold on

barWidth = barWidth*0.9;
bar(x(1), nanmean(y1), barWidth, 'FaceColor', c_before, 'EdgeColor', c_before);
bar(x(2), nanmean(y2), barWidth, 'FaceColor', c_after30, 'EdgeColor', c_after30);

errorbar(x(1), nanmean(y1), nanstd(y1) / sqrt(sum(~isnan(y1))), 'k', 'LineWidth', 1, 'CapSize', 3);
errorbar(x(2), nanmean(y2), nanstd(y2) / sqrt(sum(~isnan(y2))), 'k', 'LineWidth', 1, 'CapSize', 3);

markers = ['x','o','s','d','^','v','>','<','p','h','+','*']; % enough for 12 rats

barWidth = barWidth*.8;
markerSize = 5;
lw = 0.5;
for i=1:8
    x_sample = linspace(x(1)-barWidth/2,x(1)+barWidth/2,numel(y1));
    plot(x_sample(i), ...
        y1(i), markers(i), 'Color', 'k', 'MarkerFaceColor', c_before,'MarkerSize', markerSize, 'LineWidth', lw);
    x_sample = linspace(x(2)-barWidth/2,x(2)+barWidth/2,numel(y2));
    plot(x_sample(i), ...
        y2(i), markers(i), 'Color', 'k', 'MarkerFaceColor', c_after30,'MarkerSize', markerSize, 'LineWidth', lw);
end

[h,p] = ttest(y1, y2)
% addSignificanceStar(x(1), x(2), 550, h, p, true)


% Axes and labels
xticks(x);
xticklabels({"Before","After30"});
xtickangle(45); 

% lgd = legend({"","Before","","After30"});
% 
% set(lgd, 'Box', 'off');
% % Customize font and position
% set(lgd, 'FontName', 'Helvetica', 'FontSize', 4, 'Location', 'northwest');


% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 5, 'LineWidth', 1);
xlim([min(x)-barWidth max(x)+barWidth])
% ylim([350 600])
% ylabel('Peak amplitude (a.u.)', 'FontSize', 6);
ylabel('PAC', 'FontSize', 6);

% title(my_title, 'FontName', 'Helvetica', 'FontSize', 6,'FontWeight', 'bold')
% Remove the top and right borders
set(gca, 'box', 'off');


% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'ERP_P3Amp_bar_perRat.pdf'), 'ContentType', 'vector', 'Resolution', 300);
% exportgraphics(gcf, strcat(fig_dir,'ERP_P3Lat_bar_perRat.pdf'), 'ContentType', 'vector', 'Resolution', 300);
