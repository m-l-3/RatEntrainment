function [PAC_avg] = pac_makeAvg(Data, PAC, useClean, balance, params)


nRat = length(PAC);
PAC_avg = cell(size(PAC));

fph_out = params.fph_out;
famp_out = params.famp_out;
fph_range = params.fph_range;
famp_range = params.famp_range;
time_pac = params.time_pac;
t_range = params.t_range;

fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);
tpac_idx = time_pac>=t_range(1) & time_pac<=t_range(2);


for iRat=1:nRat
    PACRat = PAC{iRat,1};
    nSess = size(PACRat,2);
    PAC_sess = cell(1,nSess);

    for iSess=1:nSess
        PACSess = PACRat{1,iSess};
        cleanTr = logical(Data{iRat,1}{4,iSess});
        stdLabel = logical(Data{iRat,1}{7,iSess});
        targetLabel = logical(Data{iRat,1}{8,iSess});
        changedLabel = logical(Data{iRat,1}{9,iSess});
        unChangedLabel = logical(Data{iRat,1}{10,iSess});

        if(useClean)
            stdLabel = stdLabel & cleanTr;
            targetLabel = targetLabel & cleanTr;
            changedLabel = changedLabel & cleanTr;
            unChangedLabel = unChangedLabel & cleanTr;
        end



        stdErp = squeeze(mean(PACSess(:,:,:,:,:, stdLabel),6,'omitnan'));
        targetErp = squeeze(mean(PACSess(:,:,:,:,:, targetLabel),6,'omitnan'));
        changedErp = squeeze(mean(PACSess(:,:,:,:,:, changedLabel),6,'omitnan'));
        unChangedErp = squeeze(mean(PACSess(:,:,:,:,:, unChangedLabel),6,'omitnan'));
        nStd = sum(stdLabel,1);
        nTarget = sum(targetLabel,1);
        nChanged = sum(changedLabel,1);
        nUnChanged = sum(unChangedLabel,1);

        if(balance)
            stdSig = squeeze(PACSess(:,:,:,:,:, stdLabel));
            idx = randsample(nStd,nTarget);
            stdErp = squeeze(mean(stdSig(:,:,:,:,:, idx),6,'omitnan'));

            unChangeSig = squeeze(PACSess(:,:,:,:,:, unChangedLabel));
            idx = randsample(nUnChanged,nChanged);
            unChangedErp = squeeze(mean(unChangeSig(:,:,:,:,:, idx),6,'omitnan'));
        end


        PacAmp(:,:,1) = mean(stdErp(:,:,tpac_idx,famp_idx,fph_idx),[3 4 5]);
        PacAmp(:,:,2) = mean(targetErp(:,:,tpac_idx,famp_idx,fph_idx),[3 4 5]);
        PacAmp(:,:,3) = PacAmp(:,:,2) - PacAmp(:,:,1);
        PacAmp(:,:,4) = mean(changedErp(:,:,tpac_idx,famp_idx,fph_idx),[3 4 5]);
        PacAmp(:,:,5) = mean(unChangedErp(:,:,tpac_idx,famp_idx,fph_idx),[3 4 5]);
        PacAmp(:,:,6) = PacAmp(:,:,4) - PacAmp(:,:,5);

        PAC_sess{1,iSess} = PacAmp;
    end
    
PAC_avg{iRat,1} = PAC_sess;
end




