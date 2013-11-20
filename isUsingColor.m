function isUsing = isUsingColor(color)
global data
    [numOfColors three]= size(data.usedColors);
    for i = 1:numOfColors
        tmpColor = data.usedColors(i,:);
        if(tmpColor == color)
            isUsing = 1;
            return;
        end
    end
    isUsing = 0;
