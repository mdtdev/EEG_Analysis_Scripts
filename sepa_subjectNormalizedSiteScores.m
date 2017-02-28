function [zHi, zLo] = sepa_subjectNormalizedSiteScores(eegDataBlob, overlap, duration)

% [zHi zLo] = sepa_subjectNormalizedSiteScores(eegDataBlob, overlap, duration)
%
% Program to get the z-scores for alpha power at each electrode site,
% normalized across sites for a single subject. Returns a list of 14 z
% scores, ordered by site. Computes for both high and low alpha a la Smith
% et al. (2016) Neuropsychologia 85, 118-126.
%
% MDT
% 2017.02.23 ALPHA

    % Setup and Defaults:
    
    if nargin < 3
        duration = 4;       % Default 4 seconds per epoch
    end
    
    if nargin < 2
        overlap = 0.50;     % New setting for more smoothing for EPOC
    end

    % Obtain the average power spectrum:
    
    [aps, freq, ~] = averagePowerSpectrum(eegDataBlob.data, eegDataBlob.Fs, duration, overlap);
    
    % Pick out alpha power for each site
    
    hiAlphaIndex   = find(freq >  10 & freq <= 13);
    loAlphaIndex   = find(freq >=  8 & freq <= 10);
    siteHiAlphaPowers = sum(aps(hiAlphaIndex, :));
    siteLoAlphaPowers = sum(aps(loAlphaIndex, :));
    
    % Divide by sum of alpha power then z-score:
    
    zHi = zscore(siteHiAlphaPowers ./ sum(siteHiAlphaPowers));
    zLo = zscore(siteLoAlphaPowers ./ sum(siteLoAlphaPowers));
    
end

