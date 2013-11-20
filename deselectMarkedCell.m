function deselectMarkedCell()
global markedCell
    if(markedCell.col == 0)
        return;
    end
    set(markedCell.col,'LineWidth',0.5);
    set(markedCell.marker,'LineWidth',0.5);    
    markedCell.col = 0;
    markedCell.marker = 0;    
