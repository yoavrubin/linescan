function [imageStartPoint imageEndPoint] = getSubImageInterval(subImageIndex, rowsPerSubImage)
    imageStartPoint = uint32((subImageIndex-1)*rowsPerSubImage+1);
    imageEndPoint = uint32((subImageIndex)*rowsPerSubImage);
