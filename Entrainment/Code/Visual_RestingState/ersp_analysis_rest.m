clear
close all
clc

cfgRef_Rest
%% load

fname = sprintf('allRatSessBlock_dur%d_winLen%d-winSlip%.1f_fil%d-%d_fs%d.mat', ...
        cfg.Duration,cfg.winLen,cfg.winSlip,cfg.filBand(1),cfg.filBand(2),cfg.Fs);
fileName = fullfile(path_dataset,'aggregate',fname);
load(fileName)

addpath(genpath("D:\Documents\SUT Ph.D\Research\Matlab codes\chronux_2_12"));
%%

useERP = true;
useClean = true;
params.tapers = [3 5]; 
params.pad = -1;
params.Fs = cfg.Fs;
params.fpass = cfg.filBand;
params.trialave = true;
params.tWinLen = 0.5;
params.tWinSlip = 0.05;


[time,freq,Spec] = calc_specgram_rest(Data,cleanTags,params,useClean,useERP);

%%

[SpecArr] = makeArray(Spec, cfg);

%% 2d spec
iCh = 3;
iRat = 1:9;
iSess = 5;
iBlock = 1;

[t_mesh, f_mesh] = meshgrid(time,freq);
figure
pcolor(t_mesh, f_mesh, squeeze(mean(SpecArr(:,:,iCh, iRat, iSess, iBlock),[4 5],'omitnan'))')
colormap jet
shading flat

%% 1d
iCh = 1;
iRat = 1:9;
iSess = 1;
iBlock = 2;
figure
stdshade(squeeze(mean(SpecArr(:,:,iCh, iRat, iSess, iBlock),[1 6],'omitnan'))', 0.4,'b', freq);
hold on
iSess = 5;
stdshade(squeeze(mean(SpecArr(:,:,iCh, iRat, iSess, iBlock),[1 6],'omitnan'))', 0.4,'m', freq);

%% 1d in freq.

iRat = 1:9;
ylimit = 80e-3;

figure
for iCh=1:cfg.nCh
    for iSess=1:cfg.nSession
        subplot(cfg.nCh,cfg.nSession,(iCh-1)*cfg.nSession+iSess)
        iBlock = 1;
        stdshade(squeeze(mean(SpecArr(:,:,iCh, iRat, iSess, iBlock),[1],'omitnan'))', 0.4,'b', freq);
        hold on
        iBlock = 2;
        stdshade(squeeze(mean(SpecArr(:,:,iCh, iRat, iSess, iBlock),[1],'omitnan'))', 0.4,'m', freq);
        legend("Block1","Block2")
%         ylim([0 ylimit])
        xlim([0 50])
        
        if iCh==1
            title("Day"+string(days(iSess)))
        end

        if iSess==1
            ylabel(T.Channel{iRat(end),1}(iCh), 'Rotation', 0)
        end
    end
end


%% 1d in time

iRat = 1:9;
ylimit = 80e-3;
fRange = [38 42];
fIdx = freq>=fRange(1) & freq<=fRange(2);
t = time - 1;
figure
for iCh=1:cfg.nCh
    for iSess=1:cfg.nSession
        subplot(cfg.nCh,cfg.nSession,(iCh-1)*cfg.nSession+iSess)
        iBlock = 1;
        stdshade(squeeze(mean(SpecArr(:,fIdx,iCh, iRat, iSess, iBlock),[2],'omitnan'))', 0.4,'b', t);
        hold on
        iBlock = 2;
        stdshade(squeeze(mean(SpecArr(:,fIdx,iCh, iRat, iSess, iBlock),[2],'omitnan'))', 0.4,'m', t);
        xline(0)
        legend("Block1","Block2")
%         ylim([0 ylimit])
        
        
        if iCh==1
            title("Day"+string(days(iSess)))
        end

        if iSess==1
            ylabel(T.Channel{iRat(end),1}(iCh), 'Rotation', 0)
        end
    end
end

