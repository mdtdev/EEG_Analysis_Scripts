function [zHi, zLo] = sepa_handContractionZ(filename)

% AIS = sepa_handContractionZ(filename)
%
% Imports a single TAP file and computes the alpha asymmetry scores.
% Designed to be called from a wrapper function like sepa_TAPBlockImport.m.
%
% MDT
% 2017.02.27
% 0.0.1 ALPHA

    lowerBound  = 1;
    upperBound  = 41;
    eegChannels = 3:16;
    
    % The file in loaded (or imported) and a "derived" data set is made
    %    that contains the EEG data only.  The original data with markers
    %    is in EEG2; the selected/filtered data is in EEG_only.

    if regexp(filename,'set$')
        EEG = pop_loadset(filename);
    elseif regexp(filename,'edf$')
        EEG = pop_biosig(filename);
    else
        error('sepa_parrotImportZ: File type unknown!');
    end

    EEG_only = pop_select(EEG, 'channel', eegChannels);
    EEG_only = pop_eegfilt(EEG_only, lowerBound, upperBound, [], [0], 0, 0, 'fir1', 0);

    % Make the blocks of selected/filtered data:
    
    for m = 3:5
        ss      = ge_getSampleBounds(EEG, m);     % Bounds from EEG2
        data{m} = EEG_only.data(:,ss(1):ss(2));   % Data from EEG_only
    end

    % Do the analysis to each block:
    
    blob.Fs = 128;
    for ii  = 3:5
        blob.data          = data{ii}';
        [zHi{ii}, zLo{ii}] = sepa_subjectNormalizedSiteScores(blob);
    end
end