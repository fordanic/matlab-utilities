function [speckleNoise] = create_speckle_noise2d(noise)
% CREATE_SPECKLE_NOISE2D Use funtion to convert uniform noise to speckle like noise.
%
% function [speckleNoise] = create_speckle_noise2d(noise)
%
% INPUT ARGUMENTS
% noise             - Input noise, expected to be gaussian white noise
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% speckleNoise      - Speckle like noise

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

noiseff = fft2(noise);
noiseff = fftshift(noiseff);
sizeNoise = size(noise);
if sizeNoise(1) == 1
    [x,y]=meshgrid(-sizeNoise(2)/2:sizeNoise(2)/2-1,0);
else
    [x,y]=meshgrid(-sizeNoise(2)/2:sizeNoise(2)/2-1,-sizeNoise(1)/2:sizeNoise(1)/2-1);
end
w = 1./(sqrt(x.^2 + y.^2));
w(floor(sizeNoise(1)/2+1),floor(sizeNoise(2)/2+1)) = 1;
noiseffw = noiseff.*w;
noiseffw = ifftshift(noiseffw);
noiselp = ifft2(noiseffw,sizeNoise(1),sizeNoise(2));
speckleNoise = 10*(noiselp - mean(noiselp(:)));
