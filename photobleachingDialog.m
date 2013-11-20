function varargout = photobleachingDialog(varargin)
% PHOTOBLEACHINGDIALOG M-file for photobleachingDialog.fig
%      PHOTOBLEACHINGDIALOG, by itself, creates a new PHOTOBLEACHINGDIALOG or raises the existing
%      singleton*.
%
%      H = PHOTOBLEACHINGDIALOG returns the handle to a new PHOTOBLEACHINGDIALOG or the handle to
%      the existing singleton*.
%
%      PHOTOBLEACHINGDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHOTOBLEACHINGDIALOG.M with the given input arguments.
%
%      PHOTOBLEACHINGDIALOG('Property','Value',...) creates a new PHOTOBLEACHINGDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before photobleachingDialog_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to photobleachingDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help photobleachingDialog

% Last Modified by GUIDE v2.5 30-Nov-2008 00:14:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @photobleachingDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @photobleachingDialog_OutputFcn, ...
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


% --- Executes just before photobleachingDialog is made visible.
function photobleachingDialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to photobleachingDialog (see VARARGIN)
global cells pbDialog
% Choose default command line output for photobleachingDialog
    handles.output = hObject;

% Update handles structure
    pbDialog.handles = handles;
    pbDialog.cellSnapshot = cells;
    pbDialog.regressionLine = -1;
    guidata(hObject, handles);
    
    names = [];
    [numOfCells stam] = size(cells);
    for i=1:numOfCells
        names = [names; {cells(i).name}];
    end

    set(handles.cellsCombo,'String',names);

% UIWAIT makes photobleachingDialog wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Executes during object creation, after setting all properties.
function groupSizeCombo_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function cellsCombo_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function methodCombo_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Outputs from this function are returned to the command line.
function varargout = photobleachingDialog_OutputFcn(hObject, eventdata, handles) 
varargout{1} ='';

% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
global cells pbDialog
    cells = pbDialog.cellSnapshot;
    close(handles.figure1);

% --- Executes on button press in okButton.
function okButton_Callback(hObject, eventdata, handles)
    close(handles.figure1);


% --- Executes on selection change in cellsCombo.
function cellsCombo_Callback(hObject, eventdata, handles)
global cells
    selectedCellIndex = get(hObject, 'Value');
    selectedCell = cells(selectedCellIndex);
    xValues = getDfBoundsInMs(selectedCell);
    drawDataOnAxes(handles.fAxes, xValues, selectedCell.F);
    drawDataOnAxes(handles.dfAxes, xValues, selectedCell.dF)
    updateAxes();


% --- Executes on selection change in methodCombo.
function methodCombo_Callback(hObject, eventdata, handles)
    updateAxes();

% --- Executes on selection change in groupSizeCombo.
function groupSizeCombo_Callback(hObject, eventdata, handles)
    updateAxes();

% --- Executes on button press in fRadio.
function fRadio_Callback(hObject, eventdata, handles)
    updateAxes();

% --- Executes on button press in dfRadio.
function dfRadio_Callback(hObject, eventdata, handles)
    updateAxes();

function theVal = getValueOfCombo(comboHandle)
    allValues = get(comboHandle,'String');
    indx =  get(comboHandle,'Value');
    theVal = allValues(indx);
    
function [cell method groupSize target] = getCalcParams()
global pbDialog cells
    cell = cells(get(pbDialog.handles.cellsCombo,'Value'));
    method = getValueOfCombo(pbDialog.handles.methodCombo);
    groupSize = getValueOfCombo(pbDialog.handles.groupSizeCombo);
    groupSize = str2num(groupSize{1});
    if(get(pbDialog.handles.dfRadio,'Value'))
        target = 'df';
    else
        target = 'f';
    end
        
function updateAxes()
global pbDialog
    [cell method groupSize target] = getCalcParams();
    if(strcmp(target,'f'))
        signal = cell.F;
        targetAxes = pbDialog.handles.fAxes;
    else
        signal = cell.dF;
        targetAxes = pbDialog.handles.dfAxes;
    end
    [x1 y1 x2 y2] = getSignalAfterLinearRegression(signal, method, groupSize);
    x1 = pixelToTime(x1);
    x2 = pixelToTime(x2);
    if( pbDialog.regressionLine == -1)
        axes(targetAxes);
        pbDialog.regressionLine = line([x1 x2],[y1 y2],'Color','r');
    else
        set(pbDialog.regressionLine,'XData',[x1 x2],'YData',[y1 y2], 'Parent',targetAxes);
    end

% --- Executes on button press in calcButton.
function calcButton_Callback(hObject, eventdata, handles)
global pbDialog
%     if(get(pbDialog.handles.fRadio,'Value'))
%         theAxes = pbDialog.handles.dfAxes;
%     else
%         theAxes = pbDialog.handles.fAxes;
%     end
    
    x = get(pbDialog.regressionLine,'XData');
    y = get(pbDialog.regressionLine,'YData');
    a = double((y(2)-y(1)))/double((x(2)-x(1)));
    deltas = ((1:numel(signal))*a)';
    %fixedSignal = signal-deltas;


% --- Executes on button press in apply2cellButton.
function apply2cellButton_Callback(hObject, eventdata, handles)
% hObject    handle to apply2cellButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

