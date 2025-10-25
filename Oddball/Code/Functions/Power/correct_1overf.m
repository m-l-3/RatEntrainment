function [S_corrected, slope, intercept] = correct_1overf(S, f, fitFreqRange)
%CORRECT_1OVERF Performs 1/f correction on Chronux spectrum output
% 
%   [S_corrected, slope, intercept] = correct_1overf(S, f, fitFreqRange)
%
%   Inputs:
%       S            - Power spectrum (nTimeWindows x nFreqs x nTrials)
%       f            - Frequency vector (nFreqs x 1)
%       fitFreqRange - [minFreq maxFreq] for 1/f fit (default: [5 100])
%
%   Outputs:
%       S_corrected  - Log-power residuals (same size as S)
%       slope        - 1/f slope per time window and trial
%       intercept    - 1/f intercept per time window and trial

    if nargin < 3
        fitFreqRange = [5 100]; % Default frequency range for 1/f fit
    end

    % Dimensions
    [nTime, nFreqs, nTrials] = size(S);

    % Preallocate outputs
    S_corrected = nan(size(S));
    slope = nan(nTime, nTrials);
    intercept = nan(nTime, nTrials);

    % Log-transform frequency axis
    log_f = log10(f);
    fitIdx = f >= fitFreqRange(1) & f <= fitFreqRange(2);
    log_f_fit = log_f(fitIdx);

    for iTrial = 1:nTrials
        for iTime = 1:nTime
            spec = squeeze(S(iTime, :, iTrial)); % [1 x nFreqs]
            if all(isnan(spec))
                continue;
            end

            log_spec = log10(spec);
            log_spec_fit = log_spec(fitIdx);

            % Fit line in log-log space
            p = polyfit(log_f_fit, log_spec_fit, 1);

            % Store fit coefficients
            slope(iTime, iTrial) = p(1);
            intercept(iTime, iTrial) = p(2);

            % Remove 1/f trend
            log_fit_full = polyval(p, log_f);
            S_corrected(iTime, :, iTrial) = log_spec - log_fit_full;
        end
    end
end
