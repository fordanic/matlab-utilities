function R = compose_rotation(phiX,phiY,phiZ)
% COMPOSE_ROTATION Composes rotation matrix defined by the sequential rotation around the standard x-, y- and z-axis
%
% R = compose_rotation(phiX,phiY,phiZ)
%
% INPUT ARGUMENTS
% phiX          - Rotation around X
% phiY          - Rotation around Y
% phiZ          - Rotation around Z
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% R             - Composed rotation matrix

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

	X = eye(3,3);
	Y = eye(3,3);
	Z = eye(3,3);

    X(2,2) = cos(phiX);
    X(2,3) = -sin(phiX);
    X(3,2) = sin(phiX);
    X(3,3) = cos(phiX);

    Y(1,1) = cos(phiY);
    Y(1,3) = sin(phiY);
    Y(3,1) = -sin(phiY);
    Y(3,3) = cos(phiY);

    Z(1,1) = cos(phiZ);
    Z(1,2) = -sin(phiZ);
    Z(2,1) = sin(phiZ);
    Z(2,2) = cos(phiZ);

	R = Z*Y*X;
end