function Complexity = calc_complexity(Data,num_levels,win_st,win_end,iTarStd)


nRat = length(Data);
Complexity = cell(size(Data));
for iRat=1:nRat
    DataRat = Data{iRat,1};
    nSess = size(DataRat,2);
    comp_sess = cell(1,nSess);
    for iSess=1:nSess
        DataSess = DataRat{iTarStd,iSess};
        cleanTr = DataRat{iTarStd+3,iSess};
        nTrial = size(DataSess,3);
        nCh = size(DataSess,1);
        comp = zeros(nTrial,nCh);

        for iCh = 1:nCh
            if all(isnan(DataSess(iCh,:,:)),'all')
                comp(:,iCh) = nan;
                continue
            end
            for iTrial=1:nTrial
%                 if(cleanTr(iTrial))
                    sig =  squeeze(DataSess(iCh,win_st:win_end,iTrial));
                    [out,~]=lempel_ziv(sig,num_levels);
                    comp(iTrial,iCh) = out;
%                 else
%                     comp(iTrial,iCh) = NaN;
%                 end
            end
        end
        comp_sess{1,iSess} = comp;
    end
    Complexity{iRat,1} = comp_sess;
end
