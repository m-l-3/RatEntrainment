clc; 
clear;

addpath(genpath('./Functions'))

path_res = ("D:\Documents\SUT Ph.D\Research\Matlab codes\Hamgera\Oddball\Oddball_Entrain_ERP-main\Results\"); 

cfgReference
if(cfg.is_downsample)
    fs = cfg.fs_down;
else
    fs = cfg.fs;
end

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

%% load pacs

useSingle = true;
path = path_res + "PAC_general\";
[PAC_Before, time_pac, famp_out, fph_out] = pacLoader(Before_Datasets,path,"Before",useSingle);
[PAC_After30, time_pac, famp_out, fph_out] = pacLoader(After30days_Datasets,path,"After30",useSingle);


%% single rat/sess

ch1 = 4;
ch2 = 4;
iRat = 5;
iSess = 1;

PAC_in = PAC_After30;
sigEpoched_in = After30_Data;
titleMetaData = After30days_Datasets;

fph_range = [4 6];
famp_range = [60 90];
fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);



figure
sgtitle("Rat"+titleMetaData{iRat,1}{iSess,1}+" Sess"+titleMetaData{iRat,1}{iSess,2})
subplot(2,1,1)
plot(time_pac, squeeze(mean(PAC_in{iRat,1}{1,iSess}(ch1,ch2,:,famp_idx,fph_idx,:),[4 5 6])),'LineWidth',2)
xline(0,'LineWidth',1)
xlim([-0.5 1.5])
title(sprintf('PAC\n %s {phase} (%d-%d) - %s {amp} (%d-%d)\n', ch_labels{1}(ch1),fph_range(1), fph_range(2), ch_labels{1}(ch2), famp_range(1), famp_range(2)))
subplot(2,1,2)
plot(time_epoched, mean(sigEpoched_in{iRat,1}{1,iSess}(ch1,:,:),3),'LineWidth',2,'DisplayName',ch_labels{1}(ch1))
hold on
plot(time_epoched, mean(sigEpoched_in{iRat,1}{1,iSess}(ch2,:,:),3),'LineWidth',2,'DisplayName',ch_labels{1}(ch2))
xline(0,'LineWidth',1)
legend()
xlim([-0.5 1.5])
title('ERP')

%% overal rat/sess

useClean = true;
ch = 3;
ch1 = 3;
ch2 = 3;
iSess = 1;
PAC_in = PAC;
sigEpoched_in = Before_Data;

fph_range = [8 12];
famp_range = [30 50];
fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

t_range = [.3 .7];
tepoch_idx = time_epoched>=t_range(1) & time_epoched<=t_range(2);
t_range = [0 0.5];
tpac_idx = time_pac>=t_range(1) & time_pac<=t_range(2);

figure
x=[];
y=[];
for iRat=1:nRat
    if useClean
        selTr = logical(sigEpoched_in{iRat,1}{4,iSess});
    else
        selTr = true(size(sigEpoched_in{iRat,1}{4,iSess}));
    end
    
    p3Amp = squeeze(max(sigEpoched_in{iRat,1}{1,iSess}(ch,tepoch_idx,selTr),[],2));
    pacAmp = squeeze(mean(PAC_in{iRat,1}{1,iSess}(ch1,ch2,tpac_idx,famp_idx,fph_idx,selTr),[1 2 3 4 5]));
    if(~any(isnan(p3Amp)))
        x = cat(1,x,pacAmp);
        y = cat(1,y,p3Amp);
    end
    scatter(pacAmp, p3Amp, 20, '.')
    hold on
%     [rho,pval] = corr(pacAmp,p3Amp)
    [R,P] = corrcoef(pacAmp,p3Amp)
end

% [rho,pval] = corr(x,y)
figure
scatter(x, y, 20, '.')
[R,P] = corrcoef(x,y) 

%% over rats

useClean = false;
ch = 3;
ch1 = 3;
ch2 = 3;
iSess = 1;
PAC_in = PAC;
sigEpoched_in = Before_Data;
titleMetaData = Before_Datasets;

fph_range = [8 12];
famp_range = [30 50];
fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

