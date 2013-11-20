function resultImage = fillBadAreasWithValue(baseImage, value)
global data
    resultImage = baseImage;
    numOfAreas = numel(data.badAreas);
    for i=1:numOfAreas
        rect = uint16(data.badAreas{i});
        resultImage(rect(i): rect(1)+rect(3) , rect(2): rect(2)+rect(4)) = value;
    end