function [phiX,phiY,phiZ] = decompose_rotation(R,varargin)
% DECOMPOSE_ROTATION Performs a decompoition of a rotation matrix according to Euler and using fixed frames
%
% [phiX,phiY,phiZ] = decompose_rotation(R)
%
% INPUT ARGUMENTS
% R                     - Rotation matrix to decompose
%
% OPTIONAL INPUT ARGUMENTS
% 'eulerDecomposition'  - (true)/false, if set to false than the rotation angles
%                         around the x-, y- and z- will be computed by simply
%                         projecting the primary axis onto the standard
%                         orthogonal planes
%
% OUTPUT ARGUMENTS
% phiX                  - Rotation around X
% phiY                  - Rotation around Y
% phiZ                  - Rotation around Z

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

% Default parameters
eulerDecomposition = true;

% Overwrites default parameter
for k=1:2:length(varargin)
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end;

%%

if eulerDecomposition
    phiX = atan2(R(3,2), R(3,3));
    phiY = asin(-R(3,1));
    phiZ = atan2(R(2,1), R(1,1));
else
    xHat = [1 0 0]';
    yHat = [0 1 0]';
    zHat = [0 0 1]';
    xHatPrim = R(:,1);
    yHatPrim = R(:,2);
    zHatPrim = R(:,3);
    yHatPrimProjected = yHatPrim;
    yHatPrimProjected(3) = 0;
    yHatPrimProjected = normalize(yHatPrimProjected);
    r = vrrotvec(yHat,yHatPrimProjected);
    if r(3) > 0
        phiZ = r(4);
    else
        phiZ = -r(4);
    end
    xHatPrimProjected = xHatPrim;
    xHatPrimProjected(2) = 0;
    xHatPrimProjected = normalize(xHatPrimProjected);
    r = vrrotvec(xHat,xHatPrimProjected);
    if r(2) > 0
        phiY = r(4);
    else
        phiY = -r(4);
    end
    zHatPrimProjected = zHatPrim;
    zHatPrimProjected(1) = 0;
    zHatPrimProjected = normalize(zHatPrimProjected);
    r = vrrotvec(zHat,zHatPrimProjected);
    if r(1) > 0
        phiX = r(4);
    else
        phiX = -r(4);
    end
end

