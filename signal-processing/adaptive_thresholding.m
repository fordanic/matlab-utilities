function binaryMap = adaptive_thresholding(im,varargin)
% ADAPTIVE_THRESHOLDING Performs an adaptive thresholding on the given image to segment foregound and background.
%
% binaryMap = adaptive_thresholding(im)
%
% INPUT ARGUMENTS
% im                    - Image to segment, assumed to be a gray level image
%
% OPTIONAL INPUT ARGUMENTS
% 'sizeL'               - Size of local neighborhood for computing the
%                         local average (default value is 51)
% 'offset'              - Offset to apply for local thresholding
%
% OUTPUT
% binaryMap             - Binary map with the same size as im, where
%                         the result from the thresholding is given as:
%                         0: Background
%                         1: Foreground

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

offset = 30;
sizeL = 51;

% Overwrites default parameter values
for k=1:2:length(varargin)
    eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end

%% Compute local means
imLocalMeans = compute_local_average(im,'sizeL',sizeL);

%% Perform thresholding
binaryMap = double(im < imLocalMeans - offset);
