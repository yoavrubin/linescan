function varargout = crossCorrelationWindow(varargin)
% CROSSCORRELATIONWINDOW M-file for crossCorrelationWindow.fig
%      CROSSCORRELATIONWINDOW, by itself, creates a new
%      CROSSCORRELATIONWINDOW or raises the existing
%      singleton*.
%
%      H = CROSSCORRELATIONWINDOW returns the handle to a new CROSSCORRELATIONWINDOW or the handle to
%      the existing singleton*.
%
%      CROSSCORRELATIONWINDOW('CALLBACK',hObject,eventData,handles,...)
%      calls the local
%      function named CALLBACK in CROSSCORRELATIONWINDOW.M with the given input arguments.
%
%      CROSSCORRELATIONWINDOW('Property','Value',...) creates a new CROSSCORRELATIONWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before crossCorrelationWindow_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to crossCorrelationWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help crossCorrelationWindow

% Last Modified by GUIDE v2.5 20-Dec-2009 11:06:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @crossCorrelationWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @crossCorrelationWindow_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before crossCorrelationWindow is made visible.
function crossCorrelationWindow_OpeningFcn(hObject, eventdata, handles, varargin)
global cells crossCorrelationData data
    % Choose default command line output for crossCorrelationWindow
    handles.output = hObject;
    crossCorrelationData.handles = handles;
    % Update handles structure
    guidata(hObject, handles);
    names = [];
    [numOfCells stam] = size(cells);
    for i=1:numOfCells
        if(~isempty(cells(i).spikes))
            names = [names; {cells(i).name}];
        end
    end
    set(handles.sourceCellCombo,'String',names);
    set(handles.targetCellList,'String',names);
    crossCorrelationData.meanLine = [];
    crossCorrelationData.SDLines = [];
    crossCorrelationData.allCrossCorrelations = [];
    crossCorrelationData.nWayCorrelationData = [];
    crossCorrelationData.groupsData = 'none';
    crossCorrelationData.chainsData = 'none';
    crossCorrelationData.groupsRawData = [];

    if(~isempty(data.referenceImageData))
        displayImage(data.referenceImageData, handles.correlationImage);
    end
    updateNumOfBins();
% UIWAIT makes crossCorrelationWindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = crossCorrelationWindow_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function minSpikesTxt_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
% --- Executes during object creation, after setting all properties.
function nWayLevel_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    
% --- Executes during object creation, after setting all properties.
function nWayNumOfStd_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function nWayCorrelationList_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function nWayMinNumfOfSpikes_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function nWayJitter_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes during object creation, after setting all properties.
function afterTxt_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function minimalSpikeTimeTxt_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function allCorrelations_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function stdCombo_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function sourceCellCombo_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function targetCellList_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function[beforeInPixels afterInPixels ] =  getCalculationParams()
global data crossCorrelationData
    before = str2num(get(crossCorrelationData.handles.beforeTxt,'String'));
    after = str2num(get(crossCorrelationData.handles.afterTxt,'String'));

    factor = data.timePerLine;
    beforeInPixels = int16(before/factor);
    afterInPixels = int16(after / factor);

% --- Executes on button press in calcBtn.
function calcBtn_Callback(hObject, eventdata, handles)
global  crossCorrelationData cells
    if(eventdata ~= -1)
        h = waitbar(0,'Please Wait, Calculating Cross Correlation', 'Name', 'Cross Correlation', 'WindowStyle', 'modal', 'Pointer', 'watch');  
    else
        h = [];
    end
    if(eventdata ~= -1)
        waitbar(0.2,h);
    end
    crossCorrelationData.data = calcCrossCorrelationBetweenSourcesAndTargets(1,get(handles.sourceCellCombo,'Value'), get(handles.targetCellList,'Value'), h, 0.2, 0.7);
    if(eventdata ~= -1)
        waitbar(0.99,h);
    end
    showCorrelationData(crossCorrelationData.data,'bar');
    set(handles.presentedCorrelationLbl,'String',['Specific Correlation, Source: ' cells(get(handles.sourceCellCombo,'Value')).name ' Target: ' cells(get(handles.targetCellList,'Value')).name]);
    close(h);

