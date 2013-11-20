function newBigImage =   shiftSubImage(bigImage, numOfSubImages, movedImageIndex, shiftSize)
    newBigImage = bigImage;
    [height stam] = size(bigImage);
    rowsPerImage = height / numOfSubImages;
    [imageStartPoint imageEndPoint] = getSubImageInterval(movedImageIndex,rowsPerImage);
    partialImage = bigImage(imageStartPoint:imageEndPoint, :);
    partialImage =  circshift(partialImage,[0 double(shiftSize)]);
    newBigImage(imageStartPoint:imageEndPoint, :) = partialImage;
