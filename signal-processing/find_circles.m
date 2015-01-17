function [circles] = find_circles(im,radii,varargin)
% FIND_CIRCLES Finds circles with radii(1) < radius < radii(2) in im
%
% [circles] =  find_circles(im,radii)
%
% INPUT ARGUMENTS
% im                            - Image to search
% radii                         - [minRadius maxRadius]
%
% OPTIONAL INPUT ARGUMENTS
% 'numberOfCirclesToReturn'     - Number of circles to find (5)
% 'objectPolarity'              - Brigt or dark circles ('bright')
% 'sensitivity'                 - Sensitivity when searching for circles
% 'showResults'                 - Display found circles (false)
% 'figNo'                       - Figure to display found circles in
%
% OUTPUT ARGUMENTS
% circles                       - Found circles
%
% See also imfindcircles

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

% Setup default parameters
showResults = false;
numberOfCirclesToReturn = 5;
objectPolarity = 'bright';
sensitivity = 0.85;
figNo = 101;

% Overwrites default parameters
for k=1:2:length(varargin),
    eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end

% Find all the circles with radius >= radii(1) and radius <= radii(2)
[centers, radii, metric] = imfindcircles(im,radii,...
    'ObjectPolarity',objectPolarity,'Sensitivity',sensitivity,...
    'Method','PhaseCode');

% Retain the strongest circles according to metric values
if numberOfCirclesToReturn > 0 && size(centers,1) > numberOfCirclesToReturn
    circles.centers = centers(1:numberOfCirclesToReturn,:);
    circles.radii = radii(1:numberOfCirclesToReturn);
    circles.metric = metric(1:numberOfCirclesToReturn);
else
    circles.centers = centers;
    circles.radii = radii;
    circles.metric = metric;
end

if showResults
    % Display the original image
    display_image(im,figNo,'Detected circles')
    
    % Draw the circle perimeter for the strongest circles
    viscircles(circles.centers, circles.radii,'EdgeColor','b');
    hold on
    for k = 1 : size(circles.centers,1)
        plot(circles.centers(k,1),circles.centers(k,2),'r+')
    end
    hold off
    drawnow;
end

