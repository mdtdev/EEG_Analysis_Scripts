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
        freqBlock = EEGBandProportionBlock(data(:,startWindow:endWindow), Fs);
        freqMeans = mean(freqBlock);
        
        
        
    end
    
    
    startpoints=1:m:len;
    avpByChannel = [];%array that stores avp values
    avpByLobeFL_PL=[];
    avpByLobeFR_PR=[];
    for channel = 1:14
        vp= [];
        for k = startpoints(1:end-1)
            b = bandpower(data(channel, k:(k+m)),Fs,[8 13])/ bandpower(data(channel, k:(k+m)), Fs, [1 41]); % gives you the alpha power per file
            vp=[vp b];
        end
        avp = mean(vp); % finds the mean of the alpha power per file ( I need to section to per channel and put into new variable aavp)
        avpByChannel = [avpByChannel avp];
           
    end
    averageavp = mean(avpByChannel);
   
    fprintf(fileID,'%s\t%g\t%g\t%g\n',filename,FL,avgelectrodes,time);
    fprintf(fileID,'%s\t%g\t%g\t%g\n',filename,PL,avgelectrodes,time);
    fprintf(fileID,'%s\t%g\t%g\t%g\n',filename,FR,avgelectrodes,time);
    fprintf(fileID,'%s\t%g\t%g\t%g\n',filename,PR,avgelectrodes,time);
end




fclose(fileID);

%fprintf(fileID,'filename\tlength(min)\tname\tvalue\n');
