function output = extend_volume(input, spacing, interpolation, relativeValues)
% EXTEND_VOLUME Extends input to have the same physical size in all dimensions
%
% output = extend_volume(input, spacing, interpolation)
%
% INPUT ARGUMENTS
% input             - Input data
% spacing           - Physical spacing of the voxels
% interpolation     - Method to use for interpolation
% relativeValues    - True/false
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% output            - Output data

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

variates = size(input,4);
inputSize = size(input);

physicalSize = (inputSize(1:3) - 1).*spacing;

extension = zeros(1,3);

for k = 1 : 3
    if max(physicalSize) > physicalSize(k)
        extension(k) = round((max(physicalSize) - physicalSize(k))/spacing(k)/2);
    end
end

outputSize = max(inputSize(1:3))*ones(1,3);

for k = 1 : variates
    input = padarray(input(:,:,:,k),extension);
    inputSize = size(input);
    output(:,:,:,k) = resampler(input, outputSize, ...
                                'interpolation', interpolation,...
                                'relativeValues', relativeValues);
end

