function cellSpikes = getSpikesForCell(cellName)
    cell = getCellByName(cellName);
    cellSpikes = cell.spikes.x; 
