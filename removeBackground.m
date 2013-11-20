function removeBackground()
global data  lineScanFigureHandles 
    rect= getrect(lineScanFigureHandles.referenceImage);
    [rows cols] = size(data.referenceImageData);
    if(rect(1) < 0 || rect(1) > cols || rect(2) < 0  || rect(2) > rows)
         return;
    end
    bg  = uint16(extracAverageValueFromRegion(rect(1), rect(2),rect(3),rect(4)));
    performLSImageChange( 'Undo Background Removal',data.imgData - bg);
    fileName = strcat(data.files.lsdPath,'imageSetup.imageSetup');
    fid = fopen(fileName,'a');   
    fprintf(fid,'bg=%f\n', bg);
    fclose(fid);

function avg =  extracAverageValueFromRegion(x,y,w,h)
global data 
    minX = uint16(x);
    maxX = uint16(x+w);
    minY = uint16(y);
    maxY = uint16(y+h);
    cnt = 0;
    total = uint32(0);
    for currX=minX:maxX
        for currY=minY:maxY
                total = total+uint32(data.referenceImageData(currY,currX));
                cnt = cnt+1;
        end
    end
    avg  = uint32(total/cnt);