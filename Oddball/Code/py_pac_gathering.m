clc; 
clear;
% close all;

addpath(genpath('./Functions'))

path_res = ("D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Results\PAC_general\"); 


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

input = After30_Data;
useClean = true;
t_trim = -0.7; % ignore nan values in time

path_load = ['D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\' ...
    'Oddball\Oddball_Entrain_ERP-main\Results\PAC_general\After30\'];
save_dir = path_res + 'After30\';

nRat = length(input);
PAC = cell(size(input));

for iRat=1:nRat
    disp('Rat: '+string(iRat))
    DataRat = input{iRat,1};
    nSess = size(DataRat,2);
    pac_sess = cell(3,nSess);

    for iSess=1:nSess
        DataSess = DataRat{1,iSess};
        cleanTr = logical(DataRat{4,iSess});

        all_labels = true(size(cleanTr));
        std_labels  = DataRat{7,iSess};
        target_labels  = DataRat{8,iSess};
        changed_labels  = DataRat{9,iSess};
        unChanged_labels  = DataRat{10,iSess};

        if(useClean)
            all_labels = all_labels & cleanTr;
            std_labels = std_labels & cleanTr;
            target_labels = target_labels & cleanTr;
            changed_labels = changed_labels & cleanTr;
            unChanged_labels = unChanged_labels & cleanTr;
        end

        fname = "pyPACcomo_allCh_allWin_allTrial_After30_Rat"+string(iRat-1)+"_Sess"+string(iSess-1)+".mat";
        load(path_load + fname);

        idx = find(paramsOut.tout>=t_trim,1,'first');

        pac_sess{1,iSess} = mean(pac(:,:,idx:end,:,:,all_labels),6,'omitnan'); % all trials
        pac_sess{2,iSess} = mean(pac(:,:,idx:end,:,:,std_labels),6,'omitnan'); % std trial
        pac_sess{3,iSess} = mean(pac(:,:,idx:end,:,:,target_labels),6,'omitnan'); % target trial
        pac_sess{4,iSess} = mean(pac(:,:,idx:end,:,:,changed_labels),6,'omitnan'); % changed trial
        pac_sess{5,iSess} = mean(pac(:,:,idx:end,:,:,unChanged_labels),6,'omitnan'); % unChanged trial

    end

    PAC{iRat,1} = pac_sess;
     
end
%%

PAC_After30 = PAC;
tout = paramsOut.tout(paramsOut.tout>=t_trim);
paramsOut.tout = tout;
paramsOut.fph_out
paramsOut.famp_out
% save(strcat(save_dir, 'pyPACcomo_After30_allCh_allWin_meanTrial_perRatSess', '.mat'), 'PAC_After30', 'params', 'paramsOut', 'cfg');


%% load pacs

save_dir = '../Results/PAC_trialSwap/';
% 
load(strcat(save_dir, 'before/', 'pyPACcomo_Before_allCh_allWin_meanTrial_perRatSess', '.mat'));
load(strcat(save_dir, 'after10/', 'pyPACcomo_After10_allCh_allWin_meanTrial_perRatSess', '.mat'));
load(strcat(save_dir, 'after20/', 'pyPACcomo_After20_allCh_allWin_meanTrial_perRatSess', '.mat'));
load(strcat(save_dir, 'after30/', 'pyPACcomo_After30_allCh_allWin_meanTrial_perRatSess', '.mat'));

%% 1D -  in time
ch1 = 3;
ch2 = 3;
iRat = 7;
iSess = 1;
fph_range = [8 12];
famp_range = [30 50];
PAC_in = PAC_Before;

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);


figure
plot(paramsOut.tout, squeeze(mean(PAC_in{iRat,1}{1,iSess}(ch1,ch2,:,famp_idx,fph_idx),[4 5])),'LineWidth',2)
hold on
plot(paramsOut.tout, squeeze(mean(PAC_in{iRat,1}{2,iSess}(ch1,ch2,:,famp_idx,fph_idx),[4 5])),'LineWidth',2)
plot(paramsOut.tout, squeeze(mean(PAC_in{iRat,1}{3,iSess}(ch1,ch2,:,famp_idx,fph_idx),[4 5])),'LineWidth',2)
plot(paramsOut.tout, squeeze(mean(PAC_in{iRat,1}{4,iSess}(ch1,ch2,:,famp_idx,fph_idx),[4 5])),'LineWidth',2)
plot(paramsOut.tout, squeeze(mean(PAC_in{iRat,1}{5,iSess}(ch1,ch2,:,famp_idx,fph_idx),[4 5])),'LineWidth',2)

xline(0,'-k','LineWidth',2)
legend('All','Std.','Target','changed', 'unChanged')
title(sprintf('%s {phase} - %s {amp}\n', ch_labels{1}(ch1),ch_labels{1}(ch2)))
    
%% 2D - comodulogram

ch1 = 3;
ch2 = 3;
iRat = 4;
iSess = 1;
PAC_in = PAC_After30;
iState = [3 2];

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;


[fph_mesh,famp_mesh] = meshgrid(fph_out, famp_out);

fig = figure; % Create a figure  
screenSize = get(0, 'ScreenSize'); % Get the screen size  
set(fig, 'Position', [screenSize(1), screenSize(4)*2/4, screenSize(3)/2, screenSize(4)/3]); % Set figure position to full vertical size

for ti=1:length(tout)
    
    p1 = subplot(1,2,1);
    pcolor(fph_mesh,famp_mesh,squeeze((PAC_in{iRat,1}{iState(1),iSess}(ch1,ch2,ti,:,:))));
    shading interp;colormap jet;colorbar;
    cmin1 = min(squeeze((PAC_in{iRat,1}{iState(1),iSess}(ch1,ch2,:,:,:))),[],'all');
    cmax1 = max(squeeze((PAC_in{iRat,1}{iState(1),iSess}(ch1,ch2,:,:,:))),[],'all');
    title('Target')

    p2 = subplot(1,2,2);
    pcolor(fph_mesh,famp_mesh,squeeze((PAC_in{iRat,1}{iState(2),iSess}(ch1,ch2,ti,:,:))));
    shading interp;colormap jet;colorbar;
    cmin2 = min(squeeze((PAC_in{iRat,1}{iState(2),iSess}(ch1,ch2,:,:,:))),[],'all');
    cmax2 = max(squeeze((PAC_in{iRat,1}{iState(2),iSess}(ch1,ch2,:,:,:))),[],'all');
    title('Std.')

    cmin = min([cmin1 cmin2]);
    cmax = max([cmax1 cmax2]);
%     clim(p1,[cmin*1.2 cmax*.9]); 
%     clim(p2,[cmin*1.2 cmax*.9]);
    clim(p1,[0 cmax*.9]); 
    clim(p2,[0 cmax*.9]);

    sgtitle(sprintf('%s {phase} - %s {amp}\n t=%.2f', ch_labels{1}(ch1),ch_labels{1}(ch2),tout(ti)))
    drawnow
    pause(0.05)
end

%% mean over sessions

input = PAC_Before;
nRat = size(input,1);
beforeAll_pac_rat = [];
beforeStd_pac_rat = [];
beforeTarget_pac_rat = [];
beforeChanged_pac_rat = [];
beforeUnChanged_pac_rat = [];
for iRat=1:nRat
    temp_rat = input{iRat,1};
    nSess = size(temp_rat,2);
    tempAll_sess = [];
    tempStd_sess = [];
    tempTarget_sess = [];
    tempChanged_sess = [];
    tempUnChanged_sess = [];
    if iRat==5, nSess = 1; elseif iRat==6, nSess = 3; else nSess = 1; end
    for iSess=nSess:nSess
        tempAll_sess = cat(6,tempAll_sess,temp_rat{1,iSess});
        tempStd_sess = cat(6,tempStd_sess,temp_rat{2,iSess});
        tempTarget_sess = cat(6,tempTarget_sess,temp_rat{3,iSess});
        tempChanged_sess = cat(6,tempChanged_sess,temp_rat{4,iSess});
        tempUnChanged_sess = cat(6,tempUnChanged_sess,temp_rat{5,iSess});
    end
    beforeAll_pac_rat = cat(6,beforeAll_pac_rat, mean(tempAll_sess,6,'omitnan'));
    beforeStd_pac_rat = cat(6,beforeStd_pac_rat, mean(tempStd_sess,6,'omitnan'));
    beforeTarget_pac_rat = cat(6,beforeTarget_pac_rat, mean(tempTarget_sess,6,'omitnan'));
    beforeChanged_pac_rat = cat(6,beforeChanged_pac_rat, mean(tempChanged_sess,6,'omitnan'));
    beforeUnChanged_pac_rat = cat(6,beforeUnChanged_pac_rat, mean(tempUnChanged_sess,6,'omitnan'));
end
before_pac_rat{1,1} = beforeAll_pac_rat;
before_pac_rat{2,1} = beforeStd_pac_rat;
before_pac_rat{3,1} = beforeTarget_pac_rat;
before_pac_rat{4,1} = beforeChanged_pac_rat;
before_pac_rat{5,1} = beforeUnChanged_pac_rat;

input = PAC_After10;
nRat = size(input,1);
after10All_pac_rat = [];
after10Std_pac_rat = [];
after10Target_pac_rat = [];
after10Changed_pac_rat = [];
after10UnChanged_pac_rat = [];
for iRat=1:nRat
    temp_rat = input{iRat,1};
    nSess = size(temp_rat,2);
    tempAll_sess = [];
    tempStd_sess = [];
    tempTarget_sess = [];
    tempChanged_sess = [];
    tempUnChanged_sess = [];
    for iSess=1:1
        tempAll_sess = cat(6,tempAll_sess,temp_rat{1,iSess});
        tempStd_sess = cat(6,tempStd_sess,temp_rat{2,iSess});
        tempTarget_sess = cat(6,tempTarget_sess,temp_rat{3,iSess});
        tempChanged_sess = cat(6,tempChanged_sess,temp_rat{4,iSess});
        tempUnChanged_sess = cat(6,tempUnChanged_sess,temp_rat{5,iSess});
    end
    after10All_pac_rat = cat(6,after10All_pac_rat, mean(tempAll_sess,6,'omitnan'));
    after10Std_pac_rat = cat(6,after10Std_pac_rat, mean(tempStd_sess,6,'omitnan'));
    after10Target_pac_rat = cat(6,after10Target_pac_rat, mean(tempTarget_sess,6,'omitnan'));
    after10Changed_pac_rat = cat(6,after10Changed_pac_rat, mean(tempChanged_sess,6,'omitnan'));
    after10UnChanged_pac_rat = cat(6,after10UnChanged_pac_rat, mean(tempUnChanged_sess,6,'omitnan'));
end
after10_pac_rat{1,1} = after10All_pac_rat;
after10_pac_rat{2,1} = after10Std_pac_rat;
after10_pac_rat{3,1} = after10Target_pac_rat;
after10_pac_rat{4,1} = after10Changed_pac_rat;
after10_pac_rat{5,1} = after10UnChanged_pac_rat;

input = PAC_After20;
nRat = size(input,1);
after20All_pac_rat = [];
after20Std_pac_rat = [];
after20Target_pac_rat = [];
after20Changed_pac_rat = [];
after20UnChanged_pac_rat = [];
for iRat=1:nRat
    temp_rat = input{iRat,1};
    nSess = size(temp_rat,2);
    tempAll_sess = [];
    tempStd_sess = [];
    tempTarget_sess = [];
    tempChanged_sess = [];
    tempUnChanged_sess = [];
    for iSess=1:1
        tempAll_sess = cat(6,tempAll_sess,temp_rat{1,iSess});
        tempStd_sess = cat(6,tempStd_sess,temp_rat{2,iSess});
        tempTarget_sess = cat(6,tempTarget_sess,temp_rat{3,iSess});
        tempChanged_sess = cat(6,tempChanged_sess,temp_rat{4,iSess});
        tempUnChanged_sess = cat(6,tempUnChanged_sess,temp_rat{5,iSess});
    end
    after20All_pac_rat = cat(6,after20All_pac_rat, mean(tempAll_sess,6,'omitnan'));
    after20Std_pac_rat = cat(6,after20Std_pac_rat, mean(tempStd_sess,6,'omitnan'));
    after20Target_pac_rat = cat(6,after20Target_pac_rat, mean(tempTarget_sess,6,'omitnan'));
    after20Changed_pac_rat = cat(6,after20Changed_pac_rat, mean(tempChanged_sess,6,'omitnan'));
    after20UnChanged_pac_rat = cat(6,after20UnChanged_pac_rat, mean(tempUnChanged_sess,6,'omitnan'));
end

after20All_pac_rat = cat(6,NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),after20All_pac_rat);
after20Std_pac_rat = cat(6,NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),after20Std_pac_rat);
after20Target_pac_rat = cat(6,NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),after20Target_pac_rat);
after20Changed_pac_rat = cat(6,NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),after20Changed_pac_rat);
after20UnChanged_pac_rat = cat(6,NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),after20UnChanged_pac_rat);

