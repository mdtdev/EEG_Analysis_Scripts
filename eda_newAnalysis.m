%% Analysis (Demo)
%
% New analysis for moving averages of all spectra

%% Setup
%
% Constants
Fs         = 128;
windowSize = 2*60*Fs;   % 2 minutes of data are one window
overlapP   = 0.25;
channels   = 1:14;      % Emotiv EEG has 14 channels
resultFile = 'moving_averages.txt';

% Inputs
listOfFiles   = dir('*.set');
numberOfFiles = length(listOfFiles);

% Outputs
fileID = fopen(resultFile,'wt');

% Header for TSV/CSV
fprintf(fileID,'filename\tlength(min)\tname\tvalue\n');


%% Analysis
%

for ff = 1:numberOfFiles
    filename = listOfFiles(ff).name;
    EEGDF    = pop_loadset(filename);   % Load EEG Data Frame (EEGDF)
    len      = EEGDF.pnts; 
    time     = (len/128)/60;            % time in human format (minutes)
    data     = EEGDF.data;
    endPoint = size(data,2)             % Last sample in file
    
    startWindow = 1;
    endWindow   = startWindow + windowSize;
    
    
    while endWindow < endPoint
        
        % This returns the power in each frequency range for each channel
        % in a matrix with rows for channels and columns for bands in the
        % column order delta theta alpha beta.
        freqBlock = EEGBandProportionBlock(data(:,startWindow:endWindow), Fs);
        
        % Now we make a derived quantity. For example, this averages for
        % each band across channels (do it interactively to see!)
        freqMeans = mean(freqBlock);
        
        % Write the data to file -- needs to be changed for each derived
        % quantity
        bandNames = ["delta", "theta", "alpha", "beta"]
        for kk = 1:4
            fprintf(fileID,'%s\t%g\t%s\t%g\n', filename, time, bandNames(kk), freqMeans(kk));
        end
        startWindow = startWindow + ceil((1 - overlapP)*windowSize);
    end
end

fclose(fileID);