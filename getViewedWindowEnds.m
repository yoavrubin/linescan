function [startPoint endPoint]  = getViewedWindowEnds(imageData, panelhandle, scrollerHandle)  
    location = get(scrollerHandle,'Value');
    [imageHeight stam] = size(imageData);
    panelPos = get(panelhandle,'Position');
    panelHeight = panelPos(4);
    realLoc = (panelHeight-imageHeight)*location;
    startPoint =imageHeight -  uint16(panelHeight-realLoc) +1;
    endPoint =imageHeight -  uint16(0-realLoc) +1;
 