%% Final Figures for SEPA Talk
%
% MDT
% 2017.03.01

%% Load Data for Graphics
%
% The code below will work for any file loaded in the first step. The
% original file used was: '702-S6-L-P-15.07.2016.14.40.57.set' in case that
% gets lost in working!

EEG      = pop_loadset('702-S6-L-P-15.07.2016.14.40.57.set');

% Process and extract relevant data:

EEG_only = pop_select(EEG, 'channel', 3:16);
EEG_only = pop_eegfilt(EEG_only, 1, 41, [], [0], 0, 0, 'fir1', 0);

% For squeezing experiment, the resting recording is denoted with marker
% value 3, the action takes place during the interval marked with 4, and
% the post-recording part is 5.

preB  = ge_getSampleBounds(EEG, 3);
postB = ge_getSampleBounds(EEG, 5);

s704.Fs   = 128;
s704.pre  = EEG_only.data(1:14,  preB(1):preB(2))';
s704.post = EEG_only.data(1:14, postB(1):postB(2))';

%% Graphics and Smoothing parameters
%

duration = 4;
overlap  = 0.25;
lw       = 2;               % Default Linewidth for Printing
ltgray   = [0.75 0.75 0.75];

%% Average versus Raw Spectra Plot
%
% The first plot shows what an average spectrum looks like compared to the
% raw data that it is made from. This is a resting spectrum.

[aps, freq, stac] = averagePowerSpectrum(s704.pre, s704.Fs, duration, overlap);

pc = 3;  % Plot the 3rd channel (F3)

f1 = figure;
h = plotColumns(freq, stac(:, pc, :), {'r','g','b','c'});
for ii = 1:length(h)
    set(h(ii), 'color', ltgray);
end
hold on;
h2 = plot(freq, aps(:, pc), 'r', 'LineWidth', lw);
xlabel('\fontsize{18}Frequency (Hz)');
ylabel('\fontsize{18}Power');
title('\fontsize{20}Power Spectra for F3 (Left) Site');
legend([h2, h(2)], {'Average Spectrum', 'Individual Spectrum'}, 'FontSize', 14, 'FontWeight', 'bold');

% Save figure and report number of intervals that went into it

filename = 'sepa_AverageVsRawSpectra.png';
x        = size(stac);
saveas(gcf, filename);
fprintf(['\nPlot ', filename, ' is the result of  ', num2str(x(3), '%d'), ' intervals.\n']);

%% "Thin" Spectrum Plot
%

f1 = figure;
h = plotColumns(freq, stac(:, pc, 25:28), {'r','g','b','c'});
xlabel('\fontsize{18}Frequency (Hz)');
ylabel('\fontsize{18}Power');
title('\fontsize{20}Power Spectra for F3 (Left) Site');
saveas(gcf, 'sepa_thin_spectra.png');

%% Asymmetry at Rest Plot
%
% This plot shows the right and left averages at rest. There is a clear
% asymmetry visible.

[aps, freq, stac] = averagePowerSpectrum(s704.pre, s704.Fs, duration, overlap);

f2 = figure;
h2 = plot(freq, aps(:, 12), 'g', 'LineWidth', lw);  % F4 (Channel 12)
hold on;
h1 = plot(freq, aps(:, 3),  'r', 'LineWidth', lw);  % F3 (Channel 3)
ylim([0 600]);
xlabel('\fontsize{18}Frequency (Hz)');
ylabel('\fontsize{18}Power');
title('\fontsize{20}Average Spectrum Left vs Right at Rest (S704)');
legend([h1 h2], {'F3 (Left)', 'F4 (Right)'}, 'FontSize', 14, 'FontWeight', 'bold');

% Set the alpha highlight:

pkgray   = [0.92 0.92 0.92];
p1 = patch([8 13 13 8],[0 0 599 599], pkgray);
set(p1, 'EdgeColor', 'none');
set(gca,'children',flipud(get(gca,'children')))

% Save figure and report number of intervals that went into it

filename = 'sepa_RestingLeftVsRightWithPatch.png';
x        = size(stac);
saveas(gcf, filename);
fprintf(['\nPlot ', filename, ' is the result of  ', num2str(x(3), '%d'), ' intervals.\n']);

%% Different Subject (with Greater Asymmetry)
%
EEG      = pop_loadset('sub034-oc-before-21.10.16.13.21.00.set');
EEG_only = pop_select(EEG, 'channel', 3:16);
EEG_only = pop_eegfilt(EEG_only, 1, 41, [], [0], 0, 0, 'fir1', 0);
ge_makeEventList(EEG)
s34tap.opendata   = EEG_only.data(1:14, 938:18580)';
s34tap.closeddata = EEG_only.data(1:14, 21115:39114)';
s34tap.Fs         = 128;

