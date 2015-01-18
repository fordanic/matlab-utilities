function [output,pixelDimensions,rotationMatrix,offset] = merge_image_volumes(...
    input1,pixelToWorldMatrix1,input2,pixelToWorldMatrix2,varargin)
% MERGE_IMAGE_VOLUMES Merges two image volumes defined according to pixel to world matrices
%
% [output] = merge_image_volumes(input1,pixelToWorldMatrix1,input2,pixelToWorldMatrix2)
%
% INPUT ARGUMENTS
% input1                - Input volume 1
% pixelToWorldMatrix1   - A transformation matrix mapping pixel coordinates to
%                         world coordinates for input volume 1
% input2                - Input volume 2
% pixelToWorldMatrix2   - A transformation matrix mapping pixel coordinates to
%                         world coordinates for input volume 2
%
% OPTIONAL INPUT ARGUMENTS
% 'pixelDimensions'     - Preferred spatial resolution for the output volume
% 'rotationMatrix'      - Preferred rotation matrix for the output volume relative [0,0]
% 'offset'              - Preferred offset from [0,0,0] for the output volume
% 'sizeOutput'          - Preferred size for output volume
%
% OUTPUT
% output                - Output volume containing the two initial volumes
% pixelDimensions       - Spatial resolution for the output volume
% rotationMatrix        - Rotation matrix for the output volume relative [0,0]
% offset                - Offset from [0,0,0] for the output volume

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

% Compute physical coordinates of the corners of the input volume 1
sizeInput1 = size(input1);
k = [0 sizeInput1(2) 0 sizeInput1(2) 0 sizeInput1(2) 0 sizeInput1(2)];
l = [0 0 sizeInput1(1) sizeInput1(1) 0 0 sizeInput1(1) sizeInput1(1)];
m = [0 0 0 0 sizeInput1(3) sizeInput1(3) sizeInput1(3) sizeInput1(3)];
xyz = pixelToWorldMatrix1 * [k;l;m;ones(size(k))];
minMaxXYZ = minmax(xyz);
boundingBoxInput1 = minMaxXYZ(1:3,:)';

% Compute physical coordinates of the corners of the input volume 1
sizeInput2 = size(input2);
k = [0 sizeInput2(2) 0 sizeInput2(2) 0 sizeInput2(2) 0 sizeInput2(2)];
l = [0 0 sizeInput2(1) sizeInput2(1) 0 0 sizeInput2(1) sizeInput2(1)];
m = [0 0 0 0 sizeInput2(3) sizeInput2(3) sizeInput2(3) sizeInput2(3)];
xyz = pixelToWorldMatrix2 * [k;l;m;ones(size(k))];
minMaxXYZ = minmax(xyz);
boundingBoxInput2 = minMaxXYZ(1:3,:)';

boundingBoxInput = minmax([boundingBoxInput1' boundingBoxInput2'])';

% Determine offset
if isempty(offset)
    offset = boundingBoxInput(1,:);
end

% Determine output size
if isempty(sizeOutput)
    sizeOutput = round((boundingBoxInput(2,:) - boundingBoxInput(1,:))./pixelDimensions + 1);
    sizeOutput(1:2) = fliplr(sizeOutput(1:2));
end

%% Resample input image volumes according to output volume
output1 = resample_image_volume(input1, pixelToWorldMatrix1,...
    'rotationMatrix',rotationMatrix,...
    'pixelDimensions',pixelDimensions,...
    'offset',offset,...
    'sizeOutput',sizeOutput);

output2 = resample_image_volume(input2, pixelToWorldMatrix2,...
    'rotationMatrix',rotationMatrix,...
    'pixelDimensions',pixelDimensions,...
    'offset',offset,...
    'sizeOutput',sizeOutput);

%% Merge output volumes
output = reshape(max([output1(:) output2(:)],[],2),sizeOutput);