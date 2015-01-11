function [output] = subdata(input, limits)
% SUBDATA Extracts the data from input according to limits 
% 
% [output] = subdata(input, limits)
%
% INPUT ARGUMENTS
% input             - Input data to extract data from
% limits            - Defining data to extract, given in voxel positions
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% output            - Extracted data

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

dims = ndims(input);

switch dims
    case 2
        xmin = limits(1);
        xmax = limits(2);
        ymin = limits(3);
        ymax = limits(4);
        
        [x, y] = meshgrid(xmin:xmax,ymin:ymax);
        
        output = ba_interp2(input,x,y,'nearest');
    case 3
        xmin = limits(1);
        xmax = limits(2);
        ymin = limits(3);
        ymax = limits(4);
        zmin = limits(5);
        zmax = limits(6);
        
        [x, y, z] = meshgrid(xmin:xmax,ymin:ymax,zmin:zmax);
        
        output = ba_interp3(input,x,y,z,'nearest');
    otherwise
        error('Only supports 2D/3D data')
end