function epoch_sig = prepare_baseline_data(rat_no, date, ep_time)

    file_dir = strcat('E:\SUT\Neuro-RA\OddBall_Proj\Data\Dataset/Data-Rat', ...
                       rat_no, '-Baseline-', date);
    data = load(strcat(file_dir, '\MatData\sessionData.mat'));
    fs = data.SampleRate;

    band = [0.5 300];

    sig = [data.channelData'; double(data.digitalByte)'];
    nCh = size(sig, 2);
    EEG.etc.eeglabvers = '2023.0';
    EEG = pop_importdata('dataformat','array','nbchan',nCh,'data',sig,'setname','raw','srate',fs,'pnts',0,'xmin',0);
    EEG = pop_chanevent(EEG, 5,'edge','leading','edgelen',0);

    EEG = pop_eegfiltnew(EEG, 'locutoff', band(1), 'hicutoff', band(2), 'plotfreqz',0);
    EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:4] ,'computepower',1, ...
                            'linefreqs',50,'newversion',0,'normSpectrum',0,'p',0.01, ...
                            'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels', ...
                            'taperbandwidth',2,'tau',100,'verb',1,'winsize',4,'winstep',1);
    asr = 20;
    EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off', ...
                                'LineNoiseCriterion','off','Highpass','off','BurstCriterion', ...
                                asr,'WindowCriterion','off','BurstRejection','off','Distance','Euclidian');

    signal = EEG.data;

    % Epoching

    epoch_len = fs * (ep_time(2) + ep_time(1));
    num_tr = ceil(length(signal) / epoch_len) - 1;
    epoch_sig = zeros(size(signal, 1), epoch_len, num_tr);

    for i=1:num_tr 

        start_idx = (i-1)*epoch_len + 1;
        end_idx = start_idx + epoch_len - 1;
        epoch_sig(:,:,i) = signal(:,start_idx:end_idx);

    end

end