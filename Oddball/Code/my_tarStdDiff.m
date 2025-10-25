clc; 
clear;

addpath(genpath('./Functions'))

path_res = ("D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Results\"); 

cfgReference

%% load epoched data

sig_path = path_res+"Signals\sigZscr_eeglab_trZscore_0.1-300Hz-1.5-2epoch\";

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


Before_Data   = load(strcat(sig_path, 'Before_Data', dataName, '.mat')).Before_Data;
% After10_Data  = load(strcat(sig_path, 'After10days_Data', dataName, '.mat')).After10days_Data;
% After20_Data  = load(strcat(sig_path, 'After20days_Data', dataName, '.mat')).After20days_Data;
After30_Data  = load(strcat(sig_path, 'After30days_Data', dataName, '.mat')).After30days_Data;

smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * fs;
time_epoched = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start);

%% p3 erp

useClean = true;
balance = false;
params.t_range = [0.3 0.7];

[P3_Before] = p3_peakFinder(Before_Data,useClean,balance,params,cfg);
[P3_After30] = p3_peakFinder(After30_Data,useClean,balance,params,cfg);

[P3_BeforeArr] = makeArray(P3_Before);
[P3_After30eArr] = makeArray(P3_After30);

%%
iCh = 3;
States = ['std','tar','tar-std','changed','unChanged','changed-unChanged'];
iState = 3;
iSess = 1;
figure
histogram(squeeze(P3_BeforeArr(iCh, iState,:, iSess)),50)
hold on
histogram(squeeze(P3_After30eArr(iCh, iState,:, iSess)),50)


%% load pacs

useSingle = true;
path = path_res + "PAC_general\";
[PAC_Before, time_pac, famp_out, fph_out] = pacLoader(Before_Datasets,path,"Before",useSingle);
[PAC_After30, time_pac, famp_out, fph_out] = pacLoader(After30days_Datasets,path,"After30",useSingle);



%% pac erp
useClean = true;
balance = false;

params.fph_out = fph_out;
params.famp_out = famp_out;
params.fph_range = [4 6];
params.famp_range = [60 80];
params.time_pac = time_pac;
params.t_range = [0.3 0.6];

[PAC_avgBefore] = pac_makeAvg(Before_Data, PAC_Before, useClean, balance, params);
[PAC_avgAfter30] = pac_makeAvg(After30_Data, PAC_After30, useClean, balance, params);


[PAC_avgBeforeArr] = makeArray(PAC_avgBefore);
[PAC_avgAfter30Arr] = makeArray(PAC_avgAfter30);
%%
ch = 3;
ch1 = 3;
ch2 = 3;
iSess = 1:4;
States = ["std","tar","tar-std","changed","unChanged","changed-unChanged"];
iState = 3;

x_bef = squeeze(P3_BeforeArr(ch, iState,:, iSess));
x_after30 = squeeze(P3_After30eArr(ch, iState,:, iSess));

y_bef = squeeze(PAC_avgBeforeArr(ch1, ch2, iState,:, iSess));
y_after30 = squeeze(PAC_avgAfter30Arr(ch1, ch2, iState,:, iSess));

figure
for iRat=1:length(Before_Datasets)
    for iSession=1:max(iSess)
        if(~isnan(x_bef(iRat,iSession)))
            scatter(x_bef(iRat,iSess), y_bef(iRat,iSess),'MarkerEdgeColor','b');
            text(x_bef(iRat,iSession), y_bef(iRat,iSession),"Rat"+Before_Datasets{iRat,1}{iSession,1}+"-"+string(iSession))
        end
        hold on
    end
end

for iRat=1:length(After30days_Datasets)
    for iSession=1:max(iSess)
        if(~isnan(x_after30(iRat,iSession)))
            scatter(x_after30(iRat,iSess), y_after30(iRat,iSess),'MarkerEdgeColor','r');
            text(x_after30(iRat,iSession), y_after30(iRat,iSession),"Rat"+After30days_Datasets{iRat,1}{iSession,1}+"-"+string(iSession))
        end
        hold on
    end
end

xlabel(sprintf('P3^{%s}', States(iState)))
ylabel(sprintf('PAC^{%s} ', States(iState)))
title(sprintf("PAC: %s {phase} (%d-%d) - %s {amp} (%d-%d) \nERP :%s",...
    ch_labels{1}(ch1), params.fph_range(1), params.fph_range(2), ...
    ch_labels{1}(ch2), params.famp_range(1), params.famp_range(2)), ch_labels{1}(ch))

%%

ch = 3;
ch1 = 3;
ch2 = 1;
iSess = 1:2;
States = ["std","tar","tar-std","changed","unChanged","changed-unChanged"];
iState = 2;


x = squeeze(P3_After30eArr(ch, iState,:, iSess)) - squeeze(P3_BeforeArr(ch, iState,4:end, iSess));
y = squeeze(PAC_avgAfter30Arr(ch1, ch2, iState,:, iSess)) - squeeze(PAC_avgBeforeArr(ch1, ch2, iState,4:end, iSess));

figure
for iRat=1:5
    for iSession=1:max(iSess)
        scatter(x(iRat,iSession), y(iRat,iSession),'MarkerEdgeColor','b');
        if(~isnan(x(iRat,iSession)))
            text(x(iRat,iSession), y(iRat,iSession),"Rat"+After30days_Datasets{iRat,1}{iSession,1}+"-"+string(iSession))
        end
        hold on
    end
end

xlabel(sprintf('P3_{After30}^{%s} - P3_{Before}^{%s}', States(iState),States(iState)))
ylabel(sprintf('PAC_{After30}^{%s} - PAC_{Before}^{%s}', States(iState),States(iState)))
title(sprintf("PAC: %s {phase} (%d-%d) - %s {amp} (%d-%d) \nERP :%s",...
    ch_labels{1}(ch1), params.fph_range(1), params.fph_range(2), ...
    ch_labels{1}(ch2), params.famp_range(1), params.famp_range(2)), ch_labels{1}(ch))

[R,P] = corrcoef(x,y)

