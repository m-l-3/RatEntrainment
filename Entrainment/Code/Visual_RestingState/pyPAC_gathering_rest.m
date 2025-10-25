clear
close all
clc

cfgRef_Rest
%%
sessionExcluded = ["Day5"];
useClean = true;
PAC = cell(size(nRat));

fname = sprintf('allRatSessBlock_dur%d_winLen%d-winSlip%.1f_fil%d-%d_fs%d.mat', ...
        cfg.Duration,cfg.winLen,cfg.winSlip,cfg.filBand(1),cfg.filBand(2),cfg.Fs);
fileName = fullfile(path_dataset,'aggregate',fname);

cleanTags = load(fileName).cleanTags;

fph_range = [4 12];
famp_range = [16 90];

for iRat=1:nRat
%     figure(iRat)
    ratName = T.Name(iRat);
    if ismember(ratName, ratExcluded)
        continue
    end

    nSession = numel(T.Session{iRat,1});
    for iSession=1:nSession
%         subplot(5,1,iSession)
        date = T.Dates{iRat,1}{iSession};
        if(isempty(date))
            continue
        end
        sessionName = T.Session{iRat,1}{iSession};
        if ismember(sessionName, sessionExcluded)
            continue
        end

        
        nBlock = numel(T.Blocks{iRat,1}{iSession});
        for iBlock=1:nBlock

            blockName = T.Blocks{iRat,1}{iSession}{iBlock};
            
            fname = "pyPACcomo_allCh_allWin_Rat"+string(iRat-1)+"_Sess"+string(iSession-1)+"_Block"+string(iBlock-1)+".mat";
            load(fullfile(path_results,'PAC_trialSwap/',fname));

            tag = cleanTags{iRat,1}{1,iSession}{1,iBlock};

            trialSel = true(size(tag));
            if useClean
                trialSel = logical(tag);                
            end


            fph_out = mean(paramsOut.fph_out,2);
            famp_out = mean(paramsOut.famp_out,2);

            fph_idx = fph_out>=fph_range(1) & fph_out<=fph_range(2);
            famp_idx = famp_out>=famp_range(1) & famp_out<=famp_range(2);
%             plot(squeeze(mean(pac(3,3,famp_idx,fph_idx,:),[3 4],'omitnan')))
%             hold on

            tempPac = mean(pac(:,:,famp_idx,fph_idx,:), [3 4], 'omitnan');
            pacNorm = zscore(tempPac,0,5);
            mask = pacNorm < 3;  
            mask = repmat(mask, [1, 1, size(pac,3), size(pac,4), 1]);  

            pac(mask) = NaN;
            PAC{iRat,1}{iSession}{iBlock} = mean(pac(:,:,:,:,trialSel), 5, 'omitnan');

            log = sprintf(">>> %s: %5s(%s) - %s done \n", ratName, sessionName, date, blockName);
            fprintf(log)



        end
    end
end

%%
fname = fullfile(path_results,'PAC_trialSwap/','pyPACcomo_allCh_meanWin_perRatSess.mat');
save(fname, 'PAC', 'params', 'paramsOut', 'cfg');

