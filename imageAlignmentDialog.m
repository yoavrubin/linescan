function varargout = imageAlignmentDialog(varargin)
% IMAGEALIGNMENTDIALOG M-file for imageAlignmentDialog.fig
%      IMAGEALIGNMENTDIALOG, by itself, creates a new IMAGEALIGNMENTDIALOG or raises the existing
%      singleton*.
%
%      H = IMAGEALIGNMENTDIALOG returns the handle to a new IMAGEALIGNMENTDIALOG or the handle to
%      the existing singleton*.
%
%      IMAGEALIGNMENTDIALOG('CALLBACK',hObject,eventData,handles,...) calls
%      the local
%      function named CALLBACK in IMAGEALIGNMENTDIALOG.M with the given input arguments.
%
%      IMAGEALIGNMENTDIALOG('Property','Value',...) creates a new IMAGEALIGNMENTDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageAlignmentDialog_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageAlignmentDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imageAlignmentDialog

% Last Modified by GUIDE v2.5 19-Nov-2007 11:52:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageAlignmentDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @imageAlignmentDialog_OutputFcn, ...
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

% --- Executes during object creation, after setting all properties.
function lsImageScroll_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

function drawRectangle(minX, maxX, minY, maxY)
    annotation('line',[minX minX],[minY maxY],'Color','c','LineWidth',2);
    annotation('line',[minX maxX],[minY minY],'Color','c','LineWidth',2);
    annotation('line',[minX maxX],[maxY maxY],'Color','c','LineWidth',2);
    annotation('line',[maxX maxX],[minY maxY],'Color','c','LineWidth',2);

% --- Executes just before imageAlignmentDialog is made visible.
function imageAlignmentDialog_OpeningFcn(hObject, eventdata, handles, varargin)
global data  alignmentDialogData imageAlignDialogHandles
    handles.output = hObject;
    imageAlignDialogHandles = handles;
    % Update handles structure
    guidata(hObject, handles);
    axes(handles.lineScanImageAxes);
    drawRectangle(0.01,0.583,0.268,0.304)
    drawRectangle(0.01,0.583,0.815,0.851);
    alignmentDialogData.imgData = data.imgData;
    alignmentDialogData.imageMarkingLines = [];
    [numOfRows stam] = size(alignmentDialogData.imgData);
    alignmentDialogData.numOfImages = numOfRows / data.numOfLinesInImage;
    alignmentDialogData.tmpTotalMoves = int16(zeros(alignmentDialogData.numOfImages,1));
    alignmentDialogData.totalMoves = [];
    alignmentDialogData.numOfRows = numOfRows;
    alignmentDialogData.rowsPerImage =  data.numOfLinesInImage;
    alignmentDialogData.currImageIndx = -1;
    lsImgPos = get(handles.lineScanImageAxes,'Position');
    lsImgPos(4)  = numOfRows;
    set(handles.lineScanImageAxes,'Position',lsImgPos);
    imshow(alignmentDialogData.imgData);
    lsImageScroll_Callback(handles.lsImageScroll,[],handles);
    drawBadArea(data.badAreas, handles.lineScanImageAxes);
% UIWAIT makes imageAlignmentDialog wait for user response (see UIRESUME)
    uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imageAlignmentDialog_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = '';

function refreshHintArea(startPoint, endPoint)
global alignmentDialogData imageAlignDialogHandles
    topPartialImage = alignmentDialogData.imgData(startPoint+39: startPoint+71,:);
    bottomPartialImage = alignmentDialogData.imgData(endPoint- 64: endPoint-32,:);
    mergedImage = [topPartialImage ; bottomPartialImage];
    axes(imageAlignDialogHandles.hintAreaAxes);
    imshow(mergedImage);

