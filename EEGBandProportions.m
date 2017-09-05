function [deltaP, thetaP, alphaP, betaP] = EEGBandProportions(wave, Fs)

% EEGBandProportions.m
%
% Computes the power in each band, then converts these to proportions. This
% function can take in one vector which causes it to return just 4 scalar
% valeus (proportions for delta, theta, alpha, and beta) or it can be
% called with multiple vectors of data (one per electrode) in the format
% where each row is a waveform for a channel and each column is a time
% point. (Internally, EEGBandProportions rotates this matrix -- do not do
% this to the input!)
%
% MDT
% 2017.09.04

    bandDelta = [ 1  4];    % Due to filtering, everything < 1 Hz ~0
    bandTheta = [ 4  8];
    bandAlpha = [ 8 14];    % Wikipedia's alpha (Electroencphalography Article)
    bandBeta  = [14 31];
    bandAll   = [ 1 31];
    
    wave = wave';
    
    deltaP = bandpower(wave, Fs, bandDelta) ./ bandpower(wave, Fs, bandAll);
    thetaP = bandpower(wave, Fs, bandTheta) ./ bandpower(wave, Fs, bandAll);
    alphaP = bandpower(wave, Fs, bandAlpha) ./ bandpower(wave, Fs, bandAll);
    betaP  = bandpower(wave, Fs, bandBeta)  ./ bandpower(wave, Fs, bandAll);
end
