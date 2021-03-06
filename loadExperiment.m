function  loadExperiment()
%LOADEXPERIMENT Summary of this function goes here
%   Detailed explanation goes here
    global data lineScanFigureHandles state
    waitbarHandle= waitbar(0, 'Reading LSD file', 'Name', 'LineScan Analyzer Software Initialization', 'WindowStyle', 'modal', 'Pointer', 'watch');            
    data.usedColors = [];
    data.currentPosition = -1;
    data.stimGhoustAxis = [];
    data.stimuliData = [];
    data.valuesX = [];
    data.flourecencePlotData = [];
    data.dfPlotData = [];
    data.firstDerivation = [];
    data.imageUndoStack = [];
    data.objects.zoom = [];
    data.objects.pan = [];
    data.objects.cursor = [];
    data.lineHandles = [];
    data.recording.values = [];
    data.recording.preferedChannelIndex = -1;
    data.recording.blankingChannelIndex = -1;
    state.settingPosition = 0;
    state.data = 'noData';
    data.nextColIndex = 1;
    data.recordingData = [];
    data.preferedChannel = -1;
    fileLocation = data.files.lsd;
    data.rawStims = [];
    data.pixelResamplingFactor = 1;
    [sourceName data.refLineX data.refLineY numOfPoints sources numOfImages stimFileLoc]  = getLSDMetaData(fileLocation);
    waitbar(0.2,waitbarHandle, 'Creating Reference Image'); 
    channel1SourceName = 'q.qq';
    if(~isempty(strfind(sourceName,'_Ch2'))) %the chosen channel is channel 2
        channel1SourceName = strrep(sourceName, '_Ch2', '_Ch1');
        if(exist(strcat(data.files.lsdPath,channel1SourceName),'file')) %there is channel 1 and channel 2
            drawImageOnAxes(lineScanFigureHandles.channel1Image, channel1SourceName,numOfPoints);
            set(lineScanFigureHandles.channel2Btn,'Enable','on');
            set(lineScanFigureHandles.channel2Btn,'Value',1);
            set(lineScanFigureHandles.channel1Btn,'Enable','on');
        else %there is only channel 2
            set(lineScanFigureHandles.channel2Btn,'Enable','off');
            set(lineScanFigureHandles.channel2Btn,'Value',1);
            set(lineScanFigureHandles.channel1Btn,'Enable','off');
        end
    else %the chosen channel is channel 1
         set(lineScanFigureHandles.channel2Btn,'Enable','off');
         set(lineScanFigureHandles.channel1Btn,'Value',1);
         set(lineScanFigureHandles.channel1Btn,'Enable','off');
    end
    drawImageOnAxes(lineScanFigureHandles.referenceImage, sourceName,numOfPoints); %drawing the source - either channel 1 or 2  
    if(~strcmp('',data.files.dat)) 
        stimFileLoc = data.files.dat;
    else
        stimFileLoc = strrep(stimFileLoc,'.prm','.dat');
        stimFileLoc = strcat({data.files.lsdPath},stimFileLoc);
    end
    waitbar(0.3,waitbarHandle, 'Creating LineScan Image');
    sources = strcat({data.files.lsdPath},sources);
    cell = sources(1);
    img = imread(cell{1});
    rows = size(img,1);
    data.numOfLinesInImage = rows;
    numOfImages = numel(sources); 
    for i = 2:numOfImages
        cell = sources(i);
        tmpImage = imread(cell{1});
        img = [img ; tmpImage];
    end
    if(data.filesUsage.applyMedianFilter)
        data.imgData = medfilt2(img,[3 3]);
    else
        data.imgData = img;
    end
    if(data.filesUsage.imageFilters)
        prepareImageAccordingToFilters();
    end
    set(lineScanFigureHandles.imageScroller,'Value',1);
    waitbar(0.6,waitbarHandle, 'Initializing display');
    a = get(lineScanFigureHandles.image);
    pos = a.Position;
    sz = size(data.imgData);
    height = sz(1);
    pos(4) = height;
    set(lineScanFigureHandles.image, 'Position', pos);
    imshow(data.imgData, 'Parent', lineScanFigureHandles.image);
    [imageHandle, axHandle, figHandle] = imhandles(lineScanFigureHandles.image); 
    imageHandle = imageHandle(1);
    axHandle = axHandle(1);
    cdata = get(imageHandle, 'CData');
    imageRange = [double(min(cdata(:))) double(max(cdata(:)))];
    set(axHandle,'Clim', imageRange);

    cla(lineScanFigureHandles.dFData,'reset');
    cla(lineScanFigureHandles.flourecenceData,'reset');
    cla(lineScanFigureHandles.firstDerivationAxes,'reset');
    if(~data.usingStimuli)
        if(data.filesUsage.columns)
            columnsFileName = strcat(data.files.lsdPath,'columns.columns');
            loadColumns( columnsFileName);
        end
        set(lineScanFigureHandles.figure1,'WindowButtonMotionFcn',[]);
        close(waitbarHandle);
        return;
    end
    setHorizontalScrollerPositionWithinParent(size(data.imgData,2),lineScanFigureHandles.imageHorizontalScroll,lineScanFigureHandles.image);
    set(lineScanFigureHandles.figure1,'WindowButtonMotionFcn',@mouseMoveOverLSFigure);
    waitbar(0.7,waitbarHandle, 'Reading Stimuli Data file');
    data.stimuliData = readStimFile(stimFileLoc,sz,numOfImages);
    data.rawFilteredStims = data.stimuliData;
    [rows cols] = size(data.stimuliData);
    data.valuesX = (1:1:rows);
    data.valuesX = data.valuesX';
    if(data.filesUsage.columns)
        columnsFileName = strcat(data.files.lsdPath,'columns.columns');
        loadColumns( columnsFileName);
    end
    close(waitbarHandle);

