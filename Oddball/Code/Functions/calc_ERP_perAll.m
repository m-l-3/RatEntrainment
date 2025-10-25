function [ERP, Trials, time] = calc_ERP_perAll(Data,cfg,useClean, bootStrap)

nBootStrap = 200;
nRat = length(Data);
% nCh = cfg.n_ch;
if(cfg.is_downsample)
    fs = cfg.fs_down;
else
    fs = cfg.fs;
end
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * fs;
time = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start) * 1000;

allTrials = [];
stdTrials = [];
targetTrials = [];
changedTrials = [];
unChangedTrials = [];

for iRat=1:nRat
    DataRat = Data{iRat,1};
    nSess = size(DataRat,2);

    for iSess=1:nSess
        DataSess = DataRat{1,iSess};
        cleanTr = logical(DataRat{4,iSess});

        allTr = true(size(DataRat{4,iSess}));
        stdTr = logical(DataRat{7, iSess});
        targetTr = logical(DataRat{8, iSess});
        changedTr = logical(DataRat{9, iSess});
        unChangedTr = logical(DataRat{10, iSess});

        if(useClean)
            allTr = allTr & cleanTr;
            stdTr = stdTr & cleanTr;
            targetTr = targetTr & cleanTr;
            changedTr = changedTr & cleanTr;
            unChangedTr = unChangedTr & cleanTr;
        end

        allTrials = cat(3, allTrials, DataSess(:,:,allTr));
        stdTrials = cat(3, stdTrials, DataSess(:,:,stdTr));
        targetTrials = cat(3, targetTrials, DataSess(:,:,targetTr));
        changedTrials = cat(3, changedTrials, DataSess(:,:,changedTr));
        unChangedTrials = cat(3, unChangedTrials, DataSess(:,:,unChangedTr));
    end

end

if(~bootStrap)
    ERP.all = mean(allTrials,3,'omitnan');
    ERP.std = mean(stdTrials,3,'omitnan');
    ERP.target = mean(targetTrials,3,'omitnan');
    ERP.changed = mean(changedTrials,3,'omitnan');
    ERP.unChanged = mean(unChangedTrials,3,'omitnan');

    Trials.all = allTrials;
    Trials.std = stdTrials;
    Trials.target = targetTrials;
    Trials.changed = changedTrials;
    Trials.unChanged = unChangedTrials;

else
    for iBootStrap = 1:nBootStrap
        allSample = datasample(allTrials, size(allTrials,3), 3);
        stdSample = datasample(stdTrials, size(stdTrials,3), 3);
        targetSample = datasample(targetTrials, size(targetTrials,3), 3);
        changedSample = datasample(changedTrials, size(changedTrials,3), 3);
        unChangedSample = datasample(unChangedTrials, size(unChangedTrials,3), 3);
        
        Trials.all(:,:,iBootStrap) = mean(allSample,3,'omitnan');
        Trials.std(:,:,iBootStrap) = mean(stdSample,3,'omitnan');
        Trials.target(:,:,iBootStrap) = mean(targetSample,3,'omitnan');
        Trials.changed(:,:,iBootStrap) = mean(changedSample,3,'omitnan');
        Trials.unChanged(:,:,iBootStrap) = mean(unChangedSample,3,'omitnan');

        ERP.all = mean(Trials.all,3,'omitnan');
        ERP.std = mean(Trials.std,3,'omitnan');
        ERP.target = mean(Trials.target,3,'omitnan');
        ERP.changed = mean(Trials.changed,3,'omitnan');
        ERP.unChanged = mean(Trials.unChanged,3,'omitnan');

    end
end


