function [centroidDistances] = compute_centroid_distances(labelVolume,groundTruth,spacing)
% COMPUTE_CENTROID_DISTANCES Computes the centroid distances for a given label volume and its corresponding ground truth
%
% [centroidDistances] = compute_centroid_distances(labelVolume,groundTruth,spacing)
%
% INPUT ARGUMENTS
% labelVolume                   - Computed label volume, assumes 0 to be
%                                 background
% groundTruth                   - Ground truth data
% spacing                       - Voxel spacing in mm
%
% OPTIONAL INPUT ARGUMENTS
% N/A
%
% OUTPUT ARGUMENTS
% centroidDistances             - Computed centroid distances

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

centroidDistances = zeros(length(labels),1);

% For each label
for k = 1 : length(labels)
    label = labels(k);
    
    % Label volume centroid
    [ly,lx,lz] = ind2sub(size(labelVolume),find(labelVolume(:) == label));
    labelVolumeCentroid = mean([lx ly lz]).*spacing;
    
    % Ground truth centroid
    [gty,gtx,gtz] = ind2sub(size(groundTruth),find(groundTruth(:) == label));
    groundTruthCentroid = mean([gtx gty gtz]).*spacing;
    
    % Centroid distance
    centroidDistances(k) = sqrt(sum((labelVolumeCentroid - groundTruthCentroid).^2));
end