function [overlap,overlapPerLabel] = compute_overlap_coefficient(labelVolume,groundTruth,metric)
% COMPUTE_OVERLAP_COEFFICIENT Computes an overlap coefficient for a given label volume and its corresponding ground truth
%
% [overlap,overlapPerLabel] = compute_overlap_coefficient(labelVolume,groundTruth)
%
% INPUT ARGUMENTS
% labelVolume                   - Computed label volume, assumes 0 to be
%                                 background
% groundTruth                   - Ground truth data
% metric                        - Overlap metric to compute
%                                 TO - target overlap
%                                 UO - union overlap
%                                 FP - false positive (amount of oversegmentation)
%                                 FN - false negative (amount of undersegmentation)
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% overlap                       - Computed overlap coefficients
% overlapPerLabel               - Computed overlap coefficients per label

% Copyright (c) 2015 Daniel Forsberg
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

% Extract labels, assumes label = 0 to be background
labels = unique(vec(groundTruth(groundTruth>0)));

% Initialize numerator and denominator
numerator = 0;
denominator = 0;

overlapPerLabel = zeros(length(labels),1);

% Add for each label
for k = 1 : length(labels)
    label = labels(k);
    switch lower(metric)
        case 'to'
            num = sum(labelVolume(:) == label & groundTruth(:) == label);
            den = sum(groundTruth(:) == label);
        case 'uo'
            num = sum(labelVolume(:) == label & groundTruth(:) == label);
            den = sum(labelVolume(:) == label | groundTruth(:) == label);
        case 'fn'
            num = sum(groundTruth(labelVolume(:) ~= label) == label);
            den = sum(groundTruth(:) == label);
        case 'fp'
            num = sum(labelVolume(groundTruth(:) ~= label) == label);
            den = sum(labelVolume(:) == label);
        otherwise
            warning('Unknown metric, running target overlap instead.')
            num = sum(labelVolume(:) == label & groundTruth(:) == label);
            den = sum(groundTruth(:) == label);
    end
    numerator = numerator + num;
    denominator = denominator + den;
    overlapPerLabel(k) = num/den;
end

% Compute total DICE
overlap = numerator / denominator;