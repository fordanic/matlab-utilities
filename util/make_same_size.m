function [imOut1, imOut2] = make_same_size(im1, im2, varargin)
% MAKE_SAME_SIZE Pads the two images to make them have same size.
%
% [im1, im2] = make_same_size(im1, im2)
%
% INPUT ARGUMENTS
% im1           - Image 1
% im2           - Image 2
%
% OPTIONAL INPUT ARGUMENTS
% 'direction'   - Direction to pad
%                 'pre','post','both'
%
% OUTPUT ARGUMENTS
% imOut1        - Image 1
% imOut2    - Image 2

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

direction = 'both';

% Overwrites default parameter
for k=1:2:length(varargin)
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

sz = max([size(im1); size(im2)]);

imOut1 = pad(im1,sz,'direction',direction);
imOut2 = pad(im2,sz,'direction',direction);