t_range = [.3 .7];
tepoch_idx = time_epoched>=t_range(1) & time_epoched<=t_range(2);
t_range = [0 0.5];
tpac_idx = time_pac>=t_range(1) & time_pac<=t_range(2);

x=[];
y=[];
figure
for iRat=1:nRat
    if useClean
        selTr = logical(sigEpoched_in{iRat,1}{4,iSess});
    else
        selTr = true(size(sigEpoched_in{iRat,1}{4,iSess}));
    end

    p3Amp = squeeze(max(mean(sigEpoched_in{iRat,1}{1,iSess}(ch,tepoch_idx,selTr),3),[],2));
    pacAmp = squeeze(mean(PAC_in{iRat,1}{1,iSess}(ch1,ch2,tpac_idx,famp_idx,fph_idx,selTr),[1 2 3 4 5 6]));
    if(~any(isnan(p3Amp)))
        x = cat(1,x,pacAmp);
        y = cat(1,y,p3Amp);
        scatter(pacAmp, p3Amp,100,'.')
        text(pacAmp, p3Amp,"Rat"+titleMetaData{iRat,1}{iSess,1})
        hold on
    end
end

[R,P] = corrcoef(x,y) 

%% over batch of trials
lBatch = 30;
lBatchStep = 1;

useClean = false;
baslineNormalize = true;
ch = 3;
ch1 = 3;
ch2 = 3;
iSess = 1;
PAC_in = PAC_Before;
sigEpoched_in = Before_Data;
titleMetaData = Before_Datasets;

fph_range = [4 6];
famp_range = [60 80];
fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

t_range = [.42 .5];
tepoch_idx = time_epoched>=t_range(1) & time_epoched<=t_range(2);
t_range = [.3 .5];
tpac_idx = time_pac>=t_range(1) & time_pac<=t_range(2);

nRat = length(PAC_in);

x=[];
y=[];
figure
for iRat=4:nRat
    if useClean
        selTr = logical(sigEpoched_in{iRat,1}{4,iSess});
    else
        selTr = true(size(sigEpoched_in{iRat,1}{4,iSess}));
    end

    if baslineNormalize
        pac_in = PAC_in{iRat,1}{1,iSess} - mean(PAC_in{iRat,1}{1,iSess}(:,:,time_pac>=-.7 & time_pac<=0,:,:,:),3);
    else
        pac_in = PAC_in{iRat,1}{1,iSess};
    end

    nBatch = (length(selTr)-lBatch)/lBatchStep+1;
    for iBatch=1:nBatch
        idx_tr = (iBatch-1)*lBatchStep+1:(iBatch-1)*lBatchStep+lBatch;
        selBatch = zeros(size(selTr));
        selBatch(idx_tr) = true;
        
        p3Amp = squeeze(max(mean(sigEpoched_in{iRat,1}{1,iSess}(ch,tepoch_idx,selTr & selBatch),3),[],2));
        pacAmp = squeeze(mean(pac_in(ch1,ch2,tpac_idx,famp_idx,fph_idx, selTr & selBatch),[1 2 3 4 5 6]));
        
        if(~any(isnan(p3Amp)))
            x = cat(1,x,pacAmp);
            y = cat(1,y,p3Amp);
            scatter(pacAmp, p3Amp,100,'.')
            text(pacAmp, p3Amp,"Rat"+titleMetaData{iRat,1}{iSess,1})
            hold on
        end
    end
end

figure
scatter(x, y, 20, '.')
xlabel(sprintf('PAC\n %s {phase} (%d-%d) - %s {amp} (%d-%d)\n', ch_labels{1}(ch1),fph_range(1), fph_range(2), ch_labels{1}(ch2), famp_range(1), famp_range(2)))
ylabel('P3')
[R,P] = corrcoef(x,y) 



%% %%%%%%%%%%%%%%%% pac peak in single trial. before/after comparison
%% single rat/sess

useClean = true;
ch = 3;
iSess = 1;
sigEpoched_in = Before_Data;

t_range = [0.42 0.49];
tepoch_idx = time_epoched>=t_range(1) & time_epoched<=t_range(2);

lBatch = 1;
lBatchStep = 1;

