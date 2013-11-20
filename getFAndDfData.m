function [fData dfData] = getFAndDfData(minX, maxX)
global data 
    [height stam] = size(data.imgData);
    fData = zeros(height,1);
    minX = int32(minX);
    maxX = int32(maxX);
    % building the F values for the column - for each row we average all the
    % pixels within it and this value is the F value of that row
    columnValues = data.imgData(:,minX:maxX);
    if(data.isAveraging)
        columnValues = int32(sum(columnValues,2));
        columnValues = columnValues/(maxX-minX);
    else
        columnValues = columnValues';
        columnValues = columnValues(1:numel(columnValues))';
    end
    if(data.fixPhotobleaching)
        fData = getSignalAfterLinearRegression(columnValues,'Median',9); %fixing photobleaching
    else
        fData = double(columnValues);
    end
    numOfImages =  ceil(height / data.numOfLinesInImage);
    % for each image in the line scan (which is built of several images) we
    % find the base F and use it to calculate df/f
    dfData = [];
    fixedF = [];
    tmpFixedF = [];
    pixelsInExtactedLine = 1;
    if(~data.isAveraging)
        pixelsInExtactedLine = maxX-minX +1;
    end
    for i=1:numOfImages  
      imageStartIndex = (i-1)*data.numOfLinesInImage*pixelsInExtactedLine + 1;
      imageEndIndex = i*data.numOfLinesInImage*pixelsInExtactedLine;
      if(height*pixelsInExtactedLine<imageEndIndex)
          imageEndIndex = height;
      end
      tmpPartialF = double(fData(imageStartIndex:imageEndIndex));
      %tmpPartialF = getSignalAfterLinearRegression(double(tmpPartialF));
      fixedF = [fixedF ; tmpPartialF];
      avgTmpPartialF = average(tmpPartialF,25*pixelsInExtactedLine);
      %avgTmpPartialF = filterBadAreas(avgTmpPartialF, minX, maxX);
      baseF = min(avgTmpPartialF);
      tmpPartialF = (tmpPartialF - baseF) / baseF;
      %tmpPartialF = getSignalAfterLinearRegression(tmpPartialF,'Median',9);
      dfData = [dfData ;tmpPartialF];
    end
    %fData = fixedF;
    
function avgAfterFilt = filterBadAreas(avgBeforeFilt, minX, maxX)
    [rows cols] = size(avgBeforeFilt);
    avgAfterFilt = [];
    for i=1:rows
        filteredValue = 0;
        if(isIntervalValid(i,i+25,minX, maxX))
            filteredValue = avgBeforeFilt(i);
        else
            filteredValue = 65000;
        end
        avgAfterFilt = [avgAfterFilt;filteredValue];
    end
