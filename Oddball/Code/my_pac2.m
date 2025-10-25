clc; 
clear;

addpath(genpath('./Functions'))

path_res = ("D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Results\"); 
% path_res = ("H:\rat_mojtaba\Results\"); 

cfgReference

%% load pacs (mean of trial)

save_dir = '../Results/PAC_general/';
% save_dir = '../Results/PAC_trialSwap/';
% save_dir = '../Results/PAC_restTimeSwap/';

load(strcat(save_dir, 'Before/', 'pyPACcomo_Before_allCh_allWin_meanTrial_perRatSess', '.mat'));
% load(strcat(save_dir, 'After10/', 'pyPACcomo_After10_allCh_allWin_meanTrial_perRatSess', '.mat'));
% load(strcat(save_dir, 'After20/', 'pyPACcomo_After20_allCh_allWin_meanTrial_perRatSess', '.mat'));
load(strcat(save_dir, 'After30/', 'pyPACcomo_After30_allCh_allWin_meanTrial_perRatSess', '.mat'));


%% load pacs (trial)

useSingle = true;
path = path_res + "PAC_general\";
[PAC_Before, time_pac, famp_out, fph_out] = pacLoader(Before_Datasets,path,"Before",useSingle);
[PAC_After30, time_pac, famp_out, fph_out] = pacLoader(After30days_Datasets,path,"After30",useSingle);

%%
% *********************************************
% *************** cfg correction **************
% *********************************************
% cfgCorrection
temp = cell(1,2);
for i=1:5
    temp{i,1}=PAC_Before{6,1}{i,3};
    temp{i,2}=PAC_Before{6,1}{i,4};
end
PAC_Before{6,1} = [];
PAC_Before{6,1} = temp;

%% make array for each all/std/target/changed/unChanged
before_pac_rat = cell(5,1);
% after10_pac_rat = cell(5,1);
% after20_pac_rat = cell(5,1);
after30_pac_rat = cell(5,1);

for i=1:5
    before_pac_rat{i,1} = makeArray(PAC_Before,i);
%     after10_pac_rat{i,1} = makeArray(PAC_After10,i);
%     after20_pac_rat{i,1} = makeArray(PAC_After20,i);
    after30_pac_rat{i,1} = makeArray(PAC_After30,i);
end

size_element = size(PAC_After30{1,1}{1,1});
temp = NaN(cat(2, size_element, 1, 4));

% after20_pac_rat{1,1} = cat(6,temp,temp,after20_pac_rat{1,1});
% after20_pac_rat{2,1} = cat(6,temp,temp,after20_pac_rat{2,1});
% after20_pac_rat{3,1} = cat(6,temp,temp,after20_pac_rat{3,1});
% after20_pac_rat{4,1} = cat(6,temp,temp,after20_pac_rat{4,1});
% after20_pac_rat{5,1} = cat(6,temp,temp,after20_pac_rat{5,1});

after30_pac_rat{1,1} = cat(6,temp,temp,temp,after30_pac_rat{1,1});
after30_pac_rat{2,1} = cat(6,temp,temp,temp,after30_pac_rat{2,1});
after30_pac_rat{3,1} = cat(6,temp,temp,temp,after30_pac_rat{3,1});
after30_pac_rat{4,1} = cat(6,temp,temp,temp,after30_pac_rat{4,1});
after30_pac_rat{5,1} = cat(6,temp,temp,temp,after30_pac_rat{5,1});


%% fig panelA
% grand average with baseline removal 2D comodulogram
%('All','Std.','Target','changed', 'unChanged')
baselineNormalize = true;
c_max_norm = 2.5e-3;
c_max_nonNorm = 2e-2;
ch1 = 3;
ch2 = 3;
fph_range = [4 12];
famp_range = [16 90];

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

[fph_mesh,famp_mesh] = meshgrid(fph_out(fph_idx), famp_out(famp_idx));
tb = tout>=-0.3 & tout<=-0;
% ti= tout>=.1 & tout<=0.8;
ti = false(size(tout)); ti(19)=1;% ti(24)=1; ti(29)=1;
iRat = 1:8;
iBlock = 1;

% Define figure dimensions in inches
figWidth = 2.2;  % Width in inches (e.g., single-column width)
figHeight = 2.8; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);

% Define the number of rows and columns
rows = 2;
cols = 2;

% Create a tiled layout with no padding or spacing
t = tiledlayout(rows, cols, 'TileSpacing', 'compact', 'Padding', 'compact');

iState = 3;
if(baselineNormalize)
    before_pac_rat_bn = before_pac_rat{iState,1} - mean(before_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
    after30_pac_rat_bn = after30_pac_rat{iState,1} - mean(after30_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
    c_max = c_max_norm;
else
    before_pac_rat_bn = before_pac_rat{iState,1};
    after30_pac_rat_bn = after30_pac_rat{iState,1};
    c_max = c_max_nonNorm;
end

ax(1) = nexttile;

img = squeeze(mean(before_pac_rat_bn(ch1,ch2,ti,famp_idx,fph_idx,iRat,iBlock),[3 6 7], 'omitnan'));
pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
clim([0 c_max])
title('Before', 'FontSize', 6);
ylabel('DEV', 'FontSize', 6);

ax(2) = nexttile;

img = squeeze(mean(after30_pac_rat_bn(ch1,ch2,ti,famp_idx,fph_idx,iRat,iBlock),[3 6 7], 'omitnan'));
pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
clim([0 c_max])
title('After30', 'FontSize', 6);

iState = 2;
if(baselineNormalize)
    before_pac_rat_bn = before_pac_rat{iState,1} - mean(before_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
    after30_pac_rat_bn = after30_pac_rat{iState,1} - mean(after30_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
    c_max = c_max_norm;
else
    before_pac_rat_bn = before_pac_rat{iState,1};
    after30_pac_rat_bn = after30_pac_rat{iState,1};
    c_max = c_max_nonNorm;
end

ax(3) = nexttile;

img = squeeze(mean(before_pac_rat_bn(ch1,ch2,ti,famp_idx,fph_idx,iRat,iBlock),[3 6 7], 'omitnan'));
pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
clim([0 c_max])
ylabel('STD', 'FontSize', 6);

ax(4) = nexttile;

img = squeeze(mean(after30_pac_rat_bn(ch1,ch2,ti,famp_idx,fph_idx,iRat,iBlock),[3 6 7], 'omitnan'));
pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
clim([0 c_max])

% Set colormap and color limits for all subplots
% set(ax, 'Colormap', jet, 'CLim', [-20 20])
% assign color bar to one tile 
% cbh = colorbar(ax(end)); 
% To position the colorbar as a global colorbar representing
% all tiles, 
% cbh.Layout.Tile = 'east';
% cbh.Label.String = 'Normalized PAC';
% cbh.FontSize = 6;

xlabel(t, 'Phase frequency (Hz)', 'FontSize', 6);
ylabel(t, 'Amplitude frequency (Hz)', 'FontSize', 6);

% Set font size for all axes in the current figure
set(findall(gcf, 'Type', 'axes'), 'FontSize', 6);

sgtitle(string(round(tout(ti)*1000))+" ms",'FontSize', 8, 'FontWeight', 'bold')

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'PACcomo_general_tarStd_beforAfter30_t29.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%% fig panelA colorbar
% Create a new figure with specified size (in pixels)
figure('Units', 'inches', 'Position', [1, 1, 0.5, 2]);

% Create an invisible axes
ax = axes('Position', [0.3, 0.1, 0.4, 0.8], 'Visible', 'off');

% Set the colormap and color limits
colormap(jet);       % You can choose any colormap you prefer
caxis([0, 2.5]*1e-3);      % Set the color axis limits

% Add the colorbar
cb = colorbar('Position', [0.3, 0.1, 0.1, 0.7]);  % [left, bottom, width, height]

% Customize the colorbar title
cb.Label.String = 'Normalized PAC';
cb.Label.FontSize = 6;
cb.Label.FontWeight = 'bold';
cb.Label.Rotation = 90;  % Rotate label if desired

% Customize tick labels (optional)
% cb.Ticks = linspace(-1, 1, 5);  % Set tick positions
% cb.TickLabels = {'Low', '-0.5', '0', '0.5', 'High'};  % Set custom labels

fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'PACcomo_general_colorbar.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%% fig panelA
% grand average 1D in time
baselineNormalize = true;
iState = 1; %('All','Std.','Target','changed', 'unChanged')
ch1 = 3;
ch2 = 3;
fph_range = [5 7];
famp_range = [20 40];
smooth = 0;
iRat = 1:8;
iSess = 1; % session 1 has the best effect compared to all

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;

tb = tout>=-0.3 & tout<=-0;
tTrim = tout>=-0.3 & tout<=1;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

[fph_mesh,famp_mesh] = meshgrid(fph_out(fph_idx), famp_out(famp_idx));

if (baselineNormalize)
    before_pac_rat_bn = before_pac_rat{iState,1} - mean(before_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
    after30_pac_rat_bn = after30_pac_rat{iState,1} - mean(after30_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
else
    before_pac_rat_bn = before_pac_rat{iState,1};
    after30_pac_rat_bn = after30_pac_rat{iState,1};
end

befor_trend = squeeze(mean(before_pac_rat_bn(ch1,ch2,tTrim,famp_idx,fph_idx,iRat,:),[4 5], 'omitnan'));
after30_trend = squeeze(mean(after30_pac_rat_bn(ch1,ch2,tTrim,famp_idx,fph_idx,iRat,:),[4 5], 'omitnan'));

[cmap] = cbrewer('seq','OrRd',20);
fontSize = 6;
lw = 1.5;
% Define figure dimensions in inches
figWidth = 4;  % Width in inches (e.g., single-column width)
figHeight = 2; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);

stdshade(reshape(befor_trend,length(befor_trend),[])', 0.4, cmap(10,:), tout(tTrim)*1000, smooth)
hold on
stdshade(reshape(after30_trend,length(after30_trend),[])', 0.4, cmap(end-2,:), tout(tTrim)*1000, smooth)
xline(0,'LineWidth', lw)
xlim([-350 1050])
hLeg = legend('Before', 'After30');

% title('\phi_{[6-10]} Amp_{[30-60]}', 'FontSize', fs);

% Remove the legend box
set(hLeg, 'Box', 'off');

% Customize font and position
set(hLeg, 'FontName', 'Helvetica', 'FontSize', fontSize, 'Location', 'northeast');

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', fontSize, 'LineWidth', lw);
xlabel('Time (ms)', 'FontSize', fontSize);

ylabel('Normalized PAC', 'FontSize', fontSize);

ax = findall(gcf, 'Type', 'axes');  % Find all axes in the current figure
set(ax, 'LineWidth', lw);            % Set axis line width to 2 points

% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'PACgeneral_trend.pdf'), 'ContentType', 'vector', 'Resolution', 300);


%% representing before/after for each target/std
% grand average 1D in time, shade on rat

state = "target";
baselineNormalize = true;
ch1 = 3;
ch2 = 3;
fph_range = [4 8];
famp_range = [20 40];
smooth = 0;
iRat = 1:8;
iBlock = 1:4;

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;

tb = tout>=-0.2 & tout<=0;
tTrim = tout>=-0.1 & tout<=1;
ti = find(tout(tTrim)>=0.2,1);

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);


if (baselineNormalize)
    iState = 3; %('All','Std.','Target','changed', 'unChanged')
    before_pac_tar_bn = before_pac_rat{iState,1} - mean(before_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
    after30_pac_tar_bn = after30_pac_rat{iState,1} - mean(after30_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
    iState = 2; %('All','Std.','Target','changed', 'unChanged')
    before_pac_std_bn = before_pac_rat{iState,1} - mean(before_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
    after30_pac_std_bn = after30_pac_rat{iState,1} - mean(after30_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
else
    iState = 3; %('All','Std.','Target','changed', 'unChanged')
    before_pac_tar_bn = before_pac_rat{iState,1};
    after30_pac_tar_bn = after30_pac_rat{iState,1};
    iState = 2; %('All','Std.','Target','changed', 'unChanged')
    before_pac_tar_bn = before_pac_rat{iState,1};
    after30_pac_tar_bn = after30_pac_rat{iState,1};
end

before_tar_trend = squeeze(mean(before_pac_tar_bn(ch1,ch2,tTrim,famp_idx,fph_idx,iRat,iBlock),[4 5 7], 'omitnan'));
after30_tar_trend = squeeze(mean(after30_pac_tar_bn(ch1,ch2,tTrim,famp_idx,fph_idx,iRat,iBlock),[4 5 7], 'omitnan'));

before_std_trend = squeeze(mean(before_pac_std_bn(ch1,ch2,tTrim,famp_idx,fph_idx,iRat,iBlock),[4 5 7], 'omitnan'));
after30_std_trend = squeeze(mean(after30_pac_std_bn(ch1,ch2,tTrim,famp_idx,fph_idx,iRat,iBlock),[4 5 7], 'omitnan'));


[cmap] = cbrewer('seq','OrRd',29);
ctar_before = cmap(14,:);
ctar_after30 = cmap(26,:);
cstd_before = cmap(12,:);
cstd_after30 = cmap(24,:);

tout_trim = tout(tTrim)*1000;
fontSize = 6;
lw = 1.5;
% Define figure dimensions in inches
figWidth = 2.5;  % Width in inches (e.g., single-column width)
figHeight = 1; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);
hold on

if(state=="target")
    stdshade(reshape(before_tar_trend,length(before_tar_trend),[])', 0.4, ctar_before, tout_trim, smooth)
    stdshade(reshape(after30_tar_trend,length(after30_tar_trend),[])', 0.4, ctar_after30, tout_trim, smooth)
    mytitle = "DEV";
%     [h,p] = ttest(mean(before_tar_trend(ti-1:ti+1,:)), mean(after30_tar_trend(ti-1:ti+1,:)))
    [h,p] = ttest(before_tar_trend(ti,:), after30_tar_trend(ti,:))
else
    stdshade(reshape(before_std_trend,length(before_std_trend),[])', 0.4, cstd_before, tout_trim, smooth)
    stdshade(reshape(after30_std_trend,length(after30_std_trend),[])', 0.4, cstd_after30, tout_trim, smooth)
    mytitle = "STD";
    [h,p] = ttest(before_std_trend(ti,:), after30_std_trend(ti,:))
end
xline(0,'LineWidth', lw)
xlim([min(tout(tTrim))*1000-50 max(tout(tTrim))*1000+50])
ylim([-0.0020    0.0025]);
yl = ylim;

hLine = line([200 200], yl, 'LineWidth', lw, 'Color', [0.5 0.5 0.5], 'LineStyle', '-.');
uistack(hLine, 'bottom');  % push behind other plots
text(180, 2.5e-3, '*','FontSize',14,'FontWeight', 'bold')

title(sprintf("Theta to low-gamma\n"+mytitle), 'FontSize', fontSize);

% hLeg = legend('Before', 'After30');
% % Remove the legend box
% set(hLeg, 'Box', 'off');
% hLeg.ItemTokenSize = [10 10];
% % Customize font and position
% set(hLeg, 'FontName', 'Helvetica', 'FontSize', fontSize, 'Location', 'north');

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', fontSize, 'LineWidth', lw);
xlabel('Time (ms)', 'FontSize', fontSize);

ylabel('Normalized PAC', 'FontSize', fontSize);

ax = findall(gcf, 'Type', 'axes');  % Find all axes in the current figure
set(ax, 'LineWidth', lw);            % Set axis line width to 2 points

% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'PACgeneral_trend_std.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%% target/std encoding the theta to high-gamma
% grand average 1D in time, shade on rat

baselineNormalize = true;
ch1 = 3;
ch2 = 3;
fph_range = [5 7];
famp_range = [60 80];
smooth = 0;
iRat = 1:8;
iBlock = 1:4;

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;

tb = tout>=-0.29 & tout<=-0;
tTrim = tout>=-0.2 & tout<=1;
ti = find(tout(tTrim)>=0.2,1);

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

[fph_mesh,famp_mesh] = meshgrid(fph_out(fph_idx), famp_out(famp_idx));

if (baselineNormalize)
    iState = 3; %('All','Std.','Target','changed', 'unChanged')
    before_pac_tar_bn = before_pac_rat{iState,1} - mean(before_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
    after30_pac_tar_bn = after30_pac_rat{iState,1} - mean(after30_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
    iState = 2; %('All','Std.','Target','changed', 'unChanged')
    before_pac_std_bn = before_pac_rat{iState,1} - mean(before_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
    after30_pac_std_bn = after30_pac_rat{iState,1} - mean(after30_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
else
    iState = 3; %('All','Std.','Target','changed', 'unChanged')
    before_pac_tar_bn = before_pac_rat{iState,1};
    after30_pac_tar_bn = after30_pac_rat{iState,1};
    iState = 2; %('All','Std.','Target','changed', 'unChanged')
    before_pac_tar_bn = before_pac_rat{iState,1};
    after30_pac_tar_bn = after30_pac_rat{iState,1};
end

before_tar_trend = squeeze(mean(before_pac_tar_bn(ch1,ch2,tTrim,famp_idx,fph_idx,iRat,iBlock),[4 5 7], 'omitnan'));
after30_tar_trend = squeeze(mean(after30_pac_tar_bn(ch1,ch2,tTrim,famp_idx,fph_idx,iRat,iBlock),[4 5 7], 'omitnan'));

% before_std_trend = squeeze(mean(before_pac_std_bn(ch1,ch2,tTrim,famp_idx,fph_idx,iRat,iBlock),[4 5 7], 'omitnan'));
% after30_std_trend = squeeze(mean(after30_pac_std_bn(ch1,ch2,tTrim,famp_idx,fph_idx,iRat,iBlock),[4 5 7], 'omitnan'));


[cmap] = cbrewer('seq','OrRd',29);
ctar_before = cmap(14,:);
ctar_after30 = cmap(26,:);
cstd_before = cmap(12,:);
cstd_after30 = cmap(24,:);

fontSize = 6;
lw = 1.5;
% Define figure dimensions in inches
figWidth = 2.5;  % Width in inches (e.g., single-column width)
figHeight = 1; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);
hold on

stdshade(reshape(before_tar_trend,length(before_tar_trend),[])', 0.4, ctar_before, tout(tTrim)*1000, smooth)
stdshade(reshape(after30_tar_trend,length(after30_tar_trend),[])', 0.4, ctar_after30, tout(tTrim)*1000, smooth)
mytitle = "DEV";
    
% stdshade(reshape(after30_std_trend,length(after30_std_trend),[])', 0.4, cstd_after30, tout(tTrim)*1000, smooth)
% stdshade(reshape(after30_tar_trend,length(after30_tar_trend),[])', 0.4, ctar_after30, tout(tTrim)*1000, smooth)

xline(0,'LineWidth', lw)
xlim([min(tout(tTrim))*1000-50 max(tout(tTrim))*1000+50])
ylim([-0.0020    0.0025]);
yl = ylim;

% [h,p] = ttest(before_tar_trend(ti,:), after30_tar_trend(ti,:))
[h,p] = ttest(mean(before_tar_trend(ti-1:ti+1,:)), mean(after30_tar_trend(ti-1:ti+1,:)))

hLine = line([200 200], yl, 'LineWidth', lw, 'Color', [0.5 0.5 0.5], 'LineStyle', '-.');
uistack(hLine, 'bottom');  % push behind other plots
text(180, 2.5e-3, '*','FontSize',14,'FontWeight', 'bold')

title(sprintf("Theta to high-gamma\n"+mytitle), 'FontSize', fontSize);

% hLeg = legend('Before', 'After30');
% % Remove the legend box
% set(hLeg, 'Box', 'off');
% hLeg.ItemTokenSize = [10 10];
% % Customize font and position
% set(hLeg, 'FontName', 'Helvetica', 'FontSize', fontSize, 'Location', 'north');

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', fontSize, 'LineWidth', lw);
xlabel('Time (ms)', 'FontSize', fontSize);

ylabel('Normalized PAC', 'FontSize', fontSize);

ax = findall(gcf, 'Type', 'axes');  % Find all axes in the current figure
set(ax, 'LineWidth', lw);            % Set axis line width to 2 points

% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'PACgeneral_trend_dev_highGamma.pdf'), 'ContentType', 'vector', 'Resolution', 300);


%% fig PanelB
% grand average without baseline removal 2D comodulogram
%('All','Std.','Target','changed', 'unChanged')
ch1 = 3;
ch2 = 3;
fph_range = [4 12];
famp_range = [16 90];
c_max = 2e-3;

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

[fph_mesh,famp_mesh] = meshgrid(fph_out(fph_idx), famp_out(famp_idx));
tb = tout>=-0.7 & tout<=-0;
ti= tout<=0.3 | tout>=0.9;
% ti= tout>=0;
iRat = 1:8;
iSess = 1:4;

% Define figure dimensions in inches
figWidth = 4;  % Width in inches (e.g., single-column width)
figHeight = 3; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);

% Define the number of rows and columns
rows = 2;
cols = 2;

% Create a tiled layout with no padding or spacing
t = tiledlayout(rows, cols, 'TileSpacing', 'compact', 'Padding', 'compact');

iState = 3;
ax(1) = nexttile;

img = squeeze(mean(before_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,iRat,iSess),[3 6 7], 'omitnan'));

pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
clim([0 c_max])
title('Before', 'FontSize', 6);
ylabel('DEV', 'FontSize', 6);

ax(2) = nexttile;

img = squeeze(mean(after30_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,iRat,iSess),[3 6 7], 'omitnan'));
    

pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
clim([0 c_max])
title('After30', 'FontSize', 6);

iState = 2;
ax(3) = nexttile;

img = squeeze(mean(before_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,iRat,iSess),[3 6 7], 'omitnan'));

pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
clim([0 c_max])
ylabel('STD', 'FontSize', 6);

ax(4) = nexttile;

img = squeeze(mean(after30_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,iRat,iSess),[3 6 7], 'omitnan'));

pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
clim([0 c_max])

% Set colormap and color limits for all subplots
% set(ax, 'Colormap', jet, 'CLim', [-20 20])
% assign color bar to one tile 
cbh = colorbar(ax(end)); 
% To position the colorbar as a global colorbar representing
% all tiles, 
cbh.Layout.Tile = 'east';
cbh.Label.String = 'PAC';
cbh.FontSize = 6;

xlabel(t, 'Phase frequency (Hz)', 'FontSize', 6);
ylabel(t, 'Amplitude frequency (Hz)', 'FontSize', 6);

% Set font size for all axes in the current figure
set(findall(gcf, 'Type', 'axes'), 'FontSize', 6);


% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'PACcomo_trialSwap_tarStd_beforAfter30.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%% fig PanelB
% grand average 1D in time
baselineNormalize = true;

iState = 1; %('All','Std.','Target','changed', 'unChanged')
ch1 = 3;
ch2 = 3;
fph_range = [6 10];
famp_range = [30 50];
smooth = 0;
iRat = 1:8;
iSess = 1; % session 1 has the best effect compared to all

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;

tb = tout>=-0.3 & tout<=-0;
tTrim = tout>=-0.3 & tout<=1;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

[fph_mesh,famp_mesh] = meshgrid(fph_out(fph_idx), famp_out(famp_idx));

if(baselineNormalize)
    before_pac_rat_bn = before_pac_rat{iState,1} - mean(before_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
    after30_pac_rat_bn = after30_pac_rat{iState,1} - mean(after30_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
else
   before_pac_rat_bn = before_pac_rat{iState,1};
   after30_pac_rat_bn = after30_pac_rat{iState,1};
end
 
befor_trend = squeeze(mean(before_pac_rat_bn(ch1,ch2,tTrim,famp_idx,fph_idx,iRat,iSess),[4 5], 'omitnan'));
after30_trend = squeeze(mean(after30_pac_rat_bn(ch1,ch2,tTrim,famp_idx,fph_idx,iRat,iSess),[4 5], 'omitnan'));

[cmap] = cbrewer('seq','OrRd',20);
fontSize = 6;
lw = 1.5;
% Define figure dimensions in inches
figWidth = 2.5;  % Width in inches (e.g., single-column width)
figHeight = 2.8; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);

stdshade(reshape(befor_trend,length(befor_trend),[])', 0.4, cmap(10,:), tout(tTrim)*1000, smooth)
hold on
stdshade(reshape(after30_trend,length(after30_trend),[])', 0.4, cmap(end-2,:), tout(tTrim)*1000, smooth)
xline(0,'LineWidth', lw)
xlim([-350 1050])
hLeg = legend('Before', 'After30');

% title('\phi_{[6-10]} Amp_{[30-60]}', 'FontSize', fs);

% Remove the legend box
set(hLeg, 'Box', 'off');

% Customize font and position
set(hLeg, 'FontName', 'Helvetica', 'FontSize', fontSize, 'Location', 'northeast');

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', fontSize, 'LineWidth', lw);
xlabel('Time (ms)', 'FontSize', fontSize);

ylabel('Normalized PAC', 'FontSize', fontSize);

ax = findall(gcf, 'Type', 'axes');  % Find all axes in the current figure
set(ax, 'LineWidth', lw);            % Set axis line width to 2 points

% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'PACtrialSwap_trend.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%% trialSwap before/after for all
% grand average without baseline removal 2D comodulogram
%('All','Std.','Target','changed', 'unChanged')
ch1 = 3;
ch2 = 3;
fph_range = [4 12];
famp_range = [16 90];
c_max = 3e-3;

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

[fph_mesh,famp_mesh] = meshgrid(fph_out(fph_idx), famp_out(famp_idx));
tb = tout>=-0.7 & tout<=-0;
ti= tout<=0.3 | tout>=0.9;
% ti= tout>=-70;
iRat = 1:8;
iSess = 1;

% Define figure dimensions in inches
figWidth = 3;  % Width in inches (e.g., single-column width)
figHeight = 2; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);

% Define the number of rows and columns
rows = 1;
cols = 2;

% Create a tiled layout with no padding or spacing
t = tiledlayout(rows, cols, 'TileSpacing', 'compact', 'Padding', 'compact');

iState = 1;
ax(1) = nexttile;

img = squeeze(mean(before_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,iRat,iSess),[3 6 7], 'omitnan'));

pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
clim([0 c_max])
title('Before', 'FontSize', 6);

ax(2) = nexttile;

img = squeeze(mean(after30_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,iRat,iSess),[3 6 7], 'omitnan'));
    

pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
clim([0 c_max])
title('After30', 'FontSize', 6);

% Set colormap and color limits for all subplots
% set(ax, 'Colormap', jet, 'CLim', [-20 20])
% assign color bar to one tile 
% cbh = colorbar(ax(2)); 
% % To position the colorbar as a global colorbar representing
% % all tiles, 
% cbh.Layout.Tile = 'east';
% cbh.Label.String = 'PAC';
% cbh.FontSize = 6;

xlabel(t, 'Phase frequency (Hz)', 'FontSize', 6);
ylabel(t, 'Amplitude frequency (Hz)', 'FontSize', 6);

sgtitle('Auditory oddball', 'FontSize', 6, 'FontWeight','bold')

% Set font size for all axes in the current figure
set(findall(gcf, 'Type', 'axes'), 'FontSize', 6);


% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'PACcomo_trialSwap_oddball_beforAfter30.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%% bar plot
baselineNormalize = false;
ch1 = 3;
ch2 = 3;
fph_range = [6 10];
famp_range = [30 50];

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

[fph_mesh,famp_mesh] = meshgrid(fph_out(fph_idx), famp_out(famp_idx));
tb = tout>=-0.1 & tout<=-0;
ti= tout<=0.3 | tout>=0.7;
% ti= ~ti;
iRat = 1:8;
iSess = 1;


[cmap] = cbrewer('seq','OrRd',29);
c_before = cmap(14,:);
c_after30 = cmap(26,:);

iState = 1;
if(baselineNormalize)
    before_pac_rat_bn = before_pac_rat{iState,1} - mean(before_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
    after30_pac_rat_bn = after30_pac_rat{iState,1} - mean(after30_pac_rat{iState,1}(:,:,tb,:,:,:,:),3,'omitnan');
else
   before_pac_rat_bn = before_pac_rat{iState,1};
   after30_pac_rat_bn = after30_pac_rat{iState,1};
end

y1 = squeeze(mean(before_pac_rat_bn(ch1,ch2,ti,famp_idx,fph_idx,iRat,iSess),[3 4 5 7], 'omitnan'));
y2 = squeeze(mean(after30_pac_rat_bn(ch1,ch2,ti,famp_idx,fph_idx,iRat,iSess),[3 4 5 7], 'omitnan'));
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
