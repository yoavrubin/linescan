function varargout = cellTaggingDialog(varargin)
% CELLTAGGINGDIALOG M-file for cellTaggingDialog.fig
%      CELLTAGGINGDIALOG, by itself, creates a new CELLTAGGINGDIALOG or raises the existing
%      singleton*.
%
%      H = CELLTAGGINGDIALOG returns the handle to a new CELLTAGGINGDIALOG or the handle to
%      the existing singleton*.
%
%      CELLTAGGINGDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELLTAGGINGDIALOG.M with the given input arguments.
%
%      CELLTAGGINGDIALOG('Property','Value',...) creates a new CELLTAGGINGDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cellTaggingDialog_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cellTaggingDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cellTaggingDialog

% Last Modified by GUIDE v2.5 18-Dec-2007 11:44:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cellTaggingDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @cellTaggingDialog_OutputFcn, ...
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


% --- Executes just before cellTaggingDialog is made visible.
function cellTaggingDialog_OpeningFcn(hObject, eventdata, handles, varargin)
global cellTaggingDialogHandles
    handles.output = hObject;
    cellTaggingDialogHandles = handles;
    guidata(hObject, handles);
    buildContent();

function varargout = cellTaggingDialog_OutputFcn(hObject, eventdata, handles) 
varargout{1} = '';


function errorMessage = verifyValues()
    global cellTaggingData
    errorMessage = [];
    [numOfCells stam] = size(cellTaggingData.tmpCells);
    for i=1:numOfCells
        sourceCell = cellTaggingData.tmpCells(i);
        for j=i+1:numOfCells
            comparedCell = cellTaggingData.tmpCells(j);
            if(strcmp(sourceCell.name, comparedCell.name))
                errorMessage = ['The name ' sourceCell.name ' exists more then once'];
                return;
            end
            if(sourceCell.color == comparedCell.color)
                errorMessage = ['The cells ' sourceCell.name ' and ' comparedCell.name 'have the same color'];
                return;
            end
        end
    end


% --- Executes on button press in okBtn.
function okBtn_Callback(hObject, eventdata, handles)
global cells cellTaggingData
    errorMessage = verifyValues();
    if(~isempty(errorMessage))
        errordlg(errorMessage);
        return;
    end
    cells = cellTaggingData.tmpCells;
    [numOfCells stam] = size(cellTaggingData.tmpCells);
    for i=1:numOfCells
        tmpColor = cellTaggingData.tmpCells(i).color;
        setCellColor(i, tmpColor);
        set(cells(i).refLineLabelHandle,'String',cells(i).name);
        set(cells(i).columnTagHandle,'String',cells(i).name);
    end
    saveColumns();
    delete(handles.figure1);

% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
    delete(handles.figure1);

% --- Executes on slider movement.
function scroller_Callback(hObject, eventdata, handles)
    scrollTo( get(hObject,'Value'));

% --- Executes during object creation, after setting all properties.
function scroller_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

function scrollTo (position)
    global cellTaggingData
    realPos = 1-position;   
    firstVisibleRow = realPos/ cellTaggingData.sliderStepMin  + 1;
    lastVisibleRow  = cellTaggingData.viewableRows+ firstVisibleRow -1;
    yPostionDelta = (firstVisibleRow - cellTaggingData.previousTopRow)*cellTaggingData.rowHeight;
    cellTaggingData.previousTopRow = firstVisibleRow;
    [numOfRows four]= size(cellTaggingData.controlsHandles);
    for i=1:numOfRows
        toDisplay = 'on';
        if(i < firstVisibleRow || i> lastVisibleRow)
            toDisplay = 'off';
        end
        row = cellTaggingData.controlsHandles(i,1:4);
        for j=1:4
                    pos = get(row(j),'Position');
                    pos(2) = pos(2) + yPostionDelta;
                    set(row(j),'Visible',toDisplay);
                    set(row(j),'Position',pos);
                    
        end
    end

