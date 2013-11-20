function performLSImageChange(undoTitle, newImageValue)
    pushActionToUndoStack(undoTitle);
    updateLinescanImage(newImageValue);