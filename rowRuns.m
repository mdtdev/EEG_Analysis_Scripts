function [runLengths, countMatrix] = rowRuns(binaryMatrix)

% Simple program to blackbox the run counter from: 
%
% https://www.mathworks.com/matlabcentral/answers/96982-how-can-i-find-run-length-consecutive-ones-and-zeros-and-their-occurrence-times-in-a-binary-sequence
%
% MDT
% 2017.10.30

    numRows = size(binaryMatrix, 1);
    numCols = size(binaryMatrix, 2);
    
    countMatrix = zeros(2,2);
    for row = 1:numRows
        es    = sprintf('%d',binaryMatrix(row,:));
        tcell = textscan(es, '%s', 'delimiter', '0', 'multipleDelimsAsOne', 1);
        ed = tcell{:};
        for k = 1:length(ed)
            data(k) = length(ed{k});
        end
        [number_times run_length] = hist(data, [1:max(data)]);
        for ii = 1:length(run_length)
            countMatrix(row, run_length(ii)) = number_times(ii);
        end
    end
    runLengths = 1:size(countMatrix, 2);
end
