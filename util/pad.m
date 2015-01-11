function paddedImage = pad(im,sz,varargin)
% PAD Pads an images with zeros to have the given size
%
% paddedImage = pad(image, sz)
%
% INPUT ARGUMENTS
% im            - Image to pad
% sz            - Desired image size
% paddedIm      - Padded image
%
% OPTIONAL INPUT ARGUMENTS
% 'direction'   - Direction to pad
%                 'pre','post',('both')
% 'value'       - Value to pad with (0)
%
% OUTPUT ARGUMENTS
% paddedImage   - Padded image

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
value = 0;

% Overwrites default parameter
for k=1:2:length(varargin)
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

sizeDifference = sz-size(im);

switch direction
    case 'both'
        padPre = floor(sizeDifference/2);
        padPost = ceil(sizeDifference/2);
        
        paddedImage = padarray(im,padPre,value,'pre');
        paddedImage = padarray(paddedImage,padPost,value,'post');
    case 'pre'
        paddedImage = padarray(im,sizeDifference,value,'pre');
    case 'post'
        paddedImage = padarray(im,sizeDifference,value,'post');
    otherwise
        error('Unknown direction for padding')
end
