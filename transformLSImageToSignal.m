function signal = transformLSImageToSignal()
global data
% considering the bad areas so they  will not effect the averaging
% calculation
    tmpImgData = double(data.imgData);
    %tmpImgData = fillBadAreasWithValue(tmpImgData,0);
    [numOfRows cols] = size(tmpImgData);
    numOfImages = numOfRows / data.numOfLinesInImage;
    summedImage = zeros(data.numOfLinesInImage,cols);
    for i=1:numOfImages
        imgStartIndx = ((i -1)* data.numOfLinesInImage) +1;
        imgEndIndex = i*data.numOfLinesInImage;
        tmpImage = tmpImgData(imgStartIndx:imgEndIndex, :);
        summedImage = summedImage+ tmpImage;
    end
    goodPixelCntImage = ones(size(tmpImgData));
    goodPixelCntImage = sum(goodPixelCntImage);
    img = sum(summedImage); %img is a single line holding the average pixel value in each column 
    for j=1:cols
        img(j) = img(j) / goodPixelCntImage(j);
    end
    sorted = sort(img);
    nonZeroIndex = 0;
    while (1)
        nonZeroIndex = nonZeroIndex +1;
        if(sorted(nonZeroIndex) > 0)
            break;
        end
    end
    nonZeroMin = sorted(nonZeroIndex);
    img = img - nonZeroMin;
    maxVal = max(img);
    signal = img/ maxVal;