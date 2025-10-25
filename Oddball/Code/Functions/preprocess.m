function [fs, out] = preprocess(tstep, signal, digitalByte, band, rl, fs, is_downsample, fs_down) 

    % preprocess: Preprocesses signal data based on specified parameters.
    % Inputs:
    %   tstep: Time step for selecting subsets of signal. [start end]
    %   signal: Input signal data.
    %   digitalByte: Representing Trigger values (20: standard and 10: target) for each trial.
    %   band: Frequency band for bandpass filtering.
    %   rl: Remove list.
    %   fs: Sampling frequency.
    %   type: Type of preprocessing (rest, stimulus, or rest&Stimulus).
    %   **Zscore-type: 'over trials' / 'over channel' (must be imlpemented)**
    %
    % Output:
    %   out: Preprocessed signal data.
         
    % Downsampling
    if(is_downsample)
        new_signal = [];
        r = round(fs/fs_down);
        for i=1:min(size(signal))
            new_signal = [new_signal decimate(signal(:,i), r)];
        end
        digitalByte = downsample(digitalByte, r);
        fs = fs_down;
        signal = new_signal;
    end
    
    % Filtering
    tic
    signal = bandpass(signal, band, fs); 
    toc
    
    if size(signal, 1) > size(signal, 2)
       signal = signal'; 
    end
    
    % Epoching    
    triggers = find(diff(digitalByte) > 0 & diff(digitalByte) ~= 255); 
    all_trial = triggers(digitalByte(triggers) == 0);
    all_trial(rl) = [] ;
    tar_mask = digitalByte(all_trial+10) == 10;
    std_mask = digitalByte(all_trial+10) == 20;
    target_trial = all_trial(tar_mask);
    std_trial = all_trial(std_mask);
    
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
        
    out_target = zscore(out_target, 0, 2);
    out_std = zscore(out_std, 0, 2);
    
    out = struct( ...
            'target', out_target, ...
            'standard', out_std, ...
            'trial_labels', trial_labels ...
            );

end