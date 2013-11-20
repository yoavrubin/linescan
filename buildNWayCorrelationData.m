%building nWayCorrelationData based on a previously built
%nWayCorrelationsData - adding another level to the data by appending the
%target to the sources list
function nWayCorrelationData = buildNWayCorrelationData(correlations)
    global crossCorrelationData
    numOfCorrelations = numel(correlations);
    nWayCorrelationData = [];
    if(numOfCorrelations == 0)
        return;
    end
    jitter = str2num(get(crossCorrelationData.handles.nWayJitter,'String'))/2;
    jitterInPixels = jitter / pixelToTime(1);
    corSources = [correlations.source];
    references = {corSources.reference};
    sources = {corSources.sources};
    targets = {correlations.target};
    locationTimesM = [correlations.location] - jitterInPixels;
    locationTimesP = [correlations.location] + jitterInPixels;
    offsets = [locationTimesM'  locationTimesP'];
    offsetsCell = mat2cell(offsets,ones(size(offsets,1),1),2);
    srcs = struct('name',targets,'offset',offsetsCell');
    sr = [[corSources.sources]; srcs];
    sources = mat2cell(sr,size(sr,1),ones(numOfCorrelations,1));
    nWayCorrelationData = struct('reference',references,'sources',sources);
