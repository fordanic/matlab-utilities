function setup_matlab_utilities_repository()
% SETUP_MATLAB_UTILITIES_REPOSITORY Call this function to setup and compile necessary files
%
% setup_matlab_utilities_repository

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

%% Compile mex files
[externalPath,~,~] = fileparts(mfilename('fullpath'));

compile_mex_files([externalPath,filesep,'external'],...
    'fileExtension','cpp','compilerInstructions','-O');