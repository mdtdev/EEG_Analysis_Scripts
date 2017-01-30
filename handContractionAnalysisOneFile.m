function AIS = handContractionAnalysisOneFile(filename, refMode)
% AIS = handContractionAnalysisOneFile(filename, refMode)
%
% General function for importing data from DHB's collection of hand
% contraction asymmetry data. This version takes a flag for re-referencing
% modes. It allows: 'none' (default reference); 'car' (common average
% reference or CAR); 'robcar' (robust CAR or spectral transformed CAR); and
% 'rest' for Yao's REST (reference electrode standardization technique or
% approximate infinity reference). The default is 'none'.
%
% MDT
% 2017.01.30 (alpha)

    % Deal with missing parameters from the call!

    if nargin < 2
        refMode = 'none';
    end
    
    % Setup

    lowerBound  = 1;        % New standard frequency as of 2017.01
    upperBound  = 41;
    eegChannels = 3:16;
    
    % Deal with different file formats; for this research we are usually
    % expecting to see SET files.
    
    if regexp(filename,'set$')
        EEG = pop_loadset(filename);
    elseif regexp(filename,'edf$')
        EEG = pop_biosig(filename);
    else
        error('handContractionAnalysisOneFile: File type unknown, no SET or EDF');
    end
    
    % This section does the import and pre-processing steps, following
    % Luck's advice from his ERP book, see the link:
    % http://www.erpinfo.org/order-of-processing-steps.html for more
    % details of the procedure. Here we do the following in order:
    %
    %   1. High- and Low-pass filter the data (as a bandpass)
    %   2. Re-reference the data
    
    % Select and Filter
    EEG_only = pop_select(EEG, 'channel', eegChannels);
    EEG_only = pop_eegfilt(EEG_only, lowerBound, upperBound, [], [0], 0, 0, 'fir1', 0);
    
    % Re-reference
    if strcmp(refMode, 'car')
        EEG_only = pop_reref(EEG_only, []);             % eeglab's CAR
    elseif strcmp(refMode, 'rest')
        EEG_only      = pop_reref(EEG_only, []);
        EEG_only.data = RESTreference(EEG_only.data);   % Yao's REST
    elseif strcmp(refMode, 'robcar')
        error('handContractionAnalysisOneFile: robcar not implemented yet!');
    elseif strcmp(refMode, 'none')
        warning('handContractionAnalysisOneFile: No re-referencing done.');
    else
        error('handContractionAnalysisOneFile: Problem with reference specification.');
    end
    
    % Chop the EEG data at the markers (inclusive)
    for m = 3:5
        ss      = ge_getSampleBounds(EEG, m);
        data{m} = EEG_only.data(:,ss(1):ss(2));
    end

    blob.Fs = 128;

    % Do the asymmetry score calculation
    for ii = 3:5
        blob.data = data{ii}';
        AIS{ii}   = averageAlphaPowerByChannel(blob);
    end
    
end