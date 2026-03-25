function import_data_biofilmq(fileName, varName)
    %IMPORT_STATS Imports the "stats" field from the specified file and assigns it the specified variable name
    %  fileName: Name of the .mat file to read
    %  varName: Desired name for the imported "stats" variable

    % Check if the file exists
    disp(['Trying to load file: ', fileName]);
    if exist(fileName, 'file') ~= 2
        error(['File does not exist: ', fileName]);
    end

    % Import the file
    try
        newData = load('-mat', fileName);
    catch
        error('Failed to load the file. Ensure it is a valid .mat file.');
    end

    % Check if 'stats' field exists
    if isfield(newData, 'stats')
        assignin('base', varName, newData.stats);
    else
        error('The field "stats" does not exist in the file.');
    end
end