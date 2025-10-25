function [bandPower,t_seg] = power_batchCalculator(Data,useClean,params,cfg)


nRat = length(Data);


bandPower = cell(size(Data));

fs = params.Fs;


lBatch = params.lBatch;
lBatchStep = params.lBatchStep;

twin_len = params.twin_len;
twin_slip = params.twin_slip;

total_dur = cfg.epoch_time(1) + cfg.epoch_time(2);
N = total_dur*fs;
% nWin = round((total_dur-twin_len)/twin_slip + 1);
% t_seg = (-cfg.epoch_time(1)+twin_len/2:twin_slip:cfg.epoch_time(2)-twin_len/2) * 1000;

nWin = N;
t_seg = (-cfg.epoch_time(1)+1/fs:1/fs:cfg.epoch_time(2)) * 1000;

freq_range = params.freq_range;
params.trialave = false;

for iRat=1:nRat
    DataRat = Data{iRat,1};
    nSess = size(DataRat,2);
    bandPow_sess = cell(1,nSess);

    for iSess=1:nSess
        DataSess = DataRat{1,iSess};
        cleanTr = logical(DataRat{4,iSess});
        stdLabel = logical(DataRat{7,iSess});
        targetLabel = logical(DataRat{8,iSess});
        changedLabel = logical(DataRat{9,iSess});
        unChangedLabel = logical(DataRat{10,iSess});
        allLabel = true(size(cleanTr));

        if(useClean)
            allLabel = allLabel & cleanTr;
            stdLabel = stdLabel & cleanTr;
            targetLabel = targetLabel & cleanTr;
            changedLabel = changedLabel & cleanTr;
            unChangedLabel = unChangedLabel & cleanTr;
        end
        
        nCh = size(DataSess,1);
        selTr = allLabel;
        nBatch = floor((length(selTr)-lBatch)/lBatchStep+1);
        erp = NaN(nCh,N,nBatch);
        bandPow = NaN(nCh,nWin,nBatch); 

        for iCh=1:nCh
            if(all(isnan(DataSess(iCh, :, :))))
                continue
            end            
            for iBatch=1:nBatch
                idx_tr = (iBatch-1)*lBatchStep+1:(iBatch-1)*lBatchStep+lBatch;
                selBatch = zeros(size(selTr));
                selBatch(idx_tr) = true;

                erp(iCh, :, iBatch) = mean(DataSess(iCh,:,selTr & selBatch),3);
            end                     
        end

        for iCh=1:nCh
            if(all(isnan(DataSess(iCh, :, :))))
                continue
            end 
            %%%%
            SBatch = NaN(69,nWin,nBatch);
            for iBatch=1:nBatch
                [SBatch(:,:,iBatch),f] = cwt(squeeze(erp(iCh, :, iBatch)),'amor',fs);
            end                 
            erp_power = abs(SBatch).^2;
            erp_power = permute(erp_power, [2 1 3]);
            %%%%
%             [erp_power,~,f]=mtspecgramc(squeeze(erp(iCh, :, :)), [twin_len twin_slip], params);
            f_sel = f>=freq_range(1) & f<=freq_range(2);
            
            bandPow(iCh, :, :) = squeeze(mean(erp_power(:,f_sel,:),2,'omitnan'));
        end
        bandPow_sess{1,iSess} = bandPow;
        disp(['>>> Rat:' num2str(iRat) ' Sess.' num2str(iSess) ])
    end

    bandPower{iRat,1} = bandPow_sess; 
end


    