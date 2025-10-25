function [T] = p3_batchPeakFinder_table(Data,Dataset, useClean,params,cfg, iState)


nRat = length(Data);


T = table;
fs = params.fs;
smple_num = (cfg.epoch_time(1) + cfg.epoch_time(2)) * fs;
time_epoched = ((1:smple_num)/fs - 1/fs - cfg.epoch_t_start)*1000;
t_range = params.t_range;
tepoch_idx = time_epoched>=t_range(1) & time_epoched<=t_range(2);
t_sel = time_epoched(tepoch_idx);
lBatch = params.lBatch;
lBatchStep = params.lBatchStep;


for iRat=1:nRat
    DataRat = Data{iRat,1};
    nBlock = size(DataRat,2);
    

    for iBlock=1:min(nBlock,2)
        DataSess = DataRat{1,iBlock};
        cleanTr = logical(DataRat{4,iBlock});
        stdLabel = logical(DataRat{7,iBlock});
        targetLabel = logical(DataRat{8,iBlock});
        changedLabel = logical(DataRat{9,iBlock});
        unChangedLabel = logical(DataRat{10,iBlock});
        allLabel = true(size(cleanTr));

        if(useClean)
            allLabel = allLabel & cleanTr;
            stdLabel = stdLabel & cleanTr;
            targetLabel = targetLabel & cleanTr;
            changedLabel = changedLabel & cleanTr;
            unChangedLabel = unChangedLabel & cleanTr;
        end
        
        ratName = "Rat"+string(Dataset{iRat,1}(iBlock,1));
        blockName = "Block"+string(Dataset{iRat,1}(iBlock,2));

        nCh = size(DataSess,1);
        switch iState
            case "all"
                selTr = allLabel;
            case "std"
                selTr = stdLabel;
            case "target"
                selTr = targetLabel;
            case "changed"
                selTr = changedLabel;
            case "unChanged"
                selTr = unChangedLabel;
        end

        nBatch = floor((length(selTr)-lBatch)/lBatchStep+1);
        p3amp = NaN(nCh,nBatch);
        p3latency = NaN(nCh,nBatch);

        for iCh=1:nCh
            if(all(isnan(DataSess(iCh, :, :))))
                continue
            end
 
            
            for iBatch=1:nBatch
                idx_tr = (iBatch-1)*lBatchStep+1:(iBatch-1)*lBatchStep+lBatch;
                selBatch = zeros(size(selTr));
                selBatch(idx_tr) = true;
                
                erp = mean(DataSess(iCh,tepoch_idx,selTr & selBatch),3);
%                 erp = conv(erp, mean(DataSess(iCh,tepoch_idx,selTr),3),'same');
%                 erpSum = cumsum(erp);
%                 p3idx = find(erpSum>=max(erpSum)*0.8,1,'first'); 
%                 if(isempty(p3idx))
%                     continue;
%                 end

                [~, p3idx] = max(erp,[],2);
                p3latency(iCh, iBatch) = t_sel(p3idx);
                p3amp(iCh, iBatch) = erp(p3idx);
                
            end
            
            
        end
        t = table(p3latency', p3amp',(1:nBatch)', repmat(ratName,nBatch,1),repmat(blockName,nBatch,1));
        T = cat(1,T,t);
       
    end

end

T.Properties.VariableNames = {'P3Lat', 'P3Amp', 'Batch', 'Rat', 'Block'};

    