function pushActionToUndoStack(actionTitle)
global lineScanFigureHandles data
    undoAction.title =actionTitle;
    undoAction.image = data.imgData;
    data.imageUndoStack = [data.imageUndoStack; undoAction];
    set(lineScanFigureHandles.undoBgOrSmooth,'Label',actionTitle,'Enable','on');