function result = deriveVector(vector)
    shiftedVector = [vector(2:numel(vector)); 0];
    result = shiftedVector - vector ;