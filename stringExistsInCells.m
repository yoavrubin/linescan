function hasString = stringExistsInCells(string, cells)
    hasString = 0;
    numOfCells = numel(cells);
    for i=1:numOfCells
        if(strcmp(string, cells{i}))
            hasString = 1;
            return;
        end
    end