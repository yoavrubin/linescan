function varargout = spikeSortingDialog(varargin)
% SPIKESORTINGDIALOG M-file for spikeSortingDialog.fig
%      SPIKESORTINGDIALOG, by itself, creates a new SPIKESORTINGDIALOG or
%      raises the existing
%      singleton*.
%
%      H = SPIKESORTINGDIALOG returns the handle to a new SPIKESORTINGDIALOG or the handle to
%      the existing singleton*.
%
%      SPIKESORTINGDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPIKESORTINGDIALOG.M with the given input arguments.
%
%      SPIKESORTINGDIALOG('Property','Value',...) creates a new SPIKESORTINGDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spikeSortingDialog_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spikeSortingDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spikeSortingDialog

% Last Modified by GUIDE v2.5 14-Jun-2009 13:22:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spikeSortingDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @spikeSortingDialog_OutputFcn, ...
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


% --- Executes just before spikeSortingDialog is made visible.
function spikeSortingDialog_OpeningFcn(hObject, eventdata, handles, varargin)
global cells spikeSortingDialogData data
    handles.output = hObject;
    spikeSortingDialogData.handles = handles;
    spikeSortingDialogData.cellSnapshot = cells;
    spikeSortingDialogData.markedSpike = [];


    % Update handles structure
    guidata(hObject, handles);

    names = [];
    [numOfCells stam] = size(cells);
    for i=1:numOfCells
        names = [names; {cells(i).name}];
    end

    set(handles.cellsList,'String',names);
    endIndex = numel(cells(1).F) * data.timePerLine;
    set(handles.sliceEndTxt,'String', num2str(endIndex));
    cellsList_Callback(handles.cellsList,[],handles);

% UIWAIT makes spikeSortingDialog wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = spikeSortingDialog_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = '';

    % --- Executes during object creation, after setting all properties.
function sliceStartTxt_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function sliceEndTxt_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    
% --- Executes during object creation, after setting all properties.
function thresholdTxt_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function cellsList_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function significatDelta_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function minimalSpikeTimeTxt_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function[threshold significantDelta minimalRadius] =  getCalculationParams()
global data spikeSortingDialogData
    threshold = str2num(get(spikeSortingDialogData.handles.thresholdTxt,'String'));
    significantDelta = double(str2num(get(spikeSortingDialogData.handles.significantDeltaTxt,'String')))/100.0;
    factor = data.timePerLine;
    minimalRadius = str2num(get(spikeSortingDialogData.handles.minimalSpikeTimeTxt,'String') );
    minimalRadius = int16(minimalRadius/factor);

% --- Executes on button press in zoomBtn.
function zoomBtn_Callback(hObject, eventdata, handles)
global spikeSortingDialogData
    if(get(hObject,'Value'))
        spikeSortingDialogData.zoomHandle = zoom(handles.tracesAxes);
        set(spikeSortingDialogData.zoomHandle,'Motion','horizontal','Enable','on'); 
    else
        set(spikeSortingDialogData.zoomHandle,'Enable','off');
    end

% --- Executes on selection change in cellsList.
function cellsList_Callback(hObject, eventdata, handles)
    contents = get(hObject,'String') ;
    cellName = contents{get(hObject,'Value')};
    cell = getCellByName(cellName);
    if(~isempty(cell.spikes))
        showSpikes_Callback(hObject, eventdata, handles);
        setPositionOfThreshold(cell.spikes.threshold);
        set(handles.significantDeltaTxt,'String',cell.spikes.significantDelta);
        set(handles.minimalSpikeTimeTxt,'String',cell.spikes.minimalRadius);
        set(handles.showSpikes,'Enable','on');
    else
        set(handles.showSpikes,'Enable','off');
        drawDfDataOnPlot(cell);
        setPositionOfThreshold(0.001); 
    end    

