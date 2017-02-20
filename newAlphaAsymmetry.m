function AIS = newAlphaAsymmetry(eegDataBlob, overlap, duration, logbase)

% AIS = newAlphaAsymmetry(eegDataBlob, overlap, duration, logbase)
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
% **Expects the EEG time courses in GMAC order time X channels, not the
% natural order used by eeglab!**
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
        logbase = exp(1);   % Switched to exp b/c Allen at al (2004)
    end

    if nargin < 3
        duration = 2;       % Default number of seconds per epoch
    end
    
    if nargin < 2
        overlap = 0.50;     % New setting for more smoothing for EPOC
    end
    
    % Construct FFT Windows (Mostly from gmac01.m; see for details!)
    
    fftlength  = eegDataBlob.Fs * duration; % Based on duration variable!
    hanning    = [1:fftlength]';
    hanning_in = 2*pi*(hanning - (fftlength+1)/2)/(fftlength+1);
    hanning    = (sin(hanning_in)./hanning_in).^2;
    hanning    = repmat(hanning, 1, 14);
    f          = [128/fftlength:128/fftlength:128];
    
    % The following code selects the locations, in f, where the named
    % frequencies are located. To see the alpha frequencies, for instance,
    % you would use f(alphaIndex), etc. The use of < and <= is to make sure
    % the spectrum is not ever counted double.
    
    thetaIndex    = find(f >=  4 & f <   8);
    alphaIndex    = find(f >=  8 & f <= 13); % Note new bounds/H-J 2006 used 13 Hz
    betaIndex     = find(f >  13 & f <  25); % No more high and low beta as in gmac01
    gammaIndex    = find(f >= 25 & f <= 40);
    totIndex      = find(f >=  4 & f <= 40);
    usefulSpec    = find(f >=  2 & f <= 40);
    outdata       = [];    
    
    % Make locations to store frequency powers
    
    eegDataBlob.theta    = [];
    eegDataBlob.alpha    = [];
    eegDataBlob.beta     = [];
    eegDataBlob.gamma    = [];
    eegDataBlob.tot      = [];
    eegDataBlob.totmed   = [];
    
    % Main power computation
    %
    % Overlap is 50% of duration by default, based loosely on Harmon-Jones
    % and the EPOC's noisiness
    
    stepSamples   = ceil((1 - overlap)*fftlength);
    allSpectra = zeros(length(fftlength:stepSamples:size(eegDataBlob.filterData,1)),length(usefulSpec))
    
    for k = fftlength:stepSamples:size(eegDataBlob.filterData,1)
        spectrum  = fft(eegDataBlob.filterData(k - fftlength + 1:k, :) .* hanning);
        spectrum  = sqrt(spectrum .* conj(spectrum)); 
        
        eegDataBlob.theta = [eegDataBlob.theta; k sum(spectrum(thetaIndex, :))];
        eegDataBlob.alpha = [eegDataBlob.alpha; k sum(spectrum(alphaIndex, :))];
        eegDataBlob.beta  = [eegDataBlob.beta;  k sum(spectrum(betaIndex, :))];
        eegDataBlob.gamma = [eegDataBlob.gamma; k sum(spectrum(gammaIndex, :))];
        eegDataBlob.tot   = [eegDataBlob.tot;   k sum(spectrum(totIndex, :))];
    end
        

    
    averageAlphaPowerByChannel = mean(eegDataBlob.alpha(:,2:15));
    
    % Harmon-Jones: Asymmetry indices defined as log right minus log left
    % alpha power. He does not state the log used, so we go with log10:
    
    leftAlpha  = averageAlphaPowerByChannel(1:7);
    rightAlpha = averageAlphaPowerByChannel(14:-1:8);  % Trick to reverse order of channels!
    
    AIS = log(rightAlpha)./log(logbase) - log(leftAlpha)./log(logbase);
end

% REFERENCES:
%
% Harmon-Jones, E. (2006). Unilateral right?hand contractions cause
% contralateral alpha power suppression and approach motivational affective
% experience. Psychophysiology, 43(6), 598-603.
%
% Allen, J. J., Coan, J. A., & Nazarian, M. (2004). Issues and assumptions
% on the road from raw signals to metrics of frontal EEG asymmetry in
% emotion. Biological psychology, 67(1), 183-218.
    
   
end