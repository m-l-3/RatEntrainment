
clc; 
clear;
% close all;

addpath(genpath('./Functions'))
addpath(genpath("D:\Documents\SUT Ph.D\Research\Matlab codes\chronux_2_12"));
addpath("D:\Documents\SUT Ph.D\Research\Matlab codes\eeglab2023.1")
addpath('D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Dataset\')

path_res = ("D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Results\Pow_spec\"); 

%% Load Data and PreProcess

clc;

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


save_dir = '../Results/Signals/sigZscr_eeglab_trZscore_0.1-100Hz/';
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
After10_Data  = load(strcat(save_dir, 'After10days_Data', dataName, '.mat')).After10days_Data;
After20_Data  = load(strcat(save_dir, 'After20days_Data', dataName, '.mat')).After20days_Data;
After30_Data  = load(strcat(save_dir, 'After30days_Data', dataName, '.mat')).After30days_Data;

if(cfg.is_downsample)
    fs = cfg.fs_down;
else
    fs = cfg.fs;
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 2D %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%% calculation
states = ["All", "Std.", "Target", "Diff."];
iTarStd = 1; % 1:All, 2:Std, 3:Target
useERP = false;
useClean = true;
params.tapers = [3 5];
params.pad = -1;
params.Fs = fs;
params.fpass = [0 300];
params.trialave = 1;

total_dur = cfg.epoch_time(1) + cfg.epoch_time(2);
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * fs;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;

twin_len = 1;
win_len = twin_len*fs;
twin_slip = 0.05;
win_slip = twin_slip*fs;

n_win = round((total_dur-twin_len)/twin_slip + 1);
t_seg = -cfg.epoch_time(1)+twin_len/2:twin_slip:cfg.epoch_time(2)-twin_len/2;

[t,f,Before_Spec] = calc_specgram(Before_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After10_Spec] = calc_specgram(After10_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After20_Spec] = calc_specgram(After20_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After30_Spec] = calc_specgram(After30_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
n_f  = numel(f);
if(numel(t)~=numel(t_seg))
    warning('Somthing went wrong in timing')
end

%% mean session per rat
nCh = 4;
input = Before_Spec;
nRat = length(input);
spec_all_before = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec = input{iRat,1};
    nSess = size(spec,2);
    spec_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_sess = spec{1,iSess};
        spec_rat(iSess,:,:,:) = spec_sess;
    end
    spec_all_before(iRat,:,:,:) = mean(spec_rat,1,'omitnan');
end

input = After10_Spec;
nRat = length(input);
spec_all_after10 = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec = input{iRat,1};
    nSess = size(spec,2);
    spec_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_sess = spec{1,iSess};
        spec_rat(iSess,:,:,:) = spec_sess;
    end
    spec_all_after10(iRat,:,:,:) = mean(spec_rat,1,'omitnan');
end

input = After20_Spec;
nRat = length(input);
spec_all_after20 = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec = input{iRat,1};
    nSess = size(spec,2);
    spec_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_sess = spec{1,iSess};
        spec_rat(iSess,:,:,:) = spec_sess;
    end
    spec_all_after20(iRat,:,:,:) = mean(spec_rat,1,'omitnan');
end
spec_all_after20 = cat(1,NaN([1, size(spec_sess)]),NaN([1, size(spec_sess)]),spec_all_after20);


input = After30_Spec;
nRat = length(input);
spec_all_after30 = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec = input{iRat,1};
    nSess = size(spec,2);
    spec_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_sess = spec{1,iSess};
        spec_rat(iSess,:,:,:) = spec_sess;
    end
    spec_all_after30(iRat,:,:,:) = mean(spec_rat,1,'omitnan');
end
spec_all_after30 = cat(1,NaN([1, size(spec_sess)]),NaN([1, size(spec_sess)]),NaN([1, size(spec_sess)]),spec_all_after30);

%% mean over rats
% plotting and saving
% close all
freq_ranges = [150 300
               90 150
               60 90;
               30 60;
               12 30
               8 12;
               4 8];
sizes = [7 6 5 5 5 3 2 2];
t_ranges = t_seg>=-1.5 & t_seg<=2;
for iCh = 1:nCh
    lw = 2;
    
    input1 = squeeze(mean(spec_all_before(2:end,:,:,iCh),1,'omitnan'));
    input2 = squeeze(mean(spec_all_after10(2:end,:,:,iCh),1,'omitnan'));
    input3 = squeeze(mean(spec_all_after20(2:end,:,:,iCh),1,'omitnan'));
    input4 = squeeze(mean(spec_all_after30(2:end,:,:,iCh),1,'omitnan'));
    input = cat(3,input1,input2,input3,input4);
    leg = ["Before", "After10", "After20", "After30"];
    
    plot_multi_band_specgram (input,t_seg,f,freq_ranges,t_ranges,sizes,lw,leg)
    sgtitle(sprintf('%s clean trials\n%s', states(iTarStd), ch_labels{1}(iCh)))
    
    set(gcf,'Units','Inches');
    set(gcf,'PaperPosition',[0 0 9 9],'PaperUnits','Inches','PaperSize',[9, 9])
%     fname = path_res+sprintf('mtspecgram_%sWinLen500WinSlip20_beforeAfter_meanof%sClnTrial',  ch_labels{1}(iCh), states(iTarStd));
%     print(gcf, '-vector', '-dpng', '-r300', fname+'.png');
%     saveas(gcf, fname+'.fig')
end

%% calculation of diff
states = ["All", "Std.", "Target", "Diff."];
iTarStd = 3; % 1:All, 2:Std, 3:Target
useERP = 0;
useClean = true;
params.tapers = [0.5 3];
params.pad = -1;
params.Fs = cfg.fs;
params.fpass = [0 90];
params.trialave = 1;

total_dur = cfg.epoch_time(1) + cfg.epoch_time(2);
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * fs;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;

twin_len = 0.5;
win_len = twin_len*fs;
twin_slip = 0.02;
win_slip = twin_slip*fs;

n_win = round((total_dur-twin_len)/twin_slip + 1);
t_seg = -cfg.epoch_time(1)+twin_len/2:twin_slip:cfg.epoch_time(2)-twin_len/2;

[t,f,Before_Spec_Target] = calc_specgram(Before_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After10_Spec_Target] = calc_specgram(After10_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After20_Spec_Target] = calc_specgram(After20_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After30_Spec_Target] = calc_specgram(After30_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
n_f  = numel(f);
if(numel(t)~=numel(t_seg))
    warning('Somthing went wrong in timing')
end

iTarStd = 2; % 1:All, 2:Std, 3:Target
[t,f,Before_Spec_Std] = calc_specgram(Before_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After10_Spec_Std] = calc_specgram(After10_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After20_Spec_Std] = calc_specgram(After20_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After30_Spec_Std] = calc_specgram(After30_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
n_f  = numel(f);
if(numel(t)~=numel(t_seg))
    warning('Somthing went wrong in timing')
end


%% mean session per rat
nCh = 4;
input_tar = Before_Spec_Target;
input_std = Before_Spec_Std;
nRat = length(input_tar);
spec_all_before_diff = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec_tar = input_tar{iRat,1};
    spec_std = input_std{iRat,1};
    nSess = size(spec_tar,2);
    spec_diff_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_tarSess = spec_tar{1,iSess};
        spec_stdSess = spec_std{1,iSess};
        spec_diff_rat(iSess,:,:,:) = spec_tarSess- spec_stdSess;
    end
    spec_all_before_diff(iRat,:,:,:) = mean(spec_diff_rat,1,'omitnan');
end

input_tar = After10_Spec_Target;
input_std = After10_Spec_Std;
nRat = length(input_tar);
spec_all_after10_diff = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec_tar = input_tar{iRat,1};
    spec_std = input_std{iRat,1};
    nSess = size(spec_tar,2);
    spec_tar_rat = NaN(nSess,n_win,n_f,nCh);
    spec_std_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_tarSess = spec_tar{1,iSess};
        spec_stdSess = spec_std{1,iSess};
        spec_diff_rat(iSess,:,:,:) = spec_tarSess- spec_stdSess;
    end
    spec_all_after10_diff(iRat,:,:,:) = mean(spec_diff_rat,1,'omitnan');
end

input_tar = After20_Spec_Target;
input_std = After20_Spec_Std;
nRat = length(input_tar);
spec_all_after20_diff = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec_tar = input_tar{iRat,1};
    spec_std = input_std{iRat,1};
    nSess = size(spec_tar,2);
    spec_tar_rat = NaN(nSess,n_win,n_f,nCh);
    spec_std_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_tarSess = spec_tar{1,iSess};
        spec_stdSess = spec_std{1,iSess};
        spec_diff_rat(iSess,:,:,:) = spec_tarSess- spec_stdSess;
    end
    spec_all_after20_diff(iRat,:,:,:) = mean(spec_diff_rat,1,'omitnan');
end


input_tar = After30_Spec_Target;
input_std = After30_Spec_Std;
nRat = length(input_tar);
spec_all_after30_diff = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec_tar = input_tar{iRat,1};
    spec_std = input_std{iRat,1};
    nSess = size(spec_tar,2);
    spec_tar_rat = NaN(nSess,n_win,n_f,nCh);
    spec_std_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_tarSess = spec_tar{1,iSess};
        spec_stdSess = spec_std{1,iSess};
        spec_diff_rat(iSess,:,:,:) = spec_tarSess- spec_stdSess;
    end
    spec_all_after30_diff(iRat,:,:,:) = mean(spec_diff_rat,1,'omitnan');
end

%% diff plot
% plotting and saving
iTarStd = 4;
balance_cb = true;
for iCh = 1:nCh
    lw = 2;
    freq_ranges = [60 90;
                   30 60;
                   12 30
                   8 12
                   4 8];
    sizes = [5 5 3 2 2];
    
    input1 = squeeze(mean(spec_all_before_diff(:,:,:,iCh),1,'omitnan'));
    input2 = squeeze(mean(spec_all_after10_diff(:,:,:,iCh),1,'omitnan'));
    input3 = squeeze(mean(spec_all_after20_diff(:,:,:,iCh),1,'omitnan'));
    input4 = squeeze(mean(spec_all_after30_diff(:,:,:,iCh),1,'omitnan'));
    input = cat(3,input1,input2,input3,input4);
    leg = ["Before", "After10", "After20", "After30"];
    
    plot_multi_band_specgram (input,t_seg,f,freq_ranges,sizes,lw,leg,balance_cb)
    sgtitle(sprintf('%s clean trials\n%s', states(iTarStd), ch_labels{1}(iCh)))
    
    set(gcf,'Units','Inches');
    set(gcf,'PaperPosition',[0 0 9 9],'PaperUnits','Inches','PaperSize',[9, 9])
    fname = path_res+sprintf('mtspecgram_%sWinLen500WinSlip20_beforeAfter_meanof%sClnTrial',  ch_labels{1}(iCh), states(iTarStd));
%     print(gcf, '-vector', '-dpng', '-r300', fname+'.png');
%     saveas(gcf, fname+'.fig')
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% over ERP signal
%% calculation
useERP = 1;
states = ["All", "Std.", "Target", "Diff."];
iTarStd = 1; % 1:All, 2:Std, 3:Target
useClean = true;
params.tapers = [0.5 3];
params.pad = -1;
params.Fs = cfg.fs;
params.fpass = [0 90];
params.trialave = 1;

total_dur = cfg.epoch_time(1) + cfg.epoch_time(2);
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * fs;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;

twin_len = 0.5;
win_len = twin_len*fs;
twin_slip = 0.02;
win_slip = twin_slip*fs;

n_win = round((total_dur-twin_len)/twin_slip + 1);
t_seg = -cfg.epoch_time(1)+twin_len/2:twin_slip:cfg.epoch_time(2)-twin_len/2;

[t,f,Before_Spec] = calc_specgram(Before_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After10_Spec] = calc_specgram(After10_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After20_Spec] = calc_specgram(After20_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After30_Spec] = calc_specgram(After30_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
n_f  = numel(f);
if(numel(t)~=numel(t_seg))
    warning('Somthing went wrong in timing')
end

%% mean session per rat
nCh = 4;
input = Before_Spec;
nRat = length(input);
spec_all_before = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec = input{iRat,1};
    nSess = size(spec,2);
    spec_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_sess = spec{1,iSess};
        spec_rat(iSess,:,:,:) = spec_sess;
    end
    spec_all_before(iRat,:,:,:) = mean(spec_rat,1,'omitnan');
end

input = After10_Spec;
nRat = length(input);
spec_all_after10 = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec = input{iRat,1};
    nSess = size(spec,2);
    spec_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_sess = spec{1,iSess};
        spec_rat(iSess,:,:,:) = spec_sess;
    end
    spec_all_after10(iRat,:,:,:) = mean(spec_rat,1,'omitnan');
end

input = After20_Spec;
nRat = length(input);
spec_all_after20 = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec = input{iRat,1};
    nSess = size(spec,2);
    spec_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_sess = spec{1,iSess};
        spec_rat(iSess,:,:,:) = spec_sess;
    end
    spec_all_after20(iRat,:,:,:) = mean(spec_rat,1,'omitnan');
end

input = After30_Spec;
nRat = length(input);
spec_all_after30 = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec = input{iRat,1};
    nSess = size(spec,2);
    spec_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_sess = spec{1,iSess};
        spec_rat(iSess,:,:,:) = spec_sess;
    end
    spec_all_after30(iRat,:,:,:) = mean(spec_rat,1,'omitnan');
end

%% mean over rats
% plotting and saving
lw = 2;
freq_ranges = [60 90;
    30 60;
    12 30
    8 12
    4 8];
sizes = [5 5 3 2 2];
t_ranges = t_seg>=-1.5 & t_seg<=2;

for iCh = 1:nCh
    
    input1 = squeeze(mean(spec_all_before(:,:,:,iCh),1,'omitnan'));
    input2 = squeeze(mean(spec_all_after10(:,:,:,iCh),1,'omitnan'));
    input3 = squeeze(mean(spec_all_after20(:,:,:,iCh),1,'omitnan'));
    input4 = squeeze(mean(spec_all_after30(:,:,:,iCh),1,'omitnan'));
    input = cat(3,input1,input2,input3,input4);
    leg = ["Before", "After10", "After20", "After30"];
    
    plot_multi_band_specgram (input,t_seg,f,freq_ranges,t_ranges,sizes,lw,leg)
    sgtitle(sprintf('ERP of %s clean trials\n%s', states(iTarStd), ch_labels{1}(iCh)))
    
    set(gcf,'Units','Inches');
    set(gcf,'PaperPosition',[0 0 9 9],'PaperUnits','Inches','PaperSize',[9, 9])
    fname = path_res+sprintf('mtspecgram_%sWinLen500WinSlip20_beforeAfter_ERPof%sClnTrial',  ch_labels{1}(iCh), states(iTarStd));
%     print(gcf, '-vector', '-dpng', '-r300', fname+'.png');
%     saveas(gcf, fname+'.fig')
end

%% calculation of diff
useERP = 1;
states = ["All", "Std.", "Target", "Diff."];
iTarStd = 3; % 1:All, 2:Std, 3:Target
useClean = true;
params.tapers = [0.5 3];
params.pad = -1;
params.Fs = cfg.fs;
params.fpass = [0 90];
params.trialave = 1;

total_dur = cfg.epoch_time(1) + cfg.epoch_time(2);
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * fs;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;

twin_len = 0.5;
win_len = twin_len*fs;
twin_slip = 0.02;
win_slip = twin_slip*fs;

n_win = round((total_dur-twin_len)/twin_slip + 1);
t_seg = -cfg.epoch_time(1)+twin_len/2:twin_slip:cfg.epoch_time(2)-twin_len/2;

[t,f,Before_Spec_Target] = calc_specgram(Before_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After10_Spec_Target] = calc_specgram(After10_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After20_Spec_Target] = calc_specgram(After20_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After30_Spec_Target] = calc_specgram(After30_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
n_f  = numel(f);
if(numel(t)~=numel(t_seg))
    warning('Somthing went wrong in timing')
end

iTarStd = 2; % 1:All, 2:Std, 3:Target
[t,f,Before_Spec_Std] = calc_specgram(Before_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After10_Spec_Std] = calc_specgram(After10_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After20_Spec_Std] = calc_specgram(After20_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After30_Spec_Std] = calc_specgram(After30_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
n_f  = numel(f);
if(numel(t)~=numel(t_seg))
    warning('Somthing went wrong in timing')
end


%% mean session per rat
nCh = 4;
input_tar = Before_Spec_Target;
input_std = Before_Spec_Std;
nRat = length(input_tar);
spec_all_before_diff = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec_tar = input_tar{iRat,1};
    spec_std = input_std{iRat,1};
    nSess = size(spec_tar,2);
    spec_diff_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_tarSess = spec_tar{1,iSess};
        spec_stdSess = spec_std{1,iSess};
        spec_diff_rat(iSess,:,:,:) = spec_tarSess- spec_stdSess;
    end
    spec_all_before_diff(iRat,:,:,:) = mean(spec_diff_rat,1,'omitnan');
end

input_tar = After10_Spec_Target;
input_std = After10_Spec_Std;
nRat = length(input_tar);
spec_all_after10_diff = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec_tar = input_tar{iRat,1};
    spec_std = input_std{iRat,1};
    nSess = size(spec_tar,2);
    spec_tar_rat = NaN(nSess,n_win,n_f,nCh);
    spec_std_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_tarSess = spec_tar{1,iSess};
        spec_stdSess = spec_std{1,iSess};
        spec_diff_rat(iSess,:,:,:) = spec_tarSess- spec_stdSess;
    end
    spec_all_after10_diff(iRat,:,:,:) = mean(spec_diff_rat,1,'omitnan');
end

input_tar = After20_Spec_Target;
input_std = After20_Spec_Std;
nRat = length(input_tar);
spec_all_after20_diff = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec_tar = input_tar{iRat,1};
    spec_std = input_std{iRat,1};
    nSess = size(spec_tar,2);
    spec_tar_rat = NaN(nSess,n_win,n_f,nCh);
    spec_std_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_tarSess = spec_tar{1,iSess};
        spec_stdSess = spec_std{1,iSess};
        spec_diff_rat(iSess,:,:,:) = spec_tarSess- spec_stdSess;
    end
    spec_all_after20_diff(iRat,:,:,:) = mean(spec_diff_rat,1,'omitnan');
end


input_tar = After30_Spec_Target;
input_std = After30_Spec_Std;
nRat = length(input_tar);
spec_all_after30_diff = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec_tar = input_tar{iRat,1};
    spec_std = input_std{iRat,1};
    nSess = size(spec_tar,2);
    spec_tar_rat = NaN(nSess,n_win,n_f,nCh);
    spec_std_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_tarSess = spec_tar{1,iSess};
        spec_stdSess = spec_std{1,iSess};
        spec_diff_rat(iSess,:,:,:) = spec_tarSess- spec_stdSess;
    end
    spec_all_after30_diff(iRat,:,:,:) = mean(spec_diff_rat,1,'omitnan');
end

%% diff plot
% plotting and saving
iTarStd = 4;
balance_cb = true;
for iCh = 1:nCh
    lw = 2;
    freq_ranges = [60 90;
                   30 60;
                   12 30
                   8 12
                   4 8];
    sizes = [5 5 3 2 2];
    
    input1 = squeeze(mean(spec_all_before_diff(:,:,:,iCh),1,'omitnan'));
    input2 = squeeze(mean(spec_all_after10_diff(:,:,:,iCh),1,'omitnan'));
    input3 = squeeze(mean(spec_all_after20_diff(:,:,:,iCh),1,'omitnan'));
    input4 = squeeze(mean(spec_all_after30_diff(:,:,:,iCh),1,'omitnan'));
    input = cat(3,input1,input2,input3,input4);
    leg = ["Before", "After10", "After20", "After30"];
    
    plot_multi_band_specgram (input,t_seg,f,freq_ranges,sizes,lw,leg,balance_cb)
    sgtitle(sprintf('%s clean trials (ERP first)\n%s', states(iTarStd), ch_labels{1}(iCh)))
    
    set(gcf,'Units','Inches');
    set(gcf,'PaperPosition',[0 0 9 9],'PaperUnits','Inches','PaperSize',[9, 9])
    fname = path_res+sprintf('mtspecgram_%sWinLen500WinSlip20_beforeAfter_ERPof%sClnTrial',  ch_labels{1}(iCh), states(iTarStd));
%     print(gcf, '-vector', '-dpng', '-r300', fname+'.png');
%     saveas(gcf, fname+'.fig')
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 1D %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%% calculation of std and target
useERP = 0;
states = ["All", "Std.", "Target", "Diff."];
iTarStd = 3; % 1:All, 2:Std, 3:Target
useClean = true;
params.tapers = [3 5];
params.pad = -1;
params.Fs = cfg.fs;
params.fpass = [0 90];
params.trialave = 1;

total_dur = cfg.epoch_time(1) + cfg.epoch_time(2);
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * fs;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;

twin_len = 1;
win_len = twin_len*fs;
twin_slip = 0.05;
win_slip = twin_slip*fs;

n_win = round((total_dur-twin_len)/twin_slip + 1);
t_seg = -cfg.epoch_time(1)+twin_len/2:twin_slip:cfg.epoch_time(2)-twin_len/2;

[t,f,Before_Spec_Target] = calc_specgram(Before_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After10_Spec_Target] = calc_specgram(After10_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After20_Spec_Target] = calc_specgram(After20_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After30_Spec_Target] = calc_specgram(After30_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
n_f  = numel(f);
if(numel(t)~=numel(t_seg))
    warning('Somthing went wrong in timing')
end

iTarStd = 2; % 1:All, 2:Std, 3:Target
[t,f,Before_Spec_Std] = calc_specgram(Before_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After10_Spec_Std] = calc_specgram(After10_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After20_Spec_Std] = calc_specgram(After20_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After30_Spec_Std] = calc_specgram(After30_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
n_f  = numel(f);
if(numel(t)~=numel(t_seg))
    warning('Somthing went wrong in timing')
end


iTarStd = 1; % 1:All, 2:Std, 3:Target
[t,f,Before_Spec_All] = calc_specgram(Before_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After10_Spec_All] = calc_specgram(After10_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After20_Spec_All] = calc_specgram(After20_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After30_Spec_All] = calc_specgram(After30_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
n_f  = numel(f);
if(numel(t)~=numel(t_seg))
    warning('Somthing went wrong in timing')
end

%% mean session per rat
nCh = 4;
input_tar = Before_Spec_Target;
input_std = Before_Spec_Std;
input_all = Before_Spec_All;
nRat = length(input_tar);
spec_all_before_target = NaN(nRat,n_win,n_f,nCh);
spec_all_before_std = NaN(nRat,n_win,n_f,nCh);
spec_all_before_all = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec_tar = input_tar{iRat,1};
    spec_std = input_std{iRat,1};
    spec_all = input_all{iRat,1};
    nSess = size(spec_tar,2);
    spec_tar_rat = NaN(nSess,n_win,n_f,nCh);
    spec_std_rat = NaN(nSess,n_win,n_f,nCh);
    spec_all_rat = NaN(nSess,n_win,n_f,nCh);
    if iRat==5, inSess = 1; elseif iRat==6, inSess = 3; else inSess = 1; end
    for iSess=inSess:nSess
        spec_tarSess = spec_tar{1,iSess};
        spec_stdSess = spec_std{1,iSess};
        spec_allSess = spec_all{1,iSess};
        spec_tar_rat(iSess,:,:,:) = spec_tarSess;
        spec_std_rat(iSess,:,:,:) = spec_stdSess;
        spec_all_rat(iSess,:,:,:) = spec_allSess;
    end
    spec_all_before_target(iRat,:,:,:) = mean(spec_tar_rat,1,'omitnan');
    spec_all_before_std(iRat,:,:,:) = mean(spec_std_rat,1,'omitnan');
    spec_all_before_all(iRat,:,:,:) = mean(spec_all_rat,1,'omitnan');
end

input_tar = After10_Spec_Target;
input_std = After10_Spec_Std;
input_all = After10_Spec_All;
nRat = length(input_tar);
spec_all_after10_target = NaN(nRat,n_win,n_f,nCh);
spec_all_after10_std = NaN(nRat,n_win,n_f,nCh);
spec_all_after10_all = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec_tar = input_tar{iRat,1};
    spec_std = input_std{iRat,1};
    spec_all = input_all{iRat,1};
    nSess = size(spec_tar,2);
    spec_tar_rat = NaN(nSess,n_win,n_f,nCh);
    spec_std_rat = NaN(nSess,n_win,n_f,nCh);
    spec_all_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_tarSess = spec_tar{1,iSess};
        spec_stdSess = spec_std{1,iSess};
        spec_allSess = spec_all{1,iSess};
        spec_tar_rat(iSess,:,:,:) = spec_tarSess;
        spec_std_rat(iSess,:,:,:) = spec_stdSess;
        spec_all_rat(iSess,:,:,:) = spec_allSess;
    end
    spec_all_after10_target(iRat,:,:,:) = mean(spec_tar_rat,1,'omitnan');
    spec_all_after10_std(iRat,:,:,:) = mean(spec_std_rat,1,'omitnan');
    spec_all_after10_all(iRat,:,:,:) = mean(spec_all_rat,1,'omitnan');
end

input_tar = After20_Spec_Target;
input_std = After20_Spec_Std;
input_all = After20_Spec_All;
nRat = length(input_tar);
spec_all_after20_target = NaN(nRat,n_win,n_f,nCh);
spec_all_after20_std = NaN(nRat,n_win,n_f,nCh);
spec_all_after20_all = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec_tar = input_tar{iRat,1};
    spec_std = input_std{iRat,1};
    spec_all = input_all{iRat,1};
    nSess = size(spec_tar,2);
    spec_tar_rat = NaN(nSess,n_win,n_f,nCh);
    spec_std_rat = NaN(nSess,n_win,n_f,nCh);
    spec_all_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_tarSess = spec_tar{1,iSess};
        spec_stdSess = spec_std{1,iSess};
        spec_allSess = spec_all{1,iSess};
        spec_tar_rat(iSess,:,:,:) = spec_tarSess;
        spec_std_rat(iSess,:,:,:) = spec_stdSess;
        spec_all_rat(iSess,:,:,:) = spec_allSess;
    end
    spec_all_after20_target(iRat,:,:,:) = mean(spec_tar_rat,1,'omitnan');
    spec_all_after20_std(iRat,:,:,:) = mean(spec_std_rat,1,'omitnan');
    spec_all_after20_all(iRat,:,:,:) = mean(spec_all_rat,1,'omitnan');
end
spec_all_after20_target = cat(1,NaN([1 size(spec_tarSess)]),NaN([1 size(spec_tarSess)]),spec_all_after20_target);
spec_all_after20_std = cat(1,NaN([1 size(spec_stdSess)]),NaN([1 size(spec_stdSess)]),spec_all_after20_std);
spec_all_after20_all = cat(1,NaN([1 size(spec_allSess)]),NaN([1 size(spec_allSess)]),spec_all_after20_all);


input_tar = After30_Spec_Target;
input_std = After30_Spec_Std;
input_all = After30_Spec_All;
nRat = length(input_tar);
spec_all_after30_target = NaN(nRat,n_win,n_f,nCh);
spec_all_after30_std = NaN(nRat,n_win,n_f,nCh);
spec_all_after30_all = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec_tar = input_tar{iRat,1};
    spec_std = input_std{iRat,1};
    spec_all = input_all{iRat,1};
    nSess = size(spec_tar,2);
    spec_tar_rat = NaN(nSess,n_win,n_f,nCh);
    spec_std_rat = NaN(nSess,n_win,n_f,nCh);
    spec_all_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_tarSess = spec_tar{1,iSess};
        spec_stdSess = spec_std{1,iSess};
        spec_allSess = spec_all{1,iSess};
        spec_tar_rat(iSess,:,:,:) = spec_tarSess;
        spec_std_rat(iSess,:,:,:) = spec_stdSess;
        spec_all_rat(iSess,:,:,:) = spec_allSess;
    end
    spec_all_after30_target(iRat,:,:,:) = mean(spec_tar_rat,1,'omitnan');
    spec_all_after30_std(iRat,:,:,:) = mean(spec_std_rat,1,'omitnan');
    spec_all_after30_all(iRat,:,:,:) = mean(spec_all_rat,1,'omitnan');
end
spec_all_after30_target = cat(1,NaN([1 size(spec_tarSess)]),NaN([1 size(spec_tarSess)]),NaN([1 size(spec_tarSess)]),spec_all_after30_target);
spec_all_after30_std = cat(1,NaN([1 size(spec_stdSess)]),NaN([1 size(spec_stdSess)]),NaN([1 size(spec_stdSess)]),spec_all_after30_std);
spec_all_after30_all = cat(1,NaN([1 size(spec_allSess)]),NaN([1 size(spec_allSess)]),NaN([1 size(spec_allSess)]),spec_all_after30_all);

%% tar/std in same subplot, before after in different subplot
smth = 1;
lw = 2;
freq_ranges = [60 90;
               30 60;
               12 30
               8 12
               4 8];
colors = ['b','r'];
    
for iCh = 1:nCh
    
    input1_target = spec_all_before_target(2:end,:,:,iCh);
    input2_target = spec_all_after10_target(2:end,:,:,iCh);
    input3_target = spec_all_after20_target(2:end,:,:,iCh);
    input4_target = spec_all_after30_target(2:end,:,:,iCh);
    input1 = {input1_target,input2_target,input3_target,input4_target};

    input1_std = spec_all_before_std(2:end,:,:,iCh);
    input2_std = spec_all_after10_std(2:end,:,:,iCh);
    input3_std = spec_all_after20_std(2:end,:,:,iCh);
    input4_std = spec_all_after30_std(2:end,:,:,iCh);
    input2 = {input1_std,input2_std,input3_std,input4_std};

    input = cat(1,input1,input2);
    titles = ["Before", "After10", "After20", "After30"];
    leg = ["Target","Std."];
    plot_multi_band_power(input,t_seg,f,freq_ranges,smth,lw,titles,leg,colors)
    sgtitle(sprintf('Band Power - ERP of clean trials\n%s', ch_labels{1}(iCh)))
    
    set(gcf,'Units','Inches');
    set(gcf,'PaperPosition',[0 0 9 9],'PaperUnits','Inches','PaperSize',[9, 9])
    fname = path_res+sprintf('bandPow_%sWinLen500WinSlip20_beforeAfter_ERPofTarStdClnTrial',  ch_labels{1}(iCh));
%     print(gcf, '-vector', '-dpng', '-r300', fname+'.png');
%     saveas(gcf, fname+'.fig')
end

%% tar/std in different subplot, before after in same subplot
smth = 1;
lw = 2;
freq_ranges = [60 90;
               30 60;
               12 30
               8 12
               4 8];
colors = ['b','r','g','m'];    
for iCh = 1:nCh
    
    input_all = spec_all_before_all(2:end,:,:,iCh);
    input_target = spec_all_before_target(2:end,:,:,iCh);
    input_std = spec_all_before_std(2:end,:,:,iCh);
    input_diff = spec_all_before_target(2:end,:,:,iCh) - spec_all_before_std(2:end,:,:,iCh);
    input_before = {input_all,input_target,input_std,input_diff};

    input_all = spec_all_after10_all(2:end,:,:,iCh);
    input_target = spec_all_after10_target(2:end,:,:,iCh);
    input_std = spec_all_after10_std(2:end,:,:,iCh);
    input_diff = spec_all_after10_target(2:end,:,:,iCh) - spec_all_after10_std(2:end,:,:,iCh);
    input_after10 = {input_all,input_target,input_std,input_diff};

    input_all = spec_all_after20_all(2:end,:,:,iCh);
    input_target = spec_all_after20_target(2:end,:,:,iCh);
    input_std = spec_all_after20_std(2:end,:,:,iCh);
    input_diff = spec_all_after20_target(2:end,:,:,iCh) - spec_all_after20_std(2:end,:,:,iCh);
    input_after20 = {input_all,input_target,input_std,input_diff};

    input_all = spec_all_after30_all(2:end,:,:,iCh);
    input_target = spec_all_after30_target(2:end,:,:,iCh);
    input_std = spec_all_after30_std(2:end,:,:,iCh);
    input_diff = spec_all_after30_target(2:end,:,:,iCh) - spec_all_after30_std(2:end,:,:,iCh);
    input_after30 = {input_all,input_target,input_std,input_diff};

    input = cat(1,input_before,input_after10,input_after20,input_after30);
    titles = ["All", "Target", "Std.", "Diff."];
    leg = ["Before","After10","After20","After30"];
    plot_multi_band_power(input,t_seg,f,freq_ranges,smth,lw,titles,leg,colors)
    sgtitle(sprintf('Band Power - clean trials\n%s', ch_labels{1}(iCh)))
    
    set(gcf,'Units','Inches');
    set(gcf,'PaperPosition',[0 0 9 9],'PaperUnits','Inches','PaperSize',[9, 9])
    fname = path_res+sprintf('bandPow2_%sWinLen500WinSlip20_beforeAfter_TarStdClnTrial',  ch_labels{1}(iCh));
%     print(gcf, '-vector', '-dpng', '-r300', fname+'.png');
%     saveas(gcf, fname+'.fig')
end

%% tar/std in different subplot, before after in same subplot 1d over freq.
smth = 1;
lw = 2;
freq_ranges = [0 300];
colors = ['b','r','g','m'];    
for iCh = 1:nCh
    
    input_all = spec_all_before_all(2:end,:,:,iCh);
    input_target = spec_all_before_target(2:end,:,:,iCh);
    input_std = spec_all_before_std(2:end,:,:,iCh);
    input_diff = spec_all_before_target(2:end,:,:,iCh) - spec_all_before_std(2:end,:,:,iCh);
    input_before = {input_all,input_target,input_std,input_diff};

    input_all = spec_all_after10_all(2:end,:,:,iCh);
    input_target = spec_all_after10_target(2:end,:,:,iCh);
    input_std = spec_all_after10_std(2:end,:,:,iCh);
    input_diff = spec_all_after10_target(2:end,:,:,iCh) - spec_all_after10_std(2:end,:,:,iCh);
    input_after10 = {input_all,input_target,input_std,input_diff};

    input_all = spec_all_after20_all(2:end,:,:,iCh);
    input_target = spec_all_after20_target(2:end,:,:,iCh);
    input_std = spec_all_after20_std(2:end,:,:,iCh);
    input_diff = spec_all_after20_target(2:end,:,:,iCh) - spec_all_after20_std(2:end,:,:,iCh);
    input_after20 = {input_all,input_target,input_std,input_diff};

    input_all = spec_all_after30_all(2:end,:,:,iCh);
    input_target = spec_all_after30_target(2:end,:,:,iCh);
    input_std = spec_all_after30_std(2:end,:,:,iCh);
    input_diff = spec_all_after30_target(2:end,:,:,iCh) - spec_all_after30_std(2:end,:,:,iCh);
    input_after30 = {input_all,input_target,input_std,input_diff};

    input = cat(1,input_before,input_after10,input_after20,input_after30);
    titles = ["All", "Target", "Std.", "Diff."];
    leg = ["Before","After10","After20","After30"];
    plot_fmulti_band_power(input,t_seg,f,freq_ranges,smth,lw,titles,leg,colors)
    sgtitle(sprintf('Band Power - clean trials\n%s', ch_labels{1}(iCh)))
    
    set(gcf,'Units','Inches');
    set(gcf,'PaperPosition',[0 0 9 9],'PaperUnits','Inches','PaperSize',[9, 9])
    fname = path_res+sprintf('bandPow2_%sWinLen500WinSlip20_beforeAfter_TarStdClnTrial',  ch_labels{1}(iCh));
%     print(gcf, '-vector', '-dpng', '-r300', fname+'.png');
%     saveas(gcf, fname+'.fig')
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar Plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

%% calculation of std and target
useERP = 0;
states = ["All", "Std.", "Target", "Diff."];
iTarStd = 3; % 1:All, 2:Std, 3:Target
useClean = true;
params.tapers = [0.5 3];
params.pad = -1;
params.Fs = cfg.fs;
params.fpass = [0 90];
params.trialave = 1;

total_dur = cfg.epoch_time(1) + cfg.epoch_time(2);
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * fs;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;

twin_len = 0.5;
win_len = twin_len*fs;
twin_slip = 0.02;
win_slip = twin_slip*fs;

n_win = round((total_dur-twin_len)/twin_slip + 1);
t_seg = -cfg.epoch_time(1)+twin_len/2:twin_slip:cfg.epoch_time(2)-twin_len/2;

[t,f,Before_Spec_Target] = calc_specgram(Before_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After10_Spec_Target] = calc_specgram(After10_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After20_Spec_Target] = calc_specgram(After20_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After30_Spec_Target] = calc_specgram(After30_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
n_f  = numel(f);
if(numel(t)~=numel(t_seg))
    warning('Somthing went wrong in timing')
end

iTarStd = 2; % 1:All, 2:Std, 3:Target
[t,f,Before_Spec_Std] = calc_specgram(Before_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After10_Spec_Std] = calc_specgram(After10_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After20_Spec_Std] = calc_specgram(After20_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After30_Spec_Std] = calc_specgram(After30_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
n_f  = numel(f);
if(numel(t)~=numel(t_seg))
    warning('Somthing went wrong in timing')
end


iTarStd = 1; % 1:All, 2:Std, 3:Target
[t,f,Before_Spec_All] = calc_specgram(Before_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After10_Spec_All] = calc_specgram(After10_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After20_Spec_All] = calc_specgram(After20_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
[t,f,After30_Spec_All] = calc_specgram(After30_Data,[twin_len twin_slip],params,iTarStd,useClean,useERP);
n_f  = numel(f);
if(numel(t)~=numel(t_seg))
    warning('Somthing went wrong in timing')
end


%% mean session per rat
nCh = 4;
input_tar = Before_Spec_Target;
input_std = Before_Spec_Std;
input_all = Before_Spec_All;
nRat = length(input_tar);
spec_all_before_target = NaN(nRat,n_win,n_f,nCh);
spec_all_before_std = NaN(nRat,n_win,n_f,nCh);
spec_all_before_all = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec_tar = input_tar{iRat,1};
    spec_std = input_std{iRat,1};
    spec_all = input_all{iRat,1};
    nSess = size(spec_tar,2);
    spec_tar_rat = NaN(nSess,n_win,n_f,nCh);
    spec_std_rat = NaN(nSess,n_win,n_f,nCh);
    spec_all_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_tarSess = spec_tar{1,iSess};
        spec_stdSess = spec_std{1,iSess};
        spec_allSess = spec_all{1,iSess};
        spec_tar_rat(iSess,:,:,:) = spec_tarSess;
        spec_std_rat(iSess,:,:,:) = spec_stdSess;
        spec_all_rat(iSess,:,:,:) = spec_allSess;
    end
    spec_all_before_target(iRat,:,:,:) = mean(spec_tar_rat,1,'omitnan');
    spec_all_before_std(iRat,:,:,:) = mean(spec_std_rat,1,'omitnan');
    spec_all_before_all(iRat,:,:,:) = mean(spec_all_rat,1,'omitnan');
end

input_tar = After10_Spec_Target;
input_std = After10_Spec_Std;
input_all = After10_Spec_All;
nRat = length(input_tar);
spec_all_after10_target = NaN(nRat,n_win,n_f,nCh);
spec_all_after10_std = NaN(nRat,n_win,n_f,nCh);
spec_all_after10_all = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec_tar = input_tar{iRat,1};
    spec_std = input_std{iRat,1};
    spec_all = input_all{iRat,1};
    nSess = size(spec_tar,2);
    spec_tar_rat = NaN(nSess,n_win,n_f,nCh);
    spec_std_rat = NaN(nSess,n_win,n_f,nCh);
    spec_all_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_tarSess = spec_tar{1,iSess};
        spec_stdSess = spec_std{1,iSess};
        spec_allSess = spec_all{1,iSess};
        spec_tar_rat(iSess,:,:,:) = spec_tarSess;
        spec_std_rat(iSess,:,:,:) = spec_stdSess;
        spec_all_rat(iSess,:,:,:) = spec_allSess;
    end
    spec_all_after10_target(iRat,:,:,:) = mean(spec_tar_rat,1,'omitnan');
    spec_all_after10_std(iRat,:,:,:) = mean(spec_std_rat,1,'omitnan');
    spec_all_after10_all(iRat,:,:,:) = mean(spec_all_rat,1,'omitnan');
end

input_tar = After20_Spec_Target;
input_std = After20_Spec_Std;
input_all = After20_Spec_All;
nRat = length(input_tar);
spec_all_after20_target = NaN(nRat,n_win,n_f,nCh);
spec_all_after20_std = NaN(nRat,n_win,n_f,nCh);
spec_all_after20_all = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec_tar = input_tar{iRat,1};
    spec_std = input_std{iRat,1};
    spec_all = input_all{iRat,1};
    nSess = size(spec_tar,2);
    spec_tar_rat = NaN(nSess,n_win,n_f,nCh);
    spec_std_rat = NaN(nSess,n_win,n_f,nCh);
    spec_all_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_tarSess = spec_tar{1,iSess};
        spec_stdSess = spec_std{1,iSess};
        spec_allSess = spec_all{1,iSess};
        spec_tar_rat(iSess,:,:,:) = spec_tarSess;
        spec_std_rat(iSess,:,:,:) = spec_stdSess;
        spec_all_rat(iSess,:,:,:) = spec_allSess;
    end
    spec_all_after20_target(iRat,:,:,:) = mean(spec_tar_rat,1,'omitnan');
    spec_all_after20_std(iRat,:,:,:) = mean(spec_std_rat,1,'omitnan');
    spec_all_after20_all(iRat,:,:,:) = mean(spec_all_rat,1,'omitnan');
end


input_tar = After30_Spec_Target;
input_std = After30_Spec_Std;
input_all = After30_Spec_All;
nRat = length(input_tar);
spec_all_after30_target = NaN(nRat,n_win,n_f,nCh);
spec_all_after30_std = NaN(nRat,n_win,n_f,nCh);
spec_all_after30_all = NaN(nRat,n_win,n_f,nCh);
for iRat=1:nRat
    spec_tar = input_tar{iRat,1};
    spec_std = input_std{iRat,1};
    spec_all = input_all{iRat,1};
    nSess = size(spec_tar,2);
    spec_tar_rat = NaN(nSess,n_win,n_f,nCh);
    spec_std_rat = NaN(nSess,n_win,n_f,nCh);
    spec_all_rat = NaN(nSess,n_win,n_f,nCh);
    for iSess=1:nSess
        spec_tarSess = spec_tar{1,iSess};
        spec_stdSess = spec_std{1,iSess};
        spec_allSess = spec_all{1,iSess};
        spec_tar_rat(iSess,:,:,:) = spec_tarSess;
        spec_std_rat(iSess,:,:,:) = spec_stdSess;
        spec_all_rat(iSess,:,:,:) = spec_allSess;
    end
    spec_all_after30_target(iRat,:,:,:) = mean(spec_tar_rat,1,'omitnan');
    spec_all_after30_std(iRat,:,:,:) = mean(spec_std_rat,1,'omitnan');
    spec_all_after30_all(iRat,:,:,:) = mean(spec_all_rat,1,'omitnan');
end

%%

freq_ranges = [60 90;
               30 60;
               12 30
               8 12
               4 8];
for iCh = 3
    
    input_all = spec_all_before_all(2:end,:,:,iCh);
    input_target = spec_all_before_target(2:end,:,:,iCh);
    input_std = spec_all_before_std(2:end,:,:,iCh);
    input_diff = spec_all_before_target(2:end,:,:,iCh) - spec_all_before_std(2:end,:,:,iCh);
    input_before = {input_all,input_target,input_std,input_diff};

    input_all = spec_all_after10_all(2:end,:,:,iCh);
    input_target = spec_all_after10_target(2:end,:,:,iCh);
    input_std = spec_all_after10_std(2:end,:,:,iCh);
    input_diff = spec_all_after10_target(2:end,:,:,iCh) - spec_all_after10_std(2:end,:,:,iCh);
    input_after10 = {input_all,input_target,input_std,input_diff};

    input_all = spec_all_after20_all(2:end,:,:,iCh);
    input_target = spec_all_after20_target(2:end,:,:,iCh);
    input_std = spec_all_after20_std(2:end,:,:,iCh);
    input_diff = spec_all_after20_target(2:end,:,:,iCh) - spec_all_after20_std(2:end,:,:,iCh);
    input_after20 = {input_all,input_target,input_std,input_diff};

    input_all = spec_all_after30_all(2:end,:,:,iCh);
    input_target = spec_all_after30_target(2:end,:,:,iCh);
    input_std = spec_all_after30_std(2:end,:,:,iCh);
    input_diff = spec_all_after30_target(2:end,:,:,iCh) - spec_all_after30_std(2:end,:,:,iCh);
    input_after30 = {input_all,input_target,input_std,input_diff};

    input = cat(1,input_before,input_after10,input_after20,input_after30);
    titles = ["All", "Target", "Std.", "Diff."];
    leg = ["Before","After10","After20","After30"];
    plot_multi_band_power_barPlot(input,t_seg,f,freq_ranges,titles,leg)
    sgtitle(sprintf('Band Power - clean trials\n%s', ch_labels{1}(iCh)))
    
    set(gcf,'Units','Inches');
    set(gcf,'PaperPosition',[0 0 9 9],'PaperUnits','Inches','PaperSize',[9, 9])
    fname = path_res+sprintf('bandPowBar_%sWinLen500WinSlip20_beforeAfter_TarStdClnTrial',  ch_labels{1}(iCh));
%     print(gcf, '-vector', '-dpng', '-r300', fname+'.png');
%     saveas(gcf, fname+'.fig')
end







