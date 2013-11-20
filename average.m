function averaged = average(source, windowSize)
    [rows cols] = size(source);
    if(rows < windowSize)
        windowSize = rows -1;
    end
    averaged = zeros(rows-windowSize,cols);
    averaged(1) = sum(source(1:1+windowSize));
    for i=2:rows-windowSize
        averaged(i) = averaged(i-1) - source(i-1) + source(i+windowSize);  
       % sum(source(i:i+windowSize)))/windowSize;
    end
    averaged = averaged / double(windowSize);