after20_pac_rat{1,1} = after20All_pac_rat;
after20_pac_rat{2,1} = after20Std_pac_rat;
after20_pac_rat{3,1} = after20Target_pac_rat;
after20_pac_rat{4,1} = after20Changed_pac_rat;
after20_pac_rat{5,1} = after20UnChanged_pac_rat;


input = PAC_After30;
nRat = size(input,1);
after30All_pac_rat = [];
after30Std_pac_rat = [];
after30Target_pac_rat = [];
after30Changed_pac_rat = [];
after30UnChanged_pac_rat = [];
for iRat=1:nRat
    temp_rat = input{iRat,1};
    nSess = size(temp_rat,2);
    tempAll_sess = [];
    tempStd_sess = [];
    tempTarget_sess = [];
    tempChanged_sess = [];
    tempUnChanged_sess = [];
    for iSess=1:1
        tempAll_sess = cat(6,tempAll_sess,temp_rat{1,iSess});
        tempStd_sess = cat(6,tempStd_sess,temp_rat{2,iSess});
        tempTarget_sess = cat(6,tempTarget_sess,temp_rat{3,iSess});
        tempChanged_sess = cat(6,tempChanged_sess,temp_rat{4,iSess});
        tempUnChanged_sess = cat(6,tempUnChanged_sess,temp_rat{5,iSess});
    end
    after30All_pac_rat = cat(6,after30All_pac_rat, mean(tempAll_sess,6,'omitnan'));
    after30Std_pac_rat = cat(6,after30Std_pac_rat, mean(tempStd_sess,6,'omitnan'));
    after30Target_pac_rat = cat(6,after30Target_pac_rat, mean(tempTarget_sess,6,'omitnan'));
    after30Changed_pac_rat = cat(6,after30Changed_pac_rat, mean(tempChanged_sess,6,'omitnan'));
    after30UnChanged_pac_rat = cat(6,after30UnChanged_pac_rat, mean(tempUnChanged_sess,6,'omitnan'));
