function traces = getTracesOfColumn(column)
global analysisWindowHandles
    traces = [];
    try
        lines = get(analysisWindowHandles.dataAxes,'Children');
    catch
        return;
    end
    [numOfLines stam] = size(lines);
    for i=1:numOfLines
        if(~strcmp(get(lines(i),'Type'),'line'))
            continue;
        end
        userData = get(lines(i), 'UserData');
        if(column == userData.column)
            traces = [traces ; lines(i)];
        end
    end
