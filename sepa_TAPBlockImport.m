function sepa_TAPBlockImport(files, outfile)

% sepa_TAPBlockImport(files, outfile)
%
% Imports a block of files in the required format for the "TAP"
% experiments. Uses the sepa_parrottImport.m function to resolve markers
% and pre-process data. Uses a dir() object as input! (Will break on a list
% or some other format.
%
% MDT
% 2017.02.20
% 0.0.1

    fid = fopen(outfile,'w');
    for file = files'
        % Subject and condition data:
        cleanname = regexprep(file.name, '\.edf|\.set$','');
        namelist  = strsplit(cleanname, '-');
        subnum    = regexprep(namelist{1}, '^SUB|sub|Sub','');
        eyeorder  = namelist{2};
        seqorder  = namelist{3};
        % Data analysis to get AIS's:
        x = sepa_parrottImport(file.name);
        % Write the "obvious" data to the file
        fprintf(fid, '%s,%s,%s,%s,', subnum, seqorder, eyeorder, file.name);
        fprintf(fid, '%f,%f,%f,%f,%f,%f,%f,', x{3});  % Open
        fprintf(fid, '%f,%f,%f,%f,%f,%f,%f,', x{4});  % Closed
        % Also the averages:
        avgx = (x{3} + x{4})./2;
        fprintf(fid, '%f,%f,%f,%f,%f,%f,%f\n', avgx); % Average
    end
    fclose(fid);
    fclose('all');     % Testing to fix the matlab open file bug!
end

