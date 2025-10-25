function [data_out, Warnings, figHandle] = prep_eeglab(data, cfg, cleanTag)

    Warnings = [];
    if cfg.is_sigZscore 
        new_data = zscore(data.channelData, 0, 1);
    else
        new_data = data.channelData;
    end
    
    sig = [new_data'; double(data.digitalByte)'];
    nCh = size(sig, 1);
    EEG.etc.eeglabvers = '2023.1';
    EEG = pop_importdata('dataformat','array','nbchan',nCh,'data',sig,'setname','raw','srate',data.SampleRate,'pnts',0,'xmin',0);
    EEG = pop_chanevent(EEG, 5,'edge','leading','edgelen',0);
    

    if cfg.is_downSamlpe
        EEG = pop_resample( EEG, cfg.Fs_down);
    end
    Fs = cfg.Fs;    
    
    % handling digitalByte from EEGLAB (more accurate)
    digitalByte = zeros(length(EEG.data),1);
    eventType = [EEG.event.type];
    eventLatency = round([EEG.event.latency]);
    digitalByte(eventLatency(eventType==255)) = 0;
    digitalByte(eventLatency(eventType==128)) = 128;



    EEG = pop_eegfiltnew(EEG, 'locutoff', cfg.filBand(1), 'hicutoff', cfg.filBand(2), 'plotfreqz',0);
    EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:4] ,'computepower',1, ...
                        'linefreqs',50,'newversion',0,'normSpectrum',0,'p',0.01, ...
                        'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels', ...
                        'taperbandwidth',2,'tau',100,'verb',0,'winsize',4,'winstep',1);
    
    EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off', ...
                            'LineNoiseCriterion','off','Highpass','off','BurstCriterion', ...
                            cfg.asr,'WindowCriterion','off','BurstRejection','off','Distance','Euclidian');
        
    
    EEG = pop_epoch( EEG, {  '128'  }, [cfg.epoch(1)  cfg.epoch(2)], 'newname', 'raw resampled_fil_cleanLine_clean epochs', 'epochinfo', 'yes');
    figHandle = figure; 
    pop_spectopo(EEG, 1, [], 'EEG' , 'freqrange',[2 cfg.filBand(2)],'electrodes','off');
%     EEG = pop_rmbase( EEG, [cfg.epoch(1)*1000 0] ,[]);

%     signal = EEG.data;

    % Epoching    
    triggers = find(diff(digitalByte) == 128 );


    if(any(diff(triggers)/Fs >7)) % if ISI is greater than 7 seconds (6 is expected)
        war = " >>>>>> Trials are not detected properly. <<<<<<"; 
        warning(war)
        Warnings = cat(1,Warnings,war);
    end

    
    
   
    % checking for possible issues
    fprintf("Totall number of trials: %d\n", ...
             length(triggers));
    if(length(triggers) ~= cfg.nTrial)
        war = " >>>>>> Trials are not counted properly. <<<<<<";
        warning(war)
        Warnings = cat(1,Warnings,war);
    end
    if(length(cleanTag) ~= cfg.nTrial)
        war = " >>>>>> Tags are not detected properly. <<<<<<";
        warning(war)
        Warnings = cat(1,Warnings,war);
    end


%     epoch_len = Fs * (cfg.epoch(2) - cfg.epoch(1));
%     data_out = zeros(size(signal, 1), epoch_len, length(triggers));
%     for i=1:length(triggers)
% 
%         data_out(:, :, i) = signal(:, triggers(i)+Fs*cfg.epoch(1) : ...
%                                      triggers(i)+Fs*cfg.epoch(2)-1);
%     end  

    data_out = EEG.data(:,:,1:cfg.nTrial);
    
    if cfg.is_trZscore
        data_out = zscore(data_out, 0, 2);
    end

    if cfg.is_baseLine
        data_out = data_out - mean(data_out(:,1:abs(Fs*cfg.epoch(1)),:),2);
    end
    

    