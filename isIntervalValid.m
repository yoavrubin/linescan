function isValid = isIntervalValid(minY, maxY,minX, maxX)
global data
    isValid = 1;
    [numOfBadAreas stam] = size(data.badAreas);
    for i=1:numOfBadAreas
        badArea = data.badAreas{i}; % bad area is a rectangle (x y w h)
        if(minY> badArea(2)+badArea(4)) % interval is above the bad area
            continue;
        end
        if(maxY < badArea(2)) % interval is under the bad area
            continue;
        end
        if(minX > badArea(1) + badArea(3)) % interval is on the right of the bad area
            continue;
        end
        if(maxX < badArea(1)) % interval is on the left of the bad area
            continue;
        end    
        isValid = 0;
        return;
    end
