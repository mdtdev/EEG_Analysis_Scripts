% Demonstration of a for loop for printing names of files
%
% MDT
% 2017-08-27

% Here is the dir() function, the glob, and its results stuck into a
% variable:

listOfFiles = dir('*.set');

% The "for" loop needs to know how many files. We know it is 40 for this
% case, but if we let MATLAB figure it out itself using the lentgh()
% function, it will AUTOMATICALLY adjust for any number of files:

numberOfFiles = length(listOfFiles);

% We want the loop to go from 1 to numberOfFiles (which is 40; chack it!)
% and for each file we want to display, using the disp() function the file
% name. Note that you do not need the disp() function to do this, but it
% makes the list look neater...

disp('Here is a simple for loop:');  % Note where this appears in the output

for j = 1:numberOfFiles
   disp(listOfFiles(j).name);
end

% Now here is a program to print out the file's name and the date of each
% file. Look at the entry for listOfFiles(1), say, to see what information
% is there. The fprintf() command (look in the MATLAB documentation for
% details, including why there are \n's all over the place) is an even
% better way to print things to the screen):

fprintf('\nHere is a slightly more complex for loop:\n\n');

for j = 1:numberOfFiles
   fprintf('%s \t %s \n', listOfFiles(j).name, listOfFiles(j).date);
end
