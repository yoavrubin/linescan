function writeDataToFile(fileName, xData, yData,headerLine)
    global state
    numOfPoints = numel(xData);
    if(state.export.overwrite)
        fileId = fopen(fileName,'w');
    else
        fileId = fopen(fileName,'a');
    end
    if(nargin == 4)
        fprintf(fileId,'%s\n',headerLine);
    end
    for i=1:numOfPoints
        fprintf(fileId,'%f\t%f\n',xData(i),yData(i));
    end
    fclose(fileId);
