function varargout = imageStimuliMatchDialog(varargin)
% IMAGESTIMULIMATCHDIALOG M-file for imageStimuliMatchDialog.fig
%      IMAGESTIMULIMATCHDIALOG, by itself, creates a new IMAGESTIMULIMATCHDIALOG or raises the existing
%      singleton*.
%
%      H = IMAGESTIMULIMATCHDIALOG returns the handle to a new IMAGESTIMULIMATCHDIALOG or the handle to
%      the existing singleton*.
%
%      IMAGESTIMULIMATCHDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGESTIMULIMATCHDIALOG.M with the given input arguments.
%
%      IMAGESTIMULIMATCHDIALOG('Property','Value',...) creates a new IMAGESTIMULIMATCHDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageStimuliMatchDialog_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageStimuliMatchDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imageStimuliMatchDialog

% Last Modified by GUIDE v2.5 06-Dec-2007 13:59:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageStimuliMatchDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @imageStimuliMatchDialog_OutputFcn, ...
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


% --- Executes just before imageStimuliMatchDialog is made visible.
function imageStimuliMatchDialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imageStimuliMatchDialog (see VARARGIN)
global imageMatchingData imageStimuliMatchHandles
% Choose default command line output for imageStimuliMatchDialog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

imageStimuliMatchHandles = handles;

imageIndices = [];
for i=1:imageMatchingData.numOfImageFiles
    imageIndices = [imageIndices ; {num2str(i)}];
end

set(handles.imageIndexCombo,'String',imageIndices);

imageMatchingData.nextStimFileIndex = imageMatchingData.numOfStimFiles +1;

stimuliIndices = [];
for s=1:imageMatchingData.numOfStimFiles
    stimuliIndices = [stimuliIndices ; {num2str(s)}];
end

set(handles.stimuliIndexCombo,'String',stimuliIndices);

imageMatchingData.result = zeros(imageMatchingData.numOfImageFiles,1);
buildImageMatchPresentation();

% UIWAIT makes imageStimuliMatchDialog wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imageStimuliMatchDialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = '';%handles.output;


% --- Executes during object creation, after setting all properties.
function matchList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to matchList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function stimuliIndexCombo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimuliIndexCombo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function imageIndexCombo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageIndexCombo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in viewStimuliBtn.
function viewStimuliBtn_Callback(hObject, eventdata, handles)
% hObject    handle to viewStimuliBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imageMatchingData

stimIndex = get(handles.stimuliIndexCombo,'Value');
[numOfPoints stam] = size(imageMatchingData.allStims{stimIndex});
xValues = (1:numOfPoints);
drawDataOnAxes(handles.stimuliPreviewAxes, xValues, imageMatchingData.allStims{stimIndex});

% --- Executes on selection change in matchList.
function matchList_Callback(hObject, eventdata, handles)
% hObject    handle to matchList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns matchList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from matchList

selected = get(hObject,'Value');
if(~isempty(selected))
    set(handles.removeSelectedBtn,'Enable','on');
else
    set(handles.removeSelectedBtn,'Enable','off');
end

% --- Executes on button press in removeSelectedBtn.
function removeSelectedBtn_Callback(hObject, eventdata, handles)
% hObject    handle to removeSelectedBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imageMatchingData
selected = get(handles.matchList,'Value');
numSelected = numel(selected);
for i=1:numSelected
    indx = uint16(selected(i));
    imageMatchingData.result(indx) = 0; 
end
buildImageMatchPresentation();
set(handles.removeSelectedBtn,'Enabled','off');
if(numSelected == imageMatchingData.numOfImageFiles)
    set(handles.removeAllBtn,'Enable','off');
end

% --- Executes on button press in removeAllBtn.
function removeAllBtn_Callback(hObject, eventdata, handles)
% hObject    handle to removeAllBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imageMatchingData
imageMatchingData.result = zeros(imageMatchingData.numOfImageFiles,1);
buildImageMatchPresentation();
set(handles.removeSelectedBtn,'Enabled','off');
set(handles.removeAllBtn,'Enable','off');


