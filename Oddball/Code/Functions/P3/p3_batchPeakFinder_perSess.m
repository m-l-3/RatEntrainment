function [P3amp, P3lat] = p3_batchPeakFinder_perSess(Data,useClean,params,cfg)


nRat = length(Data);
% P3amp_sess = [];
% P3latency_sess = [];
P3amp = cell(size(Data));
P3lat = cell(size(Data));
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
    nSess = size(DataRat,2);
    P3amp_sess = cell(1,nSess);
    P3latency_sess = cell(1,nSess);
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
        P3amp_sess{1,iSess} = p3amp;
        P3latency_sess{1,iSess} = p3latency;
%         P3amp_sess = cat(2,P3amp_sess,p3amp);
%         P3latency_sess = cat(2,P3latency_sess,p3latency);
        
    end

    P3amp{iRat,1} = P3amp_sess; 
    P3lat{iRat,1} = P3latency_sess; 
end

    