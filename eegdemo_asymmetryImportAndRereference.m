%% EEG Demos - Importing, arranging, and re-referencing Asymmetry Data
%
% This is a demo script for using the new functions for re-referencing,
% using these and the older tools in EEG Blocks.
%
% MDT
% 2016.09.20
% Version 0.1.0

fprintf('\n\n\nEEG DATA ANALYSIS DEMO: eegdemo_asymmetryImportAndRereference.m\n\n');

%% File Settings 
%
% The file used in this script is in the format used for the in-house
% squeezing exepriments--there are three intervals, labelled with markers
% 3, 4, and 5 (pre, during, and post; respectively). These markers appear
% at the start and also at the end of each block. Hopefully you can see
% from the examples given how to set up different markers for other
% experiments! (See below for more on this.)
%
% The demo file is **currently** located in:
%
% S:\Turner-Lab\EEG\Asymmetry\Data\Hand Contraction\Raw_data\not to be analyzed
% 
% You may copy but do not disturb the original!!!!!

filename = '702-S1-LO-19.05.2016.11.38.05.set'; % Or use your own data!

%% Extracting File Name Parts
%
% This next block of code extracts the subject name/code (subnum), the
% condition code (handorder; in this case), and the session number
% (sesnum). These could be other codes as well for different experiments.
% Note that the variable namelist will contain all the parts of the
% filename, in the ORDER USED that were separated by dashes ('-'). The last
% element will be the complex date/time code assigned by the Emotiv
% software. It is in namelist{4} but unused here.
%
% Most of the code in this block comes from the older version of the
% program: ge_handcontractionBlockImport.m see that file for details!

cleanname = regexprep(filename, '\.edf|\.set$','');
namelist  = strsplit(cleanname, '-');
subnum    = namelist{1};
handorder = namelist{3};
sesnum    = regexprep(namelist{2}, '^S', '');

%% Import and Filtering
%
% The example here is done for the "common average re-reference" (AVG/AVE
% in the literature). In other reference schemes, only the function that
% does th re-reference needs to be changed in the code just below here, if
% you want another reference scheme.
%
% Most of the code in this section comes from ge_handContraction.m.

lowerBound  = 2;        % These are frequencies for the filtering
upperBound  = 41;
eegChannels = 3:16;     % Emotiv EPOC/EPOC+ data channels in EDF

if regexp(filename,'set$')          % This code allows both SET/EDF as input
    EEG = pop_loadset(filename);
elseif regexp(filename,'edf$')
    EEG = pop_biosig(filename);
else
    error('eegdemo: File type unknown');
end

% Prints the marker table; for your reference, not important for the
% analysis! The fprintf()'s are just for formatting:

fprintf('\nHere are the "events" in the recording.\nMarker Table:\n\n');
disp(ge_makeEventList(EEG))
fprintf('\n');

% Select the data (dropping the signal quality, gyroscopic, and other
% channels) and then filter the data. Note that there are now two EEG data
% structures -- EEG and EEG_only. The former has all the channels including
% marker tracks and the latter has only the EEG channels:

EEG_only = pop_select(EEG, 'channel', eegChannels);
EEG_only = pop_eegfilt(EEG_only, lowerBound, upperBound, [], [0], 0, 0, 'fir1', 0);

% For each marker (3,4,5) get the corresponding block of EEG -- this is
% assuming that we are doing this without any manual selection of bounds.
% The block marked by 3's is the "pre" or "resting" data which we will use
% below. The other blocks could be used similarly. For that you would need
% a function here to insert hand-chosen boundary points. The data blocks
% are EACH stored inside the data structure called "data" -- at the command
% line type its name to see it. It will be a 1x5 "cell array" in Matlab
% terminology.

for m = 3:5
    ss      = ge_getSampleBounds(EEG, m);
    data{m} = EEG_only.data(:,ss(1):ss(2));
end

% Most functions that we write locally work with EEG Blocks, a collection
% of programs that consume data in a standard format (a blob) and, after
% transforming it, return the revised data in the same format. These
% functions are usually called in the form:
%
% outBlob = ebFunctionName(inBlob);
%
% Where inBlob is the data, as processed so far, and the outBlob is the
% data that results from the function application. Each blob, minimally,
% must have a value called Fs for the sampling rate and a value data tha
% hold the EEG data. The blobs may have many more values. For the
% re-referencing functions, these minimal two must be set. We create a blob
% for the 'pre' data block:

blob_pre.Fs = 128;
blob_pre.data = data{3};    % NB: data{1} and data{2} are empty--not used!

fprintf('\n\nHere is the data blob before re-referencing:\n\n');
blob_pre

%% Re-reference!
%
% Now we call the various re-referencing functions to re-reference the data
% in the blob. Here we do :

blob_pre = ebReRefAverage(blob_pre);
blob_pre = ebReRefEPOCParietal(blob_pre);

fprintf('\n\nAnd here it is after re-referencing:\n\n');
blob_pre
fprintf('\nNote that both the original and re-referenced data is saved.\n\n');

%% Plot the data
%
% This is just to finish the demo--at this point you could do anything you
% wanted with the re-referenced data.

figure;
subplot(3,1,1);
plot(blob_pre.data(2,100:500), 'b');
subplot(3,1,2);
plot(blob_pre.dataAveRef(2,100:500), 'b');
hold on
plot(blob_pre.data(2,100:500), 'r');
subplot(3,1,3);
plot(blob_pre.dataParietalRef(2,100:500), 'b');










