ls
EDB.Fs = 128;
EDB.data = EEG.data';
EDB
help averagePowerSpectrum
[avgS, eegFreqs, pileOfSpectra] = averagePowerSpectrum(EDB.data, EDB.Fs, 4, 0.250);
plotColumns(eegFreqs, pileOfSpectra(:,1,:))
hold on
[avgS, eegFreqs, pileOfSpectra] = averagePowerSpectrum(EDB.data, EDB.Fs, 8, 0.250);
hold off
close all
plotColumns(eegFreqs, pileOfSpectra(:,1,:))
hold on
plot(eegFreqs, avgS, 'r', 'lineWidth', 4);
close all
plotColumns(eegFreqs, pileOfSpectra(:,1,:))
plot(eegFreqs, avgS(:, 1), 'r', 'lineWidth', 2);
plot(eegFreqs, avgS(:, 14), 'g', 'lineWidth', 2);
close all
plotColumns(eegFreqs, pileOfSpectra(:,3,:))
hold on
plot(eegFreqs, avgS(:, 3), 'r', 'lineWidth', 2);
plot(eegFreqs, avgS(:, 12), 'g', 'lineWidth', 2);
figure;
plot(eegFreqs, avgS(:, 4), 'r', 'lineWidth', 2);
hold on
plot(eegFreqs, avgS(:, 11), 'g', 'lineWidth', 2);
close all

figure;
plot(eegFreqs, avgS(:, 3), 'r', 'lineWidth', 2);
hold on
plot(eegFreqs, avgS(:, 12), 'g', 'lineWidth', 2);
title('F34');
xlabel('Frequency');
ylabel('Power (Square Units)');



figure;
plot(eegFreqs, avgS(:, 4), 'r', 'lineWidth', 2);
hold on
plot(eegFreqs, avgS(:, 11), 'g', 'lineWidth', 2);
title('FC56');
xlabel('Frequency');
ylabel('Power (Square Units)');