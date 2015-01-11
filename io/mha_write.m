function mha_write(data,fileName,varargin)
% MHA_WRITE Write data to file according to MetaImage format
% 
% mha_write(data,fileName,spacing)
%
% INPUT ARGUMENTS
% data              - Data to be written
% fileName          - Name of file to write to
%
% OPTIONAL INPUT ARGUMENTS
% 'spacing'                 - Spacing between data points
% 'transformMatrix'         - Transformation
% 'offset'                  - Offset
% 'centerOfRotation'        - Center of rotation
% 'anatomicalOrientation'   - Anatomical orientation of the data
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

%% Default parameters

% Set default parameters
transformMatrix = [1 0 0 0 1 0 0 0 1];
offset = [0.0 0.0 0.0];
centerOfRotation = [0 0 0];
anatomicalOrientation = 'LPS';
spacing = [1.0 1.0 1.0];

% Overwrites default parameters
for k=1:2:length(varargin)
    eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end

%%
% Get number of dimensions and size of data
dims = ndims(data);
sz = size(data);

% Get data type
dataType = class(data);

% Check if data is supported
if (strcmp(dataType,'logical') || strcmp(dataType,'logical') || strcmp(dataType,'cell') || ...
    strcmp(dataType,'struct') || strcmp(dataType,'function_handle') || ...
    strcmp(dataType,'int64')  || strcmp(dataType,'uint64'))
    error('The data type is not supported to be written to an .mhd file.\n')
end

%% Write header

% Open file
fid = fopen(strcat(fileName,'.mhd'),'w');

% Start writing meta data
fprintf(fid,'ObjectType = Image\n');
fprintf(fid,'NDims = %i\n',dims);
fprintf(fid,'ElementByteOrderMSB = False\n');
if dims == 2
    fprintf(fid,'TransformMatrix = %1.3f %1.3f %1.3f %1.3f\n',...
        transformMatrix(1),transformMatrix(2),transformMatrix(3),transformMatrix(4));
elseif dims == 3 
    fprintf(fid,'TransformMatrix = %1.3f %1.3f %1.3f %1.3f %1.3f %1.3f %1.3f %1.3f %1.3f\n',...
        transformMatrix(1),transformMatrix(2),transformMatrix(3),transformMatrix(4),transformMatrix(5),...
        transformMatrix(6),transformMatrix(7),transformMatrix(8),transformMatrix(9));
end
if dims == 2
    fprintf(fid,'Offset = %1.3f %1.3f\n', offset(1), offset(2));
elseif dims == 3
    fprintf(fid,'Offset = %1.3f %1.3f %1.3f\n', offset(1), offset(2), offset(3));
end
if dims == 2
    fprintf(fid,'CenterOfRotation = %i %i\n', centerOfRotation(1), centerOfRotation(2));
elseif dims == 3
    fprintf(fid,'CenterOfRotation = %i %i %i\n', centerOfRotation(1), centerOfRotation(2), centerOfRotation(3));
end
str = strcat({'AnatomicalOrientation = '},{strcat(anatomicalOrientation,'\n')});
fprintf(fid,str{1});
if dims == 2
    fprintf(fid,'ElementSpacing = %1.5f %1.5f\n',spacing(1),spacing(2));
elseif dims == 3
    fprintf(fid,'ElementSpacing = %1.5f %1.5f %1.5f\n',spacing(1),spacing(2),spacing(3));
end
if dims == 2
    fprintf(fid,'DimSize = %i %i\n',sz(1),sz(2));
elseif dims == 3
    fprintf(fid,'DimSize = %i %i %i\n',sz(1),sz(2),sz(3));
end
switch dataType
    case 'uint8'
        fprintf(fid,'ElementType = MET_UCHAR\n');
    case 'int8'
        fprintf(fid,'ElementType = MET_CHAR\n');
    case 'uint16'
        fprintf(fid,'ElementType = MET_USHORT\n');
    case 'int16'
        fprintf(fid,'ElementType = MET_SHORT\n');
    case 'uint32'
        fprintf(fid,'ElementType = MET_INT\n');
    case 'int32'
        fprintf(fid,'ElementType = MET_INT\n');
    case 'single'
        fprintf(fid,'ElementType = MET_FLOAT\n');
    case 'double'
        fprintf(fid,'ElementType = MET_DOUBLE\n');
    otherwise
        fprintf(fid,'ElementType = MET_DOUBLE\n');
end
str = strcat({'ElementDataFile = '},{strcat(fileName,'.raw\n')});
fprintf(fid,str{1});

% Close file
fclose(fid);

%% Write raw data

% Open file
fid = fopen(strcat(fileName,'.raw'),'w');

% Write data to file
fwrite(fid,data(:),dataType);

% Close file
fclose(fid);