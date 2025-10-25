clc; 
clear;
% close all;

addpath(genpath('./Functions'))

%% Load Data and PreProcess

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
    'epoch_t_start',    0.3,                     ...
    'y_range',          [-1 1],                  ...
    'epoch_time',       [0.3, 1],                ... 
    'prep_band',        [0.1, 30],               ... 
    'run_idx',          1,                       ...
    'is_downsample',    1,                       ...
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
    
%     dataName = strcat(dataName1, dataName2, dataName3, dataName4);
    dataName = strcat(dataName3, dataName2, dataName1, dataName4);
    
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
    
% dataName = strcat(dataName1, dataName2, dataName3, dataName4);
dataName = strcat(dataName3, dataName2, dataName1, dataName4);

Before_Data   = load(strcat(save_dir, 'Before_Data', dataName, '.mat')).Before_Data;
After10_Data  = load(strcat(save_dir, 'After10days_Data', dataName, '.mat')).After10days_Data;
After20_Data  = load(strcat(save_dir, 'After20days_Data', dataName, '.mat')).After20days_Data;
After30_Data  = load(strcat(save_dir, 'After30days_Data', dataName, '.mat')).After30days_Data;

%%
balance = true;
useClean = true;
useERP = true;
pool = true;

params.twin_len = 0.1;
params.twin_slip = 0.04;
params.fs = fs;

[acc_before,~] = calc_lda(Before_Data,useClean,pool,balance,useERP,params,cfg);
[acc_after10,~] = calc_lda(After10_Data,useClean,pool,balance,useERP,params,cfg);
[acc_after20,~] = calc_lda(After20_Data,useClean,pool,balance,useERP,params,cfg);
[acc_after30,tout] = calc_lda(After30_Data,useClean,pool,balance,useERP,params,cfg);


%%
input = acc_before;
nRat = size(input,1);
before_acc_rat = [];
for iRat=1:nRat
    before_acc_rat = cat(3,before_acc_rat,input{iRat,1});
end

input = acc_after10;
nRat = size(input,1);
after10_acc_rat = [];
for iRat=1:nRat
    after10_acc_rat = cat(3,after10_acc_rat,input{iRat,1});
end

input = acc_after20;
nRat = size(input,1);
after20_acc_rat = [];
for iRat=1:nRat
    after20_acc_rat = cat(3,after20_acc_rat,input{iRat,1});
end
after20_acc_rat = cat(3,NaN(size(input{iRat,1})),NaN(size(input{iRat,1})),after20_acc_rat);


input = acc_after30;
nRat = size(input,1);
after30_acc_rat = [];
for iRat=1:nRat
    after30_acc_rat = cat(3,after30_acc_rat,input{iRat,1});
end
after30_acc_rat = cat(3,NaN(size(input{iRat,1})),NaN(size(input{iRat,1})),NaN(size(input{iRat,1})),after30_acc_rat);

%% mean over rat
iCh = 3;
figure

stdshade(squeeze(before_acc_rat(iCh,:,2:end))',0.4,'b',tout)
hold on
stdshade(squeeze(after10_acc_rat(iCh,:,2:end))',0.4,'r',tout)
stdshade(squeeze(after20_acc_rat(iCh,:,2:end))',0.4,'g',tout)
stdshade(squeeze(after30_acc_rat(iCh,:,2:end))',0.4,'m',tout)

%% per rat/beforeAfter

iCh = 3;
iRat = 1:8;

figure
plot(tout,squeeze(before_acc_rat(iCh,:,iRat)),'LineWidth',2)
hold on
set(gca,'ColorOrderIndex',1)
plot(tout,squeeze(after10_acc_rat(iCh,:,iRat)),':','LineWidth',2)
set(gca,'ColorOrderIndex',1)
plot(tout,squeeze(after20_acc_rat(iCh,:,iRat)),'--','LineWidth',2)
set(gca,'ColorOrderIndex',1)
plot(tout,squeeze(after30_acc_rat(iCh,:,iRat)),'-.','LineWidth',2)

xline(0,'-k','LineWidth',2)
title(sprintf('%s - LDA target/std.', ch_labels{1}(iCh)))
