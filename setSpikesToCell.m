function setSpikesToCell(cellName, spikes)
global cells
    numOfCells = size(cells);
    for i=1:numOfCells
        if(strcmp(cells(i).name, cellName))
                cells(i).spikes = spikes;
                break;
        end
    end