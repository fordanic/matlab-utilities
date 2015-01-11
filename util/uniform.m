function  out = uniform(a, b, matrixSize)
% UNIFORM Creates uniform distribution between the values a and b of the provided size
%
% out = uniform(a, b, matrixSize)
% INPUT ARGUMENTS
% a             - Lower value
% b             - Upper value
% matrixSize    - Size of the distribution
% 
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% out           - Created distribution

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

out = a + (b-a).*rand(matrixSize);