% Obtain all the power spectra and their average:
[apsOpen, freqOpen, stacOpen] = averagePowerSpectrum(s34tap.opendata, s34tap.Fs, duration, overlap);
% Comparison figure:
figure; 
h1 = plot(freqOpen, apsOpen(:, 3), 'r', 'LineWidth', lw);
xlabel('\fontsize{18}Frequency (Hz)');
ylabel('\fontsize{18}Power (Square Units)');
hold on;
h2 = plot(freqOpen, apsOpen(:, 12), 'g', 'LineWidth', lw);
legend([h1, h2], {'F3 Average Power Spectrum', 'F4 Average Power Spectrum'}, 'FontSize', 14);
title('\fontsize{20}Averages for F3/F4 Sites (Original Data; S34)');
p1 = patch([8 13 13 8],[0 0 799 799], pkgray)
set(p1, 'EdgeColor', 'none');
set(gca,'children',flipud(get(gca,'children')))
% Save as a file:
filename = 'sepa_AltSubjRestWithPatch.png';
x        = size(stac);
saveas(gcf, filename);
fprintf(['\nPlot ', filename, ' is the result of  ', num2str(x(3), '%d'), ' intervals.\n']);


























%% Stopped here!

[aps, freq, stac] = averagePowerSpectrum(s704.pre, s704.Fs, duration, overlap);

f1 = figure;
h = plotColumns(freq, stac(:, 4, :), {'c'});
for ii = 1:length(h)
    set(h(ii),'color',[0.75 0.75 0.75]);
end
hold on;
h2 = plot(freq, aps(:, 4), 'r', 'LineWidth', 4);
xlabel('\fontsize{14}Frequency (Hz)');
ylabel('\fontsize{14}Power (Square Units)');
title('\fontsize{20}Power Spectra for F4 (Right) Site - Before L Squeezing');
legend([h2, h(2)], {'Average Spectrum', 'Individual Spectrum'}, 'FontSize', 14, 'FontWeight', 'bold');
ylim([0 1200]);
hline = refline([0 400]);
hline.Color = 'g';








% Pre Squeezing Plot

[aps, freq, stac] = averagePowerSpectrum(s704.pre, s704.Fs, duration, overlap);

f1 = figure;
h = plotColumns(freq, stac(:, 4, :), {'c'});
for ii = 1:length(h)
    set(h(ii),'color',[0.75 0.75 0.75]);
end
hold on;
h2 = plot(freq, aps(:, 4), 'r', 'LineWidth', 4);
xlabel('\fontsize{14}Frequency (Hz)');
ylabel('\fontsize{14}Power (Square Units)');
title('\fontsize{20}Power Spectra for F4 (Right) Site - Before L Squeezing');
legend([h2, h(2)], {'Average Spectrum', 'Individual Spectrum'}, 'FontSize', 14, 'FontWeight', 'bold');
ylim([0 1200]);
hline = refline([0 400]);
hline.Color = 'g';

% Post Squeezing Plot

[aps, freq, stac] = averagePowerSpectrum(s704.post, s704.Fs, duration, overlap);

f2 = figure;
h = plotColumns(freq, stac(:, 4, :), {'c'});
for ii = 1:length(h)
    set(h(ii),'color',[0.75 0.75 0.75]);
end
hold on;
h2 = plot(freq, aps(:, 4), 'b', 'LineWidth', 4);
xlabel('\fontsize{14}Frequency (Hz)');
ylabel('\fontsize{14}Power (Square Units)');
title('\fontsize{20}Power Spectra for F4 (Right) Site - AFTER L Squeezing');
legend([h2, h(2)], {'Average Spectrum', 'Individual Spectrum'}, 'FontSize', 14, 'FontWeight', 'bold');
ylim([0 1200]);
hline = refline([0 400]);
hline.Color = 'g';

length(freq)
% Difference Plot

[ apspre,  freq, ~] = averagePowerSpectrum(s704.pre, s704.Fs, duration, overlap);
[apspost,     ~, ~] = averagePowerSpectrum(s704.post, s704.Fs, duration, overlap);


f3 = figure;
h1 = plot(freq, apspre(:,  4), 'r', 'LineWidth', 4);
hold on;
h2 = plot(freq, apspost(:, 4), 'b', 'LineWidth', 4);
ylim([0 500]);
xlabel('\fontsize{14}Frequency (Hz)');
ylabel('\fontsize{14}Power (Square Units)');
title('\fontsize{20}Average Spectra Before versus After (Left) Squeezing');
legend([h1 h2], {'Average Spectrum (Before)', 'Average Spectrum (After)'}, 'FontSize', 14, 'FontWeight', 'bold');

% Zoom

f3 = figure;
h1 = plot(freq, apspre(:,  4), 'r', 'LineWidth', 4);
hold on;
h2 = plot(freq, apspost(:, 4), 'b', 'LineWidth', 4);
ylim([50 450]);
xlim([7 14]);
xlabel('\fontsize{14}Frequency (Hz)');
ylabel('\fontsize{14}Power (Square Units)');
title('\fontsize{20}Average Spectra Before versus After (Left) Squeezing');
legend([h1 h2], {'Average Spectrum (Before)', 'Average Spectrum (After)'}, 'FontSize', 14, 'FontWeight', 'bold');









