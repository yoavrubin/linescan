function image = popActionFromUndoStack()
global data lineScanFigureHandles
    lastActionIndex = numel(data.imageUndoStack);
    undoAction = data.imageUndoStack(lastActionIndex);
    image = undoAction.image;
    newLastIndex = lastActionIndex -1;
    if(newLastIndex < 1)
        set(lineScanFigureHandles.undoBgOrSmooth,'Label','Undo','Enable','off');
    else
        newLastUndoAction= data.imageUndoStack(newLastIndex);
        newUndoTitle = newLastUndoAction.title;
        set(lineScanFigureHandles.undoBgOrSmooth,'Label',newUndoTitle,'Enable','on');
    end
    data.imageUndoStack(lastActionIndex) = [];