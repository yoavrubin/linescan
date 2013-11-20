function dfBoundsInMs = getDfBoundsInMs(cell)
    [rows cols] = size(cell.dF);
    startPoint = pixelToTime(1);
    endPoint = pixelToTime(rows);
    step = pixelToTime(1);
    dfBoundsInMs = (startPoint:step:endPoint);
