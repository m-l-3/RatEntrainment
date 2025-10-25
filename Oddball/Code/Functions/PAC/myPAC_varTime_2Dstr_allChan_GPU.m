function [PAC, tout, fph, famp, trialvec, tfd_all] = myPAC_varTime_2Dstr_allChan_GPU(EEG, fph, famp, twin, tovp, ttype, method, fres_param, nbins, nperm)

if ~exist('method','var') || isempty(method)
    method = "wavelet";
end

if ~exist('nperm','var') || isempty(nperm)
    nperm = 0;
end

if ~exist('nbins','var') || isempty(nbins)
    nbins = 3;
end

if ~exist('fres_param','var') || isempty(fres_param)
    switch lower(string(method))
        case "wavelet"
            fres_param = 10;
        case "rid-rihaczek"
            fres_param = 1;
        otherwise
            error('Unknown method!');
    end
end

data = single(EEG.data);
data = zscore(data, [], 2);
t = EEG.times;
Fs = EEG.srate;
nch = size(data, 1);
ntr = size(data, 3);
L = length(t);

% Move data to GPU
data = gpuArray(data);

switch method
    case 'wavelet'
        fb = cwtfilterbank('Wavelet', 'amor', 'SignalLength', length(t), 'FrequencyLimits', [0, max(famp)], 'SamplingFrequency', Fs, 'VoicesPerOctave', fres_param);
        
        [~, ff, cod] = cwt(data(1,:,1), FilterBank=fb);

        % Trimming the start and end of the window
        idx_start = find(cod < fph(1), 1, 'first');
        idx_end = length(t) - idx_start + 1;
        t = t(idx_start:idx_end);
        L = length(t);

        t_idx = buffer(1:L, round(twin*Fs), round(twin*Fs*tovp))';
        [r, ~] = find(t_idx == 0);
        t_idx(r, :) = [];
        [L, Lwin] = size(t_idx);

        if ~exist('ttype', 'var') || isempty(ttype)
            tout = t(t_idx(:, ceil(Lwin/2)));
        else
            switch ttype
                case "center"
                    tout = t(t_idx(:, ceil(Lwin/2)));
                case "first"
                    tout = t(t_idx(:, 1));
                case "last"
                    tout = t(t_idx(:, end));
                otherwise
                    error('Unknown ttype');
            end
        end

        fph = ff(ff >= fph(1) & ff <= fph(end));
        famp = ff(ff >= famp(1) & ff <= famp(end));
        Lfp = length(fph);
        Lfa = length(famp);

        tfd_all = cell(nch, ntr);
        for tr = 1:ntr
            for ch = 1:nch
                % Getting t-f distribution
                if gather(all(isnan(data(ch,:,tr))))
                    tfd_all{ch, tr} = NaN(length(ff), length(t), 'gpuArray');
                else
                    tfd_all{ch, tr} = cwt(data(ch,:,tr), FilterBank=fb);
                    tfd_all{ch, tr} = tfd_all{ch, tr}(:, idx_start:idx_end);
                end
            end
        end

        % Initialize PAC on GPU
        PAC = NaN(nch, nch, L, Lfp, Lfa, ntr, 'gpuArray');
        for tr = 1:ntr
            for ch1 = 1:nch
                for ch2 = 1:nch
                    if all(isnan(tfd_all{ch1, tr}), 'all') || all(isnan(tfd_all{ch2, tr}), 'all')
                        continue;
                    end

                    Phase_allwin = angle(tfd_all{ch1, tr}(ismember(ff, fph), :));
                    Amp_allwin = abs(tfd_all{ch2, tr}(ismember(ff, famp), :));

                    % Reshape to be used in parfor
                    Phase_temp = zeros(size(Phase_allwin, 1), length(tout), size(t_idx, 2), 'gpuArray');
                    Amp_temp = zeros(size(Amp_allwin, 1), length(tout), size(t_idx, 2), 'gpuArray');
                    for ti = 1:length(tout)
                        Phase_temp(:, ti, :) = Phase_allwin(:, t_idx(ti, :));
                        Amp_temp(:, ti, :) = Amp_allwin(:, t_idx(ti, :));
                    end

                    % Parallelize across GPU workers
                    parfor ti = 1:L
                        disp(['trial: ', num2str(tr), '/', num2str(ntr), ' | channels: [', num2str([ch1, ch2]), '] | ', num2str(ti/L*100), '%']);
                       
                        % Finding PAC at each window
                        PAC(ch1, ch2, ti, :, :, tr) = myPAC_MI(gather(squeeze(Phase_temp(:, ti, :))), gather(squeeze(Amp_temp(:, ti, :))), nbins, nperm);
                    end
                end
            end
        end
    otherwise
        error('Unknown method!');
end

trialvec = 1:size(PAC, 6);
PAC = gather(PAC); % Move PAC back to CPU
