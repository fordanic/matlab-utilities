function outImage  = extend_edges(image,extensionSize,varargin)
% EXTEND_EDGES Extends the edges of a 3D,2D or 1D image
%
% outImage  = extend_edges(image,extensionSize)
%
% INPUT ARGUMENTS
% image             - 3/2/1D image
% extensionSize     - Size of extension OR [extensionY extensionX extensionZ]
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% outImage          - Extended image

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

% Set up default parameters
padval = 'replicate';

for k=1:2:length(varargin)
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

[sizeY sizeX sizeZ] = size(image);
if sizeY == 1 && sizeZ == 1
    dimensionImage = 1;
elseif sizeZ == 1
    dimensionImage = 2;
else
    dimensionImage = 3;
end

if (dimensionImage > 3)
    error('Image is not 3D, 2D or 1D')
end

dimensionSize = length(extensionSize);

if dimensionSize == 2
   extensionY = extensionSize(1);
   extensionX = extensionSize(2);
   extensionZ = 0;
elseif dimensionSize == 3
   extensionY = extensionSize(1);
   extensionX = extensionSize(2);
   extensionZ = extensionSize(3);
elseif dimensionSize == 1 && dimensionImage == 3
    extensionY = extensionSize;
    extensionX = extensionSize;
    extensionZ = extensionSize;
elseif dimensionSize == 1 && dimensionImage == 2
    extensionY = extensionSize;
    extensionX = extensionSize;
    extensionZ = 0;
elseif dimensionSize == 1 && dimensionImage == 3
    extensionY = 0;
    extensionX = extensionSize;
    extensionZ = 0;
else
    error('Image and extensionSize parameters dont match')
end

outImage = padarray(image,[extensionY extensionX extensionZ],padval);