function selectCell(column,marker)
global markedCell
    set(column,'LineWidth',2);
    set(marker,'LineWidth',2);        
    markedCell.col = column;
    markedCell.marker = marker;