nBin = 50;

x=[];
sigEpoched_in = Before_Data;
nRat = length(sigEpoched_in);
for iRat=4:nRat
    cleanTr = logical(sigEpoched_in{iRat,1}{4,iSess});
    targetLabel = logical(sigEpoched_in{iRat,1}{8,iSess});
    if useClean
        selTr = targetLabel & cleanTr;
    else
        selTr = targetLabel;
    end

    nBatch = (length(selTr)-lBatch)/lBatchStep+1;
    for iBatch=1:nBatch
        idx_tr = (iBatch-1)*lBatchStep+1:(iBatch-1)*lBatchStep+lBatch;
        selBatch = zeros(size(selTr));
        selBatch(idx_tr) = true;
        
        p3Amp = squeeze(max(mean(sigEpoched_in{iRat,1}{1,iSess}(ch,tepoch_idx,selTr & selBatch),3),[],2));
        
        if(~any(isnan(p3Amp)))
            x = cat(1,x,p3Amp);
        end
    end
end


y=[];
sigEpoched_in = After30_Data;
nRat = length(sigEpoched_in);
for iRat=1:nRat
    cleanTr = logical(sigEpoched_in{iRat,1}{4,iSess});
    targetLabel = logical(sigEpoched_in{iRat,1}{8,iSess});
    if useClean
        selTr = targetLabel & cleanTr;
    else
        selTr = targetLabel;
    end

    nBatch = (length(selTr)-lBatch)/lBatchStep+1;
    for iBatch=1:nBatch
        idx_tr = (iBatch-1)*lBatchStep+1:(iBatch-1)*lBatchStep+lBatch;
        selBatch = zeros(size(selTr));
        selBatch(idx_tr) = true;
        
        p3Amp = squeeze(max(mean(sigEpoched_in{iRat,1}{1,iSess}(ch,tepoch_idx,selTr & selBatch),3),[],2));
        
        if(~any(isnan(p3Amp)))
            y = cat(1,y,p3Amp);
        end
    end
end

figure
histogram(x,nBin)
hold on
histogram(y,nBin)

% figure
% scatter(x,y,20,'.')
% hold on
% plot([min([x;y]),max([x;y])], [min([x;y]),max([x;y])])
% xlabel('Before')
% ylabel('After30')


%% to see th trend of p3Amp over trials

useClean = true;
ch = 3;
iSess = 1;
sigEpoched_in = After30_Data;

t_range = [0.3 0.6];
tepoch_idx = time_epoched>=t_range(1) & time_epoched<=t_range(2);

lBatch = 1;
lBatchStep = 1;

nBin = 50;

nRat = length(sigEpoched_in);
p3Amp = NaN(nRat,240);
for iRat=1:nRat

    cleanTr = logical(sigEpoched_in{iRat,1}{4,iSess});
    targetLabel = logical(sigEpoched_in{iRat,1}{8,iSess});
    if useClean
        selTr = targetLabel & cleanTr;
    else
        selTr = targetLabel;
    end

    nBatch = (length(selTr)-lBatch)/lBatchStep+1;
    for iBatch=1:nBatch
        idx_tr = (iBatch-1)*lBatchStep+1:(iBatch-1)*lBatchStep+lBatch;
        selBatch = zeros(size(selTr));
        selBatch(idx_tr) = true;
        
        p3Amp(iRat, iBatch) = squeeze(max(mean(sigEpoched_in{iRat,1}{1,iSess}(ch,tepoch_idx,selTr & selBatch),3),[],2));
        
    end
end

figure
stem(p3Amp');
hold on
plot(movmean(mean(p3Amp,1,'omitnan'),3,'omitnan'), 'k', 'LineWidth',2)

figure
p3Amp_tar = NaN(nRat, 50);
for iRat=4:nRat
    temp = p3Amp(iRat,:);
    temp(isnan(temp))=[];
    p3Amp_tar(iRat,1:length(temp)) = temp;
    plot(temp)
    hold on
end

p3Amp_tar(p3Amp_tar==0) = NaN;

figure
plot(movmean(squeeze(mean(p3Amp_tar(:,1:40),1,'omitnan')),3))