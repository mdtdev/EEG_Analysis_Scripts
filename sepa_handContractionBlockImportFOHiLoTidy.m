function sepa_handContractionBlockImportFOHiLoTidy(files, outfile)

% sepa_handContractionBlockImportFOHiLoTidy(files, outfile)
%
% Imports a block of files in the required format for Dom Parrott's "TAP"
% experiments and also for the hand contrraction study. Uses the
% sepa_parrottImport.m function to resolve markers and pre-process data.
% Uses a dir() object as input! (Will break on a list or some other format.
%
% The TIDY variant puts the data into the tidy format, see:
%
% https://www.jstatsoft.org/article/view/v059i10
%
% ...for more details.
%
% NB: Temporary file for SEPA 2017. 
%
% MDT
% 2016.06.13
% 2017.02.23
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
        [hi, lo] = sepa_handContractionHiLo(file.name);
        
        % Write the HI data to the file
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'high', 'pre',  'F34',  hi{3}(3));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'high', 'pre',  'FC56', hi{3}(4));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'high', 'post', 'F34',  hi{5}(3));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'high', 'post', 'FC56', hi{5}(4));
        
        % Write the LO data to the file
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'low', 'pre',  'F34',  lo{3}(3));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'low', 'pre',  'FC56', lo{3}(4));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'low', 'post', 'F34',  lo{5}(3));
        fprintf(fid, '%s,%s,%s,%s,%s,%s,%f\n',  subnum, sessionnumber, handorder, 'low', 'post', 'FC56', lo{5}(4));
        
    end
    
    fclose(fid);
    fclose('all');     % Testing to fix the matlab open file bug!
end