function color= createRandomColor()
    while(1)
        r = rand;
        g = rand;
        b = rand;
        if(~isUsingColor([r g b]))
            break;
        end
    end
    color = [r g b];
    setColorAsUsed(color);