function allValues =  readStimFile(stimFileLocation, imageDims, numOfImages)
    numOfFiles = size(stimFileLocation,1);
    allValues = [];
    initPrefferedChannel(stimFileLocation{1});
    for i=1:numOfFiles
        stimFileContent = stimFileReader(stimFileLocation{i});
        allValues = [allValues ; stimFileContent];
    end
    
    imagedPixels = double(imageDims(1)*imageDims(2));
    step = double(numel(allValues))/imagedPixels;
    newPoints = 1:step:double(numel(allValues));
    res = interp1(allValues,newPoints);
    numOfPoints = numel(res);
    if (numOfPoints < imagedPixels)
        res(numOfPoints: imagedPixels) = res(numOfPoints);
    end  
    allValues = reshape(res(1:imagedPixels),  imageDims(2),imageDims(1))';
        
%the stimuli file is built of columns - each one matches a channel that was
%read in the triggerSync software. 
function stimFileContent = stimFileReader(stimFileLocation)
global data
    stimFileContent = [];
    stimFH = fopen(stimFileLocation,'r','b');
    if(stimFH == -1)
        return;
    end
    fread(stimFH,616 ,'int8');% header
    numOfColumns = fread(stimFH,1,'int32');
    pointsPerColumn = fread(stimFH,1,'int32') ; 
    recordedValues = fread(stimFH,pointsPerColumn*numOfColumns,'float32');
    recordedValues = reshape(recordedValues, pointsPerColumn, numOfColumns);
    blankingContent = [];
    expectedSamplesDuringImaging = double(data.recordingData.samplingRate) * (data.framePeriod/1000000.0);
    samplesDuringImaging = min(expectedSamplesDuringImaging,pointsPerColumn);
    %recordedValues = recordedValues(1:recordedValues,:);
    for cI=1:numOfColumns
        if(data.recordingData.activeChannels(cI) == data.preferedChannel)
           data.recording.preferedChannelIndex = cI;
           stimFileContent = recordedValues(:, cI);
        end
        if(data.recordingData.activeChannels(cI) == 7) %7 is the blanking channel
           data.recording.blankingChannelIndex = cI;
           blankingContent = recordedValues(:, cI);
        end
    end
    if(~isempty(blankingContent))
        stimFileContent = stimFileContent(1:samplesDuringImaging);
        tmpBlanking = blankingContent(1:samplesDuringImaging);
        stimFileContent = stimFileContent(tmpBlanking < 1.0);
    end
    data.rawStims = [data.rawStims; stimFileContent];
    data.recording.values = [data.recording.values ; recordedValues];
    fclose(stimFH);

function mouseMoveOverLSFigure(src, eventData)
global data lineScanFigureHandles state
    pt =  get(lineScanFigureHandles.figure1,'CurrentPoint');
    x= pt(1);
    y = pt(2);
    if( x<= data.positions.axisLeft || x>=data.positions.axisRight)
        return;
    end
    if(y >= data.positions.topF)
        return;
    end
    if(y<=data.positions.bottomFirstDerivation)
        return;
    end
    if(strcmp(state.data,'noData'))
        return;
    end
    if(y > data.positions.bottomF) % the cursor is over the flourecence data axis
        realPoint = get(lineScanFigureHandles.flourecenceData,'CurrentPoint');
        realX = uint32(realPoint(1,1));
        drawPointValues(realX);    
        return;
    end
    if(y >= data.positions.topDF)
        return;
    end
    if(y > data.positions.bottomDF)  % the cursor is over the df data axis
        realPoint = get(lineScanFigureHandles.dFData,'CurrentPoint');
        realX = uint32(realPoint(1,1));
        drawPointValues(realX);
        return;
    end
    if(y>data.positions.topFirstDerivation)
        return;
    end
    if(y > data.positions.bottomFirstDerivation)
        realPoint = get(lineScanFigureHandles.firstDerivationAxes,'CurrentPoint');
        realX = uint32(realPoint(1,1));
        drawPointValues(realX);
        return;
    end

function drawPointValues(realX)
global data lineScanFigureHandles
    data.realX = realX;
    if(realX <= 0 || realX > numel(data.valuesX))
        return;
    end
    flourecenceStr = ['Flourecence: ' num2str(data.flourecencePlotData(realX))];
    dfStr = ['dF/F: ' num2str(data.dfPlotData(realX))];
    firstDerStr = ['first Derivation: ' num2str(data.firstDerivation(realX))];
    if(data.isAveraging)
        factor = numel(data.valuesX) /data.numOfLinesInImage ;
        realRealTime = realX/factor;
    else
        realRealTime = realX;
    end
    timeStr = ['Time: ' num2str(pixelToTime(realRealTime)) ' (ms)'];
    lineStr = ['Line: ' num2str(realRealTime)];
    tooltipString = [{flourecenceStr}; {dfStr};{firstDerStr}; {timeStr}; {lineStr}];
    set(lineScanFigureHandles.stimTooltip, 'String',tooltipString);