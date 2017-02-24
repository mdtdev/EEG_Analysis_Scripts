function T = sepa_zSiteHiLoCompare(eegBlob)

[zHi zLo] = sepa_subjectNormalizedSiteScores(eegBlob);

electrode_names = {'AF3', 'F7', 'F3', 'FC5', 'T7', 'P7', ...
                    'O1', 'O2', 'P8', 'T8', 'FC6', 'F4', 'F8', 'AF4'};

T = table(electrode_names', zHi', zLo', 'VariableNames', ...
                            {'Site', 'HighAlphaZ', 'LowAlphaZ'});
end