% --- Executes on button press in finishBtn.
function finishBtn_Callback(hObject, eventdata, handles)
% hObject    handle to finishBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data imageMatchingData
fileName = strcat(data.files.lsdPath,'match.match');
fid = fopen(fileName,'w');
for i=1:imageMatchingData.numOfImageFiles
    fprintf(fid,'image %d stim %d\n', [i imageMatchingData.result(i)]);
end
fclose(fid);
%uiresume(handles.figure1);
delete(handles.figure1);
% --- Executes on button press in matchBtn.
function matchBtn_Callback(hObject, eventdata, handles)
% hObject    handle to matchBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imageMatchingData

remainingImages = get(handles.imageIndexCombo,'String');
selectedImageIndex = get(handles.imageIndexCombo,'Value');
imageIndex = remainingImages{selectedImageIndex};

stimuliIndex = get(handles.stimuliIndexCombo,'Value');
imageMatchingData.result(str2num(imageIndex)) = stimuliIndex;
buildImageMatchPresentation();
set(handles.removeAllBtn,'Enable','on');
%---------------------------------------------------
% Utilities
%---------------------------------------------------

function buildImageMatchPresentation()
global imageMatchingData imageStimuliMatchHandles

allMatches = [];
imagesIndices = [];
for i=1:imageMatchingData.numOfImageFiles
    indexAsString = num2str(i);
    if(imageMatchingData.result(i))
        matchStr = ['Image: ' indexAsString ' -> stimuli: ' num2str(imageMatchingData.result(i))];
        allMatches = [allMatches ; {matchStr}];
    else
        imagesIndices = [imagesIndices ; {indexAsString}];
    end
end

[numOfMatches stam] = size(allMatches);
if(numOfMatches == imageMatchingData.numOfImageFiles)
    set(imageStimuliMatchHandles.matchBtn,'Enable','off');
    set(imageStimuliMatchHandles.finishBtn,'Enable','on');
    imagesIndices = [{'No More Images'}];
else
    set(imageStimuliMatchHandles.matchBtn,'Enable','on');
    set(imageStimuliMatchHandles.finishBtn,'Enable','off');
end
set(imageStimuliMatchHandles.matchList,'Value',[]);
set(imageStimuliMatchHandles.matchList,'String',allMatches);
set(imageStimuliMatchHandles.imageIndexCombo,'String',imagesIndices);



% --- Executes on button press in importStimFile.
function importStimFile_Callback(hObject, eventdata, handles)
% hObject    handle to importStimFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imageMatchingData data
[FileName,PathName] = uigetfile(strcat(data.files.lsdPath,'*.dat'),'Select Stimuli Data File') ;
if isequal(FileName,0)
    return;
end
source = strcat(PathName, FileName);
nextFileIndexAsString = '';
if(imageMatchingData.nextStimFileIndex <10)
    nextFileIndexAsString = strcat('0',num2str(imageMatchingData.nextStimFileIndex));
else
    nextFileIndexAsString = num2str(imageMatchingData.nextStimFileIndex);
end
target = strrep(imageMatchingData.stimFileNameSample,'01.dat',strcat(nextFileIndexAsString,'.dat'));
copyfile(source, target);
imageMatchingData.numOfStimFiles = imageMatchingData.numOfStimFiles+1;
stimuliIndices = [];
for s=1:imageMatchingData.numOfStimFiles
    stimuliIndices = [stimuliIndices ; {num2str(s)}];
end

set(handles.stimuliIndexCombo,'String',stimuliIndices);
numOfPixels = size(data.imgData,1)/imageMatchingData.numOfImageFiles;
stimFileContent = stimFileReader(target,numOfPixels);
 imageMatchingData.allStims = [imageMatchingData.allStims ; {stimFileContent}];
imageMatchingData.nextStimFileIndex = imageMatchingData.nextStimFileIndex +1;
msgbox(['New stimuli file is now at index ' num2str(imageMatchingData.nextStimFileIndex -1)],'Import finished');