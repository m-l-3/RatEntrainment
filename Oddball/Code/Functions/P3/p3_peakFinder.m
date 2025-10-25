function [P3] = p3_peakFinder(Data,useClean,balance,params,cfg)


nRat = length(Data);
P3 = cell(size(Data));
fs = cfg.fs;
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * fs;
time_epoched = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start);
t_range = params.t_range ;
tepoch_idx = time_epoched>=t_range(1) & time_epoched<=t_range(2);

for iRat=1:nRat
    DataRat = Data{iRat,1};
    nSess = size(DataRat,2);
    P3_sess = cell(1,nSess);

    for iSess=1:nSess
        DataSess = DataRat{1,iSess};
        cleanTr = logical(DataRat{4,iSess});
        stdLabel = logical(DataRat{7,iSess});
        targetLabel = logical(DataRat{8,iSess});
        changedLabel = logical(DataRat{9,iSess});
        unChangedLabel = logical(DataRat{10,iSess});

        if(useClean)
            stdLabel = stdLabel & cleanTr;
            targetLabel = targetLabel & cleanTr;
            changedLabel = changedLabel & cleanTr;
            unChangedLabel = unChangedLabel & cleanTr;
        end

        nCh = size(DataSess,1);
        P3Amp = NaN(nCh,6);
        for iCh=1:nCh
            if(all(isnan(DataSess(iCh, :, :))))
                continue
            end

            stdErp = squeeze(mean(DataSess(:, :, stdLabel),3,'omitnan'));
            targetErp = squeeze(mean(DataSess(:, :, targetLabel),3,'omitnan'));
            changedErp = squeeze(mean(DataSess(:, :, changedLabel),3,'omitnan'));
            unChangedErp = squeeze(mean(DataSess(:, :, unChangedLabel),3,'omitnan'));
            nStd = sum(stdLabel,1);
            nTarget = sum(targetLabel,1);
            nChanged = sum(changedLabel,1);
            nUnChanged = sum(unChangedLabel,1);

            if(balance)     
                stdSig = squeeze(DataSess(:, :, stdLabel));
                idx = randsample(nStd,nTarget);
                stdErp = squeeze(mean(stdSig(:, :, idx),3,'omitnan'));

                unChangeSig = squeeze(DataSess(:, :, unChangedLabel));
                idx = randsample(nUnChanged,nChanged);
                unChangedErp = squeeze(mean(unChangeSig(:, :, idx),3,'omitnan'));
            end


            [P3Amp(iCh,1), ~] = max(stdErp(iCh,tepoch_idx),[],2);
            [P3Amp(iCh,2), ~] = max(targetErp(iCh,tepoch_idx),[],2);
            P3Amp(iCh,3)      = P3Amp(iCh,2) - P3Amp(iCh,1);
            [P3Amp(iCh,4), ~] = max(changedErp(iCh,tepoch_idx),[],2);
            [P3Amp(iCh,5), ~] = max(unChangedErp(iCh,tepoch_idx),[],2);
            P3Amp(iCh,6)      = P3Amp(iCh,4) - P3Amp(iCh,5);
            
        end
        P3_sess{1,iSess} = P3Amp;
        
    end

    P3{iRat,1} = P3_sess; 
end

    