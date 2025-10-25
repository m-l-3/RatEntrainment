function [fs, out] = preprocess_power(tstep, data, norm_factor, band, rl, fs, is_downsample, fs_down)

    sig = [data.channelData'; double(data.digitalByte)'];
    nCh = size(sig, 2);
    EEG.etc.eeglabvers = '2023.0';
    EEG = pop_importdata('dataformat','array','nbchan',nCh,'data',sig,'setname','raw','srate',fs,'pnts',0,'xmin',0);
    EEG = pop_chanevent(EEG, 5,'edge','leading','edgelen',0);
    
    if is_downsample
        EEG = pop_resample( EEG, fs_down);
        r = round(fs/fs_down);
        digitalByte = downsample(data.digitalByte, r);
        fs = fs_down;
    else
        digitalByte = data.digitalByte;
    end
    
%     EEG = pop_eegfiltnew(EEG, 'locutoff', band(1), 'plotfreqz', 0);
    EEG = pop_eegfiltnew(EEG, 'locutoff', band(1), 'hicutoff', band(2), 'plotfreqz',0);
    EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:4] ,'computepower',1, ...
                        'linefreqs',50,'newversion',0,'normSpectrum',0,'p',0.01, ...
                        'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels', ...
                        'taperbandwidth',2,'tau',100,'verb',1,'winsize',4,'winstep',1);
    asr = 20;
    EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off', ...
                            'LineNoiseCriterion','off','Highpass','off','BurstCriterion', ...
                            asr,'WindowCriterion','off','BurstRejection','off','Distance','Euclidian');

    if norm_factor == 0
        signal = EEG.data;
    else
        signal = EEG.data ./ norm_factor;
    end
    
    % Epoching    
    triggers_pulse = diff(digitalByte, 10); 
    all_trial = find(triggers_pulse == 10 | triggers_pulse == 20);
    rmv_trig_sampl = all_trial(rl);
    
    all_trial(rl) = [] ;
   
    triggers_pulse(rmv_trig_sampl) = 0;
    target_trial = find(triggers_pulse == 10);
    std_trial = find(triggers_pulse == 20);
    
    fprintf("Totall number of trials: %d, target = %d, standard = %d \n", ...
             length(all_trial), length(target_trial), length(std_trial));
    
    epoch_len = fs * (tstep(2) + tstep(1));
    out_target = zeros(size(signal, 1), epoch_len, length(target_trial));
    out_std = zeros(size(signal, 1), epoch_len, length(std_trial));
        
    epoch_idx = fs * tstep;
        
    for i=1:length(target_trial)
        out_target(:, :, i) = signal(:, target_trial(i)-epoch_idx(1) : ...
                                        target_trial(i)+epoch_idx(2)-1);
    end
    
    for i=1:length(std_trial)
        out_std(:, :, i) = signal(:, std_trial(i)-epoch_idx(1) : ...
                                     std_trial(i)+epoch_idx(2)-1);
    end
    
    trial_labels = ismember(all_trial, target_trial);
        
    out = struct( ...
            'target', out_target, ...
            'standard', out_std, ...
            'trial_labels', trial_labels ...
            );

end