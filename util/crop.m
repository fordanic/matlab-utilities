function [croppedImage,cornerCoordinates] = crop(image,margin)
% CROP removes zeros around an image
%
% [croppedImage,cornerCoordinates] = crop[image,margin]
%
% INPUT ARGUMENTS
% image                 - Image to crop, assumed to be a 2D image or a 3D
%                         volume, but not a three channel 2D image (i.e. an
%                         RGB image)
% margin                - Extra margins around the cropped image
%
% OPTIONAL INPUT ARGUMENTS
% N/A
% 
% OUTPUT ARGUMENTS
% croppedImage          - The cropped image
% cornerCoordinates     - Corner coordinates of the cropped image 
%                         [x1 y1 z1; x2 y2 z2]

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

% Sum the values of the image
xsum = sum(sum(sum(image,4),3),1);
ysum = sum(sum(sum(image,4),3),2);
zsum = sum(sum(sum(image,4),2),1);
tsum = sum(sum(sum(image,3),2),1);

% xsum will be equal to 0 wherever there is a blank column in
% the image. The left edge for the cropped image is found by looking
% for the first column in which xsum is larger than 0
% and then subtracting the margin

xRightEdge = find(xsum~=0,1,'first')-margin;
if xRightEdge<1
    xRightEdge=1;
end
xLeftEdge=find(xsum~=0,1,'last')+margin;
if xLeftEdge>length(xsum)
    xLeftEdge=length(xsum);
end

yAnteriorEdge=find(ysum~=0,1,'first')-margin;
if yAnteriorEdge<1
    yAnteriorEdge=1;
end
yPosteriorEdge=find(ysum~=0,1,'last')+margin;
if yPosteriorEdge>length(ysum)
    yPosteriorEdge=length(ysum);
end

zInferiorEdge=find(zsum~=0,1,'first')-margin;
if zInferiorEdge<1
    zInferiorEdge=1;
end
zSuperiorEdge=find(zsum~=0,1,'last')+margin;
if zSuperiorEdge>length(zsum)
    zSuperiorEdge=length(zsum);
end

tFirstEdge=find(tsum~=0,1,'first')-margin;
if tFirstEdge<1
    tFirstEdge=1;
end
tLastEdge=find(tsum~=0,1,'last')+margin;
if tLastEdge>length(tsum)
    tLastEdge=length(tsum);
end

croppedImage = image(yAnteriorEdge:yPosteriorEdge,xRightEdge:xLeftEdge,...
    zInferiorEdge:zSuperiorEdge,tFirstEdge:tLastEdge);
cornerCoordinates = [xRightEdge yAnteriorEdge zInferiorEdge tFirstEdge; ...
    xLeftEdge yPosteriorEdge zSuperiorEdge tLastEdge];
