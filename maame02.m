



listOfFiles = dir('*.set');
numberOfFiles = length(listOfFiles);

for jj = 1:numberOfFiles
    f = listOfFiles(jj).name;
    EEG = pop_loadset(f);
    x = EEG.pnts;
    fprintf('%s \t %d \n', f, x);
end