function analyseColumn(x)
global data  state lineScanFigureHandles
    state.data = 'data';
    cell = getCellAtPosition(x);
    fAxisYData = cell.F;
    dfAxisYData = cell.dF;
    xData = (1:size(fAxisYData,1))';
    firstDerivationAxisYData = cell.firstDerivation;
    if(~isempty(data.recordingData))
        numOfPoints = double(numel(cell.F));
        stim = data.rawStims;
        numOfStims = double(numel(stim));
        step = numOfPoints / numOfStims;
        newPoints = 0:step:numOfPoints;
        data.pixelResamplingFactor = 1;
        fAxisYData = resampleSignalByPoints(fAxisYData,newPoints, numOfStims);
        dfAxisYData = resampleSignalByPoints(dfAxisYData,newPoints, numOfStims);
        firstDerivationAxisYData = resampleSignalByPoints(firstDerivationAxisYData,newPoints, numOfStims);
        stimAxisData =  stim;
        data.stimData = stimAxisData;
        w = get(cell.columnHandle,'Position');
        theShift = (x+w(3)/2);
        numStims = numel(stimAxisData);
        stimAxisData = [stimAxisData((theShift+1):numStims);zeros(theShift,1)  ];
        
        xData = (1:size(fAxisYData,1))';
        xStim = (1:size(stimAxisData,1))';
    end
    data.flourecencePlotData = fAxisYData;
    data.dfPlotData = dfAxisYData;
    data.firstDerivation = firstDerivationAxisYData;
   
    data.valuesX = xData;

     if(~isempty(data.recordingData))
        fAxisYData = [{fAxisYData} {stimAxisData}];
        dfAxisYData = [{dfAxisYData} {stimAxisData}];
        firstDerivationAxisYData = [{firstDerivationAxisYData} {stimAxisData}];
        xData = [{xData} {xStim}];
    end
    showValuesOnAxes(lineScanFigureHandles.flourecenceData,xData, fAxisYData,cell.color,1);
    showValuesOnAxes(lineScanFigureHandles.dFData,xData, dfAxisYData,cell.color,2);
    showValuesOnAxes(lineScanFigureHandles.firstDerivationAxes,xData, firstDerivationAxisYData,cell.color,3);
    if(data.usingStimuli && isempty(data.stimGhoustAxis))
        data.stimGhoustAxis = stimGhoustAxis;
    end
    scrollerPosition = get(lineScanFigureHandles.imageScroller,'Value');
    setPosition(scrollerPosition);
    
    

function newSignal = resampleSignalByPoints(oldSignal, newPoints,supposedPoints)
    newSignal = interp1(oldSignal,newPoints)';
    numOfPoints = numel(newSignal);
    if (numOfPoints < supposedPoints)
        newSignal(numOfPoints: supposedPoints) = newSignal(numOfPoints);
    end  
    
    
function showValuesOnAxes(handle, xData, yData, color, ghoustIndex)
global data
    if(numel(yData) == 2)
        minY = min(yData{1});
        maxY = max(yData{1});
    else
        minY = min(yData);
        maxY = max(yData);
    end
    if(minY == maxY)
        minY = maxY-1;
    end
    set(handle,'XColor',color,'YColor',color, 'ZColor',color, 'YLim',[minY maxY]);
    data.stimGhoustAxis(ghoustIndex) = drawDataOnAxes(handle,xData, yData);
    lineH = findobj( data.stimGhoustAxis(ghoustIndex),'Type','line');
    set(lineH, 'Color',color);
    buildContextMenuForAxes(handle,data.stimGhoustAxis(ghoustIndex));

