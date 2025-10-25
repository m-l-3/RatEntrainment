function [ErpCell, time] = calc_erp(Data, cleanTags, cfg, useClean)

nTime = cfg.Fs * (cfg.epoch(2) - cfg.epoch(1));
time = linspace(cfg.epoch(1),cfg.epoch(2),nTime+1);
time = time(1:end-1);

nRat = length(Data);
ErpCell = cell(size(Data));

for iRat=1:nRat
    DataRat = Data{iRat,1};
    if(isempty(DataRat))
        continue
    end

    nSession = size(DataRat,2);
    erp_sess = cell(1,nSession);
    for iSession=1:nSession
        DataSess = DataRat{1,iSession};
        nBlock = size(DataSess,2);
        erp_block = cell(1,nBlock);

        for iBlock=1:nBlock

            epoched_data = DataSess{1,iBlock};
            tag = cleanTags{iRat,1}{1,iSession}{1,iBlock};

            trialSel = true(120,1);
            if useClean
                trialSel = logical(tag(:,2)) & logical(tag(:,3));
            end
%             nTrialSel = sum(trialSel);
            erp_block{1,iBlock} = mean(epoched_data(:,:,trialSel), 3, 'omitnan');
        end
        erp_sess{1,iSession} = erp_block;
    end
    ErpCell{iRat,1} = erp_sess;
end
