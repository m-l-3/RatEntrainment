function [itpc, freqs, timeVec] = itpc_core(data, Fs, freqs, nCycles)
% COMPUTE_ITPC Computes Inter-Trial Phase Coherence (ITPC)
%
% Inputs:
%   data    : [time x trials] matrix of time-domain signals
%   Fs      : Sampling frequency (Hz)
%   freqs   : Vector of frequencies to analyze (e.g., 4:1:12)
%   nCycles : Number of cycles in Morlet wavelet (default = 6)
%
% Outputs:
%   itpc    : [freq x time] matrix of ITPC values (0 to 1)
%   freqs   : Vector of frequencies used
%   timeVec : Time vector corresponding to rows in 'data'

    if nargin < 4
        nCycles = 6; % default value if not provided
    end

    [nTime, nTrials] = size(data);
    nFreqs = length(freqs);
    itpc = zeros(nFreqs, nTime);
%     timeVec = (0:nTime-1) / Fs;
    timeVec = -1.5+1/Fs : 1/Fs : 2;

    for fi = 1:nFreqs
        f = freqs(fi);
        s = nCycles / (2 * pi * f);  % standard deviation of Gaussian
        t_wave = -1.5*s : 1/Fs : 2*s;
        wavelet = exp(2*1i*pi*f*t_wave) .* exp(-t_wave.^2/(2*s^2));

        phase_data = zeros(nTime, nTrials);
        for tr = 1:nTrials
            conv_result = conv(data(:,tr), wavelet, 'same');
            phase_data(:,tr) = angle(conv_result);
        end

        itpc(fi, :) = abs(mean(exp(1i * phase_data), 2));
    end
end
