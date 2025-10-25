


clc; close all; clear;

addpath(genpath('./Functions'))
% addpath('./Functions/Visualization')
% addpath('E:\SUT\Neuro-RA\OddBall_Proj\Data\Dataset\')
% eeglab;

path_res = ("D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Results\Complexity\"); 


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
     '5', '1', '1402-09-20', '0';};
    {'7', '1', '1402-12-16', '0'; ...
     '7', '2', '1402-12-16', '0';};
    {%'8', '1', '1403-02-11', '0'; ...
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
         
fs = 250;         
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
    'is_downsample',    1,                       ...
    'fs_down',          250,                     ...
    'is_trZscr',        1,                       ...
    'is_baseline_corr', 0,                       ...
    'pre_norm', 'sig_Zscr'                           ...
);

%% LOAD Data if available instead

save_dir = '../Results/Grand_Avg/Signals/';

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
    
dataName = strcat(dataName1, dataName2, dataName3);

Before_ERP   = load(strcat(save_dir, 'Before_ERP', dataName, '.mat'), 'Before_ERP').Before_ERP;
After10_ERP  = load(strcat(save_dir, 'After10days_ERP', dataName, '.mat'), 'After10_ERP').After10_ERP;
After20_ERP  = load(strcat(save_dir, 'After20days_ERP', dataName, '.mat'), 'After20_ERP').After20_ERP;
After30_ERP  = load(strcat(save_dir, 'After30days_ERP', dataName, '.mat'), 'After30_ERP').After30_ERP;

%%
load('D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Results\Grand_Avg\Signals\sigZscr_eeglab_trZscore\After20days_ERP_trZscr_BseLsig_Zscr.mat')
load('D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Results\Grand_Avg\Signals\sigZscr_eeglab_trZscore\After30days_ERP_trZscr_BseLsig_Zscr.mat')
load('D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Results\Grand_Avg\Signals\sigZscr_eeglab_trZscore\Before_ERP_trZscr_BseLsig_Zscr.mat')
load('D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Results\Grand_Avg\Signals\sigZscr_eeglab_trZscore\After10days_ERP_trZscr_BseLsig_Zscr.mat')
%% Plots

Before_all_ERPs = Before_ERP.All;
After10days_all_ERPs = After10_ERP.All;
After20days_all_ERPs = After20_ERP.All;
After30days_all_ERPs = After30_ERP.All;

Before_target_ERPs = Before_ERP.target;
After10days_target_ERPs = After10_ERP.target;
After20days_target_ERPs = After20_ERP.target;
After30days_target_ERPs = After30_ERP.target;

Before_std_ERPs = Before_ERP.std;
After10days_std_ERPs = After10_ERP.std;
After20days_std_ERPs = After20_ERP.std;
After30days_std_ERPs = After30_ERP.std;
%%
total_dur = cfg.epoch_time(1) + cfg.epoch_time(2);
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * cfg.fs_down;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;
Fs = cfg.fs_down;

twin_len = 0.2;
win_len = twin_len*Fs;
twin_slip = 1/Fs;
win_slip = twin_slip*Fs;
n_win = round((total_dur-twin_len)/twin_slip + 1);
t_seg = -cfg.epoch_time(1)+twin_len/2:twin_slip:cfg.epoch_time(2)-twin_len/2;

num_levels = 2;

input = Before_std_ERPs - Before_target_ERPs;
comp_Before = zeros(n_win,cfg.n_ch,size(input,3));
for iRat = 1:size(input,3)
    for iCh = 1:cfg.n_ch
        sig =  squeeze(input(iCh,:,iRat));
        for iWin=1:n_win   
            sig_win = sig( (iWin-1)*win_slip+1:(iWin-1)*win_slip+win_len );
            [out,P]=lempel_ziv(sig_win,num_levels);
            comp_Before(iWin,iCh,iRat) = out;
        end
    end
end

input = After10days_std_ERPs - After10days_target_ERPs;
comp_After10 = zeros(n_win,cfg.n_ch,size(input,3));
for iRat = 1:size(input,3)
    for iCh = 1:cfg.n_ch
        sig =  squeeze(input(iCh,:,iRat));
        for iWin=1:n_win   
            sig_win = sig( (iWin-1)*win_slip+1:(iWin-1)*win_slip+win_len );
            [out,P]=lempel_ziv(sig_win,num_levels);
            comp_After10(iWin,iCh,iRat) = out;
        end
    end
end

input = After20days_std_ERPs - After20days_target_ERPs;
comp_After20 = zeros(n_win,cfg.n_ch,size(input,3));
for iRat = 1:size(input,3)
    for iCh = 1:cfg.n_ch
        sig =  squeeze(input(iCh,:,iRat));
        for iWin=1:n_win   
            sig_win = sig( (iWin-1)*win_slip+1:(iWin-1)*win_slip+win_len );
            [out,P]=lempel_ziv(sig_win,num_levels);
            comp_After20(iWin,iCh,iRat) = out;
        end
    end
end

input = After30days_std_ERPs - After30days_target_ERPs;
comp_After30 = zeros(n_win,cfg.n_ch,size(input,3));
for iRat = 1:size(input,3)
    for iCh = 1:cfg.n_ch
        sig =  squeeze(input(iCh,:,iRat));
        for iWin=1:n_win   
            sig_win = sig( (iWin-1)*win_slip+1:(iWin-1)*win_slip+win_len );
            [out,P]=lempel_ziv(sig_win,num_levels);
            comp_After30(iWin,iCh,iRat) = out;
        end
    end
end
%%
figure
iCh = 3;
plot(t_seg,squeeze(mean(comp_Before(:,iCh,2:end),3)))
hold on
plot(t_seg,squeeze(mean(comp_After10(:,iCh,2:end),3)))
plot(t_seg,squeeze(mean(comp_After20(:,iCh,:),3)))
plot(t_seg,squeeze(mean(comp_After30(:,iCh,:),3)))


figure
smooth = 10;
stdshade(squeeze(comp_Before(:,iCh,2:end))',0.4,'b',t_seg,smooth)
hold on
stdshade(squeeze(comp_After10(:,iCh,2:end))',0.4,'r',t_seg,smooth)
stdshade(squeeze(comp_After20(:,iCh,:))',0.4,'g',t_seg,smooth)
stdshade(squeeze(comp_After30(:,iCh,:))',0.4,'m',t_seg,smooth)

%%
sgtitle('Complexity of ERP(Per rat)')
smooth = 10;
for iCh=1:4   
    subplot(2,2,iCh);
    stdshade(squeeze(comp_Before(:,iCh,2:end))',0.4, 'b', t_seg, smooth); hold on;
    stdshade(squeeze(comp_After10(:,iCh,2:end))',0.4, 'r', t_seg, smooth);
    stdshade(squeeze(comp_After20(:,iCh,:))',0.4, 'g', t_seg, smooth);
    stdshade(squeeze(comp_After30(:,iCh,:))',0.4, 'm', t_seg, smooth); hold off;
    title(strcat('', ch_labels{1}(iCh)))
    xline(0,'--k','LineWidth',2)
    legend('Before', 'After 10days', 'After 20days', 'After 30days')
    xlabel('Time(sec)')
    ylabel('Complexity - Lpz')
    
%     xlim([0 50])
end



set(gcf,'Units','Inches');
set(gcf,'PaperPosition',[0 0 7 7],'PaperUnits','Inches','PaperSize',[7, 7])
fname = path_res+sprintf('compLpz_allChWinLen200WinSlip20_beforeAfter_ERPofallClnTrial');
% print(gcf, '-vector', '-dpng', '-r300', fname+'.png');
% saveas(gcf, fname+'.fig')

