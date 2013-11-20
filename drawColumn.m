function [columnHandle  refLineMarkerHandle]  = drawColumn(x, width, theColor, isNeuron, varargin)
global data cells lineScanFigureHandles
    [height stam] = size(data.imgData); %#ok<NASGU>
    columnHandle = rectangle('Position',[x,1, width,height], 'EdgeColor',theColor, 'Parent',lineScanFigureHandles.image); 
    if (isempty(varargin))
        cell.name = strcat('C__',num2str(data.nextColIndex));
    else
        nm = varargin{1};
        cell.name = nm{1};
    end
    [refLineMarkerHandle  refLineLabelHandle columnTagHandle]= drawCellMarkerBasedOnCellColumn( x, width, theColor,cell.name);
    cell.columnHandle = columnHandle;
    cell.refLineLabelHandle = refLineLabelHandle;
    cell.refLineMarkerHandle = refLineMarkerHandle;
    cell.columnTagHandle = columnTagHandle;
    cell.isNeuron = isNeuron;
    cell.color = theColor;
    cell.F = [];
    cell.dF = [];
    cell.firstDerivation = [];
    cell.stimuli = [];
    cell.spikes = [];
    cells = [cells;cell];
    updateCellData(numel(cells),x, width);
    data.nextColIndex = data.nextColIndex+1;
    cmenu = getContextMenuForColumn(cell);
    set(columnHandle, 'UserData', refLineMarkerHandle);
    set(columnHandle,'Tag','cellCol');
    set(columnHandle, 'ButtonDownFcn', @cellMarked);    
    set(columnHandle,'UIContextMenu',cmenu);
    set(refLineMarkerHandle, 'UserData', columnHandle);
    set(refLineMarkerHandle,'Tag','cellMarker');
    set(refLineMarkerHandle, 'ButtonDownFcn', @cellMarked);
    set(refLineMarkerHandle,'UIContextMenu',cmenu);
    

function  [refLineMarkerHandle  refLineLabelHandle, columnTagHandle] = drawCellMarkerBasedOnCellColumn(x, width, color, cellName)
global lineScanFigureHandles data
    [subLineX subLineY] = getColumnReferenceLinePoints(x, width);
    refLineMarkerHandle =  line('XData',subLineX,'YData', subLineY,'Parent',lineScanFigureHandles.referenceImage, 'Color', color);
    refLineLabelHandle = text(subLineX(1)-3, subLineY(1)-3, cellName,'Color', color,'Parent',lineScanFigureHandles.referenceImage,'FontSize',13,'FontName','FixedWidth','FontWeight','bold','Interpreter','none');
    [minY maxY] = getViewedWindowEnds(data.imgData, lineScanFigureHandles.imageHoldingPanel,lineScanFigureHandles.imageScroller);
    yLoc = minY + 0.8 * (maxY-minY);
    columnTagHandle = text('Position', [uint16(x) yLoc],'String', cellName,'Parent',lineScanFigureHandles.image,'Color', color,'FontSize',13,'FontName','FixedWidth','FontWeight','bold','Interpreter','none');
    if(get(lineScanFigureHandles.showColumnsNameBtn,'Value'))
        visibleValue = 'on';
    else
        visibleValue = 'off';
    end       
    set(columnTagHandle,'Visible',visibleValue);
    
    
function cellMarked(src,eventdata) 
    deselectMarkedCell();
    type = get(src,'Tag');
    if(strcmp(type,'cellMarker'))
        cellMarker = src;
        cellCol = get(src,'UserData');
    else
        cellCol = src;
        cellMarker = get(src,'UserData');
    end
    selectCell(cellCol,cellMarker);