function AIS = sepa_handContraction(filename)

% AIS = sepa_handContraction(filename)
%
% Version of the calculations for the alpha asymmetry research for SEPA
% 2017 meeting. This is temporary and will be replaced by better, more
% validated code after the meeting.
%
% MDT
% 2017.02.16


    lowerBound  = 1;        % Keep filter bounds outside of the EEG 
    upperBound  = 41;       %    frequencies of interest (2-40 Hz)
    eegChannels = 3:16;
    
    if regexp(filename,'set$')
        EEG = pop_loadset(filename);
    elseif regexp(filename,'edf$')
        EEG = pop_biosig(filename);
    else
        error('sepa_handContraction: File type unknown');
    end
    
    EEG_only = pop_select(EEG, 'channel', eegChannels);
    EEG_only = pop_eegfilt(EEG_only, lowerBound, upperBound, [], [0], 0, 0, 'fir1', 0);
    
    for m = 3:5
        ss      = ge_getSampleBounds(EEG, m);
        data{m} = EEG_only.data(:,ss(1):ss(2));
    end

    blob.Fs = 128;

    for ii = 3:5
        blob.data = data{ii}';
        AIS{ii}   = sepa_alphaAsymmetry(blob);
    end
end