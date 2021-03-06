function varargout = exportDialog(varargin)
% EXPORTDIALOG M-file for exportDialog.fig
%      EXPORTDIALOG, by itself, creates a new EXPORTDIALOG or raises the existing
%      singleton*.
%
%      H = EXPORTDIALOG returns the handle to a new EXPORTDIALOG or the handle to
%      the existing singleton*.
%
%      EXPORTDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPORTDIALOG.M with the given input arguments.
%
%      EXPORTDIALOG('Property','Value',...) creates a new EXPORTDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before exportDialog_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to exportDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help exportDialog

% Last Modified by GUIDE v2.5 02-Feb-2010 12:40:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @exportDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @exportDialog_OutputFcn, ...
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


% --- Executes just before exportDialog is made visible.
function exportDialog_OpeningFcn(hObject, eventdata, handles, varargin)
global data
    handles.output = hObject;
    guidata(hObject, handles);
    try
        if(isempty(data.flourecencePlotData))
            allowToExportOnlyImage();
        end
    catch
        allowToExportOnlyImage(handles);
    end

% UIWAIT makes exportDialog wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function allowToExportOnlyImage(handles)
    preventFileExport(handles.fFileName,handles.fLabel);
    preventFileExport(handles.dfFileName, handles.dfLabel);
    preventFileExport(handles.firstDerivationFileName,handles.firstDerivationLabel);
    preventFileExport(handles.stimFileName, handles.stimLabel);

 function preventFileExport(fileNameHandle, labelHandle)    
    set(fileNameHandle,'String','');
    set(fileNameHandle,'Enable','off');
    set(labelHandle,'Enable','off');    
        
% --- Outputs from this function are returned to the command line.
function varargout = exportDialog_OutputFcn(hObject, eventdata, handles) 
    varargout{1} ='';

% --- Executes during object creation, after setting all properties.
function fFileName_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function dfFileName_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function firstDerivationFileName_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function stimFileName_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function referenceImageFileName_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function lsImageFileName_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes during object creation, after setting all properties.
function directoryName_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function browseBtn_Callback(hObject, eventdata, handles)
global data
    directory = uigetdir(data.files.lsdPath ,'Export Experiment Data');
    if(~directory)
        return;
    end
    set(handles.directoryName,'String',directory);
    set(handles.exportBtn,'Enable','on');

function exportBtn_Callback(hObject, eventdata, handles)
global lineScanFigureHandles data
    startIndex = -1;
    endIndex = -1;
    set(handles.exportBtn,'Enable','off');
    if(get(handles.allRadio,'Value') || get(handles.allCellsData,'Value'))
        startIndex = 1;
        endIndex = -1;%size(data.imgData,1);
    else
        [startIndex endIndex] = getViewedWindowEnds(data.imgData, lineScanFigureHandles.imageHoldingPanel,lineScanFigureHandles.imageScroller);
    end
    if(get(handles.allCellsData,'Value'))
        exportAllCells(handles, startIndex, endIndex);
    else
        
        doExport(handles, startIndex, endIndex,true,'');
    end  
    set(handles.exportBtn,'Enable','on');
    close(handles.figure1);

function exportAllCells(handles, startIndex, endIndex)
global cells data
    numCells = numel(cells);
    currentCellData.F = data.flourecencePlotData;
    currentCellData.df = data.dfPlotData;
    currentCellData.firstDerivation = data.firstDerivation;
    %currentCellData.stimData = data.stimuliData;
    for i=1:numCells
        cell = cells(i);
        data.flourecencePlotData = cell.F;
        data.dfPlotData = cell.dF;
        data.stimData = cell.stimuli;
        data.firstDerivation = cell.firstDerivation;
        doExport(handles, startIndex, endIndex,i==1, cell.name);
    end
    if(numCells == 0)
        doExport(handles, startIndex, endIndex,1, '');
    end
    data.flourecencePlotData = currentCellData.F;
    data.dfPlotData = currentCellData.df;
    data.firstDerivation = currentCellData.firstDerivation;
    %data.stimuliData = currentCellData.stimData;

function theName = getFileNameByHandle(handle, postfix)
    nm = get(handle,'String');
    theName = strcat(nm,'_',postfix,'.txt');
    
function doExport(handles, startIndex, endIndex, exportImages, namePostfix)
    global state
    fileNames.f = getFileNameByHandle(handles.fFileName,namePostfix);
    fileNames.df = getFileNameByHandle(handles.dfFileName,namePostfix);
    fileNames.firstDerivation = getFileNameByHandle(handles.firstDerivationFileName,namePostfix);
    fileNames.stimuli = getFileNameByHandle(handles.stimFileName,namePostfix);
    fileNames.directory = get(handles.directoryName,'String');
    if(exportImages)
        fileNames.lsImage = get(handles.lsImageFileName,'String');
        fileNames.referenceImage = get(handles.referenceImageFileName,'String');
    else
        fileNames.lsImage = [];
         fileNames.referenceImage = [];
    end
    state.export.overwrite = get(handles.overwriteCB,'Value');
    exportData(startIndex, endIndex, fileNames);
   
        
    
function CancelBtn_Callback(hObject, eventdata, handles)
    close(handles.figure1);

function toggleImageControls(handles,onOrOff)
    set(handles.referenceImageFileName, 'Enable',onOrOff); 
    set(handles.refImageLbl, 'Enable',onOrOff); 
    set(handles.lsImageLbl, 'Enable',onOrOff); 
    set(handles.lsImageFileName, 'Enable',onOrOff); 
    

% --- Executes on button press in allRadio.
function allRadio_Callback(hObject, eventdata, handles)
    toggleImageControls(handles,'on');

% --- Executes on button press in partialRadio.
function partialRadio_Callback(hObject, eventdata, handles)
    toggleImageControls(handles,'on');


% --- Executes on button press in allCellsData.
function allCellsData_Callback(hObject, eventdata, handles)
   % toggleImageControls(handles,'off');