function showCorrelationOnReferenceImage(correlationData)
global crossCorrelationData
    delete(get(crossCorrelationData.handles.correlationImage,'UserData'));
    set(crossCorrelationData.handles.correlationImage,'UserData',[]);
    drawCellOnReferenceImage(correlationData.source.reference, 0,'g')
    pathCells = correlationData.source.sources;
    numOfPathCells = numel(pathCells);
    for i=1:numOfPathCells
        cellTiming = (pathCells(i).offset(1) + pathCells(i).offset(2))/2;
        cellTiming = getActualTime(cellTiming);
        drawCellOnReferenceImage(pathCells(i).name, cellTiming,'y')
    end
    drawCellOnReferenceImage(correlationData.target(1), getActualTime(correlationData.location),'r');

function drawCellOnReferenceImage(cellIndex, timing,color)
global crossCorrelationData cells
    cell = cells(cellIndex);
    if(cell.refLineLabelHandle == -1)
        return;
    end
    labelHandle = copyobj(cell.refLineLabelHandle,crossCorrelationData.handles.correlationImage);
    setContextMenuForLabel(labelHandle);
    set(labelHandle,'Color',color);
    a = get(labelHandle,'String');
    set(labelHandle, 'String',[a '@' num2str(timing) ' ms'])
    positionHandle = copyobj(cell.refLineMarkerHandle,crossCorrelationData.handles.correlationImage);
    set(positionHandle,'Color',[0 0 1],'LineWidth',2);
    dt = get(crossCorrelationData.handles.correlationImage,'UserData');
    dt = [dt;labelHandle;positionHandle];
    set(crossCorrelationData.handles.correlationImage,'UserData',dt);

function setContextMenuForLabel(h)
global crossCorrelationData
    cmn = uicontextmenu('parent',crossCorrelationData.handles.figure1);
    clrMenu = uimenu('parent',cmn, 'Label','Color');
    uimenu(clrMenu,'Label','Red','Callback',@updateMarkerColor,'UserData',[h 1 0 0]);
    uimenu(clrMenu,'Label','Green','Callback',@updateMarkerColor,'UserData',[h 0 1 0]);
    uimenu(clrMenu,'Label','Cian','Callback',@updateMarkerColor,'UserData',[h 0 1 1]);
    uimenu(clrMenu,'Label','Yellow','Callback',@updateMarkerColor,'UserData',[h 1 1 0]);
    uimenu(clrMenu,'Label','Magenta','Callback',@updateMarkerColor,'UserData',[h 1 0 1]);
    uimenu(clrMenu,'Label','White','Callback',@updateMarkerColor,'UserData',[h 1 1 1]);
    moveMenu = uimenu('parent',cmn,'Label','Move');
    uimenu(moveMenu,'Label','Down 10 pixels','Callback',@updateMarkerPosition,'UserData',[h 0 10]);
    uimenu(moveMenu,'Label','Up 10 pixels','Callback',@updateMarkerPosition,'UserData',[h 0 -10]);
    uimenu(moveMenu,'Label','Left 10 pixels','Callback',@updateMarkerPosition,'UserData',[h -10 0]);
    uimenu(moveMenu,'Label','Right 10 pixels','Callback',@updateMarkerPosition,'UserData',[h 10 0]);
    set(h,'UIContextMenu',cmn);

function updateMarkerColor(src, eventData)
    userData = get(src,'UserData');
    set(userData(1),'Color', userData(2:4));
    
function updateMarkerPosition(src, eventData)
    userData = get(src,'UserData');
    pos = get(userData(1),'Position');
    pos(1) = pos(1) + userData(2);
    pos(2) = pos(2) + userData(3);
    set(userData(1),'Position', pos);
        
    