end

after30All_pac_rat = cat(6,NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),after30All_pac_rat);
after30Std_pac_rat = cat(6,NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),after30Std_pac_rat);
after30Target_pac_rat = cat(6,NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),after30Target_pac_rat);
after30Changed_pac_rat = cat(6,NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),after30Changed_pac_rat);
after30UnChanged_pac_rat = cat(6,NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),NaN(size(mean(tempAll_sess,6))),after30UnChanged_pac_rat);

after30_pac_rat{1,1} = after30All_pac_rat;
after30_pac_rat{2,1} = after30Std_pac_rat;
after30_pac_rat{3,1} = after30Target_pac_rat;
after30_pac_rat{4,1} = after30Changed_pac_rat;
after30_pac_rat{5,1} = after30UnChanged_pac_rat;


%% see each rat in each before/after
ch1 = 3;
ch2 = 3;
state = ["All","Std.","Target", "Changed", "unChanged"];
iState = 1;
fph_range = [8 12];
famp_range = [30 50];

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);


figure
plot(tout,squeeze(mean(before_pac_rat{iState,1}(ch1,ch2,:,famp_idx,fph_idx,:),[4 5], 'omitnan')),'LineWidth',2)
hold on
set(gca,'ColorOrderIndex',1)
plot(tout,squeeze(mean(after10_pac_rat{iState,1}(ch1,ch2,:,famp_idx,fph_idx,:),[4 5], 'omitnan')),':','LineWidth',2)
set(gca,'ColorOrderIndex',1)
plot(tout,squeeze(mean(after20_pac_rat{iState,1}(ch1,ch2,:,famp_idx,fph_idx,:),[4 5], 'omitnan')),'--','LineWidth',2)
set(gca,'ColorOrderIndex',1)
plot(tout,squeeze(mean(after30_pac_rat{iState,1}(ch1,ch2,:,famp_idx,fph_idx,:),[4 5], 'omitnan')),'-.','LineWidth',2)

