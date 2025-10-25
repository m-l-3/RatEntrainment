clc; 
clear;
% close all;

addpath(genpath('./Functions'))
% addpath(genpath("D:\Documents\SUT Ph.D\Research\Matlab codes\chronux_2_12"));
% addpath("D:\Documents\SUT Ph.D\Research\Matlab codes\eeglab2023.1")
% addpath('D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Dataset\')

path_res = ("D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Results\PAC_general\"); 
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


save_dir = '../Results/Signals/sigZscr_eeglab_trZscore_0.1-100Hz-1.5-2epoch/';
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

%%

% save_dir = '../Results/PAC_general/';

useClean = true;

params.fs = cfg.fs;
params.fph = [4 12];
params.famp = [15 90];
params.twin = 0.5;
params.tovp = .9;
params.method = "wavelet";
params.fres_param = 16;
params.nperm = 0;
params.nbins = 16;
params.ttype = "last";

smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * cfg.fs;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;
params.time = time;

[PAC_Before,tout,fph_out,famp_out] = calc_pac(Before_Data,params,useClean,cfg);
% paramsOut.tout = tout;
% paramsOut.fph_out = fph_out;
% paramsOut.famp_out = famp_out;
% save(strcat(save_dir, 'PACcomo_Before_allCh_allWin_meanTrial_perRatSess', '.mat'), 'PAC_Before', 'params', 'paramsOut', 'cfg');
% 
% [PAC_After10,tout,fph_out,famp_out] = calc_pac(After10_Data,params,useClean,cfg);
% paramsOut.tout = tout;
% paramsOut.fph_out = fph_out;
% paramsOut.famp_out = famp_out;
% save(strcat(save_dir, 'PACcomo_After10_allCh_allWin_meanTrial_perRatSess', '.mat'), 'PAC_After10', 'params', 'paramsOut', 'cfg');

% [PAC_After20,tout,fph_out,famp_out] = calc_pac(After20_Data,params,useClean,cfg);
% paramsOut.tout = tout;
% paramsOut.fph_out = fph_out;
% paramsOut.famp_out = famp_out;
% save(strcat(save_dir, 'PACcomo_After20_allCh_allWin_meanTrial_perRatSess', '.mat'), 'PAC_After20', 'params', 'paramsOut', 'cfg');


% [PAC_After30,tout,fph_out,famp_out] = calc_pac(After30_Data,params,useClean,cfg);
% paramsOut.tout = tout;
% paramsOut.fph_out = fph_out;
% paramsOut.famp_out = famp_out;
% save(strcat(save_dir, 'PACcomo_After30_allCh_allWin_meanTrial_perRatSess', '.mat'), 'PAC_After30', 'params', 'paramsOut', 'cfg');

%% load pacs

save_dir = '../Results-initial/PAC_general/';

load(strcat(save_dir, 'before/', 'PACcomo_Before_allCh_allWin_meanTrial_perRatSess', '.mat'));
load(strcat(save_dir, 'after10/', 'PACcomo_After10_allCh_allWin_meanTrial_perRatSess', '.mat'));
load(strcat(save_dir, 'after20/', 'PACcomo_After20_allCh_allWin_meanTrial_perRatSess', '.mat'));
load(strcat(save_dir, 'after30/', 'PACcomo_After30_allCh_allWin_meanTrial_perRatSess', '.mat'));

%% 1D -  in time
ch1 = 1;
ch2 = 1;
iRat = 1;
iSess = 1;
fph_range = [4 8];
famp_range = [39 41];
PAC_in = PAC_After20;

fph_out = paramsOut.fph_out;
famp_out = paramsOut.famp_out;
tout = paramsOut.tout;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);


figure
plot(paramsOut.tout, squeeze(mean(PAC_in{iRat,1}{1,iSess}(ch1,ch2,:,fph_idx,famp_idx),[4 5])),'LineWidth',2)
hold on
plot(paramsOut.tout, squeeze(mean(PAC_in{iRat,1}{2,iSess}(ch1,ch2,:,fph_idx,famp_idx),[4 5])),'LineWidth',2)
plot(paramsOut.tout, squeeze(mean(PAC_in{iRat,1}{3,iSess}(ch1,ch2,:,fph_idx,famp_idx),[4 5])),'LineWidth',2)

xline(0,'-k','LineWidth',2)
legend('All','Std.','Target')
title(sprintf('%s {phase} - %s {amp}\n', ch_labels{1}(ch1),ch_labels{1}(ch2)))
    
%% 2D - comodulogram

ch1 = 4;
ch2 = 4;
iRat = 6;
iSess = 1;
PAC_in = PAC_After10;
iTarget = [3 2];

[fph_mesh,famp_mesh] = meshgrid(fph_out, famp_out);

fig = figure; % Create a figure  
screenSize = get(0, 'ScreenSize'); % Get the screen size  
set(fig, 'Position', [screenSize(1), screenSize(4)*2/4, screenSize(3)/2, screenSize(4)/3]); % Set figure position to full vertical size

for ti=1:length(tout)
    
    p1 = subplot(1,2,1);
    pcolor(fph_mesh,famp_mesh,squeeze((PAC_in{iRat,1}{iTarget(1),iSess}(ch1,ch2,ti,:,:)))');
    shading flat;colormap jet;colorbar;
    cmin1 = min(squeeze((PAC_in{iRat,1}{iTarget(1),iSess}(ch1,ch2,:,:,:))),[],'all');
    cmax1 = max(squeeze((PAC_in{iRat,1}{iTarget(1),iSess}(ch1,ch2,:,:,:))),[],'all');
    title('Target')

    p2 = subplot(1,2,2);
    pcolor(fph_mesh,famp_mesh,squeeze((PAC_in{iRat,1}{iTarget(2),iSess}(ch1,ch2,ti,:,:)))');
    shading flat;colormap jet;colorbar;
    cmin2 = min(squeeze((PAC_in{iRat,1}{iTarget(2),iSess}(ch1,ch2,:,:,:))),[],'all');
    cmax2 = max(squeeze((PAC_in{iRat,1}{iTarget(2),iSess}(ch1,ch2,:,:,:))),[],'all');
    title('Std.')

    cmin = min([cmin1 cmin2]);
    cmax = max([cmax1 cmax2]);
    clim(p1,[cmin*1.2 cmax*.9]); 
    clim(p2,[cmin*1.2 cmax*.9]);

    sgtitle(sprintf('%s {phase} - %s {amp}\n t=%.2f', ch_labels{1}(ch1),ch_labels{1}(ch2),tout(ti)/1000))
    drawnow
    pause(0.05)
end

%% mean over sessions

input = PAC_Before;
nRat = size(input,1);
beforeAll_pac_rat = [];
beforeStd_pac_rat = [];
beforeTarget_pac_rat = [];
for iRat=1:nRat
    temp_rat = input{iRat,1};
    nSess = size(temp_rat,2);
    tempAll_sess = [];
    tempStd_sess = [];
    tempTarget_sess = [];
    for iSess=1:1
        tempAll_sess = cat(6,tempAll_sess,temp_rat{1,iSess});
        tempStd_sess = cat(6,tempStd_sess,temp_rat{2,iSess});
        tempTarget_sess = cat(6,tempTarget_sess,temp_rat{3,iSess});
    end
    beforeAll_pac_rat = cat(6,beforeAll_pac_rat, mean(tempAll_sess,6,'omitnan'));
    beforeStd_pac_rat = cat(6,beforeStd_pac_rat, mean(tempStd_sess,6,'omitnan'));
    beforeTarget_pac_rat = cat(6,beforeTarget_pac_rat, mean(tempTarget_sess,6,'omitnan'));
end
before_pac_rat{1,1} = beforeAll_pac_rat;
before_pac_rat{2,1} = beforeStd_pac_rat;
before_pac_rat{3,1} = beforeTarget_pac_rat;

input = PAC_After10;
nRat = size(input,1);
after10All_pac_rat = [];
after10Std_pac_rat = [];
after10Target_pac_rat = [];
for iRat=1:nRat
    temp_rat = input{iRat,1};
    nSess = size(temp_rat,2);
    tempAll_sess = [];
    tempStd_sess = [];
    tempTarget_sess = [];
    for iSess=1:1
        tempAll_sess = cat(6,tempAll_sess,temp_rat{1,iSess});
        tempStd_sess = cat(6,tempStd_sess,temp_rat{2,iSess});
        tempTarget_sess = cat(6,tempTarget_sess,temp_rat{3,iSess});
    end
    after10All_pac_rat = cat(6,after10All_pac_rat, mean(tempAll_sess,6,'omitnan'));
    after10Std_pac_rat = cat(6,after10Std_pac_rat, mean(tempStd_sess,6,'omitnan'));
    after10Target_pac_rat = cat(6,after10Target_pac_rat, mean(tempTarget_sess,6,'omitnan'));
end
after10_pac_rat{1,1} = after10All_pac_rat;
after10_pac_rat{2,1} = after10Std_pac_rat;
after10_pac_rat{3,1} = after10Target_pac_rat;

input = PAC_After20;
nRat = size(input,1);
after20All_pac_rat = [];
after20Std_pac_rat = [];
after20Target_pac_rat = [];
for iRat=1:nRat
    temp_rat = input{iRat,1};
    nSess = size(temp_rat,2);
    tempAll_sess = [];
    tempStd_sess = [];
    tempTarget_sess = [];
    for iSess=1:1
        tempAll_sess = cat(6,tempAll_sess,temp_rat{1,iSess});
        tempStd_sess = cat(6,tempStd_sess,temp_rat{2,iSess});
        tempTarget_sess = cat(6,tempTarget_sess,temp_rat{3,iSess});
    end
    after20All_pac_rat = cat(6,after20All_pac_rat, mean(tempAll_sess,6,'omitnan'));
    after20Std_pac_rat = cat(6,after20Std_pac_rat, mean(tempStd_sess,6,'omitnan'));
    after20Target_pac_rat = cat(6,after20Target_pac_rat, mean(tempTarget_sess,6,'omitnan'));
end

after20All_pac_rat = cat(6,NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),after20All_pac_rat);
after20Std_pac_rat = cat(6,NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),after20Std_pac_rat);
after20Target_pac_rat = cat(6,NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),after20Target_pac_rat);

