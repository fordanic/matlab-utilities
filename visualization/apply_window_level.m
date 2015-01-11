function [output] = apply_window_level(input, windowCenter, windowWidth)
% APPLY_WINDOW_LEVEL Rescales values of input to [0,1] by applying specified window level
%
% [output] = apply_window_level(input, windowCenter, windowWidth)
%
% INPUT ARGUMENTS
% input         - Input volume to apply window level to
% windowCenter  - Center of window
% windowWidth   - Width of window
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT
% output        - Output with adjusted pixel values

% Copyright (c) 2014 Daniel Forsberg
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

output = input(:);

output = output - (windowCenter - windowWidth/2);
output(output < 0) = 0;
output(output > windowWidth) = windowWidth;
output = output / windowWidth;
output = reshape(output,size(input));