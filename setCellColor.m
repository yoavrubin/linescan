function setCellColor(index, color)
global cells
    cell = cells(index);
    set(cell.columnHandle,'EdgeColor', color);
    set(cell.refLineMarkerHandle,'Color',color);
    set(cell.refLineLabelHandle,'Color',color);
    cells(index).color = color;
    set(cell.columnTagHandle,'Color',color);
    traces = getTracesOfColumn(cell.columnHandle);
    [numOfLines stam] = size(traces);
    for i=1:numOfLines 
        set(traces(i),'Color',color);
    end