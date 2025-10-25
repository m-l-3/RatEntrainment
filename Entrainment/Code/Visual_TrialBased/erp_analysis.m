
clear
close all
clc

cfgRef
%% load

fname = sprintf('allRatSessBlock_e%d-%d_fil%d-%d_fs%d.mat', ...
        cfg.epoch(1),cfg.epoch(2),cfg.filBand(1),cfg.filBand(2),cfg.Fs);
fileName = fullfile(path_dataset,'aggregate',fname);
load(fileName)


%%
useClean = true;
[ErpCell, time] = calc_erp(Data, cleanTags, cfg, useClean);

%%
[ErpArr] = makeArray(ErpCell, cfg);

%% mean of rats

iBlock = 1;

figure
for iCh=1:cfg.nCh
    subplot(2,2,iCh)
    stdshade(squeeze(ErpArr(iCh,:,:,1,iBlock))',0.4,'b',time)
    hold on
%     stdshade(squeeze(ErpArr(iCh,:,:,3,iBlock))',0.4,'r',time)
%     stdshade(squeeze(ErpArr(iCh,:,:,4,iBlock))',0.4,'g',time)
    stdshade(squeeze(ErpArr(iCh,:,:,5,iBlock))',0.4,'m',time)

    xlim([-0.5 1])
    xline(0,'k')

end

%%
iCh = 2;
iRat = 7;
iSess = 3;
iBlock = 2;

figure
stdshade(squeeze((ErpArr(iCh,:,iRat,iSess,iBlock))),0.4,'b',time)





































%%
useClean = true;

nTime = cfg.Fs * (cfg.epoch(2) - cfg.epoch(1));
data_arr = NaN(cfg.nCh, nTime, cfg.nTrial, nRat, nSession, nBlock);

for iRat=1:nRat
    ratName = T.Name(iRat);
    if ismember(ratName, ratExcluded)
        continue
    end

    nSession = numel(T.Session{iRat,1});
    for iSession=1:nSession
        date = T.Dates{iRat,1}{iSession};
        if(isempty(date))
            continue
        end
        sessionName = T.Session{iRat,1}{iSession};
        nBlock = numel(T.Blocks{iRat,1}{iSession});
        for iBlock=1:nBlock

            epoched_data = Data{iRat,1}{iSession}{iBlock};
            tag = cleanTags{iRat,1}{iSession}{iBlock};
            if useClean
                trialSel = logical(tag(:,2)) & logical(tag(:,3));
                nTrialSel = sum(trialSel);
                
            else
                trialSel = true(120,1);
                nTrialSel = cfg.nTrial;
            end
            data_arr(:,:,1:nTrialSel,iRat,iSession,iBlock) = epoched_data(:,:,trialSel);
        end
    end
end

%% mean of rats
time = linspace(cfg.epoch(1),cfg.epoch(2),nTime+1);
time = time(1:end-1);
iCh = 3;
iBlock = 1;

figure
for iCh=1:cfg.nCh
    subplot(2,2,iCh)
    stdshade(squeeze(mean(data_arr(iCh,:,:,:,1,iBlock),[3],'omitnan'))',0.4,'b',time)
    hold on
    stdshade(squeeze(mean(data_arr(iCh,:,:,:,3,iBlock),[3],'omitnan'))',0.4,'r',time)
    stdshade(squeeze(mean(data_arr(iCh,:,:,:,4,iBlock),[3],'omitnan'))',0.4,'g',time)
    stdshade(squeeze(mean(data_arr(iCh,:,:,:,5,iBlock),[3],'omitnan'))',0.4,'m',time)

    xlim([-0.5 1])
    xline(0,'k')

end


%% see each rat 

iCh = 2;
iRat = 6;
iBlock = 1;

figure
stdshade(squeeze((data_arr(iCh,:,:,iRat,1,iBlock)))',0.4,'b',time)
hold on
stdshade(squeeze((data_arr(iCh,:,:,iRat,3,iBlock)))',0.4,'r',time)
stdshade(squeeze((data_arr(iCh,:,:,iRat,4,iBlock)))',0.4,'g',time)
stdshade(squeeze((data_arr(iCh,:,:,iRat,5,iBlock)))',0.4,'m',time)

%%

iCh = 2;
iRat = 4;
iSess = 3;
iBlock = 2;

figure
stdshade(squeeze((data_arr(iCh,:,:,iRat,iSess,iBlock)))',0.4,'b',time)