after20_pac_rat{1,1} = after20All_pac_rat;
after20_pac_rat{2,1} = after20Std_pac_rat;
after20_pac_rat{3,1} = after20Target_pac_rat;


input = PAC_After30;
nRat = size(input,1);
after30All_pac_rat = [];
after30Std_pac_rat = [];
after30Target_pac_rat = [];
for iRat=1:nRat
    temp_rat = input{iRat,1};
    nSess = size(temp_rat,2);
    tempAll_sess = [];
    tempStd_sess = [];
    tempTarget_sess = [];
    for iSess=1:1
        tempAll_sess = cat(6,tempAll_sess,temp_rat{1,iSess});
        tempStd_sess = cat(6,tempStd_sess,temp_rat{2,iSess});
        tempTarget_sess = cat(6,tempTarget_sess,temp_rat{3,iSess});
    end
    after30All_pac_rat = cat(6,after30All_pac_rat, mean(tempAll_sess,6,'omitnan'));
    after30Std_pac_rat = cat(6,after30Std_pac_rat, mean(tempStd_sess,6,'omitnan'));
    after30Target_pac_rat = cat(6,after30Target_pac_rat, mean(tempTarget_sess,6,'omitnan'));
end

after30All_pac_rat = cat(6,NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),after30All_pac_rat);
after30Std_pac_rat = cat(6,NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),after30Std_pac_rat);
after30Target_pac_rat = cat(6,NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),after30Target_pac_rat);

