function index = getCellWithColor(color)
global cells
    index = [];
    [numOfCells stam] = size(cells);
    for i=1:numOfCells
        tmpCell = cells(i);
        if(tmpCell.color == color)
            index = i;
            return;
        end
    end