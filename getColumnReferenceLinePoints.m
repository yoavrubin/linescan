function [subLineX subLineY] = getColumnReferenceLinePoints(x, width)
global data
    [numOfPoints stam] = size(data.refLineX);
     [stam rectWidth]= size(data.imgData);
    startInd =uint16( x *(numOfPoints/rectWidth));
    endInd = uint16((x+width)*(numOfPoints/rectWidth));
    subLineX = data.refLineX(startInd : endInd);
    subLineY = data.refLineY(startInd : endInd);