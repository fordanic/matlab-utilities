function [mi] = mutual_information(signalA,signalB,numberOfBins)
% MUTUAL_INFORMATION Computes the mutual information between two signals
%
% function [mi] = mutual_information(signalA,signalB,numberOfBins)
%
% INPUT ARGUMENTS
% signal1       - Signal 1
% signal2       - Signal 2
% numberOfBins  - Number of bins to use for the histogram
%
% OPTIONAL INPUT ARGUMENTS
%
% OUTPUT ARGUMENTS
% mi            - Computed mutual information

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

% Vectorize signal A and B
signalA = double(signalA(:));
signalB = double(signalB(:));

numberOfElements = numel(signalA);

% Limit values of signal A and B to the given number of bins
minA = min(signalA);
maxA = max(signalA);
minB = min(signalB);
maxB = max(signalB);
signalA = round((signalA-minA)*(numberOfBins - 1) / (maxA - minA));
signalB = round((signalB-minB)*(numberOfBins - 1) / (maxB - minB));

% Estimate probability mass functions for signal A and B
mSignalA = double(repmat(signalA,1,numberOfBins) == ...
                  repmat(0:numberOfBins - 1,numberOfElements,1));
mSignalB = double(repmat(signalB,1,numberOfBins) == ...
                  repmat(0:numberOfBins - 1,numberOfElements,1));
probSignalA = sum(mSignalA) / numberOfElements;
probSignalB = sum(mSignalB) / numberOfElements;

% Estimate joint probability mass functions for signal A and B
probSignalAAndB = mSignalA' * mSignalB / numberOfElements;

% Estimate entropy of signal A and B
entropySignalA = - sum(probSignalA  .* log2(probSignalA + eps));
entropySignalB = - sum(probSignalB  .* log2(probSignalB + eps));

% Estimate joint entropy of signal A and B
entropySignalAAndB = - sum(probSignalAAndB(:) .* log2(probSignalAAndB(:) + eps));

% Estimate the mutual information of signal A and B
mi = entropySignalA + entropySignalB - entropySignalAAndB;
