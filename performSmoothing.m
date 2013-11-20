function  [isUsingNW isUsingN isUsingNE isUsingW isUsingE isUsingSW isUsingS isUsingSE] = performSmoothing(smoothingPixels)
global data markedCell
    A = data.imgData;
    markedCell.col = 0;
    markedCell.marker = 0;
    sz = size(data.imgData);
    isUsingNW = smoothingPixels(1,1);
    isUsingN = smoothingPixels(1,2);
    isUsingNE = smoothingPixels(1,3);
    isUsingW = smoothingPixels(2,1);
    isUsingE = smoothingPixels(2,3);
    isUsingSW = smoothingPixels(3,1);
    isUsingS = smoothingPixels(3,2);
    isUsingSE = smoothingPixels(3,3);
    numOfPointsToAverage = 1+isUsingNW + isUsingN + isUsingNE + isUsingW + isUsingE + isUsingSW + isUsingS + isUsingSE;
    if(numOfPointsToAverage ==1)
        return;
    end
    tmpImage =  uint32(data.imgData);
    img32 = tmpImage;
    if(isUsingNW)
       tmp =  shiftImage(img32,'south');
       tmp = shiftImage(tmp,'east');
       tmpImage = tmpImage+tmp;
    end
    if(isUsingN)
        tmp =  shiftImage(img32,'south');
         tmpImage = tmpImage+tmp;
    end
    if(isUsingNE)
       tmp =  shiftImage(img32,'south');
       tmp = shiftImage(tmp,'west');
       tmpImage = tmpImage+tmp;
    end
    if(isUsingW)
         tmp =  shiftImage(img32,'east');
         tmpImage = tmpImage+tmp;
    end
    if(isUsingE) 
        tmp =  shiftImage(img32,'west');
        tmpImage = tmpImage+tmp;
    end
    if(isUsingSW)
       tmp =  shiftImage(img32,'north');
       tmp = shiftImage(tmp,'east');
       tmpImage = tmpImage+tmp;  
    end
    if(isUsingS)
        tmp =  shiftImage(img32,'north');
        tmpImage = tmpImage+tmp;
    end
    if(isUsingSE)
       tmp =  shiftImage(img32,'north');
       tmp = shiftImage(tmp,'west');
       tmpImage = tmpImage+tmp;  
    end
    performLSImageChange( 'Undo Smoothing',uint16(tmpImage / numOfPointsToAverage));

function shiftedImg = shiftImage(image,direction)
    if(strcmp(direction,'north'))
        shiftedImg = double(circshift(image, 1));
        shiftedImg(1,:) = shiftedImg(2,:);
    end
    if(strcmp(direction,'south'))
         shiftedImg = double(circshift(image, -1));
         [rows stam]  = size(image);
        shiftedImg(rows,:) = shiftedImg(rows-1,:);
    end
    if(strcmp(direction,'east'))
        shiftedImg = double(circshift(image, [0 1]));
        shiftedImg(:,1) = shiftedImg(:,2);
    end
    if(strcmp(direction,'west'))
         shiftedImg = double(circshift(image,[0 -1]));
         [stam cols]  = size(image);
        shiftedImg(:,cols) = shiftedImg(:,cols-1);
    end
    shiftedImg = uint32(shiftedImg);
