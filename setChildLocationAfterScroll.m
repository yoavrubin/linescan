function setChildLocationAfterScroll(realHeight, childHandle, position)
    parentH = get(childHandle,'Parent');
    parentPos = get(parentH,'Position');
    parentHeight = parentPos(4);
    pos = get(childHandle,'Position');
    pos(2) =(parentHeight-realHeight)*position;
    pos(4) = realHeight;%just in case
    set(childHandle, 'Position', pos);
