%% Analysis of some randomly chosen data from TAP: subject 34.
%
% MDT
% 2017.02.20

EEG      = pop_loadset('sub034-oc-after-21.10.16.13.58.15.set');
EEG_only = pop_select(EEG, 'channel', 3:16);
EEG_only = pop_eegfilt(EEG_only, 1, 41, [], [0], 0, 0, 'fir1', 0);

ge_makeEventList(EEG)

s34tap.opendata   = EEG_only.data(1:14, 938:18580)';
s34tap.closeddata = EEG_only.data(1:14, 21115:39114)';
s34tap.Fs = 128;

% Manual voltage thresholding as a test!

upperLimit = 200;
lowerLimit = -200; 

s34tap.opendatathresh = s34tap.opendata;
s34tap.opendatathresh(s34tap.opendatathresh > upperLimit) = upperLimit;
s34tap.opendatathresh(s34tap.opendatathresh < lowerLimit) = lowerLimit;

Fs = 128;
duration = 4;
overlap  = 0.25;

% Obtain all the power spectra and their average:

[apsOpen, freqOpen, stacOpen] = averagePowerSpectrum(s34tap.opendata, Fs, duration, overlap);
[apsOT, freqOT, stacOT] = averagePowerSpectrum(s34tap.opendatathresh, Fs, duration, overlap);

%% Plots
%
% The first thing to do is define some colors and readin electrode locations:

ltgray = [0.75 0.75 0.75];
pkgray = [0.90 0.90 0.90];


fid = fopen('emotiv_location_list.txt');
txt = textscan(fid,'%s','delimiter','\n');
electrode_names = txt{1};

% Compare averages:

% First for unthresholded data:

figure; 
h1 = plot(freqOpen, apsOpen(:, 4), 'r', 'LineWidth', 4);
xlabel('\fontsize{14}Frequency (Hz)');
ylabel('\fontsize{14}Power (Square Units)');
hold on;
h2 = plot(freqOpen, apsOpen(:, 11), 'g', 'LineWidth', 4);
legend([h1, h2], {'FC5 Average Power Spectrum', 'FC6 Average Power Spectrum'}, 'FontSize', 14);
title('\fontsize{20}Averages for FC5/6 Sites (Original Data)');
ylim([0, 900]);

% With Alpha region highlight:

figure; 
h1 = plot(freqOpen, apsOpen(:, 3), 'r', 'LineWidth', 4);
xlabel('\fontsize{14}Frequency (Hz)');
ylabel('\fontsize{14}Power (Square Units)');
hold on;
h2 = plot(freqOpen, apsOpen(:, 12), 'g', 'LineWidth', 4);
legend([h1, h2], {'F3 Average Power Spectrum', 'F4 Average Power Spectrum'}, 'FontSize', 14);
title('\fontsize{20}Averages for F3/F4 Sites (Original Data)');
p1 = patch([8 13 13 8],[0 0 798 798], pkgray)
set(p1, 'EdgeColor', 'none');
set(gca,'children',flipud(get(gca,'children')))


% Big chart of all channels

alt_chan = 14:-1:8;

figure;
subplot(2,4,1);

for ii = 1:7
    subplot(2,4,ii);
    h1 = plot(freqOpen, apsOpen(:, ii), 'r', 'LineWidth', 4);
    xlabel('\fontsize{14}Frequency (Hz)');
    ylabel('\fontsize{14}Power (Square Units)');
    hold on;
    h2 = plot(freqOpen, apsOpen(:, alt_chan(ii)), 'g', 'LineWidth', 4);
    legendInfo{1} = char(strcat(electrode_names(ii), ' Average Power Spectrum'));
    legendInfo{2} = char(strcat(electrode_names(alt_chan(ii)), ' Average Power Spectrum'));
    legend(legendInfo);
end
    









% Then thresholded:

figure; 
h1 = plot(freqOT, apsOT(:, 3), 'r', 'LineWidth', 4);
xlabel('\fontsize{14}Frequency (Hz)');
ylabel('\fontsize{14}Power (Square Units)');
hold on;
h2 = plot(freqOT, apsOT(:, 12), 'g', 'LineWidth', 4);
legend([h1, h2], {'F3 Average Power Spectrum', 'F4 Average Power Spectrum'}, 'FontSize', 14);
title('\fontsize{20}Averages for F3/F4 Sites (Thresholded Data)');





figure;
h = plotColumns(freqOpen, stacOpen(:, 3, :), {'c'});
for ii = 1:length(h)
    set(h(ii),'color',[0.75 0.75 0.75]);
end
hold on;
h2 = plot(freqOpen, apsOpen(:, 3), 'r', 'LineWidth', 4);
xlabel('\fontsize{14}Frequency (Hz)');
ylabel('\fontsize{14}Power (Square Units)');
title('\fontsize{20}Power Spectra for F3 Site');
legend([h2, h(2)], {'Average Spectrum', 'Individual Spectrum'}, 'FontSize', 14, 'FontWeight', 'bold');


figure;
subplot(2,1,1);
h = plotColumns(freqOpen, stacOpen(:, 3, :), {'c'});
for ii = 1:length(h)
    set(h(ii),'color',[0.75 0.75 0.75]);
end
hold on;
h2 = plot(freqOpen, apsOpen(:, 3), 'r', 'LineWidth', 4);
ylim([0,1800]);
xlabel('\fontsize{14}Frequency (Hz)');
ylabel('\fontsize{14}Power (Square Units)');
title('\fontsize{20}Power Spectra for F3 Site');
legend([h2, h(2)], {'Average Spectrum', 'Individual Spectrum'}, 'FontSize', 14, 'FontWeight', 'bold');
subplot(2,1,2);
h = plotColumns(freqOpen, stacOpen(:, 12, :), {'c'});
for ii = 1:length(h)
    set(h(ii),'color',[0.75 0.75 0.75]);
end
hold on;
h2 = plot(freqOpen, apsOpen(:, 12), 'b', 'LineWidth', 4);
ylim([0,1800]);
xlabel('\fontsize{14}Frequency (Hz)');
ylabel('\fontsize{14}Power (Square Units)');
title('\fontsize{20}Power Spectra for F4 Site');
legend([h2, h(2)], {'Average Spectrum', 'Individual Spectrum'}, 'FontSize', 14, 'FontWeight', 'bold');
