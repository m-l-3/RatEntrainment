function [fs, out, rl] = preprocess_eeglab(tstep, data, norm_factor, band, rl, fs, is_downsample, fs_down, is_trZscr, is_baseline_corr, pre_norm, is_trRej, sequence)
    
    % Set default values for optional arguments
    if nargin < 13, sequence = []; end
    if nargin < 12, is_trRej = true; end
    if nargin < 11, pre_norm = 'none'; end
    if nargin < 10, is_baseline_corr = false; end
    if nargin < 9, is_trZscr = false; end
    if nargin < 8, fs_down = fs; end
    if nargin < 7, is_downsample = false; end
    
    if pre_norm == "power_norm" && any(norm_factor ~= 0)
        new_data = data.channelData ./ norm_factor';
    elseif pre_norm == "sig_Zscr"
        new_data = zscore(data.channelData, 0, 1);
    else
        new_data = data.channelData;
    end
    
    sig = [new_data'; double(data.digitalByte)'];
    nCh = size(sig, 1);
    EEG.etc.eeglabvers = '2023.1';
    EEG = pop_importdata('dataformat','array','nbchan',nCh,'data',sig,'setname','raw','srate',data.SampleRate,'pnts',0,'xmin',0);
    EEG = pop_chanevent(EEG, nCh,'edge','leading','edgelen',0);
    nCh = nCh - 1;

    if data.SampleRate ~= fs
        if is_downsample
            EEG = pop_resample( EEG, fs_down);
            r = round(data.SampleRate/fs_down);
            digitalByte = downsample(data.digitalByte, r);
            fs = fs_down;
        else
            EEG = pop_resample( EEG, fs);
            r = round(data.SampleRate/fs);
            digitalByte = downsample(data.digitalByte, r);
        end
    else
        if is_downsample
            EEG = pop_resample( EEG, fs_down);
            r = round(data.SampleRate/fs_down);
            digitalByte = downsample(data.digitalByte, r);
            fs = fs_down;
        else
            digitalByte = data.digitalByte;
        end
    end
    
    % handling digitalByte from EEGLAB (more accurate)
    digitalByte = zeros(length(EEG.data),1);
    eventType = [EEG.event.type];
    eventLatency = round([EEG.event.latency]);
    digitalByte(eventLatency(eventType==255)) = 255;
    digitalByte(eventLatency(eventType==20)) = 20;
    digitalByte(eventLatency(eventType==10)) = 10;



    EEG = pop_eegfiltnew(EEG, 'locutoff', band(1), 'hicutoff', band(2), 'plotfreqz',0);
    EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:nCh] ,'computepower',1, ...
                        'linefreqs',50,'newversion',0,'normSpectrum',0,'p',0.01, ...
                        'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels', ...
                        'taperbandwidth',2,'tau',100,'verb',0,'winsize',4,'winstep',1);
    asr = 20;
    EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off', ...
                            'LineNoiseCriterion','off','Highpass','off','BurstCriterion', ...
                            asr,'WindowCriterion','off','BurstRejection','off','Distance','Euclidian');
        
%     if pre_norm == "power_norm" && norm_factor ~= 0
%         signal = EEG.data ./ norm_factor;
%     elseif pre_norm == "sig_Zscr"
%         signal = zscore(EEG.data, 0, 2);
%     else
%         signal = EEG.data;
%     end
    
    signal = EEG.data;
    % making bipolar
