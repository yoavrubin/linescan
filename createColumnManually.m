function createColumnManually()
global lineScanFigureHandles
    axes(lineScanFigureHandles.image);
    if(get(lineScanFigureHandles.image,'Parent') ~= lineScanFigureHandles.imageHoldingPanel)
        set(lineScanFigureHandles.image,'Parent',lineScanFigureHandles.imageHoldingPanel);
    end
    rect  = getrect(lineScanFigureHandles.image);

    if(rect(3) == 0)
        return; %didn't mark the rectangle properly
    end
    createColumnByXW(rect(1), rect(3));