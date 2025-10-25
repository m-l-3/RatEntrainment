function [timeVec,freqs,ITPC] = calc_itpc(Data,params,iTarStd,useClean)


Fs = params.Fs;
nRat = length(Data);
ITPC = cell(size(Data));
nCycles = params.nCycles;
freq_range = params.freq_range;

for iRat=1:nRat
    DataRat = Data{iRat,1};
    nSess = size(DataRat,2);
    Itpc_sess = cell(1,nSess);
    for iSess=1:nSess
        DataSess = DataRat{iTarStd,iSess};
        cleanTr = logical(DataRat{iTarStd+3,iSess});
%         nTrial = size(DataSess,3);
        nCh = size(DataSess,1);
        Itpc = [];

        for iCh = 1:nCh
            if(useClean)
                sig =  squeeze(DataSess(iCh,:,cleanTr));
            else
                sig =  squeeze(DataSess(iCh,:,:));
            end

            [itpc, freqs, timeVec] = itpc_core(sig, Fs, freq_range(1):freq_range(2), nCycles);

%             [S,t,f]=mypmtm(sig,movingwin,params);

           
            Itpc = cat(3,Itpc,itpc);
        end
        Itpc_sess{1,iSess} = Itpc;
    end
    ITPC{iRat,1} = Itpc_sess;
end
