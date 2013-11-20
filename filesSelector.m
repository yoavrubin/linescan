function varargout = filesSelector(varargin)
% FILESSELECTOR M-file for filesSelector.fig
%      FILESSELECTOR, by itself, creates a new FILESSELECTOR or raises the
%      existing
%      singleton*.
%
%      H = FILESSELECTOR returns the handle to a new FILESSELECTOR or the handle to
%      the existing singleton*.
%
%      FILESSELECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILESSELECTOR.M with the given input arguments.
%
%      FILESSELECTOR('Property','Value',...) creates a new FILESSELECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before filesSelector_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to filesSelector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help filesSelector

% Last Modified by GUIDE v2.5 02-Feb-2010 08:54:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @filesSelector_OpeningFcn, ...
                   'gui_OutputFcn',  @filesSelector_OutputFcn, ...
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


% --- Executes just before filesSelector is made visible.
function filesSelector_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for filesSelector
global usedPath  filesSelectorHandles data
    handles.output = hObject;
    filesSelectorHandles = handles;

%     if(strcmp(data.files.cfg,'stam'))
%         data.files.cfg = '';
%     end
    set(handles.lsdText,'String', data.files.lsd);
    set(handles.datText,'String', data.files.dat);
%     set(handles.cfgText,'String', data.files.cfg);

    toggleControls();
    % Update handles structure
    guidata(hObject, handles);
    if(isempty(usedPath))
        usedPath = '';
    end
% UIWAIT makes filesSelector wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = filesSelector_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
    varargout{1} = handles.output;

function lsdText_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function datText_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% function cfgText_CreateFcn(hObject, eventdata, handles)
%     if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%         set(hObject,'BackgroundColor','white');
%     end

function lsdBrowse_Callback(hObject, eventdata, handles)
global data usedPath
    [FileName,PathName] = uigetfile(strcat(usedPath,'*.lsd'),'Select Line Scan Data File');
    if isequal(FileName,0)
        return;
    end
    fileLocation = strcat(PathName,FileName);
    usedPath = PathName;
    set(handles.lsdText,'String',fileLocation);
    data.files.lsdPath = PathName;
    data.files.lsd = fileLocation;
    toggleFinishButton();
    toggleSetupDataUsage();

function datBrowse_Callback(hObject, eventdata, handles)
global usedPath data
    [FileName,PathName] = uigetfile(strcat(usedPath,'*.dat'),'Select Stimuli Data File') ;
    if isequal(FileName,0)
        return;
    end
    fileLocation = strcat(PathName,FileName);
    usedPath = PathName;
    set(handles.datText,'String',fileLocation);
    data.files.dat = fileLocation;
    toggleFinishButton();
    toggleSetupDataUsage();

function readFromLSDRadio_Callback(hObject, eventdata, handles)
global data
    data.files.dat = '';
    setReadingStimuliDataFromLSDFile(1);

function browseRadio_Callback(hObject, eventdata, handles)
global data
    data.files.dat = get(handles.datText,'String');
    setReadingStimuliDataFromLSDFile(0);

function notUsingStimuli_Callback(hObject, eventdata, handles)
global data
    data.usingStimuli = 0;
    toggleControls();

function usingStimuli_Callback(hObject, eventdata, handles)
global data 
    data.usingStimuli = 1;
    toggleControls();

function finishBtn_Callback(hObject, eventdata, handles)
global data 
    data.filesUsage.imageFilters = useFile(handles.useImageFilters);
    data.filesUsage.columns = useFile(handles.useColumns);
    data.filesUsage.applyMedianFilter = get(handles.medianFilterCB,'Value');
    data.fixPhotobleaching = get(handles.fixPhotobleachingCB, 'Value');
    if(~data.filesUsage.imageFilters && strcmp(get(handles.useImageFilters,'Enable'), 'on')) 
        % image filters were defined previously and now we don't want to use
        % them -> we need to delete this file so its next usage would be on a
        % clean file
         fullFileName =  strcat(data.files.lsdPath,'imageSetup.imageSetup');
         delete(fullFileName); 
    end
    close(handles.figure1);
    loadExperiment();

function toUse = useFile(cbHandle)
    toUse = strcmp(get(cbHandle,'Enable'), 'on') && get(cbHandle,'Value') ;
        

