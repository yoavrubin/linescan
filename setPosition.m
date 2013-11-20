function setPosition(value)
global data state lineScanFigureHandles
    if(data.currentPosition == value)
     return;
    else
     data.currentPosition = value;
    end
    if(state.settingPosition == 1)
        return;
    end
    state.settingPosition =1;
    setImageLocationWithinPanel(data.imgData,lineScanFigureHandles.image,value);
    set(lineScanFigureHandles.imageScroller,'Value',value);
    [displayWindowMinY displayWindowMaxY] = getViewedWindowEnds(data.imgData, lineScanFigureHandles.imageHoldingPanel,lineScanFigureHandles.imageScroller);
    updateCellTagsLocation(value, displayWindowMinY, displayWindowMaxY);
    if (strcmp(state.data,'noData'))
        state.settingPosition = 0;
        return;
    end
    displayWindowMinY = uint32(double(displayWindowMinY)*data.pixelResamplingFactor);
    displayWindowMaxY = uint32(double(displayWindowMaxY)*data.pixelResamplingFactor);
    setDisplayedData(lineScanFigureHandles.flourecenceData, data.flourecencePlotData, displayWindowMinY, displayWindowMaxY, 1);
    setDisplayedData(lineScanFigureHandles.dFData, data.dfPlotData, displayWindowMinY, displayWindowMaxY,2);
    setDisplayedData(lineScanFigureHandles.firstDerivationAxes, data.firstDerivation, displayWindowMinY, displayWindowMaxY,3);
    state.settingPosition =0;

function setAxesWidth(axesHandle,width)
    pos = get(axesHandle,'Position');
    pos(3) = width;
    set(axesHandle,'Position', pos)

function setDisplayedData(axesHandle, plotData, leftIndex, rightIndex, stimuliGhoustAxisIndex)
    [axesYmin  axesYMax yRange] =  getEdgesAndRange(axesHandle);
    leftIndexValue = plotData(leftIndex);
    bottomY =(leftIndexValue  + axesYmin)/2;
    topY = (leftIndexValue + axesYMax)/2;
    leftMostX = double(leftIndex);
    w = double(rightIndex - leftIndex);
    h = topY - bottomY;
    rect = get(axesHandle,'UserData');
    if(~isempty(rect))
        set(rect, 'Position',[leftMostX bottomY w h]);
    else
        rect = rectangle('Parent',axesHandle,'Position',[leftMostX bottomY w h],'EdgeColor','r');
        set(axesHandle,'UserData', rect);
    end
    
    
function updateCellTagsLocation(value, minY, maxY)
global  cells
    yLocation = minY + 0.8 * (maxY-minY);
    numCells = numel(cells);
    for i=1:numCells
        cell = cells(i);
        pos = get(cell.columnTagHandle,'Position');
        pos(2) = yLocation;
        set(cell.columnTagHandle,'Position',pos);
    end
 
 
 