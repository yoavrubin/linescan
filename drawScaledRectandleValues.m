function markedAreaHandle = drawScaledRectandleValues(origData, targetData, origRect, targetAxesHandle, sourceAxesHandle, ghoustIndex)
    targetRect = [];
    if(targetAxesHandle == sourceAxesHandle)
        targetRect = origRect;
    else
        x = uint16(origRect(1));
        w = uint16(origRect(3));
        sourceRectMin = double(origRect(2));
        sourceRectMax = double(origRect(2)+origRect(4));
        [sourceMin sourceMax sourceRange] = getEdgesAndRange(sourceAxesHandle);
        pMin = (sourceRectMin - sourceMin)/sourceRange;
        pMax = (sourceRectMax - sourceMin)/sourceRange;
        [targetMin targetMax targetRange] = getEdgesAndRange(targetAxesHandle);
        targetRectMin = pMin*targetRange + targetMin;
        targetRectMax = pMax*targetRange + targetMin;
        targetRectHeight = targetRectMax - targetRectMin;
        centralXLocation = x + w/2;
        targetLineY = double(targetData(centralXLocation));
        targetRectMin = targetLineY - 0.5*targetRectHeight;
        targetRect =[double(x) targetRectMin double(w) targetRectHeight];
    end
    markedAreaHandle = rectangle('Parent',targetAxesHandle,'Position',targetRect, 'EdgeColor','g');
