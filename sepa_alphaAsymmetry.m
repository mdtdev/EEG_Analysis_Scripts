function AAS = sepa_alphaAsymmetry(eegDataBlob, overlap, duration, logbase)

% AIS = sepa_alphaAsymmetry(eegDataBlob, overlap, duration, logbase)
%
% Returns alpha imbalance scores a la Harmon-Jones (2006; references at
% bottom). Result is a vector of alpha imblance scores. This function does
% no cleaning of the data such as removing eye blinks, etc. Also assumes
% the EEG channels are arranged in EPOC order: channel 1 and 14 are
% homologous sites, as are 2 and 13, 3 and 12, and so on. AIS is arranged
% as number of differences (channels/2) by Harmon-Jones imbalance scores (1
% column). *DEFAULTS*: duration is 2 (2 seconds) and logbase is set to e =
% exp(1).
%
% Alpha power is INVERSELY related to cortical activity, so the larger the
% AIS score, the lower the power. HIGHER scores represent GREATER relative
% LEFT HEMISPHERIC activity.
%
% MDT
% 2017.02.14
% Version 0.0.1 ALPHA

    % SETUP and Defaults
    
    if nargin < 4
        logbase = exp(1);   % Switched to e b/c Allen at al (2004)
    end

    if nargin < 3
        duration = 4;       % Default 4 seconds per epoch
    end
    
    if nargin < 2
        overlap = 0.50;     % New setting for more smoothing for EPOC
    end
    
    % Obtain the average power spectrum, and power in alpha:
    
    [aps, freq, ~] = averagePowerSpectrum(eegDataBlob.data, eegDataBlob.Fs, duration, overlap);
    alphaIndex     = find(freq >=  8 & freq <= 13);   % H-J 2006 used 13 Hz UB
    avgAlphaPowers = sum(aps(alphaIndex,:));
    
    % Re-arrange to compute the log score
    
    leftAlpha  = avgAlphaPowers(1:7);
    rightAlpha = avgAlphaPowers(14:-1:8); % Reverse order to line up!
    
    AAS        = log(rightAlpha)./log(logbase) - log(leftAlpha)./log(logbase);
end

% REFERENCES:
%
% Harmon-Jones, E. (2006). Unilateral right-hand contractions cause
% contralateral alpha power suppression and approach motivational affective
% experience. Psychophysiology, 43(6), 598-603.
%
% Allen, J. J., Coan, J. A., & Nazarian, M. (2004). Issues and assumptions
% on the road from raw signals to metrics of frontal EEG asymmetry in
% emotion. Biological psychology, 67(1), 183-218.