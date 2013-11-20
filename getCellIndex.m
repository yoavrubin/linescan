function index = getCellIndex(cellName)
global cells
    index = find(strcmp(cellName,{cells.name}));