function  cell = getCellAtPosition(x)
global cells
    cell = [];
    numOfCells = size(cells);
    for i=1:numOfCells
        cellPos = get(cells(i).columnHandle,'Position');
        if(cellPos(1) == x)
            cell = cells(i);
            return;
        end
    end