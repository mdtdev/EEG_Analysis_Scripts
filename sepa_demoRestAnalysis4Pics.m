% Attempt to make a small analysis and picture from a resting (eyes closed)
% segment in the "resting data" directory from the S drive
%
% MDT
% 2017.02.16

EEG           = pop_loadset('702-S3-C2_filtEEG.set');
s702s3c2.data = EEG.data';
s702s3c2.Fs   = 128;
s702s3c2      = ebThreshold(s702s3c2);                % Not used in main analysis?
s702s3c2.data = s702s3c2.data((8*128+1):(128*128),:); % Select out 2 minutes

size(s702s3c2.data)

duration = 4;
overlap  = 0.25;

[aps, freq, stac] = averagePowerSpectrum(s702s3c2.data, s702s3c2.Fs, duration, overlap);

% Plots

figure;
h = plotColumns(freq, stac(:, 3, :), {'c'});
for ii = 1:length(h)
    set(h(ii),'color',[0.75 0.75 0.75]);
end
hold on;
h2 = plot(freq, aps(:, 3), 'r', 'LineWidth', 4);
xlabel('\fontsize{14}Frequency (Hz)');
ylabel('\fontsize{14}Power (Square Units)');
title('\fontsize{20}Power Spectra for F3 Site');
legend([h2, h(2)], {'Average Spectrum', 'Individual Spectrum'}, 'FontSize', 14, 'FontWeight', 'bold');


figure;
subplot(2,1,1);
h = plotColumns(freq, stac(:, 3, :), {'c'});
for ii = 1:length(h)
    set(h(ii),'color',[0.75 0.75 0.75]);
end
hold on;
h2 = plot(freq, aps(:, 3), 'r', 'LineWidth', 4);
ylim([0,1800]);
xlabel('\fontsize{14}Frequency (Hz)');
ylabel('\fontsize{14}Power (Square Units)');
title('\fontsize{20}Power Spectra for F3 Site');
legend([h2, h(2)], {'Average Spectrum', 'Individual Spectrum'}, 'FontSize', 14, 'FontWeight', 'bold');
subplot(2,1,2);
h = plotColumns(freq, stac(:, 12, :), {'c'});
for ii = 1:length(h)
    set(h(ii),'color',[0.75 0.75 0.75]);
end
hold on;
h2 = plot(freq, aps(:, 12), 'b', 'LineWidth', 4);
ylim([0,1800]);
xlabel('\fontsize{14}Frequency (Hz)');
ylabel('\fontsize{14}Power (Square Units)');
title('\fontsize{20}Power Spectra for F4 Site');
legend([h2, h(2)], {'Average Spectrum', 'Individual Spectrum'}, 'FontSize', 14, 'FontWeight', 'bold');
