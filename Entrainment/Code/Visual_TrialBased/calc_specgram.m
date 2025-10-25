function [t,f,Specgram] = calc_specgram(Data, cleanTags, params, useClean, useERP)

movingwin = [params.tWinLen params.tWinSlip];

nRat = length(Data);
Specgram = cell(size(Data));

for iRat=1:nRat
    DataRat = Data{iRat,1};
    if(isempty(DataRat))
        continue
    end

    nSess = size(DataRat,2);
    specgram_sess = cell(1,nSess);
    for iSess=1:nSess
        DataSess = DataRat{1,iSess};
        nBlock = size(DataSess,2);
        specgram_block = cell(1,nBlock);
        
        for iBlock=1:nBlock
            DataBlock = DataSess{1,iBlock};
            nCh = size(DataBlock,1);
            spec = [];
            for iCh = 1:nCh
                if(useClean)
                    tag = cleanTags{iRat,1}{1,iSess}{1,iBlock};
                    trialSel = logical(tag(:,2)) & logical(tag(:,3));
                    sig =  squeeze(DataBlock(iCh,:,trialSel));
                else
                    sig =  squeeze(DataBlock(iCh,:,:));
                end
                if(useERP)
                    sig = mean(sig,2,'omitnan');
                end

                [S,t,f]=mtspecgramc(sig,movingwin,params);

%                 STrial = NaN(71,1000,size(sig,2));
%                 Fs = params.Fs;
%                 if(~any(isnan(sig)))
%                     for iTrial=1:size(sig,2)
%                         [STrial(:,:,iTrial),f] = cwt(sig(:,iTrial),'amor',Fs);
%                     end
%                     %                 [S,f] = cwt(sig,'amor',Fs);
%                 end
%                 S = mean(abs(STrial).^2,3)';
%                 f = f';
%                 t = 0+1/Fs:1/Fs:1;

                if(params.trialave)
                    spec = cat(3,spec,abs(S));
                else
                    spec = cat(4,spec,abs(S));
                end   
            end
            specgram_block{1,iBlock} = spec;
        end
        specgram_sess{1,iSess} = specgram_block;
    end
    Specgram{iRat,1} = specgram_sess;
end
