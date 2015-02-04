function create_new_m_function(functionName)
% CREATE_NEW_M_FUNCTION Creates a new m-file with proper help layout
%
% create_new_m_function(functionName)
%
% INPUT ARGUMENTS
% functionName      - Name of the new function. CREATE_NEW_M_FUNCTION will 
%                     check that the function name has not been used yet, 
%                     and it will ask for additional input.
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% N/A

% Copyright (c) 2011 Daniel Forsberg
% danne.forsberg@outlook.com
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%% CHECK INPUT

% if no input argument, assign empty to functionname
if nargin < 1 || isempty(functionName) || ~ischar(functionName)
    functionName = [];
end

% check whether function already exists - only if given as input
if ~isempty(functionName)
    functionCheck = which(functionName);
    if ~isempty(functionCheck)
        error('%s already exists: %s',functionName,functionCheck)
    end
end

%% GATHER DATA

% data-gathering stage begins below
% getenv() and version are used to derive environmental variables

% ask for the rest of the input with inputdlg

% set up inputdlg
inPrompt = {'Function name',...
    'Synopsis: ''[output1, output2] = functionname(input1, input2)',...
    'Description: ''FUNCTIONNAME does ...'' (captitalized function name)',...
    'Description of input arguments (use \n for additional line breaks)',...
    'Description of optional input arguments (use \n for additional line breaks)',...
    'Description of output arguments (use \n for additional line breaks)',...
    'Author'};
inTitle = 'Please describe your function';
numLines = repmat([1,100],7,1);
numLines([4,5],1) = 5;
numLines([5,5],1) = 5;
numLines([6,5],1) = 5;

% assign defaultAnswer
[defaultAnswer{1:7}] = deal('');
% assign username in default answers
% if we have a function name already, all will be simpler
if ~isempty(functionName)
    defaultAnswer{1} = functionName;
    defaultAnswer{3} = sprintf('%s ...', upper(functionName));
end

% loop till description is ok
ok = false;

while ~ok
    
    % get input
    description = inputdlg(inPrompt, inTitle, numLines, defaultAnswer);
    
    % check for user abort
    if isempty(description)
        error('description cancelled by user');
    else
        ok = true; % hope for the best
    end
    
    % read description. Functionname, description and synopsis are required
    functionName = description{1};
    if isempty(functionName) || isempty(description{1})...
            || isempty(description{2}) || isempty(description{3}) ||...
            any(strfind(description{3},'...')) || isempty(regexpi(description{3},functionName))
        h = errordlg('Username, function name, description and synopsis are required inputs!');
        uiwait(h);
        ok = false;
    end
    
    % check whether function already exists (again)
    functionCheck = which(functionName);
    if ~isempty(functionCheck)
        h = errordlg('%s already exists: %s',functionName,functionCheck);
        uiwait(h);
        ok = false;
    end
    
    % check for ok and update defaultAnswer with description if necessary
    if ~ok
        defaultAnswer = description;
    end
    
end % while

% read other input
synopsis = description{2};
desc = description{3};

% if there are line breaks in inputtext and outputtext: make sure that
% these lines will still be commented!
inputText = description{4};
% add line breaks if necessary, turn into single line of text
if size(inputText,1) > 1
    inputText = [inputText,repmat('\n',size(inputText,1),1)];
    inputText(end,end-1:end) = ' ';
    inputText = inputText';
    inputText = inputText(:)';
    % kill some white space
    inputText = regexprep(inputText,'(\s*)\\n','\\n');
end
if strfind(inputText,'\n')
    inputText = regexprep(inputText,'\\n','\\n%%\\t\\t');
end
inputOptionalText = description{5};
% add line breaks if necessary, turn into single line of text
if size(inputOptionalText,1) > 1
    inputOptionalText = [inputOptionalText,repmat('\n',size(inputOptionalText,1),1)];
    inputOptionalText(end,end-1:end) = ' ';
    inputOptionalText = inputOptionalText';
    inputOptionalText = inputOptionalText(:)';
    % kill some white space
    inputOptionalText = regexprep(inputOptionalText,'(\s*)\\n','\\n');
end
if strfind(inputOptionalText,'\n')
    inputOptionalText = regexprep(inputOptionalText,'\\n','\\n%%\\t\\t');
end
outputText = description{6};
if size(outputText,1) > 1
    outputText = [outputText,repmat('\n',size(outputText,1),1)];
    outputText(end,end-1:end) = ' ';
    outputText = outputText';
    outputText = outputText(:)';
    outputText = regexprep(outputText,'(\s*)\\n','\\n');
end
if strfind(outputText,'\n')
    outputText = regexprep(outputText,'\\n','\\n%%\\t\\t\\t');
end
author = description{7};

% ask for directory to save the function
directory = uigetdir(pwd,'Select directory to save function');
if directory == 0
    error('directory selection cancelled by user')
end
% end of data-gathering stage

%% WRITE FUNCTION

% create the filename based on the function name
fileSuffix = '.m';
fileName = fullfile(directory,[functionName fileSuffix]);
% end filename creation

% beginning of file-printing stage
fid = fopen(fileName,'wt');
fprintf(fid,'function %s\n',synopsis);
fprintf(fid,'%% %s\n',desc);
fprintf(fid,'%%\n');
fprintf(fid,'%% %s\n',synopsis);
fprintf(fid,'%%\n');
fprintf(fid,'%% INPUT ARGUMENTS\n');
fprintf(fid,'%% %s\n',inputText);
fprintf(fid,'%%\n');
fprintf(fid,'%% OPTIONAL INPUT ARGUMENTS\n');
fprintf(fid,'%% %s\n',inputOptionalText);
fprintf(fid,'%%\n');
fprintf(fid,'%% OUTPUT\n');
fprintf(fid,'%% %s\n',outputText);
fprintf(fid,'\n');
fprintf(fid,'%% Copyright (c) 2015 %s\n',author);
fprintf(fid,'%% danne.forsberg@outlook.com \n');
fprintf(fid,'%% \n');
fprintf(fid,'%% This program is free software: you can redistribute it and/or modify\n');
fprintf(fid,'%% it under the terms of the GNU General Public License as published by\n');
fprintf(fid,'%% the Free Software Foundation, either version 3 of the License, or\n');
fprintf(fid,'%% (at your option) any later version.\n');
fprintf(fid,'%%\n');
fprintf(fid,'%% This program is distributed in the hope that it will be useful,\n');
fprintf(fid,'%% but WITHOUT ANY WARRANTY; without even the implied warranty of\n');
fprintf(fid,'%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n');
fprintf(fid,'%% GNU General Public License for more details.\n');
fprintf(fid,'%%\n');
fprintf(fid,'%% You should have received a copy of the GNU General Public License\n');
fprintf(fid,'%% along with this program.  If not, see <http://www.gnu.org/licenses/>.\n');
fprintf(fid,'\n');
fprintf(fid,'%%%% Default parameters\n');
fprintf(fid,'%%\n');
fprintf(fid,'%% Overwrites default parameter values\n');
fprintf(fid,'for k=1:2:length(varargin)\n');
fprintf(fid,'    eval([varargin{k},''=varargin{'',int2str(k+1),''};'']);\n');
fprintf(fid,'end\n');
fprintf(fid,'%%\n');
fprintf(fid,'%%\n');
% end of file-printing stage
fclose(fid);

% pop up the newly generated file
edit(fileName);