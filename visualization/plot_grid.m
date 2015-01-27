function plot_grid(displacementField,varargin)
% PLOT_GRID Plots the grid of a displacement field
%
% plot_grid(displacementField)
%
% INPUT ARGUMENTS
% displacementField         - Displacement field to plot
%
% OPTIONAL INPUT ARGUMENTS
% 'spacing'                 - Spacing between grid points
% 'color'                   - Color of grid
% 'lineWidth'               - Width of displayed grid
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

%%

% Setup default parameter
spacing   = [5,5,5];
color     = 'b';
lineWidth = 1;

% Overwrites default parameter
for k=1:2:length(varargin)
    eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end

%%

dims = ndims(displacementField{1});

m = size(displacementField{1});

switch dims
    case 2
        [x,y] = meshgrid(1:m(2),1:m(1));
        Y = [displacementField{1}(:)+x(:) displacementField{2}(:)+y(:)];
    case 3
        [x,y,z] = meshgrid(1:m(2),1:m(1), 1:m(3));
        Y = [displacementField{1}(:)+x(:) ...
            displacementField{2}(:)+y(:) ...
            displacementField{3}(:)+z(:)];
    otherwise
        error('Only 2D/3D data is supported');
end

% Picks the j-th coordinate
y = @(j) reshape(Y(:,j),m);

% Save current hold status
isHold = ishold;
if ~isHold
    cla;
end

% Hold
hold on;

switch dims,
    case 2
        J1 = 1:spacing(1):m(1);
        y1 = reshape(y(1),m);
        J2 = 1:spacing(2):m(2);
        y2 = reshape(y(2),m);
        p1 = plot(y1(:,J2),y2(:,J2));
        p2 = plot(y1(J1,:)',y2(J1,:)');
        ph = [p1;p2];
    case 3
        p1 = plot3d(y(1),y(2),y(3),m,[1,2,3],spacing);
        p2 = plot3d(y(1),y(2),y(3),m,[2,1,3],spacing);
        p3 = plot3d(y(1),y(2),y(3),m,[3,1,2],spacing);
        ph = [p1;p2;p3];
    otherwise
        error('Only 2D/3D data is supported');
end

if length(color) == 1
    color = char(color);
end;
set(ph,'color',color,'linewidth',lineWidth);

if ~isHold
    hold off;
end

end

function ph = plot3d(y1,y2,y3,m,order,s)
m  = m(order);
s  = s(order);
y  = @(y) reshape(permute(y,order),m(1),m(2)*m(3));
y1 = y(y1); y2 = y(y2); y3 = y(y3);
J2 = 1:s(2):m(2);
J3 = 1:s(3):m(3);
K2 = J2'*ones(1,length(J3));
K3 = ones(length(J2),1)*(m(2)*(J3-1));
K = K2(:)+K3(:);
ph = plot3(y1(:,K),y2(:,K),y3(:,K));
end