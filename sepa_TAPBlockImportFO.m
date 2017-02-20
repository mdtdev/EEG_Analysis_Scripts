function sepa_TAPBlockImportFO(files, outfile)

% sepa_TAPBlockImportFO(files, outfile)
%
% Imports a block of files in the required format for the "TAP"
% experiments. Uses the sepa_parrottImport.m function to resolve markers
% and pre-process data. Uses a dir() object as input! (Will break on a list
% or some other format.
%
% The FO version of this code only returns the averages and values
% associated with the frontal electrode pairs F3-F4 and FC5-FC6.
%
% MDT
% 2017.02.20
% 0.0.1

    fid = fopen(outfile,'w');
    
    fprintf(fid, 'subject,seqorder,eyeorder,openF34,openFC56,closedF34,closedFC56,avgF34,avgFC56\n');
    
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
        fprintf(fid, '%s,%s,%s,', subnum, seqorder, eyeorder);
        fprintf(fid, '%f,%f,', x{3}(3:4));  % Open
        fprintf(fid, '%f,%f,', x{4}(3:4));  % Closed
        % Also the averages:
        avgx = (x{3} + x{4})./2;
        fprintf(fid, '%f,%f\n', avgx(3:4)); % Average
    end
    fclose(fid);
    fclose('all');     % Testing to fix the matlab open file bug!
end

