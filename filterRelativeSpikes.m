function filteredSpikes = filterRelativeSpikes(referenceSpikes, filteringSpikes, boundaries)
    numOfRefs = numel(referenceSpikes);
    disp(['rs=' num2str(numel(referenceSpikes)) ' , fs=' num2str(numel(filteringSpikes))]);
    referenceSpikes = int32(referenceSpikes);
    filteringSpikes = int32(filteringSpikes);

    if(numel(referenceSpikes)>2000)
        indx = 1;
        step=2000;
        dd=[];
        while indx<numOfRefs
            rm = referenceSpikes(indx:min(indx+step-1, numOfRefs));
            d = bsxfun(@minus,filteringSpikes,rm');
            fd = sum(((d >= boundaries(1)) & (d <=boundaries(2))));
            d=[];
            dd = [dd fd];
            fd=[];
            indx = indx+step;
        end
        filteredSpikes = referenceSpikes(dd>0);
        return;
    end

    d = bsxfun(@minus,filteringSpikes,referenceSpikes'); % first create a distrance matrix between the references and the filtering spikes
    dd = sum(((d >= boundaries(1)) & (d <=boundaries(2)))); % see how many filtering spikes each reference spike have within the given boundries (according to the distance matrix)
    filteredSpikes = referenceSpikes(dd>0);  %the filtered spikes are the reference spikes that has at least one filtering spike within the given boundaries