function showCorrelationData(correlationData,displayMethod)
global crossCorrelationData
    before = str2num(get(crossCorrelationData.handles.beforeTxt,'String'));
    after = str2num(get(crossCorrelationData.handles.afterTxt,'String'));
    histCols = (-before:pixelToTime(1): after);
    if(numel(histCols) < numel(correlationData.correlation))
        histCols = [histCols histCols(numel(histCols))+pixelToTime(1)];
    end
    color = [0.3 0.6 0.8];
    if(strcmp(displayMethod,'bar'))
        barHandle = bar(histCols, correlationData.correlation, 'Parent',crossCorrelationData.handles.correlationAxes);
        set(barHandle,'FaceColor',color);
        set(barHandle,'EdgeColor',color);
        set(crossCorrelationData.handles.correlationAxes,'XLim',[-before after]);
        set(crossCorrelationData.handles.correlationAxes,'YLim',[0 max(correlationData.correlation)+1]);
    else
        plot(histCols,correlationData.correlation, 'Parent',crossCorrelationData.handles.correlationAxes,'Color',color);
    end
    set(crossCorrelationData.handles.meanLbl,'Visible','on');
    set(crossCorrelationData.handles.meanVal,'Visible','on');
    set(crossCorrelationData.handles.stdLbl,'Visible','on');
    set(crossCorrelationData.handles.stdVal,'Visible','on');
    drawStates(correlationData.correlation);

function crossCol =  calcCrossCorrelationBetweenSourcesAndTargets(allowSelfCorrelation, sources, targets, waitbarHandle, waitbarBase, waitbarDelta)
global cells %crossCorrelationData
    [before after] =  getCalculationParams();
    crossCol = [];
    numOfSources = numel(sources);
    numOfTargets= numel(targets);
    numberOfCyclesNeeded = double(numOfTargets*numOfSources);
    currentCycle = 0;
    if(~allowSelfCorrelation)
        numberOfCyclesNeeded = double(numOfTargets*(numOfSources-1)); % for the progress bar
    end
    numOfCells = numel(cells);
    for j=1:numOfSources
        sourceMaximas = cells(sources(j)).spikes.x;
        tmpCor = [];
        for i=1:numOfTargets
            if(~allowSelfCorrelation && sources(j)== targets(i))
                continue;
            end
            currentCycle = currentCycle +1;
            targetMaximas = cells(targets(i)).spikes.x;
           % disp(['j=' num2str(j) ' , i=' num2str(i)]);
            correlationData.correlation = calculateCrossCorrelation(sourceMaximas, targetMaximas,before,after);
            if(isempty(correlationData.correlation))
                continue;
            end
            correlationData.source = sources(j);
            correlationData.target = targets(i);
            tmpCor = [tmpCor ;  correlationData];
            if(~isempty(waitbarHandle))
                currentStage = waitbarDelta *   (currentCycle / numberOfCyclesNeeded);
                waitbar(waitbarBase+currentStage,waitbarHandle);
            end
        end
        crossCol = [crossCol ;  tmpCor];
    end

% --- Executes on button press in meanSDBtn.
function drawStates(correlation)
global crossCorrelationData
    theStd = std(correlation);
    theMean = mean(correlation);
    lims = get(crossCorrelationData.handles.correlationAxes,'XLim');
    meanLine = line(lims, [theMean theMean],'Parent',crossCorrelationData.handles.correlationAxes);
    set(meanLine,'Color','k','LineWidth',2);
    set(crossCorrelationData.handles.meanVal,'String',num2str(theMean));
    set(crossCorrelationData.handles.stdVal,'String',num2str(theStd));
    numOfStds= 1;
    minVal = min(correlation);
    while 1
        yVal = theMean - numOfStds*theStd;
        if(yVal < 0 || yVal < minVal)
            break;
        else
            numOfStds=numOfStds+1;
        end
        drawSTDLine(lims,yVal);
        if(yVal == 0)
            break;
        end
    end
    numOfStds = 1;
    maxVal = max(correlation);
    while 1
        yVal = theMean + numOfStds*theStd;
        if(yVal > maxVal)
            break;
        else
            numOfStds=numOfStds+1;
        end    
        drawSTDLine(lims,yVal);
        if(yVal == maxVal)
            break;
        end
    end

