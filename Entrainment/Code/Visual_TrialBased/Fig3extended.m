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
figWidth = 3.5;  % Width in inches (e.g., single-column width)
figHeight = 3; % Height in inches
ch_names = ["CA1", "LP", "DS", "mPFC"];
for iCh=1:4
    ch1 = iCh;
    ch2 = iCh;
    % Create figure with specified size
    figure('Units', 'inches', 'Position', [1, 1, figWidth, figHeight]);
    
    % Define the number of rows and columns
    rows = 2;
    cols = 4;
    
    % Create a tiled layout with no padding or spacing
    t = tiledlayout(rows, cols, 'TileSpacing', 'compact', 'Padding', 'compact');
    
    cnt = 1;
    for iBlock=1:nBlock
        for iSess=[1 3:5]
            ax(cnt) = nexttile;
            img = squeeze(mean(PAC2plot(ch1,ch2,ti,famp_idx,fph_idx,iRat,iSess,iBlock),[3 6], 'omitnan'));
            pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
            clim([0 c_max])
            if(cnt<5)
                title("Day"+string(days(iSess)));
            end
            if(iSess==1)
                ylabel(YLabel(iBlock), 'FontSize', 6, 'FontWeight','bold')
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
    
    sgtitle(ch_names(iCh), 'FontSize', 6, 'FontWeight','bold')
    
    % Set font size for all axes in the current figure
    set(findall(gcf, 'Type', 'axes'), 'FontSize', 6);
    
    
    % Tight layout to minimize white space
    % set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));
    
    % Export figure as a vector-based PDF with high resolution
    fig_dir = fullfile(path_results, "Figures","PACcomo_trialSwap_visual120_allD_"+ch_names(iCh)+".pdf");
%     exportgraphics(gcf, fig_dir, 'ContentType', 'vector', 'Resolution', 300);
end
%% fig colorbar
% Create a new figure with specified size (in inches)
figure('Units', 'inches', 'Position', [1, 1, 2, 0.5]);  % wider since horizontal

% Create an invisible axes
ax = axes('Position', [0.1, 0.6, 0.8, 0.3], 'Visible', 'off');

% Set the colormap and color limits
colormap(jet);       % You can choose any colormap you prefer
caxis([0, c_max]);   % Set the color axis limits

% Add a horizontal colorbar
cb = colorbar('southoutside');  % <-- horizontal orientation
cb.Position = [0.2, 0.6, 0.6, 0.2];  % [left, bottom, width, height]

% Customize the colorbar title
cb.Label.String = '\DeltaPAC';
cb.Label.FontSize = 6;
cb.Label.FontWeight = 'bold';
cb.Label.Rotation = 0;  % keep horizontal
cb.Label.HorizontalAlignment = 'center';
cb.Label.VerticalAlignment = 'top';  % place label above bar

% (Optional) Custom tick labels
% cb.Ticks = linspace(0, c_max, 5);
% cb.TickLabels = {'Low', '0.25', '0.5', '0.75', 'High'};

% Export as vector PDF
fig_dir = fullfile(path_results, 'Figures','PACcomo_trialSwap_visual120_allD_colorbarH.pdf');
% exportgraphics(gcf, fig_dir, 'ContentType', 'vector', 'Resolution', 300);