xline(0,'-k','LineWidth',2)
title(sprintf('%s {phase} - %s {amp}\n %s', ch_labels{1}(ch1),ch_labels{1}(ch2),state(iState)))
    

figure
stdshade(squeeze(mean(before_pac_rat{iState,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5], 'omitnan'))',0.4,'b',tout)
hold on
stdshade(squeeze(mean(after10_pac_rat{iState,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5], 'omitnan'))',0.4,'r',tout)
stdshade(squeeze(mean(after20_pac_rat{iState,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5], 'omitnan'))',0.4,'g',tout)
stdshade(squeeze(mean(after30_pac_rat{iState,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5], 'omitnan'))',0.4,'m',tout)
xline(0,'-k','LineWidth',2)
title(sprintf('%s {phase} - %s {amp}\n %s', ch_labels{1}(ch1),ch_labels{1}(ch2),state(iState)))
    
%%
% without normalization
ch1 = 3;
ch2 = 3;
fph_range = [8 12];
famp_range = [50 70];

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
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
x = squeeze(mean(before_pac_rat{3,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5]))';
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(before_pac_rat{2,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5]))';
stdshade(y,0.4,colors(2,:),tout)

xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.', 'Location', 'best')

subplot(8,1,2)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

subplot(8,1,3)
x = squeeze(mean(after10_pac_rat{3,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5]))';
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(after10_pac_rat{2,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5]))';
stdshade(y,0.4,colors(2,:),tout)
xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.', 'Location', 'best')

subplot(8,1,4)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

subplot(8,1,5)
x = squeeze(mean(after20_pac_rat{3,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5]))';
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(after20_pac_rat{2,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5]))';
stdshade(y,0.4,colors(2,:),tout)
xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.', 'Location', 'best')

subplot(8,1,6)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

subplot(8,1,7)
x = squeeze(mean(after30_pac_rat{3,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5]))';
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(after30_pac_rat{2,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5]))';
stdshade(y,0.4,colors(2,:),tout)
xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.', 'Location', 'best')