%     
%     nSite = 1;
%     for iSite=1:size(EEG.data,1)-1
%         for jSite=iSite+1:size(EEG.data,1)
%             signal_bp(nSite,:) = signal(iSite,:) - signal(jSite,:);
%             nSite = nSite + 1;
%         end
%     end
%     signal = signal_bp;

    % Epoching    
    triggers = find(diff(digitalByte) >0 );
    trig2 = find(diff(triggers)< 20) ;  
    triggers(trig2+1) = [] ; 
    if triggers(2)-triggers(1)>2.2*fs
        triggers(1) = [];
    end

    if(any(diff(triggers)/fs >3)) % if ISI is greater than 3 seconds (2.2 is expected)
        warning(' >>>>>> Tags are not detected properly. <<<<<<')
    end

    tr_labels = zeros(length(triggers),1) + 3; 
    for i= 1:length(triggers)
        if sum(ismember(digitalByte(triggers(i)+1:triggers(i)+5),10))
            tr_labels(i) = 0; % target trial
        elseif sum(ismember(digitalByte(triggers(i)+1:triggers(i)+5),20))
            tr_labels(i) = 1; % std. trial
        end
    end
    
    % sanity check with the LOG sequence of stimulus
    if(~isempty(sequence))
        if(any(sequence(1:length(tr_labels))~=tr_labels))
            warning(' >>>>>> detected trial labels are not compatible with recorded sequence LOG of stimulus. <<<<<<')
        else
            cprintf('-comment',  '>>>>>> detected trial labels are truely compatible with recorded sequence LOG of stimulus. <<<<<<\n');
        end
    end

    % handling not enough samples for the last epoch
    epoch_idx = fs * tstep;
    if(triggers(end)+ epoch_idx(2) > length(signal))
        triggers(end) = [];
        tr_labels(end) = [];
    end
    
    % changed/unChanged labeling
    changed_tr_label = [1; abs(diff(1-tr_labels))];
    unChanged_tr_label = [0; 1 - abs(diff(1-tr_labels))]; 

    % handling clean trials
    all_cleanTr = ones(size(triggers));
    if(is_trRej)
        triggers(rl) = [];
        tr_labels(rl) = [];
        changed_tr_label(rl) = [];
        unChanged_tr_label(rl) = []; 
        all_cleanTr(rl) = [];
    else
        all_cleanTr(rl) = 0;
    end

    % target/std. labeling
    target_labels = 1-tr_labels == 1;
    std_labels = tr_labels == 1;
    target_trial = triggers(target_labels);
    std_trial = triggers(std_labels);
    target_cleanTr = all_cleanTr(target_labels);
    std_cleanTr = all_cleanTr(std_labels);
%     changed_cleanTr = all_cleanTr(changed_tr_label==1);
%     unChanged_cleanTr = all_cleanTr(unChanged_tr_label==1);
    
    % checking for possible issues
    fprintf("Totall number of trials: %d, target = %d, standard = %d \n", ...
             length(triggers), length(target_trial), length(std_trial));
    if(length(triggers) ~= length(target_trial) + length(std_trial))
        warning(' >>>>>> target/std. are not counted properly. <<<<<<')
    end
    if(length(triggers) ~= sum(changed_tr_label) + sum(unChanged_tr_label))
        warning(' >>>>>> changed/unChanged. are not counted properly. <<<<<<')
    end


    epoch_len = fs * (tstep(2) + tstep(1));
    out_all = zeros(size(signal, 1), epoch_len, length(triggers));
    for i=1:length(triggers)

        out_all(:, :, i) = signal(:, triggers(i)-epoch_idx(1) : ...
                                     triggers(i)+epoch_idx(2)-1);
    end  

    if is_trZscr
        out_all = zscore(out_all, 0, 2);
    end

    if is_baseline_corr
        out_all = out_all - mean(out_all(:,1:epoch_idx(1),:),2);
    end

    out_target = out_all(:,:,target_labels);
    out_std = out_all(:,:,std_labels);
    
    out = struct( ...
            'target', out_target, ...
            'standard', out_std, ...
            'all', out_all, ...
            'target_cleanTr', target_cleanTr, ...
            'std_cleanTr', std_cleanTr, ...
            'all_cleanTr', all_cleanTr, ...
            'target_labels', target_labels, ...
            'std_labels', std_labels, ...
            'changed_labels', changed_tr_label == 1, ...
            'unChanged_labels', unChanged_tr_label == 1 ...
            );

end