function actualTime = getActualTime(pixelTime)
global crossCorrelationData
    before = str2num(get(crossCorrelationData.handles.beforeTxt,'String'));
    after = str2num(get(crossCorrelationData.handles.afterTxt,'String'));
    actualTimes = (-before:pixelToTime(1): after);
    if(pixelTime > numel(actualTimes))
        actualTime = actualTimes(numel(actualTimes)) + pixelToTime(1);
        return;
    end
    actualTime = actualTimes(uint32(pixelTime));

function drawSTDLine(xLims,yVal)
global crossCorrelationData
    aLine = line(xLims, [yVal yVal],'Parent',crossCorrelationData.handles.correlationAxes);
    set(aLine,'Color','k','LineWidth',1, 'LineStyle',':');
  
% --- Executes on button press in findAllCorrelations.
function findAllCorrelations_Callback(hObject, eventdata, handles)
global crossCorrelationData cells
    userData.before = get(handles.beforeTxt,'String');
    userData.after = get(handles.afterTxt,'String');
    h = waitbar(0,'Please Wait, Calculating all Correlations', 'Name', 'Cross Correlation', 'WindowStyle', 'modal', 'Pointer', 'watch');
    numOfSTDs = get(handles.stdCombo,'Value');
    minSpikesInSignificantCorrelation = str2num(get(handles.minSpikesTxt,'String'));
    oldBeforeAfter = get(handles.findAllCorrelations,'UserData'); 
    if(isempty(oldBeforeAfter) || ~strcmp(oldBeforeAfter.before,userData.before) || ~strcmp(oldBeforeAfter.after,userData.after) || isempty(crossCorrelationData.allCrossCorrelations))% || oldBeforeAfter.behavioral ~= userData.behavioral)
        sources = (1:numel(cells));
        targets = (1:numel(cells));
        crossCol =  calcCrossCorrelationBetweenSourcesAndTargets(0, sources, targets, h, 0, 0.99);
        crossCorrelationData.allCrossCorrelations = crossCol;        
    end
    significantCorrelations = findSignificantCorrelations(crossCorrelationData.allCrossCorrelations,minSpikesInSignificantCorrelation,numOfSTDs);
    close(h);       
    result = [];
    if(isempty(significantCorrelations))
        result = {'None'};
    else
        numOfCorrelations = numel(significantCorrelations);
        for i=1:numOfCorrelations
            source = cells(significantCorrelations(i).source).name;
            target = cells(significantCorrelations(i).target).name;
            theTime = num2str(getActualTime(significantCorrelations(i).location));
            result = [result; {['Source: ' source  ' -> Target: ' target  ' at: ' theTime  ' ms']}];
        end
    end
    set(handles.numOfPairwiseCorrs,'String',['# Of Correlations: ' num2str(numel(significantCorrelations))]);
    set(handles.findAllCorrelations,'UserData' ,userData);
    set(handles.allCorrelations,'Value', 1,'String', result,'UserData', significantCorrelations);
    crossCorrelationData.nWayCorrelationData = [];  
    buildSyncornizationDataObject(significantCorrelations);

function buildSyncornizationDataObject(significantCorrelations)
global crossCorrelationData cells
    numOfCells = numel(cells);
    syncObject = zeros(numOfCells,numOfCells);%[];
    numOfCorrelations = numel(significantCorrelations);
    for k=1:numOfCorrelations
       syncObject(significantCorrelations(k).source, significantCorrelations(k).target) = 1;
    end
    crossCorrelationData.synconizationDataObject = syncObject;

function setValueToListHandle(value, listHandle)
    set(listHandle,'Value',value);

