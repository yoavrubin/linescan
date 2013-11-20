function updateLinescanImage(newImageValue)
global data lineScanFigureHandles
    cellsData = extractCellsData();
    data.imgData = newImageValue;
    axes(lineScanFigureHandles.image)
    imshow( imadjust(data.imgData));
    drawBadArea(data.badAreas, lineScanFigureHandles.image);
    redrawColumns(cellsData);
    
function cellsData = extractCellsData()
global cells

numOfCells = numel(cells);
cellsData = [];
for i=1:numOfCells
    cell = cells(i);
    pos = get(cell.columnHandle,'Position');
    cellData.x = pos(1);
    cellData.w = pos(3);
    cellData.color = get(cell.columnHandle,'EdgeColor');
    cellData.isNeuron = cell.isNeuron;
    cellsData = [cellsData; cellData];
end

function redrawColumns(cellsData)
global cells markedCell
    cells = [];
    numOfCells = numel(cellsData);
    for i=1:numOfCells
        drawColumn(cellsData(i).x, cellsData(i).w, cellsData(i).color, cellsData(i).isNeuron);
    end
    markedCell.col = 0;
    markedCell.marker = 0;    
