function cell=getCellByName(name)
global cells
    cell = cells(strcmp(name,{cells.name}));