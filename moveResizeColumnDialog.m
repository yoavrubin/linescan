function varargout = moveResizeColumnDialog(varargin)
% MOVERESIZECOLUMNDIALOG M-file for moveResizeColumnDialog.fig
%      MOVERESIZECOLUMNDIALOG, by itself, creates a new MOVERESIZECOLUMNDIALOG or raises the existing
%      singleton*.
%
%      H = MOVERESIZECOLUMNDIALOG returns the handle to a new MOVERESIZECOLUMNDIALOG or the handle to
%      the existing singleton*.
%
%      MOVERESIZECOLUMNDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOVERESIZECOLUMNDIALOG.M with the given input arguments.
%
%      MOVERESIZECOLUMNDIALOG('Property','Value',...) creates a new MOVERESIZECOLUMNDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before moveResizeColumnDialog_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to moveResizeColumnDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help moveResizeColumnDialog

% Last Modified by GUIDE v2.5 26-Dec-2007 14:52:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @moveResizeColumnDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @moveResizeColumnDialog_OutputFcn, ...
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


% --- Executes just before moveResizeColumnDialog is made visible.
function moveResizeColumnDialog_OpeningFcn(hObject, eventdata, handles, varargin)
global tmpMoveResizeColumnData markedCell cells
% Choose default command line output for moveResizeColumnDialog
    handles.output = hObject;
% Update handles structure
    guidata(hObject, handles);
    tmpMoveResizeColumnData.position = get(markedCell.col,'Position');
    nc = size(cells,1);
    for i=1:nc
        cell = cells(i);
        if(cell.columnHandle == markedCell.col)
            tmpMoveResizeColumnData.markedCellIndex = i;
            break;
        end
    end
% UIWAIT makes moveResizeColumnDialog wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = moveResizeColumnDialog_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = '';


% --- Executes on button press in moveRadio.
function moveRadio_Callback(hObject, eventdata, handles)
    val = get(hObject,'Value') ;
    set(handles.resizeRadio,'Value', ~val);
    set(handles.rightRadio,'Enable','off');
    set(handles.leftRadio,'Enable','off');

% --- Executes on button press in resizeRadio.
function resizeRadio_Callback(hObject, eventdata, handles)
    val = get(hObject,'Value') ;
    set(handles.moveRadio,'Value', ~val);
    set(handles.rightRadio,'Enable','on');
    set(handles.leftRadio,'Enable','on');

% --- Executes on button press in leftRadio.
function leftRadio_Callback(hObject, eventdata, handles)
    val = get(hObject,'Value') ;
    set(handles.rightRadio,'Value', ~val);

% --- Executes on button press in rightRadio.
function rightRadio_Callback(hObject, eventdata, handles)
    val = get(hObject,'Value') ;
    set(handles.leftRadio,'Value', ~val);

function stepSize = getStepSize(handles)
    stepSize = -1;
    if(get(handles.onePixelMove,'Value'))
        stepSize = 1;
        return;
    end
    if(get(handles.threePixelMove,'Value'))
        stepSize = 3;
        return;
    end
    if(get(handles.fivePixelMove,'Value'))
        stepSize = 5;
        return;
    end

function goLeft_Callback(hObject, eventdata, handles)
    stepSize = getStepSize(handles);
    wDelta = 0;
    xDelta = 0;
    if(get(handles.resizeRadio,'Value') )
        if(get(handles.leftRadio,'Value'))
            wDelta = stepSize;
            xDelta = -stepSize;
        else
            wDelta = -stepSize;
            xDelta = 0;
        end
    else
        xDelta = -stepSize;
        wDelta = 0;
    end   
    updatePosition(xDelta,wDelta);

function goRight_Callback(hObject, eventdata, handles)
    stepSize = getStepSize(handles);
    wDelta = 0;
    xDelta = 0;
    if(get(handles.resizeRadio,'Value') )
        if(get(handles.leftRadio,'Value'))
            wDelta = -stepSize;
            xDelta = stepSize;
        else
            wDelta = stepSize;
            xDelta = 0;
        end
    else
        xDelta = stepSize;
        wDelta = 0;
    end   
    updatePosition(xDelta,wDelta);

function okBtn_Callback(hObject, eventdata, handles)
global markedCell tmpMoveResizeColumnData
    pos = get(markedCell.col,'Position');
    updateCellData(tmpMoveResizeColumnData.markedCellIndex,pos(1), pos(3));
    analyseColumn(pos(1));
    close(handles.figure1);

% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
global markedCell tmpMoveResizeColumnData
    set(markedCell.col,'Position',tmpMoveResizeColumnData.position)
    [subLineX subLineY] = getColumnReferenceLinePoints(tmpMoveResizeColumnData.position(1), tmpMoveResizeColumnData.position(3) );
    set(markedCell.marker,'XData', subLineX,'YData', subLineY);
    close(handles.figure1);

function updatePosition(xDelta, wDelta)
global markedCell cells tmpMoveResizeColumnData
    pos = get(markedCell.col,'Position');
    pos(1) = pos(1) +xDelta;
    pos(3) = pos(3) + wDelta;
    set(markedCell.col,'Position',pos);
    [subLineX subLineY] = getColumnReferenceLinePoints(pos(1), pos(3) );
    set(markedCell.marker,'XData', subLineX,'YData', subLineY);
    cell = cells(tmpMoveResizeColumnData.markedCellIndex);
    x = subLineX(1)+3;
    y = subLineY(1)+3;
    set(cell.refLineLabelHandle,'Position',[x y 0]);
    pos = get(cell.columnTagHandle,'Position');
    pos(1) = pos(1)+ xDelta;
    set(cell.columnTagHandle,'Position',pos);
    set(cell.refLineLabelHandle,'Position',[x y 0]);
%             break;
%         end
%     end

    