function showCorrelationBtn_Callback(hObject, eventdata, handles)
    userData = get(handles.allCorrelations,'UserData');
    if(isempty(userData))
        return;
    end
    calcParams = get(handles.findAllCorrelations,'UserData'); 
    set(handles.beforeTxt,'String',calcParams.before);
    set(handles.afterTxt,'String',calcParams.after);
    if(isempty(userData))
        return;
    end
    index = get(handles.allCorrelations,'Value');
    if(index <=0)
        return;
    end
    correlationData = userData(index);
    setValueToListHandle(correlationData.source,handles.sourceCellCombo);
    setValueToListHandle(correlationData.target,handles.targetCellList);
    displayMethod = 'bar';
    showCorrelationData(correlationData,displayMethod);
    presentedString = get(handles.allCorrelations,'String');
    presentedString = presentedString(index);
    set(handles.presentedCorrelationLbl,'String',presentedString);

% building nWayCorrelationData from the pairwise correlations data that was
% previously accumelated
function nWayCorrelationData = buildInitialNWayCorrelationData()
global crossCorrelationData
    correlations = get(crossCorrelationData.handles.allCorrelations,'UserData');
    numOfSTDs = get(crossCorrelationData.handles.nWayNumOfStd,'Value');
    minNumOfSpikes = str2num(get(crossCorrelationData.handles.nWayMinNumfOfSpikes,'String'));
    
    correlations = findSignificantCorrelations(correlations, minNumOfSpikes, numOfSTDs);
    numOfCorrelations = numel(correlations);
    nWayCorrelationData = [];
    jitter = str2num(get(crossCorrelationData.handles.nWayJitter,'String'))/2;
    jitterInPixels = jitter / pixelToTime(1);
    for i=1:numOfCorrelations
        correlationData.reference = correlations(i).source;
        correlationData.referenceSpikes = [];
        correlationData.sources = [];
        source.name = correlations(i).target;
        locationTime = correlations(i).location;
        source.offset = [(locationTime-jitterInPixels) (locationTime+jitterInPixels)];
        correlationData.sources = [correlationData.sources ; source];
        nWayCorrelationData = [nWayCorrelationData correlationData];
    end
        
function displayNWaysCorrelations()
global crossCorrelationData
    numOfSTDs = get(crossCorrelationData.handles.nWayNumOfStd,'Value');
    minNumOfSpikes = str2num(get(crossCorrelationData.handles.nWayMinNumfOfSpikes,'String'));
    significantCorrelations = crossCorrelationData.nWayCorrelationData;%findSignificantCorrelations(crossCorrelationData.nWayCorrelationData, minNumOfSpikes, numOfSTDs);
    set(crossCorrelationData.handles.nWayCorrelationList,'UserData',significantCorrelations);

    numOfCorrelations = numel(significantCorrelations);
    result = [];
    if(numOfCorrelations == 0)
        result ='None';
    else
        result = buildNwayCorrelationStrings(significantCorrelations);
        groupsStrings = buildNWayGroupStrings(significantCorrelations);
        crossCorrelationData.groupsData = groupsStrings;
        crossCorrelationData.chainsData = result;
        if(get(crossCorrelationData.handles.groupingCB,'Value'))
            result = groupsStrings;
        end
    end
    set(crossCorrelationData.handles.nWayCorrelationList,'String', result);
    set(crossCorrelationData.handles.nWayCorrelationList,'Value', 1);
    
function correlationsStrings = buildNwayCorrelationStrings(significantCorrelations)
global cells
    correlationsStrings = [];
    numOfCorrelations = numel(significantCorrelations);
    for i=1:numOfCorrelations
        correlationSources = significantCorrelations(i).source.sources;
        numOfSources = numel(correlationSources);
        sourceIndex = significantCorrelations(i).source.reference;
        correlationString = [num2str(i) ': ' cells(sourceIndex).name ' @ 0ms' ];
        for j=1:numOfSources
            location = (correlationSources(j).offset(1) + correlationSources(j).offset(2))/2;
            location = getActualTime(location);
            correlationString = [correlationString ', ' cells(correlationSources(j).name).name ' @ ' num2str(location) 'ms' ]; 
        end
        targetLocation = significantCorrelations(i).location;
        targetLocation = getActualTime(targetLocation);
        correlationString = [correlationString ', ' cells(significantCorrelations(i).target(1)).name ' @ ' num2str(targetLocation) 'ms'];
        correlationsStrings = [correlationsStrings ; {correlationString}];
    end
  
