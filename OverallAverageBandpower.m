%% Bandpower for Entire Run
%
% This program calculates the bandpower in chunks of n minutes
% (non-overlapping) for the entire run of a subject and reports the average
% of these measurements.
%
% MDT
% 2017-09-01

%% Setup and Constants
%
% Time and Frequency Constants:

Fs          = 128;              % Samples per Second of the EEG System
oneMinute   = 60 * Fs;          % Samples in 1 minute (60*128)
n           = 2;                % Number of minutes to use for FFT window
windowLen   = n * oneMinute;

% Other Constants:

numChannels = 14;
channels    = 1:numChannels;

%% Three Nested Loops





%% Auxillary Functions
%
% To make the code easier to read, we sometimes define "functions" to
% encapsulate bits of our work.

function [deltaP, thetaP, alphaP, betaP] = bandProportions(wave, Fs)

% bandProportions.m
%
% Computes the power in each band, then converts these to proportions.

    bandDelta = [ 1  4];    % Due to filtering, everything < 1 Hz ~0
    bandTheta = [ 4  8];
    bandAlpha = [ 8 14];    % Wikipedia's alpha (Electroencphalography Article)
    bandBeta  = [14 31];
    
    deltaP = bandpower(wave, Fs,bandDelta) ./ bandpower(d(channel, k:(k+m)), Fs, [1 41]);


end





%Bandpower Loop
listOfFiles = dir('*.set');
numberOfFiles = length(listOfFiles);

for jj = 1:numberOfFiles
    f = listOfFiles(jj).name; %list of names
    x = pop_loadset(f); %loads data
    len =x.pnts;
    d=x.data;
    startpoints=1:m:len;
    vp= [];
    for k= startpoints(1:end-1);
        b=bandpower(d(channel, k:(k+m)),Fs,[8 13])/ bandpower(d(channel, k:(k+m)), Fs, [1 41]);
        vp=[vp b]
    end
    k= startpoints(1:end-1);
    b=bandpower(d(channel, k:(k+m)),Fs,[8 13])/ bandpower(d(channel, k:(k+m)), Fs, [1 41]);
    vp=[vp b]
    %plot(vp)
    avp = mean(vp)
    pause
end

%printing files
for s= 1:numberOfFiles
f= listOfFiles(s).name;
EEG=pop_loadset(f);
len=EEG.pnts;
r=(len/128)/60;
fprintf('%s\t %g \n', f, r);
end

