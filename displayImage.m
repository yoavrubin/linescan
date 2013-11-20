function displayImage(imageContent, theAxis)
    imshow(imageContent, 'Parent',theAxis);
    [imageHandle, axHandle, figHandle] = imhandles(theAxis); 
    imageHandle = imageHandle(1);
    axHandle = axHandle(1);
    cdata = get(imageHandle, 'CData');
    imageRange = [double(min(cdata(:))) double(max(cdata(:)))];
    if(imageRange(1) < imageRange(2))
        set(axHandle,'Clim', imageRange);
    end