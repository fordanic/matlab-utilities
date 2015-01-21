# matlab-utilities

This repository contains a number of different utility functions 
that are re-used in some of my other MATLAB repositories here on 
GitHub. As such, the included functions might not be so existing 
on their own. :-) Hopefully other toolboxes published will be of 
greater relevance.

# Copyright

Copyright (c) 2015 Daniel Forsberg
danne.forsberg@outlook.com

# Setup

To use the code available in this repository, add the following 
lines to your startup.m file.

addpath('<your path to where you keep the repository>');
addpath_recurse('<your path to where you keep the repository>');

setup_matlab_utilities_repository();

The last line will make sure to compile included mex-files and 
keep them up to date.

If you don't have a startup.m file, create it from startupsav.m.
Run the 'userpath' function to determine where MATLAB looks for 
the startup.m file.

# Content

This section provides a brief overview of the content in the 
different folders

dicom - This folder contains code for processing of dicom files.

external - This folder contains code from external sources that I
make regular use of. Some of them can be found on MATLAB FileExchange.

io - This folder contains code for input/output (read/write)

signal-processing - This folder contains functions related to processing 
of scalar valued data, this includes code for 1D-4D data

util - This folder contains various utility functions

visualization - This folder contains functions related to 
visualization of data, regardless of dimensionality

# Adding folders

When adding a new folder in the base folder make sure to update 
this file.

# Coding standard

Basic guidelines for a simple coding standard are given in the document 
"Matlab Programming Style Guidelines.pdf"

# Adding m-files

To create a suitable file header for new M-files, use the function 
create_new_m_function.

# Licensing

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Source code provided in this repository is generally released under 
the GNU GENERAL PUBLIC LICENSE Version 3, if not otherwise stated.