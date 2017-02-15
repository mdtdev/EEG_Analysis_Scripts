function [aps, freq, stac] = averagePowerSpectrum(TBC, Fs, duration, overlap)

% [aps, freq, stac] = averagePowerSpectrum(TBC, Fs, duration, overlap)
%
% This function takes a matrix representation of multiple time series (TBC)
% and returns a matrix (aps) with the AVERAGE power spectrum for each time
% series. It also returns the list of frequencies appearing in the average
% spectrum (freq). Finally it also returns the "stack" of individual
% spectra (a multi-page, matrix time series). The each individual spectrum
% in the stack are defined as a window (size: duration * Fs) that is moved
% along each time series (with some overlap). Because of this, the object
% stac is very large: (channels x "usable spectrum" x number of windows x
% double-precision number size).
%
% This function encapsulates a large part of the calculations for alpha
% asymmetry research without making any assumptions about parameters. So
% you have to specifically specify everything completely. Specifically the
% sampling frequency (Fs), duration of the sliding time window (duration;
% in seconds), and the overlap percentage (overlap; as a proportion, >= 0)
% must be fully specified. Note that the duration is converted to samples
% by the function.
%
% NB: I finally discovered why the code we got from Emotiv does time by
% channels, unlike the channels by time that everyone else seems to use. It
% is because MATLAB's base FFT function expects each time series to be in a
% column! WTF?
%
% MDT 
% 2017.02.15  ALPHA

    % Setup:
    %
    % Determine number of samples in a window, the frequencies, and the
    % "useful" part of the spectrum: from 2 to 40 Hz
    
    fftlength   = Fs * duration;                     % Length in number of samples
    f           = [128/fftlength:128/fftlength:128]; % All the frequencies
    usefulSpec  = find(f >=  2 & f <= 40);           % Indices of freqencies from 2 to 40 Hz
    stepSamples = ceil((1 - overlap)*fftlength);     % Step size for windows
    
    % Build a window to attenuate edge effects: Hanning (Does it matter?)
    
    hanning    = [1:fftlength]';
    hanning_in = 2*pi*(hanning - (fftlength+1)/2)/(fftlength+1);
    hanning    = (sin(hanning_in)./hanning_in).^2;
    hanning    = repmat(hanning, 1, 14);
    
    % Make the "stack" -- this is a tensor, or a multi-paged matrix. Each
    % page is a set of spectra returned from fft() in the spectrum by
    % channels format. Note that the:
    %
    % length(fftlength:stepSamples:size(TBC,1)) 
    %
    % line is there because I keep having a fence error and being off by 1;
    % I do not want to arbitrarily remove 1 from: 
    %
    % (size(TBC,1) - mod(size(TBC,1), stepSamples))/ stepSamples
    %
    % which seems like it is the right calculation.

    stac = zeros(length(usefulSpec), size(TBC, 2), length(fftlength:stepSamples:size(TBC,1)));
    
    % Calculate the individual spectra    
    
    page = 1;
    for k = fftlength:stepSamples:size(TBC,1)
        spectrum  = fft(TBC(k - fftlength + 1:k, :) .* hanning);
        spectrum  = sqrt(spectrum .* conj(spectrum));
        stac(:, :, page) = spectrum(usefulSpec, :);
        page = page + 1;
    end
    
    freq = f(usefulSpec);
    aps   = mean(stac,3);
    
end

