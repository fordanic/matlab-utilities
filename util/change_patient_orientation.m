function [output] = change_patient_orientation(input, patientOrientation, newPatientOrientation)
% CHANGE_PATIENT_ORIENTATION Changes the patient orientation of the provided data.
%
% [output] = change_patient_orientation(input, patientOrientation, newPatientOrientation)
%
% INPUT ARGUMENTS
% input                 - Input data to re-orient
% patientOrientation    - Current patient orientation
% newPatientOrientation - Desired patient orientation
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% output                - Re-oriented output data

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

% Check if patient orientation is same as new patient orientation
if strcmp(patientOrientation,newPatientOrientation)
    output = input;
    return
end

% Determine order of axis for patient orientation and new patient
% orientation
currentOrder = [strfind(patientOrientation,'L') strfind(patientOrientation,'R') ...
    strfind(patientOrientation,'P') strfind(patientOrientation,'I') ...
    strfind(patientOrientation,'S') strfind(patientOrientation,'A')];

newOrder = [strfind(newPatientOrientation,'L') strfind(newPatientOrientation,'R') ...
    strfind(newPatientOrientation,'P') strfind(newPatientOrientation,'I') ...
    strfind(newPatientOrientation,'S') strfind(newPatientOrientation,'A')];

% Change order of axis
if sum(newOrder == currentOrder) == 3
    output = input;
else
    newOrder = [find(newOrder == currentOrder(1)) ...
        find(newOrder == currentOrder(2))...
        find(newOrder == currentOrder(3))];
    output = permute(input,newOrder);
    patientOrientation = [patientOrientation(newOrder(1)) ...
        patientOrientation(newOrder(2)) ...
        patientOrientation(newOrder(3))];
end

% Flip dimensions if needed
for k = 1 : 3
    if patientOrientation(k) ~= newPatientOrientation(k)
        output = flipdim(output,k);
    end
end