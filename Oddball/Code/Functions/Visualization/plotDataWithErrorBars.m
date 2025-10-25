function [legendHandles, legendLabels] = plotDataWithErrorBars(is_connectLine, colors, lineColors, xticks_label, varargin)
    
    % Number of datasets
    numDataSets = length(varargin);

    % Find the maximum length of the data arrays
    maxLength = max(cellfun(@length, varargin(1:numDataSets)));

    % Pad data arrays with NaN
    paddedData = NaN(maxLength, numDataSets);
    scatterX = NaN(maxLength, numDataSets);
    for i = 1:numDataSets
        data = varargin{i};
        paddedData(end-length(data)+1:end, i) = data;
        scatterX(end-length(data)+1:end, i) = i - 0.1 + 0.2 * (1:length(data)) / length(data);
%         scatterX(end-length(data)+1:end, i) = i * ones(1,length(data));
    end
    
    % Calculate means and standard errors, ignoring NaN values
    means = nanmean(paddedData);
    stds = nanstd(paddedData);
    stdErrors = stds ./ sqrt(sum(~isnan(paddedData)));

    % Create figure
    hold on;

    % Plot bars
    for i = 1:numDataSets
        bar(i, means(i), 'FaceColor', colors(i, :), 'EdgeColor', 'none', 'BarWidth', 0.6);
    end
    
    xticks(1:numDataSets)
	xticklabels(xticks_label)

    % Plot error bars
    h = ploterr(1:numDataSets, means, [], stdErrors, 'k.', 'abshhxy', 0);

    % Plot individual data points
    for i = 1:numDataSets
        dataPoints = varargin{i};
        scatter(scatterX(end-length(dataPoints)+1:end, i), dataPoints, ...
            'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', colors(i, :), ...
            'LineWidth', 0.01, 'SizeData', 7);
%         s = scatter(scatterX(end-length(dataPoints)+1:end, i), dataPoints, ...
%                     'MarkerEdgeColor', colors(i, :), 'MarkerFaceColor', colors(i, :));
%         s.MarkerFaceAlpha = 0.1;
%         s.MarkerEdgeAlpha = 0.1;
    end

    % Plot lines connecting rows of the paddedData matrix
    legendHandles = [];
    if is_connectLine
            numRows = size(paddedData, 1);
            legendLabels = arrayfun(@(idx) sprintf('Rat %d', 14 - numRows + idx), 1:numRows, 'UniformOutput', false);
            legendLabels{end} = 'Rat 14'; % Ensure the last row is labeled 'Rat 14'
            legendLabels(strcmp(legendLabels, 'Rat 10')) = []; % Remove 'Rat 10'
            legendLabels = [{'Rat 7'}, legendLabels];  % Add 'Rat 5' at the beginning
            legendLabels = legendLabels(~cellfun('isempty', legendLabels)); % Remove empty cells
            

            for i = 1:maxLength
                dataRow = paddedData(i, :);
                validIndices = ~isnan(dataRow);
                if sum(validIndices) > 1
                    % X-coordinates matching the corresponding data point x-coordinates
                    xVals = scatterX(i, validIndices);
                    h = plot(xVals, dataRow(validIndices), 'Color', lineColors(i,:), 'LineWidth', 1.5);
                    legendHandles = [legendHandles, h];
                end
            end
    end

    if max(means) > 10
%         pval_tail = 'right';
%         ylabel('Latency (ms)')
%         ylim([0.75*min(means) 1.25*max(means)])
        eq_fac1 = 1.1;
        eq_fac2 = 0.03;
    else
%         pval_tail = 'left';
%         ylabel('Amp.')
%         ylim([0 2.2*max(means)])
        eq_fac1 = 1.4;
        eq_fac2 = 0.2;
    end
%     pval_tail = 'both';

    % Test of significance using paddedData matrix, keeping NaN
    for i = 1:numDataSets
        for j = i + 1:numDataSets
            if(means(i)<means(j))
                pval_tail = 'left';
            else
                pval_tail = 'right';
            end
%             [pval, ~, ~] = signrank(paddedData(:, i), paddedData(:, j), 'tail', pval_tail);
%             [pval, ~, ~] = signtest(paddedData(:, i), paddedData(:, j), 'tail', pval_tail);
            [~, pval] = ttest(paddedData(:, i), paddedData(:, j), 'tail', pval_tail);
            mysigstar(gca, [i j], eq_fac1*max(means) + eq_fac2 * max(means) * (j - i), pval);
        end
    end

    % Add legend for the connecting lines only
    if is_connectLine
%         legend(legendHandles, legendLabels, 'Location', 'Best');
%         legend(legendHandles, legendLabels, 'Position', [0.46, 0.46, 0.1, 0.1], 'Units', 'normalized');
    end
    
    hold off;
end
