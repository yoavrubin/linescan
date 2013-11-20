function distinctValues = getDistinctValues(sourceVector)
    sorted = sort(sourceVector);
    [rows stam] = size(sourceVector);
    distinctValues = [];
    distinctValues = [distinctValues ; {sorted(1)}];
    distinctValuesLastIndex = 1;
    for i=1:rows
       if(distinctValues{distinctValuesLastIndex} == sorted(i))
           continue;
       end
       distinctValuesLastIndex = distinctValuesLastIndex+1;
       distinctValues = [distinctValues ; {sorted(i)}];
    end