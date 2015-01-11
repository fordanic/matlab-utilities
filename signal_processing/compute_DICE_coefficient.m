function [DICE,DICEPerLabel] = compute_DICE_coefficient(labelVolume,groundTruth)
% COMPUTE_DICE_COEFFICIENT Computes the DICE coefficient for a given label volume and its corresponding ground truth
%
% [DICE,DICEPerLabel] = compute_DICE_coefficient(labelVolume,groundTruth)
%
% INPUT ARGUMENTS
% labelVolume                   - Computed label volume, assumes 0 to be
%                                 background
% groundTruth                   - Ground truth data
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% DICE                          - Computed DICE coefficient
% DICEPerLabel                  - Computed DICE coefficient per label

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

%%

% Extract labels
labels = unique(vec(groundTruth(groundTruth>0)));

% Assumes label 0 to be present, thus remove it
labels = labels(2:end);

% Initialize numerator and denominator
numerator = 0;
denominator = 0;

DICEPerLabel = zeros(length(labels),1);

% Add for each label
for k = 1 : length(labels)
    label = labels(k);
    num = 2 * sum(labelVolume(:) == label & groundTruth(:) == label);
    den = sum(labelVolume(:) == label) + sum(groundTruth(:) == label);
    numerator = numerator + num;
    denominator = denominator + den;
    DICEPerLabel(k) = num/den;
end

% Compute total DICE
DICE = numerator / denominator;