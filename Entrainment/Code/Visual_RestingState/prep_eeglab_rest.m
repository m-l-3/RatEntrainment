function [data_out, cleanTag, Warnings, figHandle] = prep_eeglab_rest(data, cfg)

    Warnings = [];
    if cfg.is_sigZscore 
        new_data = zscore(data.channelData, 0, 1);
    else
        new_data = data.channelData;
    end
    
    nCh = size(new_data, 2);
    sig = [new_data'; double(data.digitalByte)'];
    EEG.etc.eeglabvers = '2023.1';
    EEG = pop_importdata('dataformat','array','nbchan',nCh+1,'data',sig,'setname','raw','srate',data.SampleRate,'pnts',0,'xmin',0);
    EEG = pop_chanevent(EEG, 5,'edge','leading','edgelen',0);
    

    if cfg.is_downSamlpe
        EEG = pop_resample( EEG, cfg.Fs_down);
    end
    Fs = cfg.Fs;    
    
    % handling digitalByte from EEGLAB (more accurate)
    digitalByte = zeros(length(EEG.data),1);
    if(~isempty(EEG.event))
        eventType = [EEG.event.type];
        eventLatency = round([EEG.event.latency]);
        digitalByte(eventLatency(string(eventType)=="chan5")) = 255;
        digitalByte(eventLatency(string(eventType)=="255")) = 255;
    end


    EEG = pop_eegfiltnew(EEG, 'locutoff', cfg.filBand(1), 'hicutoff', cfg.filBand(2), 'plotfreqz',0);
    EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:cfg.nCh] ,'computepower',1, ...
                        'linefreqs',50,'newversion',0,'normSpectrum',0,'p',0.01, ...
                        'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels', ...
                        'taperbandwidth',2,'tau',100,'verb',0,'winsize',4,'winstep',1);
    
    EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off', ...
                            'LineNoiseCriterion','off','Highpass','off','BurstCriterion', ...
                            cfg.asr,'WindowCriterion','off','BurstRejection','off','Distance','Euclidian');
        
    
    figHandle = figure; 
    pop_spectopo(EEG, 1, [], 'EEG' , 'freqrange',[2 cfg.filBand(2)],'electrodes','off');


    % Epoching    
    trigger = find(diff(digitalByte) == 255 ) + 1;
    durLen = round(cfg.Duration*Fs);
    winLen = round(cfg.winLen*Fs);
    winSlip = round(cfg.winSlip*Fs);

    if(numel(trigger)>1)
        war = " >>>>>> Incorrect tags. <<<<<<"; 
        warning(war)
        Warnings = cat(1,Warnings,war);
        trigger = min(trigger);
    end

    if((length(EEG.data)-trigger+1)/Fs < cfg.Duration) 
        war = " >>>>>> Not enough data length. <<<<<<"; 
        warning(war)
        Warnings = cat(1,Warnings,war);

        trigger = 1;
        nWin = floor((length(EEG.data)-winLen)/winSlip)+1;
        durLen = nWin*winLen;

    elseif(isempty(trigger))
        war = " >>>>>> Triger missed. <<<<<<"; 
        warning(war)
        Warnings = cat(1,Warnings,war);

        trigger = 1;
        nWin = min(floor((length(EEG.data)-winLen)/winSlip)+1, cfg.nWin);
    else
        
        nWin = cfg.nWin;    
    end

%     trigger = trigger + 3.5*60*Fs; % for last 2 min
    if(cfg.is_windowed)
        temp = zeros(nCh, winLen, nWin);
        for iWin=1:nWin
            temp(:, :, iWin) = EEG.data(:, (iWin-1)*winSlip+1+trigger:(iWin-1)*winSlip+winLen+trigger);
        end
    else
        temp = EEG.data(:, trigger+1:+trigger+durLen);
    end
    

    % checking for possible issues
    fprintf("Totall number of windows: %d\n", ...
             nWin);
    
 

    data_out = temp;
    
    if cfg.is_winZscore
        data_out = zscore(data_out, 0, 2);
    end

    cleanTag = squeeze(all(all(abs(data_out)<=cfg.cleanTh, 2),1));

    

    