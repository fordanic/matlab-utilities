function compile_mex_files(folder,varargin)
% COMPILE_MEX_FILES Compiles all the MEX function in the specified folder
%
% compile_mex_files(folder)
%
% INPUT ARGUMENTS
% folder                    - Folder containing files to be compiled
%
% OPTIONAL INPUT ARGUMENTS
% 'fileExtension'           - File extension of files to be compiled
% 'compilerInstructions     - Extra compiler instructions
% 'filesToExclude'          - A cell-based list with files no to compile
%
% OUTPUT ARGUMENTS
% N/A

% Copyright (c) 2012 Daniel Forsberg
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

% Set default parameters
fileExtension = 'c';
compilerInstructions = '';
filesToExclude = {};

% Overwrites default parameter
for k=1:2:length(varargin)
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

currentPath = pwd;

cd(folder);

fprintf('Compiling mex-files in %s\n',pwd);

%% MAKE ALL
sourceFiles = dir(['*.',fileExtension]);

for k = 1 : length(sourceFiles)
    
    % Extract name
    sourceFile = sourceFiles(k);
    sourceFileName = sourceFile.name;
    if sum(strcmpi(sourceFileName,filesToExclude)) > 0
        continue;
    end
    
    % Extract corresponding mexfile
    mexFilename = sprintf( '%s%s', sourceFileName(1:end-length(fileExtension)),mexext);
    mexFile = dir( mexFilename );
    
    % File not already compiled OR file compiled is outdated
    if ( isempty( mexFile ) ) || ( sourceFile.datenum > mexFile.datenum )
        % compile
        disp(sprintf('Compiling: %s', sourceFileName ) );
        eval( sprintf('mex %s %s', compilerInstructions, sourceFileName));
    else
        continue;
    end
end

cd(currentPath);

disp('Done!');

