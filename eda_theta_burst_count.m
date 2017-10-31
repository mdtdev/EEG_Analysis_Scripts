%% Theta burst counter:
%
% Slide along the waveform doing the FFT. At each time point find the
% (first) maximum in the power spectrum, then get the frequency index for
% this. Make a list of these.
%
% Go into the list and find the values in the theta range. Look for runs
% and count these.

% See: https://www.mathworks.com/matlabcentral/answers/81374-counting-the-number-of-runs-in-a-sequence
% for counts only, and the function rowRuns.m for the count by runlength
% matrix!

    Fs         =  128;              % Sampling Frequency
    windowTime =    2;              % Window length in SECONDS
    m          = windowTime * Fs;   % Window length in samples
    overlap    =    0.0;           % Proportion of overlap

    f= '1031-session8_filtEEG.set';

    x   = pop_loadset(f);       % Load the data structure into x
    len = x.pnts;               % Number of samples in whole experiment
    r   = (len/Fs)/60;          % Convert samples to minutes
    d   = x.data;               % Pull voltage data into d

    Mwidth  = floor(len/((1-overlap)*m) - 1); % This may be 1 column short!
    vt      = zeros(1, Mwidth);
    PM      = zeros(14, Mwidth);

    s = 1;
    k = 1;
    while s + m < len
        [avgPwrSpec, freqAxis, ~] = averagePowerSpectrum(d(:, s:(s+m))', Fs, windowTime, 0);  % Overlap is two things in this code!!
        [M,i] = max(avgPwrSpec);
        winner = freqAxis(i)';
        
        t = (s/128);
        PM(:, k) = winner;
        vt(k) = t;
        k = k + 1;
        s = s + ceil((1-overlap)*m); 
    end

%% Produces PM a matrix of peak frequencies

thetaRuns = (PM >= 4) & (PM < 8);   % thresholds theta peaks

[lengths, counts] = rowRuns(thetaRuns);

figure; 
hold on; 
for iii = 1:14 
    plot(lengths(1:end), counts(iii,1:end));
end
title(f);
hold off;

% Average bursts per minute, by channel:

sum(counts,2)./r
