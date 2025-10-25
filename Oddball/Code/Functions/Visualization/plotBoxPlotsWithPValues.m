function plotBoxPlotsWithPValues(varargin)
    % varargin: variable input arguments, each representing an array of data
    numGroups = nargin;
    combinedData = [];
    group = [];
    labels = cell(1, numGroups);

    % Combine data and create grouping variable
    for i = 1:numGroups
        array = varargin{i};
        combinedData = [combinedData, array];
        group = [group; repmat(i, length(array), 1)];
        labels{i} = sprintf('Group %d', i);
    end

    % Plot the box plot
    figure;
    boxplot(combinedData, group, 'Labels', labels);
    ylabel('Values');
    title('Box Plot with Significance Stars');

    % Calculate p-values and add significance stars
    pairs = nchoosek(1:numGroups, 2);
    pValues = zeros(size(pairs, 1), 1);
    for k = 1:size(pairs, 1)
        pValues(k) = ranksum(varargin{pairs(k, 1)}, varargin{pairs(k, 2)});
    end
    sigstar(num2cell(pairs, 2), pValues);

    % Display p-values
    fprintf('P-values:\n');
    for k = 1:size(pairs, 1)
        fprintf('Group %d vs Group %d: %f\n', pairs(k, 1), pairs(k, 2), pValues(k));
    end
end
