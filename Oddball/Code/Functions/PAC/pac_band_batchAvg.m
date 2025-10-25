function [PacBand_sess] = pac_band_batchAvg(PAC_in, Data, useClean, params, iState, Rat)

nRat = length(Data);
if(nargin<6)
    Rat = 1:nRat;
end

if(nargin<5)
    iState = "all";
    Rat = 1:nRat;
end

famp_out = params.famp_out;
fph_out = params.fph_out;
fph_range = params.fph_range;
famp_range = params.famp_range;
tout = params.tout;

lBatch = params.lBatch;
lBatchStep = params.lBatchStep;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);

t_range = params.t_range;
t_idx = tout>=t_range(1) & tout<=t_range(2);
t_idx = ~t_idx;

PacBand_sess = [];


for iRat = 1:length(Rat)
    DataRat = Data{Rat(iRat),1};
    PACRat = PAC_in{Rat(iRat),1};
    nSess = size(DataRat,2);

    for iSess=1:nSess
        DataSess = PACRat{1,iSess};
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
        pac_band = NaN(nCh,nCh,nBatch);

        for iCh=1:nCh
            for jCh=1:nCh
                if(all(isnan(DataSess(iCh, jCh, :, :, :, :))))
                    continue
                end
 
            
                for iBatch=1:nBatch
                    idx_tr = (iBatch-1)*lBatchStep+1:(iBatch-1)*lBatchStep+lBatch;
                    selBatch = zeros(size(selTr));
                    selBatch(idx_tr) = true;
                    
                    pac = squeeze(mean(DataSess(iCh,jCh,t_idx,famp_idx,fph_idx,selTr & selBatch),[3 4 5 6],'omitnan'));

    
                    pac_band(iCh, jCh, iBatch) = pac;
                end
            end           
        end
%         P3amp_sess{1,iSess} = p3amp;
%         P3latency_sess{1,iSess} = p3latency;
        PacBand_sess = cat(3,PacBand_sess,pac_band);
        
    end

%     P3amp{iRat,1} = P3amp_sess; 
%     P3lat{iRat,1} = P3latency_sess; 
end

    