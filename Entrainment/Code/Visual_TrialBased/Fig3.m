clear
close all
clc

cfgRef
%% load

fileName = fullfile(path_results,'PAC_trialSwap/','pyPACcomo_allCh_allWin_meanTrial_perRatSess.mat');
load(fileName)

%%
[PACArr] = makeArray(PAC, cfg);

%% 2d comodulogram
baselineNormalize = false;
iRat = 1:9;
ch1 = 3;
ch2 = 3;
fph_range = [4 12];
famp_range = [16 90];


fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;
tbase = tout>=-0.3 & tout<=0;
ti = tout>0;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

[fph_mesh,famp_mesh] = meshgrid(fph_out(fph_idx), famp_out(famp_idx));

if(baselineNormalize)
    PAC2plot = PACArr - mean(PACArr(:,:,tbase,:,:,:,:,:),3,'omitnan');
    c_max = 5e-4;
else
    PAC2plot = PACArr;
    c_max = 2e-3;
end

YLabel = ["Block1", "Block2"];
% Define figure dimensions in inches
figWidth = 2.7;  % Width in inches (e.g., single-column width)
figHeight = 4; % Height in inches

% Create figure with specified size
figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);

% Define the number of rows and columns
rows = 2;
cols = 2;

% Create a tiled layout with no padding or spacing
t = tiledlayout(rows, cols, 'TileSpacing', 'compact', 'Padding', 'compact');

cnt = 1;
for iBlock=1:nBlock
    for iSess=[1 5]
        ax(cnt) = nexttile;
        img = squeeze(mean(PAC2plot(ch1,ch2,ti,famp_idx,fph_idx,iRat,iSess,iBlock),[3 6], 'omitnan'));
        pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
        clim([0 c_max])
        if(cnt<3)
            title("Day"+string(days(iSess)));
        end
        if(iSess==1)
            ylabel(YLabel(iBlock))
        end

        cnt = cnt+1;
    end
end


% % assign color bar to one tile 
% cb = colorbar(); 
% % To position the colorbar as a global colorbar representing
% % all tiles, 
% cb.Layout.Tile = 'east';
% cb.Label.String = '\DeltaPAC (observed - surrogate)';
% cb.FontSize = 6;

xlabel(t, 'Phase frequency (Hz)', 'FontSize', 6);
ylabel(t, 'Amplitude frequency (Hz)', 'FontSize', 6);

sgtitle('Visual', 'FontSize', 6, 'FontWeight','bold')

% Set font size for all axes in the current figure
set(findall(gcf, 'Type', 'axes'), 'FontSize', 6);


% Tight layout to minimize white space
% set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));

% Export figure as a vector-based PDF with high resolution
fig_dir = fullfile(path_results, 'Figures','PACcomo_trialSwap2_visual120_D1D30.pdf');
% exportgraphics(gcf, fig_dir, 'ContentType', 'vector', 'Resolution', 300);

%% fig panelA colorbar
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

fig_dir = fullfile(path_results, 'Figures','PACcomo_trialSwap2_visual120_D1D30_colorbar.pdf');
% exportgraphics(gcf, fig_dir, 'ContentType', 'vector', 'Resolution', 300);

%% bar plot
baselineNormalize = false;  

iBlock = 2;
iRat = [1 3:9];
ch1 = 3;
ch2 = 3;
fph_range = [6 10];
famp_range = [30 50];

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;
tbase = tout>=-0.3 & tout<=0;
ti = tout>=0;


fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

[fph_mesh,famp_mesh] = meshgrid(fph_out(fph_idx), famp_out(famp_idx));

if(baselineNormalize)
    PAC2plot = PACArr - mean(PACArr(:,:,tbase,:,:,:,:,:),3,'omitnan');
else
    PAC2plot = PACArr;
end

[cmap] = cbrewer('seq','OrRd',29);
c_before = cmap(14,:);
c_after30 = cmap(26,:);

iSess = 1;
y1 = squeeze(mean(PAC2plot(ch1,ch2,ti,famp_idx,fph_idx,iRat,iSess,iBlock),[3 4 5 7 8], 'omitnan'));
iSess = 5;
y2 = squeeze(mean(PAC2plot(ch1,ch2,ti,famp_idx,fph_idx,iRat,iSess,iBlock),[3 4 5 7 8], 'omitnan'));
x = [0 1];
barWidth = 0.8;

% Define figure dimensions in inches
figWidth = 1;  % Width in inches (e.g., single-column width)
figHeight = 1.8; % Height in inches

% Create figure with specified size
fig = figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);
hold on

bar(x(1), nanmean(y1), barWidth, 'FaceColor', c_before, 'EdgeColor', c_before);
bar(x(2), nanmean(y2), barWidth, 'FaceColor', c_after30, 'EdgeColor', c_after30);

errorbar(x(1), nanmean(y1), nanstd(y1) / sqrt(sum(~isnan(y1))), 'k', 'LineWidth', 1, 'CapSize', 3);
errorbar(x(2), nanmean(y2), nanstd(y2) / sqrt(sum(~isnan(y2))), 'k', 'LineWidth', 1, 'CapSize', 3);

markers = ['x','o','s','d','^','v','>','<','p','h','+','*']; % enough for 12 rats

barWidth = barWidth*.8;
markerSize = 3;
lw = 0.5;
for i=1:length(iRat)
    x_sample = linspace(x(1)-barWidth/2,x(1)+barWidth/2,numel(y1));
    plot(x_sample(i), ...
        y1(i), markers(i), 'Color', 'k', 'MarkerFaceColor', c_before,'MarkerSize', markerSize, 'LineWidth', lw);
    x_sample = linspace(x(2)-barWidth/2,x(2)+barWidth/2,numel(y2));
    plot(x_sample(i), ...
        y2(i), markers(i), 'Color', 'k', 'MarkerFaceColor', c_after30,'MarkerSize', markerSize, 'LineWidth', lw);
end

[h,p] = ttest(y1, y2)
addSignificanceStar(x(1), x(2), 2e-3, h, p, true)


% Axes and labels
xticks(x);
xticklabels({"Day1","Day30"});
xtickangle(45); 

% Customize axes properties
set(gca, 'FontName', 'Helvetica', 'FontSize', 6, 'LineWidth', 1);
xlim([min(x)-barWidth max(x)+barWidth])
ylabel('Theta-gamma \DeltaPAC', 'FontSize', 6);

% title(my_title, 'FontName', 'Helvetica', 'FontSize', 6,'FontWeight', 'bold')
% Remove the top and right borders
set(gca, 'box', 'off');

% Ensure printed/exported figure uses the same size
set(fig, 'PaperUnits', 'inches');
set(fig, 'PaperPosition', [0, 0, figWidth, figHeight]);
set(fig, 'PaperSize', [figWidth, figHeight]);

% Export figure as a vector-based PDF with high resolution
fig_dir = fullfile(path_results, 'Figures','barPACperRat_trialSwap_visual120_B1_D1D30.pdf');
% exportgraphics(fig, fig_dir, 'ContentType', 'vector', 'Resolution', 300);
