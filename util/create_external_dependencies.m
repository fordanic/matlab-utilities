function create_external_dependencies(functionName,folder,matFileName)
% CREATE_EXTERNAL_DEPENDENCIES Creates a MATLAB variable listing necessary files and where they can be found
%
% create_external_dependencies(functionName)
%
% INPUT ARGUMENTS
% functionName
% folder
% matFileName
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT
% N/A

% Copyright (c) 2015 Daniel Forsberg
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

%%

% Remember current folder and go to folder for external dependencies
currentFolder = pwd;
cd(folder)
clear fileNames urls
if exist(matFileName,'file')
    load(matFileName)
else
    fileNames = {};
    urls = {};
end

% List dependencies for specified file
[fList,pList] = matlab.codetools.requiredFilesAndProducts(functionName);

% For each dependency
for k = 1 : length(fList)
    % Split listing
    [pathStr,fileName,ext] = fileparts(fList{k});
    fileName = [fileName,ext];
    
    % If function name then skip
    if strcmp(fileName,functionName)
        continue
    end
    
    % If mex file then skip
    if strfind(ext,'mex')
        continue
    end
    
    % Check if already listed as external dependency
    if ~sum(strcmpi(fileName,fileNames))
        % Find which repository and local repository path
        if ~isempty(strfind(pathStr,'matlab-utilities')) && ...
                isempty(strfind(pathStr,folder))
            % Add file names to list of external depencies
            fileNames{end + 1} = fileName;
            idx = strfind(pathStr,'matlab-utilities');
            repositoryPath = pathStr(idx+17:end);
            repositoryPath = strrep(repositoryPath,'\','/');
            urls{end + 1} = ...
                ['https://raw.githubusercontent.com/fordanic/matlab-utilities/master/',...
                repositoryPath,'/',fileNames{end}];
        elseif ~isempty(strfind(pathStr,'tensor-processing')) && ...
                isempty(strfind(pathStr,folder))
            % Add file names to list of external depencies
            fileNames{end + 1} = fileName;
            idx = strfind(pathStr,'tensor-processing');
            repositoryPath = pathStr(idx+18:end);
            repositoryPath = strrep(repositoryPath,'\','/');
            urls{end + 1} = ...
                ['https://raw.githubusercontent.com/fordanic/tensor-processing/master/',...
                repositoryPath,'/',fileNames{end}];
        elseif ~isempty(strfind(pathStr,'image-registration')) && ...
                isempty(strfind(pathStr,folder))
            % Add file names to list of external depencies
            fileNames{end + 1} = fileName;idx = strfind(pathStr,'image-registration');
            repositoryPath = pathStr(idx+19:end);
            repositoryPath = strrep(repositoryPath,'\','/');
            urls{end + 1} = ...
                ['https://raw.githubusercontent.com/fordanic/image-registration/master/',...
                repositoryPath,'/',fileNames{end}];
        end
    end
end

save(matFileName,'fileNames','urls')
cd(currentFolder)
