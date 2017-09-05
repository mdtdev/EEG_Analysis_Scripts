function outBlock = EEGBandProportionBlock(waves, Fs)

% EEGBandProportionBlock.m
%
% Calls EEGBandProportions.m to get the spectral power proportions, then
% arranges the results into a matrix, where each COLUMN is one of (in
% order) delta, theta, alpha, and then Beta; and each ROW is the porportion
% for the corresponding spectral range for a given CHANNEL. Order of input
% data is preserved.
%
% MDT
% 2017.09.04

    % Spectral ranges: delta, theta, alpha, beta (in order)
    
    [d, t, a, b] = EEGBandProportions(waves, Fs);
    
    % Each vector is size 1, 14 (1 row, 14 columns), so transpose and
    % combine:
    
    outBlock = horzcat(d', t', a', b');
end