subplot(8,1,8)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

xlabel('Time (msec)')
sgtitle(sprintf('PAC\n %s {phase} (%d-%d) - %s {amp} (%d-%d)\n', ch_labels{1}(ch1),fph_range(1), fph_range(2), ch_labels{1}(ch2), famp_range(1), famp_range(2)))


%%
% normalized with baseline removal
ch1 = 4;
ch2 = 1;
fph_range = [4 12];
famp_range = [30 50];

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);
t_idx = tout<=0 & tout>=-0.3 ;

colors = [0.4940 0.1840 0.5560;
          0.8500 0.3250 0.0980 ];
type = 'signrank';
is_corr = false;

fig = figure; % Create a figure  
screenSize = get(0, 'ScreenSize'); % Get the screen size  
set(fig, 'Position', [screenSize(1), 0, screenSize(3)/4, screenSize(4)]); % Set figure position to full vertical size

subplot(8,1,1)
x = squeeze(mean(before_pac_rat{3,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5]))' - squeeze(mean(before_pac_rat{3,1}(ch1,ch2,t_idx,famp_idx,fph_idx,2:end),[3 4 5]));
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(before_pac_rat{2,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5]))' - squeeze(mean(before_pac_rat{2,1}(ch1,ch2,t_idx,famp_idx,fph_idx,2:end),[3 4 5]));
stdshade(y,0.4,colors(2,:),tout)
xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.', 'Location', 'best')
ylabel('Before')

