function createColumnsAutomatically()
    waitbarHandle = waitbar(0,'Creating columns');
    signal = transformLSImageToSignal();
    waitbar(0.1,waitbarHandle);
    %we define a 15% change between maxima and minima a significant change that
    %indicates a real maxima
    significantDelta = 0.15; 
    darknessThreshold = 0.01;
    actualZero = 0.001;
    intervals = findMaximasIntervalsInSignal(signal,significantDelta, darknessThreshold, actualZero,-1);
     waitbar(0.2,waitbarHandle);
    [numOfIntervals two] = size(intervals);
    x = -1;
    w = -1;
    cellProgress = 0.7/double(numOfIntervals);
    for i=1:numOfIntervals
        x = intervals(i,1);
        w = intervals(i,2);
        waitbar(0.2+i*cellProgress,waitbarHandle);
        drawColumn(x, w, createRandomColor(),1);
    end
    analyseColumn(x);
    waitbar(0.95,waitbarHandle);
    cell = getCellAtPosition(x);
    deselectMarkedCell();
    selectCell(cell. columnHandle, cell.refLineMarkerHandle);
    waitbar(1,waitbarHandle);
    close(waitbarHandle);