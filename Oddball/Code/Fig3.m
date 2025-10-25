clc; 
clear;

addpath(genpath('./Functions'))

path_res = ("D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Results\"); 

cfgReference

%% load pacs (mean of trial)

% save_dir = '../Results/PAC_general/';
save_dir = '../Results/PAC_trialSwap/';
% save_dir = '../Results/PAC_restTimeSwap/';

load(strcat(save_dir, 'Before/', 'pyPACcomo_Before_allCh_allWin_meanTrial_perRatSess', '.mat'));
% load(strcat(save_dir, 'After10/', 'pyPACcomo_After10_allCh_allWin_meanTrial_perRatSess', '.mat'));
% load(strcat(save_dir, 'After20/', 'pyPACcomo_After20_allCh_allWin_meanTrial_perRatSess', '.mat'));
load(strcat(save_dir, 'After30/', 'pyPACcomo_After30_allCh_allWin_meanTrial_perRatSess', '.mat'));


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
after30_pac_rat = cell(5,1);

for i=1:5
    before_pac_rat{i,1} = makeArray(PAC_Before,i);
    after30_pac_rat{i,1} = makeArray(PAC_After30,i);
end

size_element = size(PAC_After30{1,1}{1,1});
temp = NaN(cat(2, size_element, 1, 4));


after30_pac_rat{1,1} = cat(6,temp,temp,temp,after30_pac_rat{1,1});
after30_pac_rat{2,1} = cat(6,temp,temp,temp,after30_pac_rat{2,1});
after30_pac_rat{3,1} = cat(6,temp,temp,temp,after30_pac_rat{3,1});
after30_pac_rat{4,1} = cat(6,temp,temp,temp,after30_pac_rat{4,1});
after30_pac_rat{5,1} = cat(6,temp,temp,temp,after30_pac_rat{5,1});

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
figWidth = 2.5;  % Width in inches (e.g., single-column width)
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

%% colorbar
% Create a new figure with specified size (in pixels)
figure('Units', 'inches', 'Position', [1, 1, 1, 2]);

% Create an invisible axes
ax = axes('Position', [0.3, 0.1, 0.2, 0.8], 'Visible', 'off');

% Set the colormap and color limits
colormap(jet);       % You can choose any colormap you prefer
caxis([0, c_max]);      % Set the color axis limits

% Add the colorbar
cb = colorbar('Position', [0.3, 0.1, 0.08, 0.4]);  % [left, bottom, width, height]

% Customize the colorbar title
cb.Label.String = '\DeltaPAC';
cb.Label.FontSize = 6;
cb.Label.FontWeight = 'bold';
cb.Label.Rotation = 90;  % Rotate label if desired
cb.Label.HorizontalAlignment = 'center';  
cb.Label.VerticalAlignment = 'bottom';  

% Customize tick labels (optional)
% cb.Ticks = linspace(-1, 1, 5);  % Set tick positions
% cb.TickLabels = {'Low', '-0.5', '0', '0.5', 'High'};  % Set custom labels

fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'PACcomo_trialSwap_oddball_beforAfter30_colorbar.pdf'), 'ContentType', 'vector', 'Resolution', 300);

%% pac trialSwap trend
% grand average 1D in time
baselineNormalize = true;

iState = 1; %('All','Std.','Target','changed', 'unChanged')
ch1 = 3;
ch2 = 3;
fph_range = [6 10];
famp_range = [30 50];
smooth = 3;
iRat = 1:8;
iSess = 1; % session 1 has the best effect compared to all

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;

tb = tout>=-0.3 & tout<=-0;
tTrim = tout>=-0.1 & tout<=1;

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

tout_trim = tout(tTrim);
ti= tout_trim<=0.6 | tout_trim>=0.7;
ti= ~ti;

[cmap] = cbrewer('seq','OrRd',29);
c_before = cmap(14,:);
c_after30 = cmap(26,:);

fontSize = 6;
lw = 1.5;
% Define figure dimensions in inches
figWidth = 1.7;  % Width in inches (e.g., single-column width)
figHeight = 1.8; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);

stdshade(reshape(befor_trend,length(befor_trend),[])', 0.4, c_before, tout_trim*1000, smooth)
hold on
stdshade(reshape(after30_trend,length(after30_trend),[])', 0.4, c_after30, tout_trim*1000, smooth)
xline(0,'LineWidth', lw)
xlim([-150 1050])
yl = ylim;

% % --- Add gray box behind plot and axes ---
% stimBox = fill([min(tout_trim(ti)) max(tout_trim(ti)) max(tout_trim(ti)) min(tout_trim(ti))]*1e3, ...
%                [yl(1) yl(1) yl(2) yl(2)], ...
%                [0.9 0.9 0.9], ...
%                'EdgeColor', 'none', ...
%                'FaceAlpha', 1, ...
%                'HandleVisibility', 'off');  % <- not shown in legend
% 
% % --- Send patch to back (visually) ---
% uistack(stimBox, 'bottom');
% 
% % --- Draw axes and ticks on top of patch ---
% ax = gca;
% ax.Layer = 'top';


% Remove the legend box
hLeg = legend('Before', 'After30');
hLeg.ItemTokenSize = [10 10];
set(hLeg, 'Box', 'off');

% Customize font and position
set(hLeg, 'FontName', 'Helvetica', 'FontSize', fontSize, 'Location', 'southwest');

%%%%%%%%%%%%%%%%
yl = ylim;
% --- Add gray box behind plot and axes ---
stimBox = fill([600 650 650 600], ...
               [yl(1) yl(1) yl(2) yl(2)], ...
               [0.85 0.85 0.85], ...
               'EdgeColor', 'none', ...
               'FaceAlpha', 1, ...
               'HandleVisibility', 'off');  % <- not shown in legend

% --- Send patch to back (visually) ---
uistack(stimBox, 'bottom');

% --- Draw axes and ticks on top of patch ---
ax = gca;
ax.Layer = 'top';
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% star
[h,p] = ttest(mean(befor_trend(ti,:),1), mean(after30_trend(ti,:),1))
% hLine = line([650 650], yl, 'LineWidth', lw, 'Color', [0.5 0.5 0.5], 'LineStyle', '-.', 'handleVisibility', 'off');
% uistack(hLine, 'bottom');  % push behind other plots
text(570, 3.5e-4, '***','FontSize',8, 'FontWeight', 'bold')


% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', fontSize, 'LineWidth', lw);
xlabel('Time (ms)', 'FontSize', fontSize);
ylabel('Normalized theta-gamma \DeltaPAC', 'FontSize', fontSize);

ax = findall(gcf, 'Type', 'axes');  % Find all axes in the current figure
set(ax, 'LineWidth', lw);            % Set axis line width to 2 points

% Remove the top and right borders
set(gca, 'box', 'off');

% Tight layout to minimize white space
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = '../Figures/';
% exportgraphics(gcf, strcat(fig_dir,'PACtrialSwap_trend_oddball.pdf'), 'ContentType', 'vector', 'Resolution', 300);
