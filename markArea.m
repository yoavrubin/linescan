function markArea(src)
global data lineScanFigureHandles
    dt = get(src,'UserData');
    sourceAxesHandle = dt.axesHandle;
    rect = getrect(sourceAxesHandle);
    origData = -1;
    switch sourceAxesHandle
        case lineScanFigureHandles.flourecenceData,
            origData = data.flourecencePlotData;
        case lineScanFigureHandles.dFData,
            origData =  data.dfPlotData;
        case lineScanFigureHandles.firstDerivationAxes,
            origData = data.firstDerivation;
        case lineScanFigureHandles.stimuliData,
            origData = data.stimData;
    end
    markedHandles = [];
    markedHandles =[markedHandles ; drawScaledRectandleValues(origData, data.flourecencePlotData, rect,lineScanFigureHandles.flourecenceData,sourceAxesHandle)];
    markedHandles =[markedHandles ;  drawScaledRectandleValues(origData, data.dfPlotData, rect,lineScanFigureHandles.dFData,sourceAxesHandle)];
    markedHandles =[markedHandles ; drawScaledRectandleValues(origData, data.firstDerivation, rect,lineScanFigureHandles.firstDerivationAxes,sourceAxesHandle)];
    [stam rectWidth]= size(data.imgData);
    rect = rectangle('Parent',lineScanFigureHandles.image,'Position',[2 rect(1) rectWidth-4 rect(3)], 'EdgeColor','g');
    cmenu = uicontextmenu;
    uimenu(cmenu,'Label','Remove','Callback',@removeMarkedArea,'UserData',rect);
    set(rect,'UIContextMenu',cmenu);
    markedHandles =[markedHandles ; rect]; 
    numOfhandles = numel(markedHandles);
    for i=1:numOfhandles
        sourceArea = markedHandles(i);
        restOfAreas = [];
        for j=1:numOfhandles
            if(i==j)
                continue;
            else
                restOfAreas = [restOfAreas;markedHandles(j)];
            end
        end
        set(sourceArea,'UserData',restOfAreas);
    end

function removeMarkedArea(src,eventData)
    sourceRectangle = get(src,'UserData');
    allRectangles = [sourceRectangle; get(sourceRectangle,'UserData')];
    numOfRects = numel(allRectangles);
    for i = 1:numOfRects
        delete(allRectangles(i));
    end