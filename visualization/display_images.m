function display_images(im1,im2,figNo,title,varargin)
% DISPLAY_IMAGES Simple function to display two images
%
% display_images(im1,im2,figNo,title)
%
% INPUT ARGUMENTS
% im1       - Image 1 to display
% im2       - Image 2 to display
% figNo     - Figure number to use
% title     - Figure title
%
% OPTIONAL INPUT ARGUMENTS
% gamma     - Gamma to apply to the displayed image
%
% OUTPUT ARGUMENTS
% N/A

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

%% Default parameters

gamma = 1.0;

% Overwrite default values with user supplied values
for k=1:2:length(varargin)
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end

%%
%**************** Display (im1 - im2) *********************
switch ndims(im1)
    case 2
        [sizeY sizeX sizeZ] = size(im1);
        minVal = min([im1(:);im2(:)]);
        maxVal = max([im1(:);im2(:)]);
        
        im1 = (im1 - minVal) / (maxVal - minVal);
        im2 = (im2 - minVal) / (maxVal - minVal);
        
        im3d = zeros(sizeY,sizeX,3);
        im3d(:,:,2) = im1;
        im3d(:,:,1) = im2;
        im3d = im3d.^gamma;
        figure(figNo)
        imshow(im3d,'InitialMagnification',100,'Border','tight')
        drawnow
        figure_title(title)
    case 3
        centerPosition = floor(size(im1) / 2);
        sz = max(size(im1));
        
        plane = squeeze(im1(:,:,centerPosition(3)));
        im1PlaneYX = pad(plane,[sz sz]);
        
        plane = squeeze(im1(:,centerPosition(2),:));
        im1PlaneYZ = pad(plane,[sz sz]);
        
        plane = squeeze(im1(centerPosition(1),:,:));
        im1PlaneXZ = pad(plane,[sz sz]);
        im1Plane = [im1PlaneYX flipud(im1PlaneYZ') flipud(im1PlaneXZ')];
        
        plane = squeeze(im2(:,:,centerPosition(3)));
        im2PlaneYX = pad(plane,[sz sz]);
        
        plane = squeeze(im2(:,centerPosition(2),:));
        im2PlaneYZ = pad(plane,[sz sz]);
        
        plane = squeeze(im2(centerPosition(1),:,:));
        im2PlaneXZ = pad(plane,[sz sz]);
        im2Plane = [im2PlaneYX flipud(im2PlaneYZ') flipud(im2PlaneXZ')];
        
        display_images(im1Plane,im2Plane,figNo,title,'gamma',gamma)
    otherwise
        error('Only supported for 2D/3D data');
end