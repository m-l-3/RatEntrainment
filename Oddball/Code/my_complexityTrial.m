

clc; 
clear;
% close all;

addpath(genpath('./Functions'))
addpath("D:\Documents\SUT Ph.D\Research\Matlab codes\eeglab2023.1")
addpath('D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Dataset\')

path_res = ("D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Results\Complexity\"); 
eeglab
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
    'epoch_t_start',    0.3,                     ...
    'y_range',          [-1 1],                  ...
    'epoch_time',       [0.3, 1],                ... 
    'prep_band',        [0.1, 30],               ... 
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


save_dir = '../Results/Signals/sigZscr_eeglab_trZscore_0.1-30Hz/';
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

save_dir = '../Results/Signals/sigZscr_eeglab_trZscore_0.1-30Hz/';

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
iTarStd = 1; % 1:All, 2:Std, 3:Target

total_dur = cfg.epoch_time(1) + cfg.epoch_time(2);
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * fs;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;
win_st = find(time>=200,1);
win_end = find(time<=400,1,'last');
num_levels = 2;

Before_Complexity = calc_complexity(Before_Data,num_levels,win_st,win_end,iTarStd);
After10_Complexity = calc_complexity(After10_Data,num_levels,win_st,win_end,iTarStd);
After20_Complexity = calc_complexity(After20_Data,num_levels,win_st,win_end,iTarStd);
After30_Complexity = calc_complexity(After30_Data,num_levels,win_st,win_end,iTarStd);

%% mean session per rat
NTrial = 240;
iCh = 1;
nRat = length(Before_Complexity);
comp_all = NaN(nRat,NTrial);


figure
for iRat=1:nRat
    comp = Before_Complexity{iRat,1};
    nSess = size(comp,2);
    comp_rat = NaN(nSess,NTrial);
    for iSess=1:nSess
        comp_sess = comp{1,iSess};
        nTrial = size(comp_sess,1);
        comp_rat(iSess,1:nTrial,:) = comp_sess(:,iCh);
    end
    comp_all(iRat,:,:) = mean(comp_rat,1,'omitnan');
    plot(squeeze(comp_all(iRat,:)))
    hold on
end

plot(squeeze(mean(comp_all,'omitnan')),'k','LineWidth',2)

figure
stdshade(comp_all,0.4,'b',1:NTrial,10)
xlabel('Trial')
ylabel('Complexity - Lpz')
title('All Trials')
% legend('After20')

set(gcf,'Units','Inches');
set(gcf,'PaperPosition',[0 0 3 3],'PaperUnits','Inches','PaperSize',[3, 3])
fname = path_res+sprintf('compLpz_str200400_after20_allTrial');
% print(gcf, '-vector', '-dpng', '-r300', fname+'.png');
% saveas(gcf, fname+'.fig')

%% mean all sessions
iCh = 3;
nRat = length(Before_Complexity);
comp_all = [];
NTrial = 240;
figure

for iRat=1:nRat
    comp = Before_Complexity{iRat,1};
    nSess = size(comp,2);
    comp_rat = NaN(nSess,NTrial);
    for iSess=1:nSess
        comp_sess = comp{1,iSess};
        nTrial = size(comp_sess,1);
        comp_rat(iSess,1:nTrial) = comp_sess(:,iCh);
    end
    comp_all = cat(1,comp_all,comp_rat);
end

plot(comp_all')
hold on
plot(mean(comp_all,'omitnan'),'k','LineWidth',2)

figure
stdshade(comp_all,0.4,'r',1:NTrial,20)

%% abstrac plot for all channel per after/before
NTrial = 240;
Nch = 4;
smooth = 20;

nRat = length(Before_Complexity);
comp_all_before = NaN(nRat,NTrial,Nch);
for iRat=1:nRat
    comp = Before_Complexity{iRat,1};
    nSess = size(comp,2);
    comp_rat = NaN(nSess,NTrial,Nch);
    for iSess=1:nSess
        comp_sess = comp{1,iSess};
        nTrial = size(comp_sess,1);
        comp_rat(iSess,1:nTrial,:) = comp_sess;
    end
    comp_all_before(iRat,:,:) = mean(comp_rat,1,'omitnan');
end

nRat = length(After10_Complexity);
comp_all_after10 = NaN(nRat,NTrial,Nch);
for iRat=1:nRat
    comp = After10_Complexity{iRat,1};
    nSess = size(comp,2);
    comp_rat = NaN(nSess,NTrial,Nch);
    for iSess=1:nSess
        comp_sess = comp{1,iSess};
        nTrial = size(comp_sess,1);
        comp_rat(iSess,1:nTrial,:) = comp_sess;
    end
    comp_all_after10(iRat,:,:) = mean(comp_rat,1,'omitnan');
end

nRat = length(After20_Complexity);
comp_all_after20 = NaN(nRat,NTrial,Nch);
for iRat=1:nRat
    comp = After20_Complexity{iRat,1};
    nSess = size(comp,2);
    comp_rat = NaN(nSess,NTrial,Nch);
    for iSess=1:nSess
        comp_sess = comp{1,iSess};
        nTrial = size(comp_sess,1);
        comp_rat(iSess,1:nTrial,:) = comp_sess;
    end
    comp_all_after20(iRat,:,:) = mean(comp_rat,1,'omitnan');
end

nRat = length(After30_Complexity);
comp_all_after30 = NaN(nRat,NTrial,Nch);
for iRat=1:nRat
    comp = After30_Complexity{iRat,1};
    nSess = size(comp,2);
    comp_rat = NaN(nSess,NTrial,Nch);
    for iSess=1:nSess
        comp_sess = comp{1,iSess};
        nTrial = size(comp_sess,1);
        comp_rat(iSess,1:nTrial,:) = comp_sess;
    end
    comp_all_after30(iRat,:,:) = mean(comp_rat,1,'omitnan');
end


figure('WindowState', 'maximized');
sgtitle('Clean all trials')
for iCh=1:4   
    subplot(2,2,iCh);
    stdshade(squeeze(comp_all_before(:,:,iCh)),0.4, 'b', 1:NTrial, smooth); hold on;
    stdshade(squeeze(comp_all_after10(:,:,iCh)),0.4, 'r', 1:NTrial, smooth);
    stdshade(squeeze(comp_all_after20(:,:,iCh)),0.4, 'g', 1:NTrial, smooth);
    stdshade(squeeze(comp_all_after30(:,:,iCh)),0.4, 'm', 1:NTrial, smooth); hold off;
    title(strcat('', ch_labels{1}(iCh)))
    legend('Before', 'After 10days', 'After 20days', 'After 30days')
    xlabel('Trial')
    ylabel('Complexity - Lpz')
%     xlim([0 50])
end

set(gcf,'Units','Inches');
set(gcf,'PaperPosition',[0 0 5 5],'PaperUnits','Inches','PaperSize',[5, 5])
fname = path_res+sprintf('compLpz_allCh200400_beforeAfter_allClnTrial');
% print(gcf, '-vector', '-dpng', '-r300', fname+'.png');
% saveas(gcf, fname+'.fig')

%% over time windows and trial

iTarStd = 1; % 1:All, 2:Std, 3:Target

total_dur = cfg.epoch_time(1) + cfg.epoch_time(2);
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * fs;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;

twin_len = 0.2;
win_len = twin_len*fs;
twin_slip = 0.02;
win_slip = twin_slip*fs;

n_win = round((total_dur-twin_len)/twin_slip + 1);
t_seg = -cfg.epoch_time(1)+twin_len/2:twin_slip:cfg.epoch_time(2)-twin_len/2;

num_levels = 2;
%%
Before_Complexity = calc_complexity2(Before_Data,num_levels,n_win,win_len,win_slip,iTarStd);
After10_Complexity = calc_complexity2(After10_Data,num_levels,n_win,win_len,win_slip,iTarStd);
After20_Complexity = calc_complexity2(After20_Data,num_levels,n_win,win_len,win_slip,iTarStd);
After30_Complexity = calc_complexity2(After30_Data,num_levels,n_win,win_len,win_slip,iTarStd);

%% save

save_dir = '..\Results\Complexity\';
dataName = 'Lpz2_200len20slip';
save(strcat(save_dir, 'Before_Complexity', dataName, '.mat'), 'Before_Complexity', 't_seg')
save(strcat(save_dir, 'After10_Complexity', dataName, '.mat'), 'After10_Complexity', 't_seg')
save(strcat(save_dir, 'After20_Complexity', dataName, '.mat'), 'After20_Complexity', 't_seg')
save(strcat(save_dir, 'After30_Complexity', dataName, '.mat'), 'After30_Complexity', 't_seg')

%% load 
save_dir = '..\Results\Complexity\';
dataName = 'Lpz2_200len20slip';
Before_Complexity   = load(strcat(save_dir, 'Before_Complexity', dataName, '.mat')).Before_Complexity;
After10_Complexity  = load(strcat(save_dir, 'After10_Complexity', dataName, '.mat')).After10_Complexity;
After20_Complexity  = load(strcat(save_dir, 'After20_Complexity', dataName, '.mat')).After20_Complexity;
After30_Complexity  = load(strcat(save_dir, 'After30_Complexity', dataName, '.mat')).After30_Complexity;
t_seg = load(strcat(save_dir, 'Before_Complexity', dataName, '.mat')).t_seg;
%%
nCh = 4;
NTrial = 240;
n_win = length(t_seg);
nRat = length(Before_Complexity);
comp_all_before = NaN(nRat,NTrial,nCh,n_win);
figure
for iRat=1:nRat
    comp = Before_Complexity{iRat,1};
    nSess = size(comp,2);
    comp_rat = NaN(nSess,NTrial,nCh,n_win);
    for iSess=1:nSess
        comp_sess = comp{1,iSess};
        nTrial = size(comp_sess,1);
        comp_rat(iSess,1:nTrial,:,:) = comp_sess;
    end
    comp_all_before(iRat,:,:,:) = squeeze(mean(comp_rat,1,'omitnan'));
end
plot(t_seg, squeeze(mean(comp_all_before,[1 2],'omitnan'))','LineWidth',1)

nRat = length(After10_Complexity);
comp_all_after10 = NaN(nRat,NTrial,nCh,n_win);
figure
for iRat=1:nRat
    comp = After10_Complexity{iRat,1};
    nSess = size(comp,2);
    comp_rat = NaN(nSess,NTrial,nCh,n_win);
    for iSess=1:nSess
        comp_sess = comp{1,iSess};
        nTrial = size(comp_sess,1);
        comp_rat(iSess,1:nTrial,:,:) = comp_sess;
    end
    comp_all_after10(iRat,:,:,:) = squeeze(mean(comp_rat,1,'omitnan'));
end
plot(t_seg, squeeze(mean(comp_all_after10,[1 2],'omitnan'))','LineWidth',1)

nRat = length(After20_Complexity);
comp_all_after20 = NaN(nRat,NTrial,nCh,n_win);
figure
for iRat=1:nRat
    comp = After20_Complexity{iRat,1};
    nSess = size(comp,2);
    comp_rat = NaN(nSess,NTrial,nCh,n_win);
    for iSess=1:nSess
        comp_sess = comp{1,iSess};
        nTrial = size(comp_sess,1);
        comp_rat(iSess,1:nTrial,:,:) = comp_sess;
    end
    comp_all_after20(iRat,:,:,:) = squeeze(mean(comp_rat,1,'omitnan'));
end
plot(t_seg, squeeze(mean(comp_all_after20,[1 2],'omitnan'))','LineWidth',1)

nRat = length(After30_Complexity);
comp_all_after30 = NaN(nRat,NTrial,nCh,n_win);
figure
for iRat=1:nRat
    comp = After30_Complexity{iRat,1};
    nSess = size(comp,2);
    comp_rat = NaN(nSess,NTrial,nCh,n_win);
    for iSess=1:nSess
        comp_sess = comp{1,iSess};
        nTrial = size(comp_sess,1);
        comp_rat(iSess,1:nTrial,:,:) = comp_sess;
    end
    comp_all_after30(iRat,:,:,:) = squeeze(mean(comp_rat,1,'omitnan'));
end
plot(t_seg, squeeze(mean(comp_all_after30,[1 2],'omitnan'))','LineWidth',1)



figure('WindowState', 'maximized');
sgtitle('Clean all trials')
smooth = 1;
for iCh=1:4   
    subplot(2,2,iCh);
    stdshade(squeeze(mean(comp_all_before(:,:,iCh,:),2,'omitnan')),0.4, 'b', t_seg, smooth); hold on;
    stdshade(squeeze(mean(comp_all_after10(:,:,iCh,:),2,'omitnan')),0.4, 'r', t_seg, smooth);
    stdshade(squeeze(mean(comp_all_after20(:,:,iCh,:),2,'omitnan')),0.4, 'g', t_seg, smooth);
    stdshade(squeeze(mean(comp_all_after30(:,:,iCh,:),2,'omitnan')),0.4, 'm', t_seg, smooth); hold off;
    title(strcat('', ch_labels{1}(iCh)))
    xline(0,'--k','LineWidth',2)
    legend('Before', 'After 10days', 'After 20days', 'After 30days')
    xlabel('Time(sec)')
    ylabel('Complexity - Lpz')
    
%     xlim([0 50])
end

set(gcf,'Units','Inches');
set(gcf,'PaperPosition',[0 0 7 7],'PaperUnits','Inches','PaperSize',[7, 7])
fname = path_res+sprintf('compLpz_allChWinLen200WinSlip20_beforeAfter_allClnTrial');
% print(gcf, '-vector', '-dpng', '-r300', fname+'.png');
% saveas(gcf, fname+'.fig')

%%


figure
iCh=4;
tcl = tiledlayout(1,4);
nexttile()
sgtitle(ch_labels{1}(iCh))
imagesc(t_seg,1:240,squeeze(mean(comp_all_before(:,:,iCh,:),1,'omitnan')))
shading flat; clim([0.1 0.17])
xlabel('Time (sec)');ylabel('Trial')
xline(0,'--k','LineWidth',2)
title('Before')

nexttile()
imagesc(t_seg,1:240,squeeze(mean(comp_all_after10(:,:,iCh,:),1,'omitnan')))
shading flat; clim([0.1 0.17])
xlabel('Time (sec)');ylabel('Trial')
xline(0,'--k','LineWidth',2)
title('Ater10')

nexttile()
imagesc(t_seg,1:240,squeeze(mean(comp_all_after20(:,:,iCh,:),1,'omitnan')))
shading flat; clim([0.1 0.17])
xlabel('Time (sec)');ylabel('Trial')
xline(0,'--k','LineWidth',2)
title('After20')

nexttile()
imagesc(t_seg,1:240,squeeze(mean(comp_all_after30(:,:,iCh,:),1,'omitnan')))
shading flat; clim([0.1 0.17])
xlabel('Time (sec)');ylabel('Trial')
xline(0,'--k','LineWidth',2)
title('After30')

cb = colorbar(); 
cb.Layout.Tile = 'east'; % Assign colorbar location

set(gcf,'Units','Inches');
set(gcf,'PaperPosition',[0 0 8 6],'PaperUnits','Inches','PaperSize',[8, 6])
fname = path_res+sprintf('compLpz_timeTrial_str_WinLen200WinSlip20_beforeAfter_allClnTrial');
% print(gcf, '-vector', '-dpng', '-r300', fname+'.png');
% saveas(gcf, fname+'.fig')

%% find the time of minimum in complexity trend of single trial and plot it through trials
% search window
win_st = find(t_seg>=0.52,1,'first');
win_end = find(t_seg<=0.7,1,'last');
figure
sgtitle('Clean all trials')
smooth = 1;
for iCh=1:4  

%     [min_comp, min_idx] = min(mean(comp_all_before(:,:,iCh,win_st:win_end),1,'omitnan'),[],4,'omitnan');
    [min_comp, min_idx] = min(comp_all_before(:,:,iCh,win_st:win_end),[],4,'omitnan');
    Idx = min_idx+win_st-1;
    t_min_before = t_seg(Idx);
    t_min_before(isnan(min_comp))=NaN;

%     [min_comp, min_idx] = min(mean(comp_all_after10(:,:,iCh,win_st:win_end),1,'omitnan'),[],4,'omitnan');
    [min_comp, min_idx] = min(comp_all_after10(:,:,iCh,win_st:win_end),[],4,'omitnan');
    Idx = min_idx+win_st-1;
    t_min_after10 = t_seg(Idx);
    t_min_after10(isnan(min_comp))=NaN;

%     [min_comp, min_idx] = min(mean(comp_all_after20(:,:,iCh,win_st:win_end),1,'omitnan'),[],4,'omitnan');
    [min_comp, min_idx] = min(comp_all_after20(:,:,iCh,win_st:win_end),[],4,'omitnan');
    Idx = min_idx+win_st-1;
    t_min_after20 = t_seg(Idx);
    t_min_after20(isnan(min_comp))=NaN;

%     [min_comp, min_idx] = min(mean(comp_all_after30(:,:,iCh,win_st:win_end),1,'omitnan'),[],4,'omitnan');
    [min_comp, min_idx] = min(comp_all_after30(:,:,iCh,win_st:win_end),[],4,'omitnan');
    Idx = min_idx+win_st-1;
    t_min_after30 = t_seg(Idx);
    t_min_after30(isnan(min_comp))=NaN;

    subplot(2,2,iCh);
    stdshade(t_min_before, 0.4, 'b',  1:NTrial, smooth); hold on;
    stdshade(t_min_after10, 0.4, 'r',  1:NTrial, smooth);
    stdshade(t_min_after20, 0.4, 'g',  1:NTrial, smooth);
    stdshade(t_min_after30, 0.4, 'm',  1:NTrial, smooth); hold off;
    title(strcat('', ch_labels{1}(iCh)))
    legend('Before', 'After 10days', 'After 20days', 'After 30days')
    xlabel('Trial')
    ylabel('Time (sec)')
    
%     xlim([0 50])
end


%% exponential fit to target sequence
iTarStd = 2; % 1:All, 2:Std, 3:Target

total_dur = cfg.epoch_time(1) + cfg.epoch_time(2);
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * fs;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;
win_st = find(time>=200,1);
win_end = find(time<=400,1,'last');
num_levels = 2;

Before_Complexity = calc_complexity(Before_Data,num_levels,win_st,win_end,iTarStd);
After10_Complexity = calc_complexity(After10_Data,num_levels,win_st,win_end,iTarStd);
After20_Complexity = calc_complexity(After20_Data,num_levels,win_st,win_end,iTarStd);
After30_Complexity = calc_complexity(After30_Data,num_levels,win_st,win_end,iTarStd);

%% mean session per rat
NTrial = 60;
iCh = 3;

input = Before_Complexity;
nRat = length(input);
comp_all = NaN(nRat,NTrial);
for iRat=1:nRat
    waitforbuttonpress;
    comp = input{iRat,1};
    nSess = size(comp,2);
    comp_rat = NaN(nSess,NTrial);
    for iSess=1:nSess
        comp_sess = comp{1,iSess};
        nTrial = min(size(comp_sess,1),NTrial);
        comp_rat(iSess,1:nTrial,:) = comp_sess(1:nTrial,iCh);
    end
    comp_all(iRat,:,:) = mean(comp_rat,1,'omitnan');
    if(any(isnan(mean(comp_rat,1,'omitnan'))))
        beforeparam.A(iRat) = NaN;
        beforeparam.B(iRat) = NaN;
        beforeparam.C(iRat) = NaN;
        continue
    end
    [fitResult, goodnessOfFit] = expFit(1:nTrial,mean(comp_rat,1,'omitnan'));
    beforeparam.A(iRat) = fitResult.a;
    beforeparam.B(iRat) = fitResult.b;
    beforeparam.C(iRat) = fitResult.c;
end


input = After10_Complexity;
nRat = length(input);
comp_all = NaN(nRat,NTrial);
for iRat=1:nRat
    comp = input{iRat,1};
    nSess = size(comp,2);
    comp_rat = NaN(nSess,NTrial);
    for iSess=1:nSess
        comp_sess = comp{1,iSess};
        nTrial = min(size(comp_sess,1),NTrial);
        comp_rat(iSess,1:nTrial,:) = comp_sess(1:nTrial,iCh);
    end
    comp_all(iRat,:,:) = mean(comp_rat,1,'omitnan');
    if(any(isnan(mean(comp_rat,1,'omitnan'))))
        fitResult.a = NaN;fitResult.b = NaN;fitResult.c= NaN;
        after10param.A(iRat) = NaN;
        after10param.B(iRat) = NaN;
        after10param.C(iRat) = NaN;
        continue
    end
    [fitResult, goodnessOfFit] = expFit(1:nTrial,mean(comp_rat,1,'omitnan'));
    after10param.A(iRat) = fitResult.a;
    after10param.B(iRat) = fitResult.b;
    after10param.C(iRat) = fitResult.c;
end

input = After20_Complexity;
nRat = length(input);
comp_all = NaN(nRat,NTrial);
for iRat=1:nRat
    comp = input{iRat,1};
    nSess = size(comp,2);
    comp_rat = NaN(nSess,NTrial);
    for iSess=1:nSess
        comp_sess = comp{1,iSess};
        nTrial = min(size(comp_sess,1),NTrial);
        comp_rat(iSess,1:nTrial,:) = comp_sess(1:nTrial,iCh);
    end
    comp_all(iRat,:,:) = mean(comp_rat,1,'omitnan');
    if(any(isnan(mean(comp_rat,1,'omitnan'))))
        after20param.A(iRat) = NaN;
        after20param.B(iRat) = NaN;
        after20param.C(iRat) = NaN;        
        continue
    end
    [fitResult, goodnessOfFit] = expFit(1:nTrial,mean(comp_rat,1,'omitnan'));
    after20param.A(iRat) = fitResult.a;
    after20param.B(iRat) = fitResult.b;
    after20param.C(iRat) = fitResult.c;
end

input = After30_Complexity;
nRat = length(input);
comp_all = NaN(nRat,NTrial);
for iRat=1:nRat

    comp = input{iRat,1};
    nSess = size(comp,2);
    comp_rat = NaN(nSess,NTrial);
    for iSess=1:nSess
        comp_sess = comp{1,iSess};
        nTrial = min(size(comp_sess,1),NTrial);
        comp_rat(iSess,1:nTrial,:) = comp_sess(1:nTrial,iCh);
    end
    comp_all(iRat,:,:) = mean(comp_rat,1,'omitnan');
    if(any(isnan(mean(comp_rat,1,'omitnan'))))
        after30param.A(iRat) = NaN;
        after30param.B(iRat) = NaN;
        after30param.C(iRat) = NaN;
        continue
    end
    [fitResult, goodnessOfFit] = expFit(1:nTrial,mean(comp_rat,1,'omitnan'));
    after30param.A(iRat) = fitResult.a;
    after30param.B(iRat) = fitResult.b;
    after30param.C(iRat) = fitResult.c;
end
%%
is_connectLine = 1;
colors = cbrewer('seq', 'Blues', 4);
n = 8;
lineColors = 0.7*ones(n, 4); % Initialize an array to hold the colors
for i = 1:n
    hue = (i - 1) / n; % Evenly spaced hues
    rgb = hsv2rgb([hue, 1, 1]); % Convert HSV to RGB
    lineColors(i, 1:3) = rgb; % Convert to 0-255 range
end

xticks_label = {'Before', 'After 10', 'After 20', 'After 30'};
figure
plotDataWithErrorBars(is_connectLine, colors, lineColors, xticks_label, ...
                beforeparam.A, after10param.A, after20param.A, after30param.A)

figure
plotDataWithErrorBars(is_connectLine, colors, lineColors, xticks_label, ...
                beforeparam.B, after10param.B, after20param.B, after30param.B)

figure
plotDataWithErrorBars(is_connectLine, colors, lineColors, xticks_label, ...
                beforeparam.C, after10param.C, after20param.C, after30param.C)