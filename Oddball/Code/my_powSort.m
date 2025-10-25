
clc; 
clear;
% close all;

addpath(genpath('./Functions'))
addpath("D:\Documents\SUT Ph.D\Research\Matlab codes\chronux_2_12");
addpath("D:\Documents\SUT Ph.D\Research\Matlab codes\eeglab2023.1")
addpath('D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Dataset\')

path_res = ("D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Results\Pow_spec\"); 
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
    'epoch_t_start',    0.3,                     ...
    'y_range',          [-1 1],                  ...
    'epoch_time',       [0.3, 1],                ... 
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

save_dir = '../Results/Signals/sigZscr_eeglab_trZscore_0.1-100Hz/';

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

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 1D %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%% calculation of std and target
useERP = 0;
states = ["All", "Std.", "Target", "Diff."];
iTarStd = 3; % 1:All, 2:Std, 3:Target
useClean = true;
params.tapers = [0.5 3];
params.pad = -1;
params.Fs = cfg.fs;
params.fpass = [0 90];
params.trialave = 0;

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

%%
nCh = 4;
freq_ranges = [4 8;
               30 90];
n_interp = 100;
[fHigh, BeforeAll_Sorting_res] = power_sorting(Before_Spec_All,f,freq_ranges,n_interp);
[fHigh, After10All_Sorting_res] = power_sorting(After10_Spec_All,f,freq_ranges,n_interp);
[fHigh, After20All_Sorting_res] = power_sorting(After20_Spec_All,f,freq_ranges,n_interp);
[fHigh, After30All_Sorting_res] = power_sorting(After30_Spec_All,f,freq_ranges,n_interp);

%%
input_all = After30All_Sorting_res;
nRat = size(input_all,1);
lowPow = NaN(nRat,n_interp,nCh);
highBand = NaN(nRat,length(fHigh),n_interp,nCh);
for iRat=1:nRat
    lowPow(iRat,:,:) = input_all{iRat,1};
    highBand(iRat,:,:,:) = input_all{iRat,2};
end

%%
iCh = 4;
figure
lowPow_mean = squeeze(mean(lowPow(:,:,iCh),'omitnan'));
highBand_mean = squeeze(mean(highBand(:,:,:,iCh),'omitnan'));

surface(lowPow_mean,fHigh,highBand_mean)
colormap jet
shading interp