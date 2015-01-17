function [localAverage] = compute_local_average(im,varargin)
% COMPUTE_LOCAL_AVERAGE Computes the local average for every pixel in the provided image.
%
% [localAverage] = compute_local_average(im)
%
% INPUT ARGUMENTS
% im                - Image to estimate local average for
%
% OPTIONAL INPUT ARGUMENTS
% 'sizeL'           - Size of local neighborhood to use for estimating the
%                     local average
%
% OUTPUT
% localAverage      - Computed local average

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

%% Default parameters

sizeL = 51;

% Overwrites default parameter values
for k=1:2:length(varargin)
    eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end

halfSizeL = (sizeL - 1)/2;

%% Check dimensions
if ndims(im) ~= 2
    error('This function only handled 2D images at the moment.')
end
%% Extend image
[sizeY, sizeX] = size(im);
imExtended = padarray(im,[halfSizeL halfSizeL],'replicate','both');

%% Estimate local means based upon the idea of integer images

% Perform cumsum over both dimensions
imCumSum = cumsum(cumsum(imExtended,2),1);

% Estimate indices of pixels to estimate local means for
[xi, yi] = meshgrid(1:sizeX+2*halfSizeL,1:sizeY+2*halfSizeL);
ind = sub2ind(size(imExtended),...
    vec(yi(1+halfSizeL:end-halfSizeL,1+halfSizeL:end-halfSizeL)),...
    vec(xi(1+halfSizeL:end-halfSizeL,1+halfSizeL:end-halfSizeL)));

% Compute local means
localAverage = reshape(imCumSum(ind + halfSizeL + halfSizeL * size(imExtended,1)) - ...
    imCumSum(ind - halfSizeL + halfSizeL * size(imExtended,1)) - ...
    imCumSum(ind + halfSizeL - halfSizeL * size(imExtended,1)) + ...
    imCumSum(ind - halfSizeL - halfSizeL * size(imExtended,1)),[sizeY, sizeX]) ./ ...
    sizeL^2;
