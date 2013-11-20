function setImageLocationWithinPanel(imageData, imageAxesHandle, position)
    [imageHeight stam] = size(imageData);
    setChildLocationAfterScroll(imageHeight,imageAxesHandle, position);