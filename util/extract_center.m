function imCenter = extract_center(im, center, radius)
% EXTRACT_CENTER Exracts a circle of data with specified center and radius from provied image.
%
% imCenter = extract_center(im, center, radius)
%
% INPUT ARGUMENTS
% im            - Image to extract data from
% center        - Center point of image, provided as [x, y]
% radius        - Radius of extracted circle
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% imCenter      - Extracted image center

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

if size(im,3) == 1
    imCenter = im(center(2)-radius:center(2)+radius,...
        center(1)-radius:center(1)+radius);
    
    [x, y] = meshgrid(-radius:radius,-radius:radius);
    r = sqrt(x.^2 + y.^2);
    
    imCenter(r > radius) = 0;
elseif size(im,3) == 3
    imCenter = im(center(2)-radius:center(2)+radius,...
        center(1)-radius:center(1)+radius,:);
    
    [x, y] = meshgrid(-radius:radius,-radius:radius);
    r = sqrt(x.^2 + y.^2);
    
    for k = 1 : 3
        temp = imCenter(:,:,k);
        temp(r > radius) = 0;
        imCenter(:,:,k) = temp;
    end
end