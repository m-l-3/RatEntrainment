function numbersArray = convertStringToNumbersArray(inputString)
    
    if isempty(inputString)
        disp('Input string is empty. Returning an empty array.');
        numbersArray = [];
        return;
    end
    
    % Split the string by commas
    parts = strsplit(inputString, ', ');
    
    % Initialize an empty array to store the numbers
    numbersArray = [];
    
    % Loop through each part and process
    for i = 1:length(parts)
        % Check if the part contains a colon, indicating a range
        if contains(parts{i}, ':')
            % Split the range into start and end values
            rangeParts = strsplit(parts{i}, ':');
            rangeStart = str2double(rangeParts{1});
            rangeEnd = str2double(rangeParts{2});
            
            % Generate the range of numbers and append to the array
            numbersArray = [numbersArray, rangeStart:rangeEnd];
        else
            % Convert the part to a number and append to the array
            numbersArray = [numbersArray, str2double(parts{i})];
        end
    end
end
