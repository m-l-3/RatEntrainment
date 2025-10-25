
clc; 
clear;
% close all;

addpath(genpath('./Functions'))
addpath(genpath("D:\Documents\SUT Ph.D\Research\Matlab codes\chronux_2_12"));
addpath("D:\Documents\SUT Ph.D\Research\Matlab codes\eeglab2023.1")
addpath('D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Dataset-initial\')

path_res = ("D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Results-initial\Pow_spec\"); 
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
     '8', '2', '1403-01-29', '0';};
    {'9', '1', '1403-02-25', '0'; ...
     '9', '2', '1403-02-25', '0';};
    {'11', '1', '1403-03-05', '0'; ...
     '11', '2', '1403-03-05', '0';};
    {'12', '1', '1403-03-05', '0'; ...
     '12', '2', '1403-03-05', '0';};
    {'13', '1', '1403-04-13', '0'; ...
     '13', '2', '1403-04-13', '0';};
    {'14', '1', '1403-04-19', '0'; ...
     '14', '2', '1403-04-19', '0';};
    };
% for rat 11, 12 : before = 03/18
% Rat 9: 

After10days_Datasets = { ...
    {'5', '1', '1402-09-20', '0'; ...
     '5', '2', '1402-09-20', '0';};
    {'7', '1', '1402-12-16', '0'; ...
     '7', '2', '1402-12-16', '0';};
    {%'8', '1', '1403-02-11', '0'; ... % trigers are incorrect
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
    {'9', '2', '1403-03-31', '0';
                                 };
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


save_dir = '../Results/Signals/sigZscr_eeglab_trZscore_0.1-100Hz-1-1epoch/';
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
    
    dataName = strcat(dataName1, dataName2, dataName3, dataName4);
    
    save(strcat(save_dir, 'Before_Data', dataName, '.mat'), 'Before_Data', 'cfg')
    save(strcat(save_dir, 'After10days_Data', dataName, '.mat'), 'After10days_Data', 'cfg')
    save(strcat(save_dir, 'After20days_Data', dataName, '.mat'), 'After20days_Data', 'cfg')
    save(strcat(save_dir, 'After30days_Data', dataName, '.mat'), 'After30days_Data', 'cfg')

end

%% LOAD Data if available instead

save_dir = '../Results-initial/Signals/sigZscr_eeglab_trZscore_0.1-100Hz-1.5-2epoch/';

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
    
dataName = strcat(dataName1, dataName2, dataName3, dataName4);

Before_Data   = load(strcat(save_dir, 'Before_Data', dataName, '.mat')).Before_Data;
After10_Data  = load(strcat(save_dir, 'After10days_Data', dataName, '.mat')).After10days_Data;
After20_Data  = load(strcat(save_dir, 'After20days_Data', dataName, '.mat')).After20days_Data;
After30_Data  = load(strcat(save_dir, 'After30days_Data', dataName, '.mat')).After30days_Data;

%%

states = ["All", "Std.", "Target", "Diff."];
iTarStd = 3; % 1:All, 2:Std, 3:Target

pool = true;
useClean = true;
params.tapers = [1 1];
params.pad = -1;
params.Fs = cfg.fs;
params.fpass = [0 90];
params.trialave = 0;

[f,Before_Wpli] = calc_wpli_spec(Before_Data, iTarStd, params, useClean, pool);
% [f,After10_Wpli] = calc_wpli_spec(After10_Data, iTarStd, params, useClean, pool);
% [f,After20_Wpli] = calc_wpli_spec(After20_Data, iTarStd, params, useClean, pool);
[f,After30_Wpli] = calc_wpli_spec(After30_Data, iTarStd, params, useClean, pool);

%%

iCh = 1;
jCh = 3;

input = Before_Wpli;
nRat = size(input,1);
before_wpli_rat = [];
figure
for iRat=1:nRat
    before_wpli_rat = cat(4,before_wpli_rat,input{iRat,1});
    plot(f, input{iRat,1}(:,iCh,jCh));
    hold on
end

% input = After10_Wpli;
% nRat = size(input,1);
% after10_wpli_rat = [];
% figure
% for iRat=1:nRat
%     after10_wpli_rat = cat(4,after10_wpli_rat,input{iRat,1});
%     plot(f, input{iRat,1}(:,iCh,jCh));
%     hold on
% end
% 
% 
% input = After20_Wpli;
% nRat = size(input,1);
% after20_wpli_rat = [];
% figure
% for iRat=1:nRat
%     after20_wpli_rat = cat(4,after20_wpli_rat,input{iRat,1});
%     plot(f, input{iRat,1}(:,iCh,jCh));
%     hold on
% end


input = After30_Wpli;
nRat = size(input,1);
after30_wpli_rat = [];
figure
for iRat=1:nRat
    after30_wpli_rat = cat(4,after30_wpli_rat,input{iRat,1});
    plot(f, input{iRat,1}(:,iCh,jCh));
    hold on
end

%%
nCh = 4;
for iCh = 1:nCh
    for jCh = iCh+1:nCh

    figure
    stdshade(squeeze(before_wpli_rat(2:end,iCh,jCh,2:end))',0.4,'b',f(2:end))
    hold on
%     stdshade(squeeze(after10_wpli_rat(2:end,iCh,jCh,2:end))',0.4,'r',f(2:end))
%     stdshade(squeeze(after20_wpli_rat(2:end,iCh,jCh,:))',0.4,'g',f(2:end))
    stdshade(squeeze(after30_wpli_rat(2:end,iCh,jCh,:))',0.4,'m',f(2:end))

    xlabel('Frequency (Hz)')
    ylabel('wPLI');
    title(strcat('', ch_labels{1}(iCh) ,'-',ch_labels{1}(jCh)))
    end
end


%% using wavelet:

save_dir = '../Results-initial/wPLI/' ;
pool = true;
useClean = true;

params.fs = cfg.fs;
params.frange = [4 90];
params.fres_param = 16;

smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * cfg.fs;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;
params.times = time;

% [fout, tout, Before_Wpli] = calc_wpli_wavelet(Before_Data,params,useClean,pool);
% save(strcat(save_dir, 'wPLI_Before_allCh_completeWin_overTrial_perRatSess', '.mat'), 'Before_Wpli', 'params', 'fout', 'tout', 'cfg');

% [fout, tout, After10_Wpli] = calc_wpli_wavelet(After10_Data,params,useClean,pool);
% save(strcat(save_dir, 'wPLI_After10_allCh_completeWin_overTrial_perRatSess', '.mat'), 'After10_Wpli', 'params', 'fout', 'tout', 'cfg');

% [fout, tout, After20_Wpli] = calc_wpli_wavelet(After20_Data,params,useClean,pool);
% save(strcat(save_dir, 'wPLI_After20_allCh_completeWin_overTrial_perRatSess', '.mat'), 'After20_Wpli', 'params', 'fout', 'tout', 'cfg');

% [fout, tout, After30_Wpli] = calc_wpli_wavelet(After30_Data,params,useClean,pool);
% save(strcat(save_dir, 'wPLI_After30_allCh_completeWin_overTrial_perRatSess', '.mat'), 'After30_Wpli', 'params', 'fout', 'tout', 'cfg');


%%
save_dir = '../Results-initial/wPLI/' ;

Before_Wpli = load(strcat(save_dir, 'wPLI_Before_allCh_completeWin_overTrial_perRatSess', '.mat')).Before_Wpli;
After10_Wpli = load(strcat(save_dir, 'wPLI_After10_allCh_completeWin_overTrial_perRatSess', '.mat')).After10_Wpli;
After20_Wpli = load(strcat(save_dir, 'wPLI_After20_allCh_completeWin_overTrial_perRatSess', '.mat')).After20_Wpli;
After30_Wpli = load(strcat(save_dir, 'wPLI_After30_allCh_completeWin_overTrial_perRatSess', '.mat')).After30_Wpli;
tout = load(strcat(save_dir, 'wPLI_After30_allCh_completeWin_overTrial_perRatSess', '.mat')).tout;
fout = load(strcat(save_dir, 'wPLI_After30_allCh_completeWin_overTrial_perRatSess', '.mat')).fout;

%%

input = Before_Wpli;
nRat = size(input,1);
before_wpli_rat = [];
for iRat=1:nRat
    before_wpli_rat = cat(6,before_wpli_rat,input{iRat,1});
end

input = After10_Wpli;
nRat = size(input,1);
after10_wpli_rat = [];
for iRat=1:nRat
    after10_wpli_rat = cat(6,after10_wpli_rat,input{iRat,1});
end

input = After20_Wpli;
nRat = size(input,1);
after20_wpli_rat = [];
for iRat=1:nRat
    after20_wpli_rat = cat(6,after20_wpli_rat,input{iRat,1});
end
after20_wpli_rat = cat(6,NaN(size(input{iRat,1})),NaN(size(input{iRat,1})),after20_wpli_rat);


input = After30_Wpli;
nRat = size(input,1);
after30_wpli_rat = [];
for iRat=1:nRat
    after30_wpli_rat = cat(6,after30_wpli_rat,input{iRat,1});
end
after30_wpli_rat = cat(6,NaN(size(input{iRat,1})),NaN(size(input{iRat,1})),NaN(size(input{iRat,1})),after30_wpli_rat);

%% in time for specific bands

freq_ranges = [60 90;
               30 60;
               12 30
               8 12
               4 8];
nCh = 4;
iTarStd = 3;

for iCh = 1:nCh
    for jCh = iCh+1:nCh

        fig = figure; % Create a figure  
        screenSize = get(0, 'ScreenSize'); % Get the screen size  
        set(fig, 'Position', [screenSize(1), 0, screenSize(3)/4, screenSize(4)]); % Set figure position to full vertical size

        for iRange=1:length(freq_ranges)
            fidx = (fout>=freq_ranges(iRange,1) & fout<=freq_ranges(iRange,2));

            subplot(length(freq_ranges),1,iRange)
            stdshade(squeeze(mean(before_wpli_rat(iCh,jCh,fidx,:,iTarStd,2:end),3))',0.4,'b',tout)
            hold on
            stdshade(squeeze(mean(after10_wpli_rat(iCh,jCh,fidx,:,iTarStd,2:end),3))',0.4,'r',tout)
            stdshade(squeeze(mean(after20_wpli_rat(iCh,jCh,fidx,:,iTarStd,2:end),3))',0.4,'g',tout)
            stdshade(squeeze(mean(after30_wpli_rat(iCh,jCh,fidx,:,iTarStd,2:end),3))',0.4,'m',tout)
        
            xlim([-500 1500])
            xline(0,'-k', 'LineWidth', 2)
            legend('Before', 'After10', 'After20', 'After30')
            ylabel(strcat(string(freq_ranges(iRange,1)),'-',string(freq_ranges(iRange,2))));
            if(iRange==1), title(strcat('', ch_labels{1}(iCh) ,'-',ch_labels{1}(jCh))), end
            if(iRange==length(freq_ranges)), xlabel('Time (msec)'), end

        end
        sgtitle(sprintf('wPLI in specific bands - %s',states(iTarStd)),'FontSize',10)
% 
%         set(gcf,'Units','Inches');
%         set(gcf,'PaperPosition',[0 0 4 9],'PaperUnits','Inches','PaperSize',[4, 9])
%         save_fig('../Results/wPLI/', strcat('temporalDynamicInFreqBand_wPLI_meanRatBeforeAfter_',states(iTarStd),'_',ch_labels{1}(iCh),'-',ch_labels{1}(jCh)))


    end
end


%% see each rat in each before/after
ch1 = 3;
ch2 = 4;
states = ["All", "Std.", "Target"];
iTarStd = 3;

fidx = (fout>=0 & fout<=40);
fsel = fout(fidx);

figure
plot(tout, squeeze(mean(before_wpli_rat(ch1,ch2,fidx,:,iTarStd,2:end),3)),'LineWidth',2)
hold on
set(gca,'ColorOrderIndex',1)
plot(tout, squeeze(mean(after10_wpli_rat(ch1,ch2,fidx,:,iTarStd,2:end),3)),':','LineWidth',2)
set(gca,'ColorOrderIndex',1)
plot(tout, squeeze(mean(after20_wpli_rat(ch1,ch2,fidx,:,iTarStd,2:end),3)),'--','LineWidth',2)
set(gca,'ColorOrderIndex',1)
plot(tout, squeeze(mean(after30_wpli_rat(ch1,ch2,fidx,:,iTarStd,2:end),3)),'-.','LineWidth',2)

xline(0,'-k','LineWidth',2)
title(sprintf('wPLI %s - %s\n %s', ch_labels{1}(ch1),ch_labels{1}(ch2), states(iTarStd)),'FontSize',10)


%% 2D visualization (time and freq.)

states = ["All", "Std.", "Target"];
iTarStd = 3; % 1:All, 2:Std, 3:Target
nCh = 4;
nRat = size(before_wpli_rat,6);
[t_mesh,f_mesh] = meshgrid(tout, fout);

for iCh = 1:nCh
    for jCh = iCh+1:nCh
        figure
        
        for iRat=1:nRat
            subplot(nRat,4,(iRat-1)*4+1)
            pcolor(t_mesh, f_mesh, squeeze(before_wpli_rat(iCh,jCh,:,:,iTarStd,iRat)));
            shading flat;colormap jet;clim([0 1]);xlim([-500 1500]);
            hold on
            xline(0,'k','LineWidth',2)
            if(iRat==1), title('Before'), end
            if(iRat==nRat), xlabel('Time (ms)'), end
            ylabel(sprintf('Rat %s',Before_Datasets{iRat,1}{1,1}))     
        
            subplot(nRat,4,(iRat-1)*4+2)
            pcolor(t_mesh, f_mesh, squeeze(after10_wpli_rat(iCh,jCh,:,:,iTarStd,iRat)));
            shading flat;colormap jet;clim([0 1]);xlim([-500 1500]);
            hold on
            xline(0,'k','LineWidth',2)
            if(iRat==1), title('After10'), end
            if(iRat==nRat), xlabel('Time (ms)'), end
        
            subplot(nRat,4,(iRat-1)*4+3)
            pcolor(t_mesh, f_mesh, squeeze(after20_wpli_rat(iCh,jCh,:,:,iTarStd,iRat)));
            shading flat;colormap jet;clim([0 1]);xlim([-500 1500]);
            hold on
            xline(0,'k','LineWidth',2)
            if(iRat==1), title('After20'), end
            if(iRat==nRat), xlabel('Time (ms)'), end
        
            subplot(nRat,4,(iRat-1)*4+4)
            pcolor(t_mesh, f_mesh, squeeze(after30_wpli_rat(iCh,jCh,:,:,iTarStd,iRat)));
            shading flat;colormap jet;clim([0 1]);xlim([-500 1500]);
            hold on
            xline(0,'k','LineWidth',2)
            if(iRat==1), title('After30'), end
            if(iRat==nRat), xlabel('Time (ms)'), end
        
        end
        sgtitle(sprintf('wPLI %s - %s\n %s', ch_labels{1}(iCh),ch_labels{1}(jCh), states(iTarStd)),'FontSize',10)

%         set(gcf,'Units','Inches');
%         set(gcf,'PaperPosition',[0 0 9 9],'PaperUnits','Inches','PaperSize',[9, 9])
%         save_fig('../Results/wPLI/', strcat('2DtemporalDynamic_wPLI_perRatBeforeAfter_',states(iTarStd),'_',ch_labels{1}(iCh),'-',ch_labels{1}(jCh)))

    end
end

%% in freq. (mean of time)

nCh = 4;
iTarStd = 3;
tidx = (tout>=200 & tout<=800);
tsel = tout(tidx);

for iCh = 1:nCh
    for jCh = iCh+1:nCh

        figure

        stdshade(squeeze(mean(before_wpli_rat(iCh,jCh,:,tidx,iTarStd,2:end),4))',0.4,'b',fout)
        hold on
        stdshade(squeeze(mean(after10_wpli_rat(iCh,jCh,:,tidx,iTarStd,2:end),4))',0.4,'r',fout)
        stdshade(squeeze(mean(after20_wpli_rat(iCh,jCh,:,tidx,iTarStd,2:end),4))',0.4,'g',fout)
        stdshade(squeeze(mean(after30_wpli_rat(iCh,jCh,:,tidx,iTarStd,2:end),4))',0.4,'m',fout)
    
        legend('Before', 'After10', 'After20', 'After30')
        title(sprintf('%s - %s\n %s', ch_labels{1}(iCh),ch_labels{1}(jCh), states(iTarStd)));
        xlabel('Frequency (Hz)')
        ylabel('wPLI')

%         set(gcf,'Units','Inches');
%         set(gcf,'PaperPosition',[0 0 4 3],'PaperUnits','Inches','PaperSize',[4, 3])
%         save_fig('../Results/wPLI/', strcat('wPLI_timeAvg',string(min(tsel)),string(max(tsel)),'_meanRatBeforeAfter_',states(iTarStd),'_',ch_labels{1}(iCh),'-',ch_labels{1}(jCh)))

    end
end


