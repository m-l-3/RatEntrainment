function [fHigh, Sorting_res] = power_sorting(Data,freq,freq_ranges,n_interp)

fLow_sel = freq>=freq_ranges(1,1) & freq<=freq_ranges(1,2);
fHigh_sel = freq>=freq_ranges(2,1) & freq<=freq_ranges(2,2);
fHigh = freq(fHigh_sel);
nCh = 4;
nRat = length(Data);
Sorting_res = cell(size(Data));

for iRat=1:nRat
    DataRat = Data{iRat,1};
    nSess = size(DataRat,2);
    sortRes_sess = cell(2,nSess);

    sortedLowBand = NaN(nSess,n_interp,nCh);
    HighBand = NaN(nSess,numel(fHigh),n_interp,nCh);
    for iSess=1:nSess
        DataSess = DataRat{1,iSess};
        nTrial = size(DataSess,3);
        nCh = size(DataSess,4);

%         sortedLowBand = NaN(nTrial,nCh);
%         HighBand = NaN(numel(fHigh),nTrial,nCh);

        for iCh=1:nCh
            if(all(isnan(DataSess(:,fLow_sel,:,iCh)),'all'))
                continue
            end
            lowPow = squeeze(mean(DataSess(:,fLow_sel,:,iCh), [1 2],'omitnan'));
            [sorted_lowPow,Idx_tr] = sort(lowPow);
%             lowPow_interp = linspace(min(sorted_lowPow),max(sorted_lowPow),n_interp);
            lowPow_interp = linspace(0,0.06,n_interp);
            sortedLowBand(iSess,:,iCh) = lowPow_interp;
            
            high_band = squeeze(mean(DataSess(:,fHigh_sel,Idx_tr,iCh), 1,'omitnan'));  
            high_band_interp = interp1(sorted_lowPow,high_band',lowPow_interp);
            HighBand(iSess,:,:,iCh) = high_band_interp'; 
        end
%         sortRes_sess{1,iSess} = sortedLowBand;
%         sortRes_sess{2,iSess} = HighBand;
    end
%     Sorting_res{iRat,1} = sortRes_sess;
    Sorting_res{iRat,1} = squeeze(mean(sortedLowBand,1));
    Sorting_res{iRat,2} = squeeze(mean(HighBand,1));
end