function groupStrings = buildNWayGroupStrings(significantCorrelations)
global cells crossCorrelationData
    groupStrings = [];
    numOfCorrelations = numel(significantCorrelations);
    if (numOfCorrelations == 0)
        return;
    end
    sizeOfLargestGroup = numel(significantCorrelations(numOfCorrelations).source.sources) + 2;
    allChains = zeros(numOfCorrelations, sizeOfLargestGroup);
    for i=1:numOfCorrelations
        allChains(i,1) = significantCorrelations(i).source.reference;
        correlationSources = significantCorrelations(i).source.sources;
        numOfSources = numel(correlationSources);
        for j=1:numOfSources
            allChains(i,j+1) = correlationSources(j).name;
        end
        allChains(i,numOfSources+2) = significantCorrelations(i).target(1);
    end
    sortedChains = sort(allChains,2,'descend');
    sortedChains = sortrows(sortedChains);
    groups = zeros(numOfCorrelations, sizeOfLargestGroup);
    groups(1,:) = sortedChains(1,:);
    groupsStrength = [];
    groupStrength = 1;
    for i=2:numOfCorrelations
        if(sortedChains(i-1,:) == sortedChains(i,:))
            groupStrength = groupStrength+1;
            continue;
        end
        groupsStrength = [groupsStrength ; groupStrength];
        groupCounter = numel(groupsStrength);
        groups(groupCounter+1,:) = sortedChains(i,:);
        groupStrength = 1;
        if(i == numOfCorrelations) % in cases where the last correlation starts a group
            groupsStrength = [groupsStrength ; groupStrength];
            groupCounter = numel(groupsStrength);     
        end
    end
    numOfGroups = numel(groupsStrength);
    if(numOfGroups == 0)
        return;
    end
    groups = groups(1:numOfGroups, :);
    crossCorrelationData.groupsRawData = sortrows([groups groupsStrength],-(sizeOfLargestGroup+1));
    
    for i=1: numOfGroups
        groupString = [];
        for j=1:sizeOfLargestGroup
            if(crossCorrelationData.groupsRawData(i,j) == 0)
                break;
            end
            groupString = [groupString cells(crossCorrelationData.groupsRawData(i,j)).name ' '];
        end
        groupString = ['Group ' num2str(i) ': ' groupString ' strength: ' num2str(crossCorrelationData.groupsRawData(i,sizeOfLargestGroup+1))];
        groupStrings = [groupStrings ; {groupString}]; 
    end
    
function nWayFindBtn_Callback(hObject, eventdata, handles) 
global crossCorrelationData
    calcIterations = 6;
    firstIterationProgressRange = 0.15;
    secondIterationProgressRange = 0.8;
    endIntervals = 1;
    if(calcIterations ~= 1)
        additionalProgressIntervalsRanges = (1-secondIterationProgressRange)/ double(calcIterations-2);
        endIntervals = [firstIterationProgressRange, secondIterationProgressRange:additionalProgressIntervalsRanges:1];
    end
    numOfAdditionalIterations = calcIterations-1;
    numOfSTDs = get(crossCorrelationData.handles.nWayNumOfStd,'Value');
    minNumOfSpikes = str2num(get(crossCorrelationData.handles.nWayMinNumfOfSpikes,'String'));    
    additionalIterationRange =(1-firstIterationProgressRange) /double(numOfAdditionalIterations);
    h = waitbar(0,'Calculating 3-Way Correlations', 'Name', 'Cross Correlations', 'WindowStyle', 'modal', 'Pointer', 'watch');  
    [before after] = getCalculationParams();
    nWayCalculationData = buildInitialNWayCorrelationData();
    significantCorrelations = [];
    progressStartPoint = 0;
    resultingSignificantCorrelations = [];
    waitbar(progressStartPoint,h, ['Calculating 3-Way Correlations (' num2str(numel(nWayCalculationData)) ' base paths)']);
    for i=1:calcIterations
        progressEndPoint = endIntervals(i);
        significantCorrelations = calculateNWayCorrelation(nWayCalculationData, before, after, numOfSTDs, minNumOfSpikes,h,progressStartPoint,progressEndPoint);
        waitbar(progressEndPoint,h, ['Filtering level ' num2str(i+2) ' results']);
        resultingSignificantCorrelations = [resultingSignificantCorrelations ; significantCorrelations];
        waitbar(progressEndPoint,h, ['Preparing level '  num2str(i+3) ' calculation data']);
        nWayCalculationData = buildNWayCorrelationData(significantCorrelations);
        if(numel(significantCorrelations) == 0)
            break;
        end
        progressStartPoint = progressEndPoint;
        waitbar(progressStartPoint,h, ['Calculating ' num2str(i+3) '-Way Correlations (' num2str(numel(significantCorrelations)) ' base paths)']);
    end
    crossCorrelationData.nWayCorrelationData = resultingSignificantCorrelations;
    waitbar(0.995,h,'Displaying results');
    displayNWaysCorrelations();
    close(h); 
    
