function output = resample_image_volume(input, pixelToWorldMatrix, varargin)
% RESAMPLE_IMAGE_VOLUME Resamples the given volume according to specified parameters of output volume
%
% output = resample_image_volume(input, pixelToWorldMatrix)
%
% INPUT ARGUMENTS
% input                     - Image volume to resample
% pixelToWorldMatrix        - Transform of voxel coordinates to world
%                             coordinates
%
% OPTIONAL INPUT ARGUMENTS
% 'pixelDimensions'         - Voxel size of resampled data
% 'offset'                  - Offset of resampled data
% 'rotationMatrix'          - Rotation matrix of resampled data
% 'sizeOutput'              - Data size of resampled data (in number of voxels)
%
% OUTPUT
% output                    - Resampled image volume

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

%% Default parameters
pixelDimensions = [1 1 1];
offset = [];
rotationMatrix = [1 0 0; 0 1 0; 0 0 1];
sizeOutput = [];

% Overwrites default parameters
for k = 1 : 2 : length(varargin)
    eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end

%% Determine the pixel to world transformation matrix of the output volume

% Compute physical coordinates of the corners of the input volume
sizeInput = size(input);
k = [0 sizeInput(2) 0 sizeInput(2) 0 sizeInput(2) 0 sizeInput(2)];
l = [0 0 sizeInput(1) sizeInput(1) 0 0 sizeInput(1) sizeInput(1)];
m = [0 0 0 0 sizeInput(3) sizeInput(3) sizeInput(3) sizeInput(3)];
xyz = pixelToWorldMatrix * [k;l;m;ones(size(k))];
minMaxXYZ = minmax(xyz);
boundingBoxInput = minMaxXYZ(1:3,:)';

% Determine offset
if isempty(offset)
    offset = boundingBoxInput(1,:);
end

scaleMatrix = diag(pixelDimensions);

pixelToWorldMatrixOutput = [rotationMatrix*scaleMatrix offset(:); 0 0 0 1];

%% Compute image coordinates of output volume

% Determine output size
if isempty(sizeOutput)
    sizeOutput = round((boundingBoxInput(2,:) - boundingBoxInput(1,:))./pixelDimensions + 1);
    sizeOutput(1:2) = fliplr(sizeOutput(1:2));
end

[k,l,m] = meshgrid(0:sizeOutput(2)-1,0:sizeOutput(1)-1,0:sizeOutput(3)-1);

%% Transform image coordinates to enable resample in input volume

% The transform is achieved by transforming the image coordinates of the output
% volume to world coordinates and then by transforming them to image coordinates
% of the input volume
klmInput = inv(pixelToWorldMatrix) * pixelToWorldMatrixOutput * [k(:)';l(:)';m(:)';ones(size(k(:)'))];
xi = reshape(klmInput(1,:),sizeOutput);
yi = reshape(klmInput(2,:),sizeOutput);
zi = reshape(klmInput(3,:),sizeOutput);

%% Resample
output = interp3(input,xi,yi,zi);
