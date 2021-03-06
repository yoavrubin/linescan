function [sourceImageLocation x y numOfPoints imageSources numOfLineImages stimFileLoc] = getLSDMetaData(LSDFileLocation)
global data
    fid = fopen(LSDFileLocation);
    sourceTitle = 'Line* Image';
    title  = 'Line1 Image';
    stimFileTemplateTitle = 'Line* Data';
    stimFileTitle = 'Line1 Data';
    imagesPerLineTitle = 'Line1 Number Images';
    imagesPerLineTitleTemplate = 'Line* Number Images';
    fragmentedSourceTitle = 'Line1 Image1';
    fragmentedSourceTitleTemplate = 'Line* Image?';
    sourceImageLocation = [];
    fragmentedLineIndex = 1;
    x = [];
    y = [];
    numOfPoints = 0;
    lineIndex = 0;
    needToIncreaseLineIndex = 1;
    imagesReadPerLine = 0;
    numOfLineImages = 0;
    imageSources  = {};
    stimFileLoc = {};
    while 1
        tline = fgetl(fid);
        if ~ischar(tline),   break,   end
        [token, remain] = strtok(tline, '=');
        if  strcmp(token, 'Source') && isempty(sourceImageLocation)
            sourceImageLocation = strtok(remain,'=');
            continue;
        end
        
        if(strcmp(token, 'Frame period (us)'))
            data.framePeriod = str2double(strtok(remain,'='));
            continue;
        end
        
        if(strcmp(token, 'Line1 Inter-Line Time'))
             data.timePerLine = double(str2num(strtok(remain,'=')));% the values is in ms (YR fix 26.10.2008)/1000.0; %the value is in us, we change it to ms
             continue;
        end
        if  strcmp(token, 'Line1 Freehand Point Count')
            numOfPoints = uint16(str2num(strtok(remain,'=')));
            x = zeros(numOfPoints,1);
            y = zeros(numOfPoints,1);
            for i=1:numOfPoints
                xline = fgetl(fid);
                yline = fgetl(fid);
                [token, remain] = strtok(xline,'=');
                xpt = strtok(remain,'=');
                x(i) = uint16(str2num(xpt));
                [token, remain] = strtok(yline,'=');
                ypt = strtok(remain,'=');
                y(i) = uint16(str2num(ypt));
            end
            if(numOfLineImages == 1)
                break;
            else
                continue;
            end
        end
        if strcmp(token,stimFileTitle)
            ind = numel(stimFileLoc);
            newStimFileLocValue = strtok(remain,'=');
            needToIncreaseLineIndex = ~needToIncreaseLineIndex;
            if(needToIncreaseLineIndex)
               lineIndex = lineIndex+1;
               title = strrep(sourceTitle,'*',num2str(lineIndex));
               stimFileTitle = strrep(stimFileTemplateTitle,'*',num2str(lineIndex));
            end
            if(~stringExistsInCells(newStimFileLocValue,stimFileLoc))
                stimFileLoc(ind+1,1) = {newStimFileLocValue};
            end
            findResult = strfind(stimFileLoc, newStimFileLocValue);
        end
        if  strcmp(token, 'Number Lines')
            numOfLineImages = uint16(str2num(strtok(remain,'=')));
            lineIndex = 1;
            continue;
        end
        if strcmp(token,title)
            imageSources(lineIndex,1) = {strtok(remain,'=')};
            needToIncreaseLineIndex = ~needToIncreaseLineIndex;
            if(needToIncreaseLineIndex)
                lineIndex = lineIndex+1;
                title = strrep(sourceTitle,'*',num2str(lineIndex));
                stimFileTitle = strrep(stimFileTemplateTitle,'*',num2str(lineIndex));
             end
        end
        if strcmp(token, imagesPerLineTitle)
            numOfImagesPerLine = str2num(strtok(remain,'='));
            lineIndex = lineIndex+1;
            imagesPerLineTitle = strrep(imagesPerLineTitleTemplate,'*',num2str(lineIndex));
            stimFileTitle = strrep(stimFileTemplateTitle,'*',num2str(lineIndex));
        end
        if strcmp(token,fragmentedSourceTitle)
            imageSources = [imageSources ; {strtok(remain,'=')}];
            imagesReadPerLine = imagesReadPerLine+1;
            if imagesReadPerLine == numOfImagesPerLine
                imagesReadPerLine = 0;
            end
            if imagesReadPerLine == 0
                fragmentedLineIndex = fragmentedLineIndex +1;
            end
            fragmentedSourceTitle = strrep(fragmentedSourceTitleTemplate,'*',num2str(fragmentedLineIndex));
            fragmentedSourceTitle = strrep(fragmentedSourceTitle,'?',num2str(imagesReadPerLine+1));
            stimFileTitle = strrep(stimFileTemplateTitle,'*',num2str(fragmentedLineIndex));
        end 
    end
    fclose(fid);
