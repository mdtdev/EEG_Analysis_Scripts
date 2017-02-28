function sepa_handContractionBlockImportZ(files, outfile)

% sepa_handContractionBlockImportZ(files, outfile)
%
% Imports a block of files in the required format for Dom Parrott's "TAP"
% experiments (extended to hand contractions with 3 markers!) and also for
% the hand contrraction study. Uses the sepa_handContractionZ.m function to
% resolve markers and pre-process data. Uses a dir() object as input! (Will
% break on a list or some other format.
%
% This version uses the z scores for each site.
%
% NB: Temporary file for SEPA 2017. 
%
% MDT
% 2017.02.27
% 0.0.1
% ALPHA

    fid = fopen(outfile,'w');

    % CSV Header Line
    fprintf(fid, 'subject,session,hand,alpharange,order,location,score\n');
    
    for file = files'
        file.name
        
        % Subject and condition data:
        cleanname      = regexprep(file.name, '\.edf|\.set$','');
        namelist       = strsplit(cleanname, '-');
        subnum         = namelist{1};
        handorder      = namelist{3};
        sessionnumber  = regexprep(namelist{2}, '^S', '');
        
        % Data analysis to get AIS's:
        [hi, lo] = sepa_parrotImportZ(file.name);
        
        % Write the HI data to the file
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'high', 'pre',  'F3',  hi{3}(3));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'high', 'pre',  'FC5', hi{3}(4));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'high', 'pre',  'F4',  hi{3}(12));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'high', 'pre',  'FC6', hi{3}(11));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'high', 'post', 'F3',  hi{5}(3));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'high', 'post', 'FC5', hi{5}(4));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'high', 'post', 'F4',  hi{5}(12));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'high', 'post', 'FC6', hi{5}(11));
        
        % Write the LO data to the file
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'low', 'pre',  'F3',  lo{3}(3));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'low', 'pre',  'FC5', lo{3}(4));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'low', 'pre',  'F4',  lo{3}(12));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'low', 'pre',  'FC6', lo{3}(11));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'low', 'post', 'F3',  lo{5}(3));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'low', 'post', 'FC5', lo{5}(4));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'low', 'post', 'F4',  lo{5}(12));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'low', 'post', 'FC6', lo{5}(11));
    end
    
    fclose(fid);
    fclose('all');     % Testing to fix the matlab open file bug!

end