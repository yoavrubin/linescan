function createColumnByXW(x, w)
  deselectMarkedCell();
  [rectHandle refSubLine] = drawColumn(x, w, createRandomColor(),1);
  analyseColumn(x);
  selectCell(rectHandle,refSubLine);