after30_pac_rat{1,1} = after30All_pac_rat;
after30_pac_rat{2,1} = after30Std_pac_rat;
after30_pac_rat{3,1} = after30Target_pac_rat;

%% see each rat in each before/after
ch1 = 1;
ch2 = 1;
state = ["All","Std.","Target"];
iTarget = 1;
fph_range = [8 12];
famp_range = [30 50];

fph_out = paramsOut.fph_out;
famp_out = paramsOut.famp_out;
tout = paramsOut.tout;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);


figure
plot(tout,squeeze(mean(before_pac_rat{iTarget,1}(ch1,ch2,:,fph_idx,famp_idx,:),[4 5])),'LineWidth',2)
hold on
set(gca,'ColorOrderIndex',1)
plot(tout,squeeze(mean(after10_pac_rat{iTarget,1}(ch1,ch2,:,fph_idx,famp_idx,:),[4 5])),':','LineWidth',2)
set(gca,'ColorOrderIndex',1)
plot(tout,squeeze(mean(after20_pac_rat{iTarget,1}(ch1,ch2,:,fph_idx,famp_idx,:),[4 5])),'--','LineWidth',2)
set(gca,'ColorOrderIndex',1)
plot(tout,squeeze(mean(after30_pac_rat{iTarget,1}(ch1,ch2,:,fph_idx,famp_idx,:),[4 5])),'-.','LineWidth',2)

xline(0,'-k','LineWidth',2)
title(sprintf('%s {phase} - %s {amp}\n %s', ch_labels{1}(ch1),ch_labels{1}(ch2),state(iTarget)))
    

