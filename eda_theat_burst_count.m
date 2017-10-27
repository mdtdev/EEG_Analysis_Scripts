%% Theta burst counter:
%
% Slide along the waveform doing the FFT. At each time point find the
% (first) maximum in the power spectrum, then get the frequency index for
% this. Make a list of these.
%
% Go into the list and find the values in the theta range. Look for runs
% and count these.

    Fs         =  128;              % Sampling Frequency
    windowTime =    2;              % Window length in SECONDS
    m          = windowTime * Fs;   % Window length in samples
    overlap    =    0.50;           % Proportion of overlap

    f= '1005-session7_filtEEG.set';

    x   = pop_loadset(f);       % Load the data structure into x
    len = x.pnts;               % Number of samples in whole experiment
    r   = (len/Fs);          % Convert samples to seconds
    d   = x.data;               % Pull voltage data into d

    Mwidth = floor(len/((1-overlap)*m) - 1); % This may be 1 column short!

    vt     = zeros(1, Mwidth);
    Ma      = zeros(14, Mwidth);

    s = 1;
    k = 1;
    while s + m < len
        %ba = bandpower(d(channel, s:(s+m)),Fs,[8 13]) / bandpower(d(channel, s:(s+m)), Fs, [1 41]);
        [avgPwrSpec, freqAxis, ~] = averagePowerSpectrum(d(:, s:(s+m))', Fs, windowTime, 0);  % Overlap is two things in this code!!
        [M,i] = max(avgPwrSpec);
        winners = freqAxis(i)';
        
        t = (s/128);
        Ma(:, k) = winners;
        vt(k) = t;
        k = k + 1;
        s = s + ceil((1-overlap)*m); 
    end

%% Produces Ma sized 14x1749 of peak frequencies