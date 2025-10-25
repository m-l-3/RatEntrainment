function [Sequence] = sequenceFinder(Data,state,params)


nRat = length(Data);
Sequence = cell(size(Data));
lBatch = params.lBatch;
lBatchStep = params.lBatchStep;

for iRat=1:nRat
    DataRat = Data{iRat,1};
    nSess = size(DataRat,2);
    Sequence_sess = cell(1,nSess);

    for iSess=1:nSess
        if(state=="target")
            seq_sess = DataRat{8,iSess};
        elseif(state=="changed")
            seq_sess = DataRat{9,iSess};
        else
            error('');
        end
        nTr = length(seq_sess);
        nBatch = (nTr-lBatch)/lBatchStep+1;
        seq_batch = NaN(nBatch,1);
        for iBatch=1:nBatch
            idx_tr = (iBatch-1)*lBatchStep+1:(iBatch-1)*lBatchStep+lBatch;
            selBatch = false(nTr,1);
            selBatch(idx_tr) = true;

            seq_batch(iBatch) = mean(seq_sess(selBatch));
   
        end
        Sequence_sess{1,iSess} = seq_batch;

    end

    Sequence{iRat,1} = Sequence_sess; 

end

    