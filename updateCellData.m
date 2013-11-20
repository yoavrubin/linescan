function updateCellData(cellIndex, x, width)
global cells data
    cell = cells(cellIndex);
    [cells(cellIndex).F cells(cellIndex).dF] = getFAndDfData(x, x+width);
        cells(cellIndex).firstDerivation = deriveVector(cells(cellIndex).dF);
    xInt = int32(x);
    width = int32(width);
    if (~isempty(data.stimuliData))
        columnStim = data.stimuliData(:,xInt:xInt+width);
        if(data.isAveraging)
            columnStim = sum(columnStim,2)/double(width);
        else
            columnStim = columnStim';
            columnStim = columnStim(1:numel(columnStim))';
        end
         cells(cellIndex).stimuli = columnStim;
    else
        cells(cellIndex).stimuli = [];
    end
    cells(cellIndex).spikes = [];
