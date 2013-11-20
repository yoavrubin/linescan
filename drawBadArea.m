function drawBadArea(badAreas, axesHandle)
    axes(axesHandle);
    numOfAreas  = numel(badAreas);
    for i=1:numOfAreas
        rect = badAreas{i};
        drawnRect = rectangle('Position',rect,'EdgeColor','r','LineWidth',2);
        line1 = line([rect(1)  rect(1)+rect(3)],[rect(2) rect(2)+rect(4)],'Color','r','LineWidth',2);
        line2 = line([rect(1)+rect(3)  rect(1)],[rect(2) rect(2)+rect(4)],'Color','r','LineWidth',2);
        cmn = uicontextmenu;
        rmvMenu = uimenu(cmn,'Label','Remove','Callback',@removeBadArea);
        set(drawnRect,'UIContextMenu',cmn);
        set(line1,'UIContextMenu',cmn);
        set(line2,'UIContextMenu',cmn);
        set(rmvMenu,'UserData',[drawnRect line1 line2]);
    end

function removeBadArea(src, eventData)
global data
    uiElements = get(src,'UserData');
    rect = get(uiElements(1),'Position');
    numOfAreas = numel(data.badAreas);
    if(numOfAreas == 1)
        data.badAreas = [];
    else
        for i=1:numOfAreas
            area = data.badAreas{i};
            if (area == rect)
                if(i == 1)
                    data.badAreas = data.badAreas(2:numOfAreas);
                    break;
                end
                if(i==numOfAreas)
                    data.badAreas = data.badAreas(1:numOfAreas-1);
                    break;
                end
                data.badAreas = [data.badAreas(1:i-1);data.badAreas(i+1 : numOfAreas)];
                break
            end
        end
    end
    delete(uiElements);