% --- Executes on button press in calcBtn.
function calcBtn_Callback(hObject, eventdata, handles)
    allCells = get(handles.cellsList,'String');
    selectedIndexes = get(handles.cellsList,'Value') ;
    numOfSelected = numel(selectedIndexes);
    selectedCells = [];
    [threshold significantDelta minimalRadius] =  getCalculationParams();
    minimalRadius = str2num(get(handles.minimalSpikeTimeTxt,'String'));
    h = waitbar(0,'Please Wait, Calculating spikes', 'Name', 'Spike Sorting', 'WindowStyle', 'modal', 'Pointer', 'watch');
    step = 0.99 / double(numOfSelected);
    for i=1:numOfSelected
        cellName = allCells{selectedIndexes(i)};
        cell = getCellByName(cellName);
        [x w] = getRealSpikesForCell(cell);
        spikes.x = x;
        spikes.w = w;
        spikes.threshold = threshold;
        spikes.significantDelta = significantDelta*100;
        spikes.minimalRadius = minimalRadius;
        setSpikesToCell(cellName, spikes);
        waitbar(double(i) * step,h);
    end
    valuesX = getDfBoundsInMs(cell);
    startPoint = valuesX(1);
    endPoint = valuesX(numel(valuesX));
    maxY = max(cell.dF);
    set(handles.tracesAxes,'XLim',[startPoint endPoint], 'YLim', [0 maxY]);
    setPositionOfThreshold(threshold);
    close(h);

