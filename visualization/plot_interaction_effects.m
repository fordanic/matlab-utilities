function plot_interaction_effects(independentVariables,dependentVariables,...
    independentLabels,dependentLabels,varargin)
% PLOT_INTERACTION_EFFECTS plots the first order interaction effects as given by the data
%
% plot_interaction_effects(independentVariables,dependentVariables,independentLabels,dependentLabels)
%
% INPUT ARGUMENTS
% independentVariables          Matrix with independent variables
%                               column-wise
% dependentVariables            Matrix with dependent variables
%                               column-wise
% independentLabels             Cell with independent variable labels
% DependentLabels               Cell with dependent variable labels
%
% OPTIONAL INPUT ARGUMENTS
% figureNumber                  Number of figure to plot in
% plotType                      Type of plot, 'distribution' or 'dotplot'
%
% OUTPUT
% N/A

% Copyright (c) 2015 Daniel  Forsberg
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

%% Default parameters
figureNumber = 1;
plotType = 'dotplot';
significanceLevel = 0.95;
% Overwrites default parameter values
for k=1:2:length(varargin)
    eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end

%%
figure(figureNumber)
clf
xTickLabels = {};
% For each dependent variable
for k = 1 : length(dependentLabels)
    subplot(length(dependentLabels),1,k)
    cla
    hold on
    xInd = 0;
    iVar1 = independentVariables(:,1);
    iVar1Unique = unique(iVar1);
    % For each value of first independent variable
    for l = 1 : length(iVar1Unique)
        % For each value of second independent variable
        iVar2 = independentVariables(:,2);
        iVar2Unique = unique(iVar2);
        for m = 1 : length(iVar2Unique)
            if length(independentLabels) == 2
                % Get data
                yData = double(dependentVariables(...
                    strcmp(iVar1,iVar1Unique(l)) &...
                    strcmp(iVar2,iVar2Unique(m)),k));
                if isempty(yData)
                    continue
                end
                % Update index
                xInd = xInd + 1;
                % Create labels to go with plots
                label1 = iVar1Unique{l};
                if length(label1) > 10
                    label1 = label1(1:10);
                end
                label2 = iVar2Unique{m};
                if length(label2) > 10
                    label2 = label2(1:10);
                end
                xTickLabels{xInd} = [label1,'-',label2];
                % Plot data
                plot_data(xInd,yData,plotType,significanceLevel)
            elseif length(independentLabels) == 3
                % For each value of third independent variable
                iVar3 = independentVariables(:,3);
                iVar3Unique = unique(iVar3);
                for n = 1 : length(iVar3Unique)
                    % Get data
                    yData = double(dependentVariables(...
                        strcmp(iVar1,iVar1Unique(l)) & ...
                        strcmp(iVar2,iVar2Unique(m)) & ...
                        strcmp(iVar3,iVar3Unique(n)),k));
                    if isempty(yData)
                        continue
                    end
                    % Update index
                    xInd = xInd + 1;% Create labels to go with plots
                    label1 = iVar1Unique{l};
                    if length(label1) > 10
                        label1 = label1(1:10);
                    end
                    label2 = iVar2Unique{m};
                    if length(label2) > 10
                        label2 = label2(1:10);
                    end
                    label3 = iVar3Unique{n};
                    if length(label3) > 10
                        label3 = label3(1:10);
                    end
                    xTickLabels{xInd} = [label1,'-',label2,'-',label3];
                    % Plot data
                    plot_data(xInd,yData,plotType,significanceLevel)
                end
            end
        end
        line(xInd*[1 1]+0.5,[0 max(ylim)],'color','green','linestyle','--')
    end
    set(gca,'XTick',1:xInd,...
        'XLim',[0 xInd+1])
    set(gca,'xTickLabel',strrep(xTickLabels,'_',' '),...
        'XTickLabelRotation',45)
    ylabel(dependentLabels{k})
    hold off
    yLim = ylim;
    ylim([0 yLim(2)])
end
if length(independentLabels) == 2
    figure_title(['Interaction effects ',independentLabels{1},'*',...
        independentLabels{2}])
elseif length(independentLabels) == 3
    figure_title(['Interaction effects ',independentLabels{1},'*',...
        independentLabels{2},'*',independentLabels{3}])
end
end
%%
function plot_data(xInd,yData,plotType,significanceLevel)
if length(yData) > 0
    if strcmp(plotType,'distribution') && length(yData) > 5
        % Fit distribution
        pd = fitdist(yData,'lognormal');
        % Get values for probabilities according to
        % significance levels
        yCenter = icdf('logn',0.5,pd.mu,pd.sigma);
        yTop = icdf('logn',1-(1-significanceLevel)/2,pd.mu,pd.sigma);
        yBottom = icdf('logn',(1-significanceLevel)/2,pd.mu,pd.sigma);
        % Plot distribution vlaues
        plot(xInd,yCenter,'ro');
        line([xInd xInd],[yTop yBottom],'color','b')
        line(xInd+[-0.3 0.3],yTop*[1 1],'color','b')
        line(xInd+[-0.3 0.3],yBottom*[1 1],'color','b')
    elseif strcmp(plotType,'dotplot')
        % Create suitable x-data
        xData = repmat(xInd,[1 length(yData)]) + uniform(-0.25,0.25,[1 length(yData)]);
        % Plot data
        plot(xData,yData,'+b','MarkerSize',3)
    end
end
end