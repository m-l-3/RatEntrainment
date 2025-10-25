clear
close all
clc

cfgRef
%%
sessionExcluded = ["Day5"];
useClean = true;
PAC = cell(size(nRat));

for iRat=1:nRat
    ratName = T.Name(iRat);
    if ismember(ratName, ratExcluded)
        continue
    end

    nSession = numel(T.Session{iRat,1});
    for iSession=1:nSession
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
            
            fname = "pyPACcomo_allCh_allWin_allTrial_Rat"+string(iRat-1)+"_Sess"+string(iSession-1)+"_Block"+string(iBlock-1)+".mat";
            load(fullfile(path_results,'PAC_trialSwap',fname));

            tag = load(fullfile(path_dataset,ratName,sessionName,blockName)+'.txt');
%             tag = cleanTags{iRat,1}{1,iSession}{1,iBlock};

            trialSel = true(120,1);
            if useClean
%                 trialSel = logical(tag(:,2)) & logical(tag(:,3)); 
%                 if(sum(trialSel)<40)
                    trialSel = logical(tag(:,3)); 
%                 end
            end
                
            PAC{iRat,1}{iSession}{iBlock} = mean(pac(:,:,:,:,:,trialSel), 6, 'omitnan');

            log = sprintf(">>> %s: %5s(%s) - %s done \n", ratName, sessionName, date, blockName);
            fprintf(log)

    
        end
    end
end

%%
fname = fullfile(path_results,'PAC_trialSwap','pyPACcomo_allCh_allWin_meanTrial_perRatSess.mat');
save(fname, 'PAC', 'params', 'paramsOut', 'cfg');

