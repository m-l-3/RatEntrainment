
cfgRef


%% aggregating data

Logs = [];
Warnings = [];
Data = cell(nRat,1);
cleanTags = cell(nRat,1);

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
        nBlock = numel(T.Blocks{iRat,1}{iSession});
        for iBlock=1:nBlock

            block = T.Blocks{iRat,1}{iSession}{iBlock};

            fileName = fullfile(path_dataset,ratName,sessionName,block)+'.mat';
            data = load(fileName);
            markFileName = fullfile(path_dataset,ratName,sessionName,block)+'.txt';
            tag = load(markFileName);
            cleanTags{iRat,1}{iSession}{iBlock} = tag;

            [Data{iRat,1}{iSession}{iBlock}, war, fig] = prep_eeglab(data, cfg, tag);

            log = sprintf(">>> %s: %5s(%s) - %s done \n", ratName, sessionName, date, block);
            fprintf(log)
            Logs = cat(1,Logs, log);
            Warnings = cat(1, Warnings, war+"/// "+log);
            
            figFileName = fullfile(path_results,'Ch-Spect',strcat(ratName,sessionName,block))+'.png';
            print(fig,figFileName,'-dpng','-r300');
    

        end
    end
end

%% editting ch2 problem

Data{T.Name=='Rat9'}{2}{1}(2,:,:) = NaN;
Data{T.Name=='Rat9'}{2}{2}(2,:,:) = NaN;

Data{T.Name=='Rat11'}{4}{1}(2,:,:) = NaN;
Data{T.Name=='Rat11'}{4}{2}(2,:,:) = NaN;

Data{T.Name=='Rat12'}{1}{1}(2,:,:) = NaN;
Data{T.Name=='Rat12'}{1}{2}(2,:,:) = NaN;
Data{T.Name=='Rat12'}{2}{1}(2,:,:) = NaN;
Data{T.Name=='Rat12'}{2}{2}(2,:,:) = NaN;
Data{T.Name=='Rat12'}{3}{1}(2,:,:) = NaN;

%% save
fname = sprintf('allRatSessBlock_e%d-%d_fil%d-%d_fs%d.mat', ...
        cfg.epoch(1),cfg.epoch(2),cfg.filBand(1),cfg.filBand(2),cfg.Fs);
fileName = fullfile(path_dataset,'aggregate',fname);
save(fileName, 'Data', 'cfg', 'cleanTags')

