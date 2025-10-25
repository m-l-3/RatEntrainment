clc; 
clear;
% close all;

addpath(genpath('./Functions'))
addpath(genpath("D:\Documents\SUT Ph.D\Research\Matlab codes\chronux_2_12"));

addpath("D:\Documents\SUT Ph.D\Research\Matlab codes\eeglab2023.1")

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
    'prep_band',        [0.1, 300],               ... 
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


save_dir = '../Results/Signals/sigZscr_eeglab_trZscore_0.1-30Hz-1.5-2epoch/';
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

save_dir = '../Results/Signals/sigZscr_eeglab_trZscore_0.1-30Hz-1.5-2epoch/';

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

%% power calculation
states = ["All", "Std.", "Target", "Diff."];
iTarStd = 1; % 1:All, 2:Std, 3:Target
useERP = false;
useClean = false;
params.tapers = [0.5 3];
params.pad = -1;
params.Fs = fs;
params.fpass = [0 90];
params.trialave = false;

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

%% sample case: rat13
f_range = [4 8];
iRat = 7;
cleanTr = logical(Before_Data{iRat,1}{4,1});
seq = Before_Data{iRat,1}{7,1};
x1 = seq; % target=0, std=1;

changed = abs(diff(seq));
changed = [1;  changed];
x2 = changed;

% x3 = movmean(changed,3);
% x3 = (1:240)'/240;
% X = [x1 x2 x3];
X = [x1 x2];

iCh = 3;
B = [];
Stats = [];
disp = [];
for iTime=1:length(t)
    y = squeeze(mean(Before_Spec{iRat,1}{1,1}(iTime, f>=f_range(1) & f<=f_range(2), :, iCh), 2, 'omitnan'));
%     y = detrend(y);
    [b,dev,stats] = glmfit(X(cleanTr,:), y(cleanTr), 'normal', 'Constant','on');
    B = cat(2,B,b./stats.se);
    Stats = cat(1,Stats,stats);
    disp = cat(2,disp, stats.sfit);
end

figure
subplot(3,1,1)
plot(t_seg, B');
hold on; xline(0)
subplot(3,1,2)
plot(t_seg, disp)
hold on; xline(0)
subplot(3,1,3)
plot(t_seg, squeeze(mean(Before_Spec{iRat,1}{1,1}(:, f>=f_range(1) & f<=f_range(2), :, iCh), [2 3], 'omitnan')))
hold on; xline(0)

%%
iRat = 8;
iCh = 1;
f_range = [4 12];
seq = Before_Data{iRat,1}{7,1};
changed = Before_Data{iRat,1}{9,1};
cleanTr = logical(Before_Data{iRat,1}{4,1});

theta = squeeze(mean(Before_Spec{iRat,1}{1,1}(:, f>=f_range(1) & f<=f_range(2), :, iCh), 2, 'omitnan'));
figure

stdshade(theta(:,cleanTr & ~seq)',0.4,[0.4940 0.1840 0.5560],t_seg)
hold on 
stdshade(theta(:,cleanTr & seq)',0.4, [0.8500 0.3250 0.0980],t_seg)
xline(0)
legend('Target','Std')
% legend('unChanged','changed')
% legend('most','least')


xlabel('Time (sec)')
%%
f_range = [4 8];
params.idx =  f>=f_range(1) & f<=f_range(2);
params.dist = 'gamma';
params.constant = 'on';
useClean = true;

[Before_Beta] = calc_glm(Before_Data,Before_Spec,params,useClean);
[After10_Beta] = calc_glm(After10_Data,After10_Spec,params,useClean);
[After20_Beta] = calc_glm(After20_Data,After20_Spec,params,useClean);
[After30_Beta] = calc_glm(After30_Data,After30_Spec,params,useClean);


%%
nBeta = 3;
nCh = 4;
input = Before_Beta;
nRat = length(input);
beta_all_before = NaN(nRat,nBeta,nCh,n_win);
for iRat=1:nRat
    beta = input{iRat,1};
    nSess = size(beta,2);
    beta_rat = NaN(nSess,nBeta,nCh,n_win);
    for iSess=1:nSess
        beta_sess = beta{1,iSess};
        beta_rat(iSess,:,:,:) = beta_sess;
    end
    beta_all_before(iRat,:,:,:) = mean(beta_rat,1,'omitnan');
end

input = After10_Beta;
nRat = length(input);
beta_all_after10 = NaN(nRat,nBeta,nCh,n_win);
for iRat=1:nRat
    beta = input{iRat,1};
    nSess = size(beta,2);
    beta_rat = NaN(nSess,nBeta,nCh,n_win);
    for iSess=1:nSess
        beta_sess = beta{1,iSess};
        beta_rat(iSess,:,:,:) = beta_sess;
    end
    beta_all_after10(iRat,:,:,:) = mean(beta_rat,1,'omitnan');
end

input = After20_Beta;
nRat = length(input);
beta_all_after20 = NaN(nRat,nBeta,nCh,n_win);
for iRat=1:nRat
    beta = input{iRat,1};
    nSess = size(beta,2);
    beta_rat = NaN(nSess,nBeta,nCh,n_win);
    for iSess=1:nSess
        beta_sess = beta{1,iSess};
        beta_rat(iSess,:,:,:) = beta_sess;
    end
    beta_all_after20(iRat,:,:,:) = mean(beta_rat,1,'omitnan');
end

input = After30_Beta;
nRat = length(input);
beta_all_after30 = NaN(nRat,nBeta,nCh,n_win);
for iRat=1:nRat
    beta = input{iRat,1};
    nSess = size(beta,2);
    beta_rat = NaN(nSess,nBeta,nCh,n_win);
    for iSess=1:nSess
        beta_sess = beta{1,iSess};
        beta_rat(iSess,:,:,:) = beta_sess;
    end
    beta_all_after30(iRat,:,:,:) = mean(beta_rat,1,'omitnan');
end


%%
figure

iCh = 3;
iBeta =2;

stdshade(squeeze(beta_all_before(:,iBeta,iCh,:)),0.4,'b',t_seg)
hold on
stdshade(squeeze(beta_all_after10(:,iBeta,iCh,:)),0.4,'r',t_seg)
stdshade(squeeze(beta_all_after20(:,iBeta,iCh,:)),0.4,'g',t_seg)
stdshade(squeeze(beta_all_after30(:,iBeta,iCh,:)),0.4,'m',t_seg)
xline(0)
%%

figure

iCh = 3;

stdshade(squeeze(beta_all_before(:,2,iCh,:)),0.4,'b',t_seg)
hold on
stdshade(squeeze(beta_all_before(:,3,iCh,:)),0.4,'r',t_seg)
xline(0)

stdshade(squeeze(beta_all_after30(:,2,iCh,:)),0.4,'g',t_seg)
hold on
stdshade(squeeze(beta_all_after30(:,3,iCh,:)),0.4,'m',t_seg)