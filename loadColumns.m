function loadColumns(columnsFileName)
    fid = fopen(columnsFileName);
    name = '';
    while(1)
        line = fgetl(fid);
        if ~ischar(line)
            break;
        end
        [token, remain] = strtok(line,'=');
        if(strcmp(token,'cell'))
            result = textscan(line,'%s %s  %s %d %s %d %s %f %s %f %s %f %s %d');  
            name = result{2};
            x= result{4};
            w=result{6};
            r=result{8};
            g=result{10};
            b=result{12};
            isNeuron=result{14}; 
            color = [r g b];
            setColorAsUsed(color);
            drawColumn(x,w, color,isNeuron, name);
        else
            realRem = strtok(remain,'=');
            result = textscan(line,'%s %s %f %s %f %s %d');
            spikes.threshold = result{3};
            spikes.significantDelta = result{5};
            spikes.minimalRadius = result{7};
            line = fgetl(fid);
            res = eval(line);
            spikes.x = res(:,1);
            spikes.w = res(:,2);
            setSpikesToCell(name, spikes);
        end
    end
    fclose(fid);