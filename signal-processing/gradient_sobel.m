function [gx,gy,gz] = gradient_sobel(input)
% GRADIENT_SOBELS Computes the gradient of provided input using the Sobel operator
%
% [gx,gy,gz] = gradient_sobel(input)
%
% Results should be similar to the ones obtained with imgradientxy for 2D data.
% Note that this function supports 3D as well.
%
% INPUT ARGUMENTS
% input             - Input data to compute gradient fors
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT
% gx                - Gradient along x-axis
% gy                - Gradient along y-axis
% gz                - Gradient along z-axis

% Copyright (c) 2014 Daniel Forsberg
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

dims = ndims(input);
switch dims
    case 2
        % Define Sobel kernels
        sobelX = [-1 0 1;-2 0 2;-1 0 1];
        sobelY = sobelX';
        
        % Filter
        gx = imfilter(input,sobelX,'conv','same','replicate');
        gy = imfilter(input,sobelY,'conv','same','replicate');
    case 3
        % Define Sobel kernels
        sobelX = [-1 0 1;-2 0 2;-1 0 1];
        sobelX(:,:,2) = 2*sobelX(:,:,1);
        sobelX(:,:,3) = sobelX(:,:,1);
        sobelY = permute(sobelX,[2 1 3]);
        sobelZ = permute(sobelX,[3 1 2]);
        
        % Filter
        gx = imfilter(input,sobelX,'conv','same','replicate');
        gy = imfilter(input,sobelY,'conv','same','replicate');
        gz = imfilter(input,sobelZ,'conv','same','replicate');
end