subplot(8,1,2)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

subplot(8,1,3)
x = squeeze(mean(after10_pac_rat{3,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5]))' - squeeze(mean(after10_pac_rat{3,1}(ch1,ch2,t_idx,famp_idx,fph_idx,2:end),[3 4 5]));
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(after10_pac_rat{2,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5]))' - squeeze(mean(after10_pac_rat{2,1}(ch1,ch2,t_idx,famp_idx,fph_idx,2:end),[3 4 5]));
stdshade(y,0.4,colors(2,:),tout)
xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.', 'Location', 'best')
ylabel('After 10')

subplot(8,1,4)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

subplot(8,1,5)
x = squeeze(mean(after20_pac_rat{3,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5]))' - squeeze(mean(after20_pac_rat{3,1}(ch1,ch2,t_idx,famp_idx,fph_idx,2:end),[3 4 5]));
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(after20_pac_rat{2,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5]))' - squeeze(mean(after20_pac_rat{2,1}(ch1,ch2,t_idx,famp_idx,fph_idx,2:end),[3 4 5]));
stdshade(y,0.4,colors(2,:),tout)
xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.', 'Location', 'best')
ylabel('After 20')

subplot(8,1,6)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

subplot(8,1,7)
x = squeeze(mean(after30_pac_rat{3,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5]))' - squeeze(mean(after30_pac_rat{3,1}(ch1,ch2,t_idx,famp_idx,fph_idx,2:end),[3 4 5]));
stdshade(x,0.4,colors(1,:),tout)
hold on
y = squeeze(mean(after30_pac_rat{2,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5]))' - squeeze(mean(after30_pac_rat{2,1}(ch1,ch2,t_idx,famp_idx,fph_idx,2:end),[3 4 5]));
stdshade(y,0.4,colors(2,:),tout)
xline(0,'-k','LineWidth',2)
[pval_vec,~] = plot_timeStar(tout,x,y,type,is_corr);
legend('Target', 'Std.', 'Location', 'best')
ylabel('After 30')

subplot(8,1,8)
plot(tout,-log(pval_vec) ,'LineWidth',2); hold on; xline(0,'-k','LineWidth',2); yline([-log(0.05),-log(0.01)],'LineWidth',2)

xlabel('Time (msec)')
sgtitle(sprintf('Normalized PAC\n %s {phase} (%d-%d) - %s {amp} (%d-%d)\n', ch_labels{1}(ch1),fph_range(1), fph_range(2), ch_labels{1}(ch2), famp_range(1), famp_range(2)))


%% grand average 2D comodulogram
%('All','Std.','Target','changed', 'unChanged')
ch1 = 3;
ch2 = 3;
fph_range = [4 12];
famp_range = [16 90];
c_max = 2e-2;
c_min = 0;

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