function nWayShowBtn_Callback(hObject, eventdata, handles)
    userData = get(handles.nWayCorrelationList,'UserData');
    if(isempty(userData))
        return;
    end
    selectedIndex = get(handles.nWayCorrelationList,'Value');
    if(selectedIndex < 1)
        return;
    end
    correlationData = userData(selectedIndex);
    src = correlationData.source;
    srcLabel = src.reference;
    numOfSources = numel(src.sources);
    for i=1:numOfSources
        srcLabel = [srcLabel ', ' src.sources(i).name];
    end
    showCorrelationOnReferenceImage(correlationData);

    correlationData.source = srcLabel;
    showCorrelationData(correlationData,'bar');
    presentedString = get(handles.nWayCorrelationList,'String');
    presentedString = presentedString(selectedIndex);
    set(handles.presentedCorrelationLbl,'String',presentedString);

function beforeTxt_Callback(hObject, eventdata, handles)
    updateNumOfBins();

function afterTxt_Callback(hObject, eventdata, handles)
    updateNumOfBins();
    
function updateNumOfBins()
global crossCorrelationData
    [before after] =  getCalculationParams();
    numOfBins = before+after +1;
    set(crossCorrelationData.handles.binsText,'String',['# Of Bins: ' num2str(numOfBins)]);





% --- Executes on button press in groupingCB.
function groupingCB_Callback(hObject, eventdata, handles)
global crossCorrelationData
    if(get(hObject,'Value'))
        result = crossCorrelationData.groupsData;
    else
        result = crossCorrelationData.chainsData;
    end
    set(crossCorrelationData.handles.nWayCorrelationList,'String', result);
    set(crossCorrelationData.handles.nWayCorrelationList,'Value', 1);
    


% --- Executes on button press in exportGroups.
function exportGroups_Callback(hObject, eventdata, handles)
global crossCorrelationData cells data

    [numOfGroups groupSize] = size(crossCorrelationData.groupsRawData);
    groupSize = groupSize-1; %last column is the strength
    directory_name = uigetdir;
    if(directory_name == 0)
        return;
    end
    fileName = fullfile(directory_name, [data.importFileName '-groups.csv']);
    fId = fopen(fileName, 'wt');
    for i=1:numOfGroups
%         for  j=1:groupSize
%              fprintf(fId, '%d, ', crossCorrelationData.groupsRawData(i,j));
%         end
        for  j=1:groupSize
             if(crossCorrelationData.groupsRawData(i,j) == 0)
                 fprintf(fId, ' , ');
                 continue;
             end
             fprintf(fId, '%s, ', cells(crossCorrelationData.groupsRawData(i,j)).name);
        end
        fprintf(fId,'strength:, %d\n', crossCorrelationData.groupsRawData(i,groupSize+1));
    end
    fclose(fId);
 

