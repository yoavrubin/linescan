function isIn = isPointInRectangle(x,y,rect)
    isIn = 0;
    rectX = rect(1);
    if(x<rect(1))
        return;
    end
    rectXW = rectX+rect(3);
    if(x>rectXW)
        return;
    end
    rectY = rect(2);
    if(y<rectY)
        return;
    end
    rectYH = rectY+rect(4);
    if(y>rectYH)
        return;
    end
    isIn = 1;