[fph_mesh,famp_mesh] = meshgrid(fph_out(fph_idx), famp_out(famp_idx));


figure
% for ti=1:length(tout)
%     ti=1:length(tout);
    ti=find(tout>=0,1);
    iState = 1;
    subplot(3,4,1)
    img = squeeze(mean(before_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([c_min c_max])
    ylabel('All')
    title('Before')

    subplot(3,4,2)
    img = squeeze(mean(after10_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([c_min c_max])
    title('After10')

    subplot(3,4,3)
    img = squeeze(mean(after20_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([c_min c_max])
    title('After20')
    
    subplot(3,4,4)
    img = squeeze(mean(after30_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([c_min c_max])
    title('After30')

    iState = 2;
    subplot(3,4,5)
    img = squeeze(mean(before_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([c_min c_max])
    ylabel('Std.')

    subplot(3,4,6)
    img = squeeze(mean(after10_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([c_min c_max])
    
    subplot(3,4,7)
    img = squeeze(mean(after20_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([c_min c_max])
    
    subplot(3,4,8)
    img = squeeze(mean(after30_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([c_min c_max])

    iState = 3;
    subplot(3,4,9)
    img = squeeze(mean(before_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([c_min c_max])
    ylabel('Target')

    subplot(3,4,10)
    img = squeeze(mean(after10_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([c_min c_max])
    
    subplot(3,4,11)
    img = squeeze(mean(after20_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([c_min c_max])
    
    subplot(3,4,12)
    img = squeeze(mean(after30_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([c_min c_max])

%     sgtitle(sprintf('%s {phase} - %s {amp}\n t=%.2f', ch_labels{1}(ch1),ch_labels{1}(ch2),tout(ti)))
    sgtitle(sprintf('%s {phase} - %s {amp}', ch_labels{1}(ch1),ch_labels{1}(ch2)))

    drawnow                             
    pause(0.05)
% end


set(gcf,'Units','Inches');
set(gcf,'PaperPosition',[0 0 15 15],'PaperUnits','Inches','PaperSize',[15, 15])
fname = path_res+sprintf('comoTrialSwap_meanAllTrialAllwinAllRatFirstSess',  ch_labels{1}(ch1));
% print(gcf, '-vector', '-dpng', '-r300', fname+'.png');
% saveas(gcf, fname+'.fig')

%% grand average with baseline removal 2D comodulogram
%('All','Std.','Target','changed', 'unChanged')
ch1 = 3;
ch2 = 3;
fph_range = [4 12];
famp_range = [16 90];
c_max = 0.5e-3;

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

[fph_mesh,famp_mesh] = meshgrid(fph_out(fph_idx), famp_out(famp_idx));
tb = tout>=-.7 & tout<=-0;

figure
% for ti=1:length(tout)
%     ti=1:length(tout);
    ti= tout>=0;
    iState = 1;
    subplot(3,4,1)
    img = squeeze(mean(before_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan')) - ...
            squeeze(mean(before_pac_rat{iState,1}(ch1,ch2,tb,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([0 c_max])
    ylabel('All')
    title('Before')

    subplot(3,4,2)
    img = squeeze(mean(after10_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan')) - ...
        squeeze(mean(after10_pac_rat{iState,1}(ch1,ch2,tb,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([0 c_max])
    title('After10')

    subplot(3,4,3)
    img = squeeze(mean(after20_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan')) - ...
        squeeze(mean(after20_pac_rat{iState,1}(ch1,ch2,tb,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([0 c_max])
    title('After20')
    
    subplot(3,4,4)
    img = squeeze(mean(after30_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan')) - ...
        squeeze(mean(after30_pac_rat{iState,1}(ch1,ch2,tb,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([0 c_max])
    title('After30')

    iState = 2;
    subplot(3,4,5)
    img = squeeze(mean(before_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan')) - ...
        squeeze(mean(before_pac_rat{iState,1}(ch1,ch2,tb,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([0 c_max])
    ylabel('Std.')

    subplot(3,4,6)
    img = squeeze(mean(after10_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan')) - ...
        squeeze(mean(after10_pac_rat{iState,1}(ch1,ch2,tb,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([0 c_max])
    
    subplot(3,4,7)
    img = squeeze(mean(after20_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan')) - ...
        squeeze(mean(after20_pac_rat{iState,1}(ch1,ch2,tb,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([0 c_max])
    
    subplot(3,4,8)
    img = squeeze(mean(after30_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan')) - ...
        squeeze(mean(after30_pac_rat{iState,1}(ch1,ch2,tb,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([0 c_max])

    iState = 3;
    subplot(3,4,9)
    img = squeeze(mean(before_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan')) - ...
        squeeze(mean(before_pac_rat{iState,1}(ch1,ch2,tb,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([0 c_max])
    ylabel('Target')

    subplot(3,4,10)
    img = squeeze(mean(after10_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan')) - ...
        squeeze(mean(after10_pac_rat{iState,1}(ch1,ch2,tb,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([0 c_max])
    
    subplot(3,4,11)
    img = squeeze(mean(after20_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan')) - ...
        squeeze(mean(after20_pac_rat{iState,1}(ch1,ch2,tb,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([0 c_max])
    
    subplot(3,4,12)
    img = squeeze(mean(after30_pac_rat{iState,1}(ch1,ch2,ti,famp_idx,fph_idx,2:end),[3 6], 'omitnan')) - ...
        squeeze(mean(after30_pac_rat{iState,1}(ch1,ch2,tb,famp_idx,fph_idx,2:end),[3 6], 'omitnan'));
    pcolor(fph_mesh,famp_mesh,img); shading interp; colormap jet
    clim([0 c_max])

%     sgtitle(sprintf('%s {phase} - %s {amp}\n t=%.2f', ch_labels{1}(ch1),ch_labels{1}(ch2),tout(ti)))
    sgtitle(sprintf('%s {phase} - %s {amp}', ch_labels{1}(ch1),ch_labels{1}(ch2)))

    drawnow                             
    pause(0.05)
% end


set(gcf,'Units','Inches');
set(gcf,'PaperPosition',[0 0 15 15],'PaperUnits','Inches','PaperSize',[15, 15])
fname = path_res+sprintf('comoTrialSwap_meanAllTrialAllwinAllRatFirstSess',  ch_labels{1}(ch1));
% print(gcf, '-vector', '-dpng', '-r300', fname+'.png');
% saveas(gcf, fname+'.fig')

%% grand average 1D in time

iState = 2; %('All','Std.','Target','changed', 'unChanged')
ch1 = 3;
ch2 = 3;
fph_range = [6 12];
famp_range = [30 50];
smooth = 0;

fph_out = mean(paramsOut.fph_out,2);
famp_out = mean(paramsOut.famp_out,2);
tout = paramsOut.tout;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

[fph_mesh,famp_mesh] = meshgrid(fph_out(fph_idx), famp_out(famp_idx));

figure
stdshade(squeeze(mean(before_pac_rat{iState,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5], 'omitnan'))', 0.4, 'b', tout+.25, smooth)
hold on
% stdshade(squeeze(mean(after10_pac_rat{iState,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5], 'omitnan'))', 0.4, 'r', tout+.25, smooth)
% stdshade(squeeze(mean(after20_pac_rat{iState,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5], 'omitnan'))', 0.4, 'g', tout+.25, smooth)
stdshade(squeeze(mean(after30_pac_rat{iState,1}(ch1,ch2,:,famp_idx,fph_idx,2:end),[4 5], 'omitnan'))', 0.4, 'm', tout+.25, smooth)
legend('Before', 'After10', 'After20', 'After30')

