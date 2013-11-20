function drawImageOnAxes(theAxis, sourceName, numOfPoints)
global data
    ref = imread(strcat(data.files.lsdPath,sourceName));
    data.referenceImageData = ref;
    displayImage(ref, theAxis);
    if(~isempty(data.refLineX))
        startLineX = data.refLineX(1:10);
        startLineY = data.refLineY(1:10);
        endMiddle = numOfPoints-10;
        middleLineX = data.refLineX(11: endMiddle);
        middleLineY = data.refLineY(11:endMiddle);
        endLineX = data.refLineX(endMiddle+1 : numOfPoints);
        endLineY = data.refLineY(endMiddle+1 : numOfPoints);
        data.lineHandles = [data.lineHandles ; line(startLineX,startLineY,'Color','g','Parent',theAxis)];
        data.lineHandles = [data.lineHandles ; line(middleLineX,middleLineY,'Color','y','Parent',theAxis)];
        data.lineHandles = [data.lineHandles ; line(endLineX,endLineY,'Color','r','Parent',theAxis)];
    end
