function plot_main_effects(independentVariables,dependentVariables,...
    independentLabels,dependentLabels,varargin)
% PLOT_MAIN_EFFECTS plots the main interaction effects as given by the data
%
% plot_main_effects(independentVariables,dependentVariables,independentLabels,dependentLabels)
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
% For each indenpendent variable
for k = 1 : length(independentLabels)
    % For each dependent variable
    for l = 1 : length(dependentLabels)
        subplot(length(dependentLabels),length(independentLabels),...
            (l-1)*length(independentLabels)+k)
        cla
        hold on
        iVar = independentVariables(:,k);
        iVarUnique = unique(iVar);
        for m = 1 : length(iVarUnique)
            yData = double(dependentVariables(strcmp(iVar,iVarUnique(m)),l));
            if strcmp(plotType,'distribution') && length(yData) > 5
                pd = fitdist(yData,'lognormal');
                yCenter = icdf('logn',0.5,pd.mu,pd.sigma);
                yTop = icdf('logn',1-(1-significanceLevel)/2,pd.mu,pd.sigma);
                yBottom = icdf('logn',(1-significanceLevel)/2,pd.mu,pd.sigma);
                plot(m,yCenter,'ro');
                line([m m],[yTop yBottom],'color','b')
                line(m+[-0.3 0.3],yTop*[1 1],'color','b')
                line(m+[-0.3 0.3],yBottom*[1 1],'color','b')
            elseif strcmp(plotType,'dotplot')
                xData = repmat(m,[1 length(yData)]) + uniform(-0.25,0.25,[1 length(yData)]);
                plot(xData,yData,'+b','MarkerSize',3)
            end
            if length(iVarUnique{m}) > 10
                iVarUnique{m} = iVarUnique{m}(1:10);
            end
        end
        set(gca,'XTick',1:length(iVarUnique),'XLim',[0 length(iVarUnique)+1])
        set(gca,'xTickLabel',strrep(iVarUnique,'_',' '),...
            'XTickLabelRotation',45)
        ylabel(dependentLabels{l})
        xlabel(independentLabels{k})
        hold off
        yLim = ylim;
        ylim([0 yLim(2)])
    end
end
figure_title('Main effects')
