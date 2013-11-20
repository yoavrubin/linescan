function crossCol = calculateCrossCorrelation(sourceMaximas, targetMaximas, before, after)
    numOfSM = numel(sourceMaximas);
    sourceMaximas = int32(sourceMaximas);
    targetMaximas = int32(targetMaximas);
    if(numel(sourceMaximas)>2000)
        indx = 1;
        step=1000;
        d1=[];
        while indx<numOfSM
            sm = sourceMaximas(indx:min(indx+step-1, numOfSM));
            d = bsxfun(@minus,targetMaximas',sm);
            d=int16(d);
            fd = d((d >= -before) & (d <= after));
            d=[];
            d1=[d1;fd];
            fd=[];
            indx = indx+step;
        end

        crossCol = histc(d1, (-before:after)); 
        return;
    end
    d = bsxfun(@minus,targetMaximas',sourceMaximas); %creating a distrances matrix between the target and source maximas
    d1 = d((d >= -before) & (d <= after));%filtering out the distances that are out of range (from -before to +after) - now we have a vector of all the distances that are in that range
    crossCol = histc(d1, (-before:after)); % binning the filtered values   