figure
stdshade(squeeze(mean(before_pac_rat{iTarget,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))',0.4,'b',tout)
hold on
stdshade(squeeze(mean(after10_pac_rat{iTarget,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))',0.4,'r',tout)
stdshade(squeeze(mean(after20_pac_rat{iTarget,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))',0.4,'g',tout)
stdshade(squeeze(mean(after30_pac_rat{iTarget,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))',0.4,'m',tout)
xline(0,'-k','LineWidth',2)
title(sprintf('%s {phase} - %s {amp}\n %s', ch_labels{1}(ch1),ch_labels{1}(ch2),state(iTarget)))
    
%%
% without normalization
ch1 = 2;
ch2 = 3;
fph_range = [4 8];
famp_range = [30 50];

fph_out = paramsOut.fph_out;
famp_out = paramsOut.famp_out;
tout = paramsOut.tout;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

colors = [0.4940 0.1840 0.5560;
          0.8500 0.3250 0.0980 ];
type = 'signrank';
is_corr = false;

fig = figure; % Create a figure  
screenSize = get(0, 'ScreenSize'); % Get the screen size  
set(fig, 'Position', [screenSize(1), 0, screenSize(3)/4, screenSize(4)]); % Set figure position to full vertical size


subplot(8,1,1)
x = squeeze(mean(before_pac_rat{3,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))';
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(before_pac_rat{2,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))';
stdshade(y,0.4,colors(2,:),tout)

xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.')

subplot(8,1,2)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

subplot(8,1,3)
x = squeeze(mean(after10_pac_rat{3,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))';
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(after10_pac_rat{2,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))';
stdshade(y,0.4,colors(2,:),tout)
xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.')

subplot(8,1,4)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

subplot(8,1,5)
x = squeeze(mean(after20_pac_rat{3,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))';
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(after20_pac_rat{2,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))';
stdshade(y,0.4,colors(2,:),tout)
xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.')

subplot(8,1,6)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

subplot(8,1,7)
x = squeeze(mean(after30_pac_rat{3,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))';
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(after30_pac_rat{2,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))';
stdshade(y,0.4,colors(2,:),tout)
xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.')

subplot(8,1,8)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

sgtitle(sprintf('%s {phase} - %s {amp}\n t=%.2f', ch_labels{1}(ch1),ch_labels{1}(ch2),tout(ti)/1000))


%%
% normalized with zscore
ch1 = 4;
ch2 = 1;
fph_range = [8 12];
famp_range = [30 50];

fph_out = paramsOut.fph_out;
famp_out = paramsOut.famp_out;
tout = paramsOut.tout;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

colors = [0.4940 0.1840 0.5560;
          0.8500 0.3250 0.0980 ];
type = 'signrank';
is_corr = false;

fig = figure; % Create a figure  
screenSize = get(0, 'ScreenSize'); % Get the screen size  
set(fig, 'Position', [screenSize(1), 0, screenSize(3)/4, screenSize(4)]); % Set figure position to full vertical size


subplot(8,1,1)
x = squeeze(mean(zscore(before_pac_rat{3,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),0,3),[4 5]))';
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(zscore(before_pac_rat{2,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),0,3),[4 5]))';
stdshade(y,0.4,colors(2,:),tout)

xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.')

subplot(8,1,2)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

subplot(8,1,3)
x = squeeze(mean(zscore(after10_pac_rat{3,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),0,3),[4 5]))';
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(zscore(after10_pac_rat{2,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),0,3),[4 5]))';
stdshade(y,0.4,colors(2,:),tout)
xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.')

subplot(8,1,4)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

subplot(8,1,5)
x = squeeze(mean(zscore(after20_pac_rat{3,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),0,3),[4 5]))';
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(zscore(after20_pac_rat{2,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),0,3),[4 5]))';
stdshade(y,0.4,colors(2,:),tout)
xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.')

subplot(8,1,6)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

subplot(8,1,7)
x = squeeze(mean(zscore(after30_pac_rat{3,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),0,3),[4 5]))';
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(zscore(after30_pac_rat{2,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),0,3),[4 5]))';
stdshade(y,0.4,colors(2,:),tout)
xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.')

subplot(8,1,8)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

sgtitle(sprintf('%s {phase} - %s {amp}\n', ch_labels{1}(ch1),ch_labels{1}(ch2)))

%%
% normalized with baseline removal
ch1 = 4;
ch2 = 1;
fph_range = [4 12];
famp_range = [30 50];

fph_out = paramsOut.fph_out;
famp_out = paramsOut.famp_out;
tout = paramsOut.tout;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);
t_idx = tout<=0 & tout>=-300 ;

colors = [0.4940 0.1840 0.5560;
          0.8500 0.3250 0.0980 ];
type = 'signrank';
is_corr = false;

fig = figure; % Create a figure  
screenSize = get(0, 'ScreenSize'); % Get the screen size  
set(fig, 'Position', [screenSize(1), 0, screenSize(3)/4, screenSize(4)]); % Set figure position to full vertical size

subplot(8,1,1)
x = squeeze(mean(before_pac_rat{3,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))' - squeeze(mean(before_pac_rat{3,1}(ch1,ch2,t_idx,fph_idx,famp_idx,2:end),[3 4 5]));
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(before_pac_rat{2,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))' - squeeze(mean(before_pac_rat{2,1}(ch1,ch2,t_idx,fph_idx,famp_idx,2:end),[3 4 5]));
stdshade(y,0.4,colors(2,:),tout)
xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.', 'Location', 'best')
ylabel('Before')

subplot(8,1,2)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

subplot(8,1,3)
x = squeeze(mean(after10_pac_rat{3,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))' - squeeze(mean(after10_pac_rat{3,1}(ch1,ch2,t_idx,fph_idx,famp_idx,2:end),[3 4 5]));
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(after10_pac_rat{2,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))' - squeeze(mean(after10_pac_rat{2,1}(ch1,ch2,t_idx,fph_idx,famp_idx,2:end),[3 4 5]));
stdshade(y,0.4,colors(2,:),tout)
xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.', 'Location', 'best')
ylabel('After 10')

subplot(8,1,4)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

subplot(8,1,5)
x = squeeze(mean(after20_pac_rat{3,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))' - squeeze(mean(after20_pac_rat{3,1}(ch1,ch2,t_idx,fph_idx,famp_idx,2:end),[3 4 5]));
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(after20_pac_rat{2,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))' - squeeze(mean(after20_pac_rat{2,1}(ch1,ch2,t_idx,fph_idx,famp_idx,2:end),[3 4 5]));
stdshade(y,0.4,colors(2,:),tout)
xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.', 'Location', 'best')
ylabel('After 20')

subplot(8,1,6)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

subplot(8,1,7)
x = squeeze(mean(after30_pac_rat{3,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))' - squeeze(mean(after30_pac_rat{3,1}(ch1,ch2,t_idx,fph_idx,famp_idx,2:end),[3 4 5]));
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(after30_pac_rat{2,1}(ch1,ch2,:,fph_idx,famp_idx,2:end),[4 5]))' - squeeze(mean(after30_pac_rat{2,1}(ch1,ch2,t_idx,fph_idx,famp_idx,2:end),[3 4 5]));
stdshade(y,0.4,colors(2,:),tout)
xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.', 'Location', 'best')
ylabel('After 30')

subplot(8,1,8)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

xlabel('Time (msec)')
sgtitle(sprintf('Normalized PAC\n %s {phase} (%d-%d) - %s {amp} (%d-%d)\n', ch_labels{1}(ch1),fph_range(1), fph_range(2), ch_labels{1}(ch2), famp_range(1), famp_range(2)))

% set(gcf,'Units','Inches');
% set(gcf,'PaperPosition',[0 0 4 9],'PaperUnits','Inches','PaperSize',[4, 9])
% save_fig('../Results/PAC_general/', strcat(ch_labels{1}(ch1), string(fph_range(1)), '-', string(fph_range(2)), ch_labels{1}(ch2), string(famp_range(1)), '-', string(famp_range(2))))

%% pval for each frequency bin between target and std.


fph_out = paramsOut.fph_out;
famp_out = paramsOut.famp_out;
tout = paramsOut.tout;


params.type = 'signrank';
params.is_corr = false;
params.is_baseline_norm = true;

[pval_before, h_before] = calc_comod_pval(before_pac_rat,tout,fph_out,famp_out,params);
[pval_after10, h_after10] = calc_comod_pval(after10_pac_rat,tout,fph_out,famp_out,type,params);
[pval_after20, h_after20] = calc_comod_pval(after20_pac_rat,tout,fph_out,famp_out,type,params);
[pval_after30, h_after30] = calc_comod_pval(after30_pac_rat,tout,fph_out,famp_out,type,params);


save_dir = '../Results/PAC_general/';

save(strcat(save_dir, 'before/', 'PACcomoPval_Before_allCh_allWin_perFreqComp', '.mat'), 'pval_before', 'h_before', 'params', 'paramsOut', 'cfg');
save(strcat(save_dir, 'after10/', 'PACcomoPval_After10_allCh_allWin_perFreqComp', '.mat'), 'pval_after10', 'h_after10', 'params', 'paramsOut', 'cfg');
save(strcat(save_dir, 'after20/', 'PACcomoPval_After20_allCh_allWin_perFreqComp', '.mat'), 'pval_after20', 'h_after20', 'params', 'paramsOut', 'cfg');
save(strcat(save_dir, 'after30/', 'PACcomoPval_After30_allCh_allWin_perFreqComp', '.mat'), 'pval_after30', 'h_after30', 'params', 'paramsOut', 'cfg');

%% load pval

save_dir = '../Results/PAC_general/';

load(strcat(save_dir, 'before/', 'PACcomoPval_Before_allCh_allWin_perFreqComp', '.mat'));
load(strcat(save_dir, 'after10/', 'PACcomoPval_After10_allCh_allWin_perFreqComp', '.mat'));
load(strcat(save_dir, 'after20/', 'PACcomoPval_After20_allCh_allWin_perFreqComp', '.mat'));
load(strcat(save_dir, 'after30/', 'PACcomoPval_After30_allCh_allWin_perFreqComp', '.mat'));


%% visualization of pval mat
ch1 = 2;
ch2 = 3;

fph_out = paramsOut.fph_out;
famp_out = paramsOut.famp_out;
tout = paramsOut.tout;

sig = -log(pval_before);
sig(~h_before)=NaN;

[fph_mesh,famp_mesh] = meshgrid(fph_out, famp_out);

figure
for t_idx = 1:length(tout)
    pcolor(fph_mesh,famp_mesh,squeeze(sig(ch1,ch2,t_idx,:,:))');
    shading flat
    colormap jet
    colorbar
    title(sprintf('%s {phase} - %s {amp}\n t=%.2f', ch_labels{1}(ch1),ch_labels{1}(ch2),tout(t_idx)/1000))
    clim([0 -log(0.05)])
    
    drawnow
    waitforbuttonpress
%     pause(0.05)
end

%% pac movie (target and std and pval)


fph_out = paramsOut.fph_out;
famp_out = paramsOut.famp_out;
tout = paramsOut.tout;
[fph_mesh,famp_mesh] = meshgrid(fph_out, famp_out);

t_idx = tout<=0;

in_pac = before_pac_rat;
before_Tar_basenorm = mean( in_pac{3,1}(:,:,:,:,:,2:end) - mean(in_pac{3,1}(:,:,t_idx,:,:,2:end),3) ,6, 'omitnan');
before_Std_basenorm = mean( in_pac{2,1}(:,:,:,:,:,2:end) - mean(in_pac{2,1}(:,:,t_idx,:,:,2:end),3) ,6, 'omitnan');

in_pac = after10_pac_rat;
after10_Tar_basenorm = mean( in_pac{3,1}(:,:,:,:,:,2:end) - mean(in_pac{3,1}(:,:,t_idx,:,:,2:end),3) ,6, 'omitnan');
after10_Std_basenorm = mean( in_pac{2,1}(:,:,:,:,:,2:end) - mean(in_pac{2,1}(:,:,t_idx,:,:,2:end),3) ,6, 'omitnan');

in_pac = after20_pac_rat;
after20_Tar_basenorm = mean( in_pac{3,1}(:,:,:,:,:,2:end) - mean(in_pac{3,1}(:,:,t_idx,:,:,2:end),3) ,6, 'omitnan');
after20_Std_basenorm = mean( in_pac{2,1}(:,:,:,:,:,2:end) - mean(in_pac{2,1}(:,:,t_idx,:,:,2:end),3) ,6, 'omitnan');

in_pac = after30_pac_rat;
after30_Tar_basenorm = mean( in_pac{3,1}(:,:,:,:,:,2:end) - mean(in_pac{3,1}(:,:,t_idx,:,:,2:end),3) ,6, 'omitnan');
after30_Std_basenorm = mean( in_pac{2,1}(:,:,:,:,:,2:end) - mean(in_pac{2,1}(:,:,t_idx,:,:,2:end),3) ,6, 'omitnan');


for ch1=1:1
    for ch2=1:1
        % Create a VideoWriter object  
%         fname = path_res+sprintf('PACcom_allBeforeAfter_ClnTrial_%sphase_%samp',  ch_labels{1}(ch1), ch_labels{1}(ch2));
%         v = VideoWriter(fname, 'MPEG-4');  
%         v.FrameRate = 2;
%         open(v);  
        
        figure('WindowState', 'maximize');
        set(gcf,'Units','Inches');
        set(gcf,'PaperPosition',[0 0 9 6],'PaperUnits','Inches','PaperSize',[9, 6])
        
        for t_idx=1:1%length(tout)
            
            p1 = subplot(3,4,1);
            pcolor(fph_mesh,famp_mesh,squeeze(before_Tar_basenorm(ch1,ch2,t_idx,:,:))');
            shading flat;colormap jet;colorbar;
            cmin_befTar = min(before_Tar_basenorm(ch1,ch2,:,:,:),[],'all');
            cmax_befTar = max(before_Tar_basenorm(ch1,ch2,:,:,:),[],'all');
            
            p5 = subplot(3,4,5);
            pcolor(fph_mesh,famp_mesh,squeeze(before_Std_basenorm(ch1,ch2,t_idx,:,:))');
            shading flat;colormap jet;colorbar;
            cmin_befStd = min(before_Std_basenorm(ch1,ch2,:,:,:),[],'all');
            cmax_befStd = max(before_Std_basenorm(ch1,ch2,:,:,:),[],'all');
            
            cmin = min([cmin_befTar cmin_befStd]);
            cmax = max([cmax_befTar cmax_befStd]);
            clim(p1,[cmin*1.2 cmax*.9]); 
            clim(p5,[cmin*1.2 cmax*.9]);
           
            p9 = subplot(3,4,9);
            sig = -log(pval_before);
            sig(~h_before)=NaN;
            pcolor(fph_mesh,famp_mesh,squeeze(sig(ch1,ch2,t_idx,:,:))');
            shading flat;colormap jet;colorbar;
            clim(p9,[-log(0.05) -log(0.01)])
            
            %
            p2 = subplot(3,4,2);
            pcolor(fph_mesh,famp_mesh,squeeze(after10_Tar_basenorm(ch1,ch2,t_idx,:,:))');
            shading flat;colormap jet;colorbar;
            cmin_af10Tar = min(after10_Tar_basenorm(ch1,ch2,:,:,:),[],'all');
            cmax_af10Tar = max(after10_Tar_basenorm(ch1,ch2,:,:,:),[],'all');
            
            p6 = subplot(3,4,6);
            pcolor(fph_mesh,famp_mesh,squeeze(after10_Std_basenorm(ch1,ch2,t_idx,:,:))');
            shading flat;colormap jet;colorbar;
            cmin_af10Std = min(after10_Std_basenorm(ch1,ch2,:,:,:),[],'all');
            cmax_af10Std = max(after10_Std_basenorm(ch1,ch2,:,:,:),[],'all');
            
            cmin = min([cmin_af10Tar cmin_af10Std]);
            cmax = max([cmax_af10Tar cmax_af10Std]);
            clim(p2,[cmin*1.2 cmax*.9]); 
            clim(p6,[cmin*1.2 cmax*.9]);
            
            p10 = subplot(3,4,10);
            sig = -log(pval_after10);
            sig(~h_after10)=NaN;
            pcolor(fph_mesh,famp_mesh,squeeze(sig(ch1,ch2,t_idx,:,:))');
            shading flat;colormap jet;colorbar;
            clim(p10,[-log(0.05) -log(0.01)])
            
            %
            p3 = subplot(3,4,3);
            pcolor(fph_mesh,famp_mesh,squeeze(after20_Tar_basenorm(ch1,ch2,t_idx,:,:))');
            shading flat;colormap jet;colorbar;
            cmin_af20Tar = min(after20_Tar_basenorm(ch1,ch2,:,:,:),[],'all');
            cmax_af20Tar = max(after20_Tar_basenorm(ch1,ch2,:,:,:),[],'all');
            
            p7 = subplot(3,4,7);
            pcolor(fph_mesh,famp_mesh,squeeze(after20_Std_basenorm(ch1,ch2,t_idx,:,:))');
            shading flat;colormap jet;colorbar;
            cmin_af20Std = min(after20_Std_basenorm(ch1,ch2,:,:,:),[],'all');
            cmax_af20Std = max(after20_Std_basenorm(ch1,ch2,:,:,:),[],'all');
            
            cmin = min([cmin_af20Tar cmin_af20Std]);
            cmax = max([cmax_af20Tar cmax_af20Std]);
            clim(p3,[cmin*1.2 cmax*.9]); 
            clim(p7,[cmin*1.2 cmax*.9]);
            
            p11 = subplot(3,4,11);
            sig = -log(pval_after20);
            sig(~h_after20)=NaN;
            pcolor(fph_mesh,famp_mesh,squeeze(sig(ch1,ch2,t_idx,:,:))');
            shading flat;colormap jet;colorbar;
            clim(p11,[-log(0.05) -log(0.01)])
            
            %
            p4 = subplot(3,4,4);
            pcolor(fph_mesh,famp_mesh,squeeze(after30_Tar_basenorm(ch1,ch2,t_idx,:,:))');
            shading flat;colormap jet;colorbar;
            cmin_af30Tar = min(after30_Tar_basenorm(ch1,ch2,:,:,:),[],'all');
            cmax_af30Tar = max(after30_Tar_basenorm(ch1,ch2,:,:,:),[],'all');
            
            p8 = subplot(3,4,8);
            pcolor(fph_mesh,famp_mesh,squeeze(after30_Std_basenorm(ch1,ch2,t_idx,:,:))');
            shading flat;colormap jet;colorbar;
            cmin_af30Std = min(after30_Std_basenorm(ch1,ch2,:,:,:),[],'all');
            cmax_af30Std = max(after30_Std_basenorm(ch1,ch2,:,:,:),[],'all');
            
            cmin = min([cmin_af30Tar cmin_af30Std]);
            cmax = max([cmax_af30Tar cmax_af30Std]);
            clim(p4,[cmin*1.2 cmax*.9]); 
            clim(p8,[cmin*1.2 cmax*.9]);
            
            p12 = subplot(3,4,12);
            sig = -log(pval_after30);
            sig(~h_after30)=NaN;
            pcolor(fph_mesh,famp_mesh,squeeze(sig(ch1,ch2,t_idx,:,:))');
            shading flat;colormap jet;colorbar;
            clim(p12,[-log(0.05) -log(0.01)])
        
            if(t_idx==1)
                position = get(p1, 'Position');  
                annotation('textbox', [position(1), 0.85, 0.1, 0.1], 'String', 'Before', 'EdgeColor', 'none', 'HorizontalAlignment', 'center');  
                position = get(p2, 'Position');  
                annotation('textbox', [position(1), 0.85, 0.1, 0.1], 'String', 'After10', 'EdgeColor', 'none', 'HorizontalAlignment', 'center');  
                position = get(p3, 'Position');  
                annotation('textbox', [position(1), 0.85, 0.1, 0.1], 'String', 'After20', 'EdgeColor', 'none', 'HorizontalAlignment', 'center');  
                position = get(p4, 'Position');  
                annotation('textbox', [position(1), 0.85, 0.1, 0.1], 'String', 'After30', 'EdgeColor', 'none', 'HorizontalAlignment', 'center');  
                    
                position = get(p1, 'Position'); 
                annotation('textbox', [0.1, position(2), 0.1, 0.1], 'String', 'Target', 'EdgeColor', 'none', 'Rotation', 90);
                position = get(p5, 'Position'); 
                annotation('textbox', [0.1, position(2), 0.1, 0.1], 'String', 'Std.', 'EdgeColor', 'none', 'Rotation', 90);
                position = get(p9, 'Position'); 
                annotation('textbox', [0.1, position(2), 0.1, 0.1], 'String', 'P-value', 'EdgeColor', 'none', 'Rotation', 90);
            end
        
            sgtitle(sprintf('%s {phase} - %s {amp}\n t = %.2f', ch_labels{1}(ch1),ch_labels{1}(ch2),tout(t_idx)/1000),'FontSize',10)
            drawnow
        %     pause(0.01)
        
            % Capture the current figure  
%             frame = getframe(gcf);  
%             writeVideo(v, frame);  % Write the frame to the video  
        
        end
%         close(v);  % Close the video file 
%         close all
    end
end



%% target-std pac diff
close all

% normalized with baseline removal
ch1 = 4;
ch2 = 1;
fph_range = [4 8];
famp_range = [39 41];

fph_out = paramsOut.fph_out;
famp_out = paramsOut.famp_out;
tout = paramsOut.tout;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);
t_idx = tout<=0 ;

rat_idx = 2:8;
colors = [0.4940 0.1840 0.5560;
          0.8500 0.3250 0.0980 ];
type = 'signrank';
is_corr = false;

fig = figure(23); % Create a figure  
% screenSize = get(0, 'ScreenSize'); % Get the screen size  
% set(fig, 'Position', [screenSize(3)*3/4, 0, screenSize(3)/4, screenSize(4)]); % Set figure position to full vertical size
hold on 

x = squeeze(mean(before_pac_rat{3,1}(ch1,ch2,:,fph_idx,famp_idx,rat_idx),[4 5]))' - squeeze(mean(before_pac_rat{3,1}(ch1,ch2,t_idx,fph_idx,famp_idx,rat_idx),[3 4 5]));
y = squeeze(mean(before_pac_rat{2,1}(ch1,ch2,:,fph_idx,famp_idx,rat_idx),[4 5]))' - squeeze(mean(before_pac_rat{2,1}(ch1,ch2,t_idx,fph_idx,famp_idx,rat_idx),[3 4 5]));
figure(23), stdshade(x-y,0.4,'b',tout)
figure(20), set(gca,'ColorOrderIndex',1), plot(tout,x-y,'LineWidth',2), hold on


x = squeeze(mean(after10_pac_rat{3,1}(ch1,ch2,:,fph_idx,famp_idx,rat_idx),[4 5]))' - squeeze(mean(after10_pac_rat{3,1}(ch1,ch2,t_idx,fph_idx,famp_idx,rat_idx),[3 4 5]));
y = squeeze(mean(after10_pac_rat{2,1}(ch1,ch2,:,fph_idx,famp_idx,rat_idx),[4 5]))' - squeeze(mean(after10_pac_rat{2,1}(ch1,ch2,t_idx,fph_idx,famp_idx,rat_idx),[3 4 5]));
figure(23), stdshade(x-y,0.4,'r',tout)
figure(20), set(gca,'ColorOrderIndex',1), plot(tout,x-y,':','LineWidth',2)


x = squeeze(mean(after20_pac_rat{3,1}(ch1,ch2,:,fph_idx,famp_idx,rat_idx),[4 5]))' - squeeze(mean(after20_pac_rat{3,1}(ch1,ch2,t_idx,fph_idx,famp_idx,rat_idx),[3 4 5]));
y = squeeze(mean(after20_pac_rat{2,1}(ch1,ch2,:,fph_idx,famp_idx,rat_idx),[4 5]))' - squeeze(mean(after20_pac_rat{2,1}(ch1,ch2,t_idx,fph_idx,famp_idx,rat_idx),[3 4 5]));
figure(23), stdshade(x-y,0.4,'g',tout)
figure(20), set(gca,'ColorOrderIndex',1), plot(tout,x-y,'--','LineWidth',2)


x = squeeze(mean(after30_pac_rat{3,1}(ch1,ch2,:,fph_idx,famp_idx,rat_idx),[4 5]))' - squeeze(mean(after30_pac_rat{3,1}(ch1,ch2,t_idx,fph_idx,famp_idx,rat_idx),[3 4 5]));
y = squeeze(mean(after30_pac_rat{2,1}(ch1,ch2,:,fph_idx,famp_idx,rat_idx),[4 5]))' - squeeze(mean(after30_pac_rat{2,1}(ch1,ch2,t_idx,fph_idx,famp_idx,rat_idx),[3 4 5]));
figure(23), stdshade(x-y,0.4,'m',tout)
figure(20), set(gca,'ColorOrderIndex',1), plot(tout,x-y,'-.','LineWidth',2)

figure(23)
xline(0,'-k','LineWidth',2)
xlabel('Time (msec)')
legend('Before', 'After10', 'After20', 'After30')
sgtitle(sprintf('PAC diff. (Tar-std.)\n %s {phase} (%d-%d) - %s {amp} (%d-%d)\n', ch_labels{1}(ch1),fph_range(1), fph_range(2), ch_labels{1}(ch2), famp_range(1), famp_range(2)))

figure(20)
xline(0,'-k','LineWidth',2)
xlabel('Time (msec)')
