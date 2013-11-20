function saveColumns()
global data cells
    fileName = strcat(data.files.lsdPath,'columns.columns');
    fid = fopen(fileName,'w');
    [numOfCells stam] = size(cells);
    cell = [];
    for i=1:numOfCells
        cell = cells(i);
        pos = get(cell.columnHandle,'Position');
        x = pos(1);
        w = pos(3);
        r = cell.color(1);
        g = cell.color(2);
        b = cell.color(3);
        fprintf(fid,'cell=name: %s',cell.name);
        fprintf(fid,' x: %d w: %d r: %f g: %f b: %f isNeuron: %d\n',[x w r g b cell.isNeuron]);
        if(~isempty(cell.spikes))
            fprintf(fid,'spikes= threshold: %f significantDelta: %f minimalRadius: %d \n',[cell.spikes.threshold cell.spikes.significantDelta cell.spikes.minimalRadius]);
            numOfSpikes = numel(cell.spikes.x);
            fprintf(fid,'[');
            for j=1:numOfSpikes
                fprintf(fid,'%u %u;',[cell.spikes.x(j) cell.spikes.w(j)]);
            end
            fprintf(fid,']\n');

        end    
    end
    fclose(fid);