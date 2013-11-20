function setHorizontalScrollerPositionWithinParent(imageWidth, scrollerHandle, imageHandle)

    position = get(scrollerHandle,'Value');
    parentW = get(imageHandle,'Parent');
    parentPos = get(parentW,'Position');
    parentWidth = parentPos(3);
    pos = get(imageHandle,'Position');
    pos(1) =(parentWidth-imageWidth)*position;
    pos(3) = imageWidth;%just in case
    set(imageHandle, 'Position', pos);    