function cancelBtn_Callback(hObject, eventdata, handles)
    close(handles.figure1);

function toggleControls()
global data
    toggleSetupDataUsage();
    if (isempty(data.files.lsd)) % initial state
        setUsingStimuli(1);
        return;
    end
    setUsingStimuli(data.usingStimuli);

function setUsingStimuli(isUsing)
global data filesSelectorHandles
    data.usingStimuli = isUsing;
    if(isUsing)
        set(filesSelectorHandles.usingStimuli,'Value',1);
        set(filesSelectorHandles.notUsingStimuli,'Value',0);
        set(filesSelectorHandles.readFromLSDRadio,'Enable','on');
        set(filesSelectorHandles.browseRadio,'Enable','on');
%         set(filesSelectorHandles.cfgText,'Enable','inactive');
%         set(filesSelectorHandles.cfgBrowse,'Enable','on');
        if(isempty(data.files.dat))
            setReadingStimuliDataFromLSDFile(1);
        else
            setReadingStimuliDataFromLSDFile(0);
        end
    else
        set(filesSelectorHandles.usingStimuli,'Value',0);
        set(filesSelectorHandles.notUsingStimuli,'Value',1);
        set(filesSelectorHandles.readFromLSDRadio,'Enable','off');
        set(filesSelectorHandles.browseRadio,'Enable','off');
%         set(filesSelectorHandles.cfgText,'Enable','off');
%         set(filesSelectorHandles.cfgBrowse,'Enable','off');
        setReadingStimuliDataFromLSDFile(1);
    end

function  setReadingStimuliDataFromLSDFile(isReadingFromLSD)
global filesSelectorHandles
    if(isReadingFromLSD)
        set(filesSelectorHandles.readFromLSDRadio,'Value',1);
        set(filesSelectorHandles.browseRadio,'Value',0);
        set(filesSelectorHandles.datText,'Enable','off');
        set(filesSelectorHandles.datBrowse,'Enable','off');
    else
        set(filesSelectorHandles.readFromLSDRadio,'Value',0);
        set(filesSelectorHandles.browseRadio,'Value',1);
        set(filesSelectorHandles.datText,'Enable','inactive');
        set(filesSelectorHandles.datBrowse,'Enable','on');            
    end
    toggleFinishButton();
         
function toggleFinishButton()
global filesSelectorHandles data
    if(isempty(data.files.lsd))
        %not having lsd file
        set(filesSelectorHandles.finishBtn,'Enable','off');
        return;
    end
    if(~data.usingStimuli)
        %we have lsd file and it is a spontaneous data experiment
         set(filesSelectorHandles.finishBtn,'Enable','on');
         return;
    end
%     if(~data.usingStimuli)
%         %we have lsd file, it is a stimulated experiment and we don't have a
%         %cfg file
%         set(filesSelectorHandles.finishBtn,'Enable','off');
%         return;
%     end
    if(get(filesSelectorHandles.readFromLSDRadio,'Value'))
    % we have the lsd and cfg files, it is a stimulated experiment and we are reading
    % stimuli data from the lsd file
         set(filesSelectorHandles.finishBtn,'Enable','on');
         return;
    end
    if(isempty(data.files.dat))
    %we have the lsd and cfg files, it is a stimulated experiment, we don't
    %read the stimuli data from the lsd file and we don't have a dat file
             set(filesSelectorHandles.finishBtn,'Enable','off');
    else
    %we have the lsd and cfg files, it is a stimulated experiment, we don't
    %read the stimuli data from the lsd file and we have a dat file
         set(filesSelectorHandles.finishBtn,'Enable','on');
    end

function toggleSetupDataUsage()
global filesSelectorHandles
    toggleFileUsage('imageSetup.imageSetup', filesSelectorHandles.useImageFilters);
    toggleFileUsage('columns.columns', filesSelectorHandles.useColumns);
    
function toggleFileUsage(fileName, usageCheckboxHandle)
global data
    if(isempty(data.files.lsdPath))
        set(usageCheckboxHandle,'Enable','off');
    end
    fullFileName =  strcat(data.files.lsdPath,fileName);
    fid = fopen(fullFileName);
    if(fid == -1)
        set(usageCheckboxHandle,'Enable','off');
    else
        set(usageCheckboxHandle,'Enable','on');
        set(usageCheckboxHandle,'Value',1);
        fclose(fid);
    end

