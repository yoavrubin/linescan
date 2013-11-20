function varargout = smoothingDialog(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @smoothingDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @smoothingDialog_OutputFcn, ...
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

% --- Executes just before smoothingDialog is made visible.
function smoothingDialog_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = smoothingDialog_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = '';

function smoothBtn_Callback(hObject, eventdata, handles)
    smoothingPixels = zeros(3,3);
    smoothingPixels(1,1) = get(handles.nwPixel,'Value');
    smoothingPixels(1,2) = get(handles.nPixel,'Value');
    smoothingPixels(1,3) = get(handles.nePixel,'Value');
    smoothingPixels(2,1) = get(handles.wPixel,'Value');
    smoothingPixels(2,3)= get(handles.ePixel,'Value');
    smoothingPixels(3,1) = get(handles.swPixel,'Value');
    smoothingPixels(3,2)= get(handles.sPixel,'Value');
    smoothingPixels(3,3) = get(handles.sePixel,'Value');
    set(hObject, 'Enable','off');
    smoothImage(smoothingPixels);
    set(hObject, 'Enable','on');
    delete(handles.figure1);

function cancelBtn_Callback(hObject, eventdata, handles)
    delete(handles.figure1);