function buildContent()
global cells cellTaggingDialogHandles  cellTaggingData
    cellTaggingData.tmpCells = cells;
    cellTaggingData.controlsHandles = [];
    cellTaggingData.rowHeight = 30;
    [numOfCells stam] = size(cellTaggingData.tmpCells);
    pos = get(cellTaggingDialogHandles.innerPane,'Position');
    scrollPanePos = get(cellTaggingDialogHandles.scrollerPane, 'Position');
    cellTaggingData.viewableRows = scrollPanePos(4) / cellTaggingData.rowHeight;
    cellTaggingData.numOfSteps = numOfCells -cellTaggingData.viewableRows ;
    pos(4) = numOfCells*cellTaggingData.rowHeight;
    pos(2) = -pos(4) + scrollPanePos(4);
    set(cellTaggingDialogHandles.innerPane,'Position',pos);
    maxY = pos(4);
    if(cellTaggingData.numOfSteps <= 0)
        set(cellTaggingDialogHandles.scroller,'Enable','off');
        cellTaggingData.sliderStepMin =1;
    else
        set(cellTaggingDialogHandles.scroller,'Enable','on');
        cellTaggingData.sliderStepMin =1 / (cellTaggingData.numOfSteps);
        cellTaggingData.sliderStepFactor = 2;
        sliderStepMax = cellTaggingData.sliderStepMin* cellTaggingData.sliderStepFactor;    
        set(cellTaggingDialogHandles.scroller, 'SliderStep', [cellTaggingData.sliderStepMin sliderStepMax]);
    end
    for i=1:numOfCells
       [btnHandle cbHandle lblHandle txtHandle] = buildRow(maxY -i*cellTaggingData.rowHeight, cellTaggingData.tmpCells(i), i);
        cellTaggingData.controlsHandles = [cellTaggingData.controlsHandles ; btnHandle cbHandle lblHandle txtHandle];
    end
    maxVal =  get(cellTaggingDialogHandles.scroller,'Max');
    set(cellTaggingDialogHandles.scroller,'Value',maxVal);
    cellTaggingData.previousTopRow = 1;
    scrollTo(maxVal);

function [btnHandle cbHandle lblHandle txtHandle] = buildRow(yBasePosition, cell, index)
    btnHandle = buildBtn(yBasePosition,cell, index);
    cbHandle = buildCheckbox(yBasePosition,cell, index);
    lblHandle = buildLabel(yBasePosition,cell);
    txtHandle = buildText(yBasePosition,cell, index);

function btnHandle =  buildBtn(yBasePosition,cell, index)
global cellTaggingData cellTaggingDialogHandles
    x = 20;
    y = yBasePosition;
    w = 64;
    h = 22;
    pos = [x y w h];
    btnHandle = uicontrol('Style','pushbutton','Parent',cellTaggingDialogHandles.innerPane);
    set(btnHandle,'Position',pos);
    set(btnHandle,'UserData',index);
    colour = get(cell.columnHandle,'EdgeColor');
    set(btnHandle,'BackgroundColor',colour);
    set(btnHandle,'String','Set Color...');
    set(btnHandle,'callback',@setColorBtnCallback);
    cellTaggingData.tmpCells(index).color = colour;

function cbHandle = buildCheckbox(yBasePosition,cell, index)
global cellTaggingDialogHandles
    x = 100;
    y = yBasePosition +4;
    w = 66;
    h = 16;
    pos = [x y w h];
    cbHandle = uicontrol('Style','checkbox','Parent',cellTaggingDialogHandles.innerPane);
    set(cbHandle,'Position',pos);
    set(cbHandle,'UserData',index);
    isNeuron = cell.isNeuron;
    set(cbHandle,'Value',isNeuron);
    set(cbHandle,'String','Is Neuron');
    set(cbHandle,'callback',@setIsNeuronCallback);

function labelHandle = buildLabel(yBasePosition,cell)
global cellTaggingDialogHandles
    x = 180;
    y = yBasePosition+1;
    w = 70;
    h = 16;
    pos = [x y w h];
    labelHandle = uicontrol('Style','text','Parent',cellTaggingDialogHandles.innerPane);
    set(labelHandle,'Position',pos);
    set(labelHandle,'UserData',cell);
    set(labelHandle,'String','Column Name:');

function txtHandle = buildText(yBasePosition,cell,index)
global cellTaggingDialogHandles
    x = 255;
    y = yBasePosition;
    w = 77;
    h = 22;
    pos = [x y w h];
    txtHandle = uicontrol('Style','edit','Parent',cellTaggingDialogHandles.innerPane);
    set(txtHandle,'Position',pos);
    set(txtHandle,'UserData',index);
    nm = cell.name;
    set(txtHandle,'String',nm);
    set(txtHandle,'Enable','on');
    set(txtHandle,'BackgroundColor','white');
    set(txtHandle,'callback',@setCellNameCallback);

function setColorBtnCallback(src, eventdata)
global cellTaggingData
    index = get(src,'UserData');
    selectedColor = uisetcolor('Select a Color for the cell');
    if(selectedColor == 0)
        return;
    end
    set(src,'BackgroundColor',selectedColor);
    cellTaggingData.tmpCells(index).color = selectedColor;


function setIsNeuronCallback(src, eventdata)
global cellTaggingData
    index = get(src,'UserData');
    cellTaggingData.tmpCells(index).isNeuron = get(src, 'Value');

function setCellNameCallback(src, eventdata)
global cellTaggingData
    index = get(src,'UserData');
    cellTaggingData.tmpCells(index).name = get(src, 'String');