function [columnHandle  refLineMarkerHandle]  = markColumn(handles,x, width)
global data
    [height stam] = size(data.imgData); %#ok<NASGU>
    axes(handles.image);
    theColor = createRandomColor();
    columnHandle = rectangle( 'Position',[x,1, width,height], 'EdgeColor',theColor); 
    refLineMarkerHandle = drawCellMarkerBasedOnCellColumn(handles, x, width, theColor);
    set(columnHandle, 'UserData', refLineMarkerHandle);
    set(columnHandle,'Tag','cellCol');
    set(columnHandle, 'ButtonDownFcn', @cellMarked);    
    set(refLineMarkerHandle, 'UserData', columnHandle);
    set(refLineMarkerHandle,'Tag','cellMarker');
    set(refLineMarkerHandle, 'ButtonDownFcn', @cellMarked);

function refLineMarkerHandle = drawCellMarkerBasedOnCellColumn(handles, x, width, color)
global data
    [numOfPoints stam] = size(data.refLineX);
    startInd =uint16( x);
    endInd = uint16((x+width));
    axes(handles.referenceImage);
    subLineX = data.refLineX(startInd : endInd);
    subLineY = data.refLineY(startInd : endInd);
    refLineMarkerHandle =  line(subLineX, subLineY, 'Color', color);