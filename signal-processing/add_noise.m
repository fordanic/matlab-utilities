function [outImage] = add_noise(SNR,image,noise)
% ADD_NOISE Adds Gaussian noise an image according to desired SNR
%
% [outImage] = add_noise(SNR,image,noise)
% 
% INPUT ARGUMENTS
% SNR           - SNR of outImage
% image         - Image to add noise to
% noise         - Noise to add
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% outImage      - Input image with added noise

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

meanImage = mean(image(:));
meanNoise = mean(noise(:));

sqDiffImage = (image-meanImage).^2;
sqDiffNoise = (noise-meanNoise).^2;

n_pix = numel(image);

stdImage = sqrt(sum(sqDiffImage(:)))/(n_pix-1);
stdNoise = sqrt(sum(sqDiffNoise(:)))/(n_pix-1);

a = 1/(stdImage/(10^(SNR/20)*stdNoise)+1);

outImage = a*(image-meanImage) + (1-a)*(noise-meanNoise) + meanImage;   