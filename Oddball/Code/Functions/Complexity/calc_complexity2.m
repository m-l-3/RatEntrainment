function Complexity = calc_complexity2(Data,num_levels,nWin,winLen,winSlip,iTarStd)
%%% over time windows and trial


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
        comp = zeros(nTrial,nCh,nWin);

        for iCh = 1:nCh
            if all(isnan(DataSess(iCh,:,:)),'all')
                comp(:,iCh,:) = nan;
                continue
            end
            for iTrial=1:nTrial
                if(cleanTr(iTrial))
                    sig =  squeeze(DataSess(iCh,:,iTrial));
                    for iWin=1:nWin
                        sig_win = sig( (iWin-1)*winSlip+1:(iWin-1)*winSlip+winLen);
                        [out,~]=lempel_ziv(sig_win,num_levels);
                        comp(iTrial,iCh,iWin) = out;
                    end                    
                else
                    comp(iTrial,iCh,:) = NaN;
                end
            end
        end
        comp_sess{1,iSess} = comp;
    end
    Complexity{iRat,1} = comp_sess;
end
