function [output] = insert_into(input,data,limits)
% INSTERT_INTO Insert data into a data volume
%
% [output] = insert_into(input,data,limits)
%
% INPUT ARGUMENTS
% input             - Data to insert to
% data              - Data to insert
% limits            - Where to insert data ([xmin xmax ymin ymax zmin zmax])
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% output            - Output data

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

xmin = limits(1);
xmax = limits(2);
ymin = limits(3);
ymax = limits(4);
zmin = limits(5);
zmax = limits(6);

sz = size(input);

% Limit
xmin1 = max(xmin,1);
xmax1 = min(xmax,sz(2));
ymin1 = max(ymin,1);
ymax1 = min(ymax,sz(1));
zmin1 = max(zmin,1);
zmax1 = min(zmax,sz(3));

output = zeros(sz);
output(ymin1:ymax1,xmin1:xmax1,zmin1:zmax1) = ...
    data(1 + ymin1 - ymin:end - (ymax - ymax1),...
    1 + xmin1 - xmin:end - (xmax - xmax1),...
    1 + zmin1 - zmin:end - (zmax - zmax1));