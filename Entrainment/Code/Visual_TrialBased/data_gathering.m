
cfgRef


%% simple gathering 

Logs = [];
Warnings = [];
for iRat=1:nRat
    ratName = T.Name(iRat);
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
            dataDir = fullfile(path_record,date,ratName,block);
    
            foldercontent = dir(dataDir);
            if numel(foldercontent) > 2
    
                [channelData, digitalByte, time, SampleRate] = read_neural_data(dataDir);
    
                if(SampleRate~=Fs_main)
                    warning = sprintf(">>> somthing wrong in %s, %5s, %s \n", ratName, sessionName, block);
                    fprintf(warning);
                    Warnings = cat(1,Warnings,warning);

                    nCh = size(channelData, 2);
                    EEG = pop_importdata('dataformat','array','nbchan',nCh,'data',channelData','setname','raw','srate',SampleRate,'pnts',0,'xmin',0);
                    r = round(SampleRate/Fs_main);
                    EEG = pop_resample(EEG,Fs_main);
                    channelData = (EEG.data)';
                    digitalByte = downsample(digitalByte, r)';
                    time = downsample(time, r);

                    clear EEG
                end
    
                saveDir = fullfile(path_dataset,ratName,sessionName);
                mkdir(saveDir)
                save(fullfile(saveDir, block), ...
                    'channelData', ...
                    'digitalByte', ...
                    'time', ...
                    'SampleRate')
    
                log = sprintf(">>> %s: %5s(%s) - %s\n", ratName, sessionName, date, block);
                fprintf(log)
                Logs = cat(1,Logs, log);
    
            else
                log = sprintf(">>> %s: %5s(%s) - %s EMPTY<<<<<<< \n", ratName, sessionName, date, block);
                fprintf(log)
                Logs = cat(1,Logs, log);
            end
        end
    end
end

