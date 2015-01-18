function outImage  = averaging3d(image, var1, var2, var3)
% AVERAGING3D Averaging of a 3D image using sequentional normalized convolution.
%
% function outImage  = averaging3d(image, certaintyImage, filterSize, sigma)
%
% INPUT ARGUMENTS
% image             -  input image
% certaintyImage    -  optional, CERTAINTY IMAGE or a SCALAR equal to 1, 0 or -1
%                      = 1 (default) implies normalized convolution using
%                      the size of the image as certainty.
%                      = 0 implies convolution using edge extraction.
%                      = -1 implies direct use of conv2.
% filterSize        -  optional (default = 5) filter size in pixels.
% sigma             -  optional (default = 1.0), std dev in F.D.
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% outImage          - Averaged image

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

size0  = 5;
sigma0 = 1.0;

% Check the input parameters.
error(nargchk(1,4,nargin))

nin=nargin;

% Determine if a certainty is provided and which convolution to use
certainty = false;
% Use normalized conv
normalizedConvolution = 1;
if nin > 1
    if numel(var1)==1
        if var1==1
            certainty = true;
            certaintyImage = ones(size(image));
        elseif var1 == 0
            certainty = true;
            % Use edge extraction
            normalizedConvolution = 0;
        elseif var1 == -1
            certainty = true;
            % Plain conv
            normalizedConvolution = -1;
        end
    elseif size(var1) == size(image)
        certainty = true;
        certaintyImage = abs(var1);
    else
        error('Different size of image and certaintyImage')
    end
end

if certainty == 0
    certaintyImage = ones(size(image));
end


if certainty
    switch nin
        case 3
            filterSize  = var2;
            sigma       = sigma0;
        case 4
            filterSize  = var2;
            sigma       = var3;
        otherwise
            filterSize  = size0;
            sigma       = sigma0;
    end
else
    switch nin
        case 1
            filterSize  = size0;
            sigma       = sigma0;
        case 2
            filterSize  = var1;
            sigma       = sigma0;
        case 3
            filterSize  = var1;
            sigma       = var2;
        case 4
            error('Illegal value of certaintyImage')
    end
end

if filterSize ~= abs(round(filterSize))
    error('Filter size must be a positive integer');
end

f = gauss_fourier(filterSize,sigma);

% Convolve
switch normalizedConvolution
    case 1
        % Using normalized convolution
        image = image.*certaintyImage;
        certaintyImage = imfilter(certaintyImage, f, 'same', 'conv', 'replicate');
        certaintyImage = imfilter(certaintyImage, f', 'same', 'conv', 'replicate');
        certaintyImage = imfilter(certaintyImage, reshape(f, [1 1 filterSize]), 'same', 'conv', 'replicate');
        certaintyImage = certaintyImage + 1e-16;
        
        outImage = imfilter(image, f, 'same', 'conv', 'replicate');
        outImage = imfilter(outImage, f', 'same', 'conv', 'replicate');
        outImage = imfilter(outImage, reshape(f, [1 1 filterSize]), 'same', 'conv', 'replicate');
        outImage = outImage./(certaintyImage);
    case 0
        % Using edge extraction
        outImage = imfilter(image, f, 'same', 'conv', 'replicate');
        outImage = imfilter(outImage, f', 'same', 'conv', 'replicate');
        outImage = imfilter(outImage, reshape(f, [1 1 filterSize]), 'same', 'conv', 'replicate');
    case -1
        % Using plain convolution
        outImage = imfilter(image, f, 'same', 'conv');
        outImage = imfilter(outImage, f', 'same', 'conv');
        outImage = imfilter(outImage, reshape(f, [1 1 filterSize]), 'same', 'conv');
end