function [realSpikes intervals]= getRealSpikesForCell(cell)
global data spikeSortingDialogData
    [threshold significantDelta minimalRadius] =  getCalculationParams();
    tmpIntervals = findMaximasIntervalsInSignal(cell.dF',significantDelta,threshold,-0.1,minimalRadius);
    startInPixels = str2num(get(spikeSortingDialogData.handles.sliceStartTxt,'String')) / data.timePerLine; 
    endInPixels = str2num(get(spikeSortingDialogData.handles.sliceEndTxt,'String'))/ data.timePerLine;
    startIntervals = tmpIntervals(:,1);
    relevantRows = ((startIntervals  >= startInPixels) + (startIntervals <endInPixels) ==2);
    tmpIntervals = tmpIntervals(relevantRows,:);
    drawDfDataOnPlot(cell);
    toHold = 1;
    tmpIntervals = validateSpikes(tmpIntervals,cell);
    realSpikes = tmpIntervals(:,1);
    intervals = tmpIntervals(:,2);


function drawDfDataOnPlot(cell)
global spikeSortingDialogData 
   % axes(spikeSortingDialogData.handles.tracesAxes);
    cla(spikeSortingDialogData.handles.tracesAxes);
    valuesX = getDfBoundsInMs(cell);
    plotHandle = drawDataOnAxes(spikeSortingDialogData.handles.tracesAxes,valuesX, cell.dF);
    lineH = findobj(plotHandle,'Type','line');
    set(lineH, 'Color', cell.color);
    setContextMenuForCell(cell);
    maxY = max(get(plotHandle,'YData'));
    xlim = get(spikeSortingDialogData.handles.tracesAxes,'XLim');
    spikeSortingDialogData.thresholdLine = rectangle('Position',[xlim(1) 0 xlim(2) maxY/200], 'LineWidth',0.1,'UserData',maxY);
    
function setContextMenuForCell(cell)
global spikeSortingDialogData
    cmn = uicontextmenu('parent',spikeSortingDialogData.handles.figure1) ;
    uimenu(cmn,'Label','Add Spike','Callback',@addSpike,'UserData',cell);
    set(spikeSortingDialogData.handles.tracesAxes,'UIContextMenu',cmn);

function addSpike(src, eventdata)
global cells spikeSortingDialogData data
    theCell = get(src,'UserData');
    rect = getrect(spikeSortingDialogData.handles.tracesAxes);
    numOfCells = numel(cells);
    for i=1:numOfCells
        if(cells(i).color == theCell.color)
            cells(i).spikes.x = [cells(i).spikes.x; rect(1)/data.timePerLine];
            cells(i).spikes.w = [cells(i).spikes.w; rect(3)/data.timePerLine];
            createRectangleForInterval(rect, theCell.color, 0.5);
            break;
        end
    end
        
function intervals = validateSpikes(unValidatedIntervals, cell)
global spikeSortingDialogData
    if(get(spikeSortingDialogData.handles.autoSort,'Value'))
        drawIntervalsOnAxes(unValidatedIntervals, cell);
        intervals = unValidatedIntervals;
        return;
    end
    [numOfIntervals two] = size(unValidatedIntervals);
    intervals = [];
    for i=1:numOfIntervals
        drawnInterval = drawInterval(unValidatedIntervals(i,1), unValidatedIntervals(i,2) , cell);
        result = promptValidationToUser(unValidatedIntervals(i,1), unValidatedIntervals(i,2), cell);
        if(strcmp(result,'Approve'))
            intervals = [intervals ; unValidatedIntervals(i,:)];   
        end
        if(strcmp(result,'Reject'))
            delete(drawnInterval);
            continue;
        else
            set(drawnInterval,'LineWidth',0.5);
        end
        if(strcmp(result,'Run'))
            intervals = [intervals ; unValidatedIntervals(i:numOfIntervals,:)];
            drawIntervalsOnAxes(unValidatedIntervals(i+1:numOfIntervals,:), cell);
            return;
        end
    end

function drawIntervalsOnAxes(intervals, cell)
    [numOfIntervals two] = size(intervals);
    numOfIntervals = uint32(numOfIntervals);
    for j=1:numOfIntervals
        rect = getRectangleAroundSpike(intervals(j,1), intervals(j,2) , cell);
        createRectangleForInterval(rect, cell.color, 0.5);
    end

function rect = getRectangleAroundSpike(x,w,cell)
    y = min( cell.dF(x : x+w));
    h = max( cell.dF(x : x+w)) -y;
    w= double(w) * pixelToTime(1);
    x= double(x) * pixelToTime(1);
    rect = [x y w h];

function h = drawInterval(x ,w, cell)
global spikeSortingDialogData
    targetRect =getRectangleAroundSpike(x,w,cell);
    beforeLim = uint32(targetRect(1)-100);
    afterLim = uint32(targetRect(1)+targetRect(3)+100);
    set(spikeSortingDialogData.handles.tracesAxes,'XLim',[beforeLim afterLim]);
    h = createRectangleForInterval(targetRect, cell.color, 2);

function h = createRectangleForInterval(position, theColor, lineWidth)
global spikeSortingDialogData
    h= rectangle('Parent',spikeSortingDialogData.handles.tracesAxes,'Position',position, 'EdgeColor','r','LineWidth',lineWidth);
    cmn = uicontextmenu('parent',spikeSortingDialogData.handles.figure1);
    uimenu(cmn,'Label','Remove','Callback',@removeSpike,'UserData',h);
    set(h,'UIContextMenu',cmn);
    set(h, 'ButtonDownFcn', @spikeMarked);  

function spikeMarked(src, eventData)
global spikeSortingDialogData
    if(ishandle(spikeSortingDialogData.markedSpike))
        set(spikeSortingDialogData.markedSpike,'LineWidth',0.5);
    end
    spikeSortingDialogData.markedSpike = src;
    set(spikeSortingDialogData.markedSpike,'LineWidth',2);    
    
function removeSpike(src, eventData)
global cells data
    theRect = get(src,'UserData');
    rectClr = get(theRect,'EdgeColor');
    rectPos = get(theRect,'Position');
    rectX = rectPos(1);
    numOfCells = numel(cells);
    for i=1:numOfCells
        if(cells(i).color == rectClr)
            numOfSpikes = numel(cells(i).spikes.x);
            for j=1:numOfSpikes
                if(cells(i).spikes.x(j) == uint32(rectX/data.timePerLine))
                    cells(i).spikes.x(j)= [];
                    cells(i).spikes.w(j)=[];
                    break;
                end
            end
            break;
        end
    end
    delete(theRect);

function result = promptValidationToUser(x , w, cell)
    top = max( cell.dF(x : x+w));
    x = pixelToTime(x);
    w = pixelToTime(w);
    qstring = ['Please validate the spike interval from : ' num2str(x) ' to: ' num2str(x+w) ' with spike max value of: ' num2str(top) ' for the cell ' cell.name  '. Press Approve to approve this spike. Press Reject to reject this spike. Press Run to sort the spikes of this cell automatically.'];
    approveBtn = 'Approve';
    rejectBtn = 'Reject';
    runBtn = 'Run';
    result =  questdlg(qstring,'Semi Automatic Spike Sorting',approveBtn,rejectBtn,runBtn,approveBtn) ;   
    
% --- Executes on button press in showSpikes.
function showSpikes_Callback(hObject, eventdata, handles)
    contents = get(handles.cellsList,'String') ;
    cellName = contents{get(handles.cellsList,'Value')};
    cell = getCellByName(cellName);
    drawDfDataOnPlot(cell);
    drawIntervalsOnAxes([cell.spikes.x cell.spikes.w], cell);
    valuesX = getDfBoundsInMs(cell);
    startPoint = valuesX(1);
    endPoint = valuesX(numel(valuesX));
    maxY = max(cell.dF);
    set(handles.tracesAxes,'XLim',[startPoint endPoint], 'YLim', [0 maxY]);

% --- Executes on button press in closeBtn.
function closeBtn_Callback(hObject, eventdata, handles)
global cells    
    numOfCells = numel(cells);
    for i=1:numOfCells
        if(~numel(cells(i).spikes))
            result = questdlg('At least one cell doesn`t have spikes, are you sure you want to close spike sorting?','Cells without spikes validation','Yes','No','No');
            if(strcmp(result, 'Yes'))
                break;
            else
                return;
            end
        end
    end         
    close(handles.figure1);

% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
global cells spikeSortingDialogData
    cells = spikeSortingDialogData.cellSnapshot;
    close(handles.figure1);

function moveRectangle(numOfSteps)
global spikeSortingDialogData
    stepSize = get(spikeSortingDialogData.thresholdLine,'UserData')/100.0;
    pos = get(spikeSortingDialogData.thresholdLine,'Position');
    targetY = pos(2) + numOfSteps*stepSize;
    if(targetY > stepSize*100.0 || targetY<=0)
        return;
    end
    setPositionOfThreshold(targetY);

    % --- Executes on button press in thresholdMoveUpBig.
function thresholdMoveUpBig_Callback(hObject, eventdata, handles)
    moveRectangle(10);

% --- Executes on button press in thresholdMoveUpSmall.
function thresholdMoveUpSmall_Callback(hObject, eventdata, handles)
    moveRectangle(1);


% --- Executes on button press in thresholdMoveDownSmall.
function thresholdMoveDownSmall_Callback(hObject, eventdata, handles)
    moveRectangle(-1);

% --- Executes on button press in thresholdMoveDownBig.
function thresholdMoveDownBig_Callback(hObject, eventdata, handles)
    moveRectangle(-10);

function thresholdTxt_Callback(hObject, eventdata, handles)
global spikeSortingDialogData
    val = str2double(get(hObject,'String'));
    if(~(val < Inf)) %val is not a number, else it was smaller the Infinity...r
        return;
    end
    maxY = get(spikeSortingDialogData.thresholdLine,'UserData');
    if(val <= 0 || val >= maxY)
        return;
    end
    setPositionOfThreshold(val);
    
function setPositionOfThreshold(value)
global spikeSortingDialogData        
    set(spikeSortingDialogData.handles.thresholdTxt,'String',value);
    pos = get(spikeSortingDialogData.thresholdLine,'Position');
    pos(2) = value;
    set(spikeSortingDialogData.thresholdLine,'Position',pos);