% --- Executes on slider movement.
function lsImageScroll_Callback(hObject, eventdata, handles)
global alignmentDialogData
    setImageLocationWithinPanel(alignmentDialogData.imgData, handles.lineScanImageAxes,get(hObject,'Value'));
    [startPoint endPoint]  = getViewedWindowEnds(alignmentDialogData.imgData, handles.lineScanImageHolder, hObject);
    midPoint = (uint32(startPoint) + uint32(endPoint))/2;
    currImageIndx = floor(double(midPoint) / alignmentDialogData.rowsPerImage)  +1;
    refreshHintArea(startPoint, endPoint);
    if(alignmentDialogData.currImageIndx == currImageIndx)
         return;
    end
    alignmentDialogData.currImageIndx = currImageIndx;
    [imageStartPoint imageEndPoint] =  getSubImageInterval(currImageIndx,alignmentDialogData.rowsPerImage); 
    if(isempty(alignmentDialogData.imageMarkingLines))
        axes(handles.lineScanImageAxes);
        alignmentDialogData.imageMarkingLines(1) = line([1 1],[imageStartPoint imageEndPoint],'Color','r','LineWidth',4);
        alignmentDialogData.imageMarkingLines(2) = line([510 510],[imageStartPoint imageEndPoint],'Color','r','LineWidth',4);
    else
        set( alignmentDialogData.imageMarkingLines(1), 'YData',[imageStartPoint imageEndPoint]);
        set( alignmentDialogData.imageMarkingLines(2), 'YData',[imageStartPoint imageEndPoint]);
    end

function stepSize = getStepSize()
global imageAlignDialogHandles
    if(get(imageAlignDialogHandles.onePx,'Value'))
        stepSize = 1;
        return;
    end
    if(get(imageAlignDialogHandles.fivePx,'Value'))
        stepSize = 5;
        return;
    end
    if(get(imageAlignDialogHandles.tenPx,'Value'))
        stepSize = 10;
        return;
    end
    if(get(imageAlignDialogHandles.fiftyPx,'Value'))
        stepSize = 50;
        return;
    end
    if(get(imageAlignDialogHandles.hundredPx,'Value'))
        stepSize = 100;
        return;
    end

function performMove(direction)
global alignmentDialogData imageAlignDialogHandles
    stepSize = getStepSize();
    shift = direction*stepSize;
    alignmentDialogData.imgData = shiftSubImage(alignmentDialogData.imgData, alignmentDialogData.numOfImages, alignmentDialogData.currImageIndx, shift); 
    axes(imageAlignDialogHandles.lineScanImageAxes);
    imshow(alignmentDialogData.imgData);
    alignmentDialogData.tmpTotalMoves( alignmentDialogData.currImageIndx) =  alignmentDialogData.tmpTotalMoves( alignmentDialogData.currImageIndx) + shift; 
    alignmentDialogData.imageMarkingLines = [];
    alignmentDialogData.currImageIndx = -1;
    lsImageScroll_Callback(imageAlignDialogHandles.lsImageScroll,[], imageAlignDialogHandles);

function leftBtn_Callback(hObject, eventdata, handles)
    performMove(-1);

function rightBtn_Callback(hObject, eventdata, handles)
    performMove(1);

function finishBtn_Callback(hObject, eventdata, handles)
global alignmentDialogData
    alignmentDialogData.totalMoves = int16(alignmentDialogData.tmpTotalMoves);
    delete(handles.figure1);

function cancelBtn_Callback(hObject, eventdata, handles)
    delete(handles.figure1);

% -- we need these callbacks to handles a matlab bug where if there is no
% callback, then the window create function is called 
function onePx_Callback(hObject, eventdata, handles)
function fivePx_Callback(hObject, eventdata, handles)
function tenPx_Callback(hObject, eventdata, handles)
function fiftyPx_Callback(hObject, eventdata, handles)
function hundredPx_Callback(hObject, eventdata, handles)

function markBadArea_Callback(hObject, eventdata, handles)
global alignmentDialogData data
    rect = getrect(handles.lineScanImageAxes);
    [rows cols] = size(alignmentDialogData.imgData);
    if(rect(1) <= 0 || rect(1) > cols || rect(2) <= 0  || rect(2) > rows)
         return;
    end
    drawBadArea({rect},handles.lineScanImageAxes);
    data.badAreas = [data.badAreas; {rect}];