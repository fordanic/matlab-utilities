function [dicomMetaData] = retrieve_dicom_meta_data(folder,dicomObjects)
% RETRIEVE_DICOM_META_DATA Retrieves dicom meta data from folder and its subfolders
%
% [dicomMetaData] = retrieve_dicom_meta_data(folder)
%
% INPUT ARGUMENTS
% folder                        - Folder to search in, folders and subfolders
%                                 are assumed to only contain DICOM files
% dicomObjects                  - List of dicom objects to retrieve
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT
% dicomMetaData                 - A cell structure

% Copyright (c) 2013 Daniel Forsberg
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
% Remember current folder
currentFolder = pwd;

% Go to specified folder
cd(folder)

% Initialize dicomMetaData
dicomMetaData = {};

% List folder content in current folder
folderContent = dir;

% Check if we have reached the final sub folder level
if ~folderContent(3).isdir
    % Retrieve dicom meta data
    info = dicominfo(folderContent(3).name);
    for k = 1 : length(dicomObjects)
        dicomObjectValue = get_dicom_value(info,dicomObjects{k});
        if isempty(dicomMetaData)
            dicomMetaData = {dicomObjectValue};
        else
            dicomMetaData = cat(2,dicomMetaData,{dicomObjectValue});
        end
    end
    dicomMetaData = cat(2,dicomMetaData,pwd);
else
    % Parse the folder content
    for k = 1 : length(folderContent)
        if strcmp(folderContent(k).name,'.') || ...
                strcmp(folderContent(k).name,'..') || ...
                ~folderContent(k).isdir
            % Do nothing
        else
            if isempty(dicomMetaData)
                dicomMetaData = retrieve_dicom_meta_data(folderContent(k).name,dicomObjects);
            else
                dicomMetaData = cat(1,dicomMetaData, ...
                    retrieve_dicom_meta_data(folderContent(k).name,dicomObjects));
            end
        end
    end
end

% Go back to original folder
cd(currentFolder)
end

function dicomObjectValue = get_dicom_value(info,dicomObject)

if isfield(info,dicomObject)
    dicomObjectValue = getfield(info,dicomObject);
else
    dicomObjectValue = '';
end
end