function outImage  = get_center(image,outSize)
% GET_CENTER Returns the centerpart with size outSize from a 3D, 2D or 1D image.
%
% outImage  = get_center(image,outSize)
%
% Image and outSize must both be either odd or even for each dimension.
%
% INPUT ARGUMENTS
% image         - 3/2/1D image
% outSize       - [outSizeY outSizeX outSizeZ]
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% outImage      - Centerpart of image

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

[sizeY sizeX sizeZ] = size(image);
if sizeY == 1 && sizeZ == 1
    dimensionImage = 1;
elseif sizeZ == 1
    dimensionImage = 2;
else
    dimensionImage = 3;
end

dimensionSize = length(outSize);

if dimensionSize == 2
   y = outSize(1);
   x = outSize(2);
   z = 1;
elseif dimensionSize == 3
   y = outSize(1);
   x = outSize(2);
   z = outSize(3);
elseif dimensionSize == 1 && dimensionImage == 3
    y = outSize;
    x = outSize;
    z = outSize;
elseif dimensionSize == 1 && dimensionImage == 2
    y = outSize;
    x = outSize;
    z = 1;
elseif dimensionSize == 1 && dimensionImage == 3
    y = 0;
    x = outSize;
    z = 1;
else
    error('Image and outSize parameters dont match')
end

if (y>sizeY && x>sizeX && z>sizeZ)
    error('Image is too small')
end

if (rem(sizeY,2) ~= rem(y,2) || rem(sizeX,2) ~= rem(x,2) || rem(sizeZ,2) ~= rem(z,2))
    error('Not possible to extract center part')
end

% y-dir
ylimage1 = (sizeY - y)/2 + 1;
ylimage2 = ylimage1 + y - 1;

% x-dir
xlimage1 = (sizeX - x)/2 + 1;
xlimage2 = xlimage1 + x - 1;

% z-dir
zlimage1 = (sizeZ - z)/2 + 1;
zlimage2 = zlimage1 + z - 1;

outImage = image(ylimage1:ylimage2, xlimage1:xlimage2, zlimage1:zlimage2);
