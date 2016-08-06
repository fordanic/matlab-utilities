function display_image(im,figNo,title,varargin)
% DISPLAY_IMAGE Simple function to display an image in true size
%
% display_image(im,figNo,title)
%
% INPUT ARGUMENTS
% im        - Image to display
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
initialMagnification = 100;

% Overwrite default values with user supplied values
for k=1:2:length(varargin)
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end

%%
%**************** Display im *************************
switch ndims(im)
    case 2
        % Convert to double
        im = double(im);
        
        % A 2D gray level image, set histogram to [0,1]
        figure(figNo)
        if min(im(:)) < 0
            im = im - min(im(:));
        end
        im = im/max(im(:));
        im = im.^gamma;
        imshow(im,'InitialMagnification',initialMagnification,'Border','tight')
        drawnow
        pause(0.01)
        figure_title(title)
    case 3
        if size(im,3) == 3
            % A 2D color image
            figure(figNo)
            imshow(im,'InitialMagnification',initialMagnification,'Border','tight')
            drawnow
            pause(0.01)
            figure_title(title)
        else
            % A 3D gray level image. Extract three orthoganal planes
            % through the center position of the image volume and display
            % these.
            sz = max(size(im));
            centerPosition = floor(size(im) / 2);
            plane = squeeze(im(:,:,centerPosition(3)));
            imPlaneYX = pad(plane,[sz sz]);
            
            plane = squeeze(im(:,centerPosition(2),:));
            imPlaneYZ = pad(plane,[sz sz]);
            
            plane = squeeze(im(centerPosition(1),:,:));
            imPlaneXZ = pad(plane,[sz sz]);
            imPlane = [imPlaneYX flipud(imPlaneYZ') flipud(imPlaneXZ')];
            display_image(imPlane,figNo,title,'gamma',gamma)
        end
    otherwise
        error('Only supported for 2D/3D data');
end
