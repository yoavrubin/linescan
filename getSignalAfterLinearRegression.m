function fixedSignal = getSignalAfterLinearRegression(signal, method, range)

if(numel(signal) >2000)
    startSignal = signal(1:2000);
    endSignal = signal(numel(signal)-2000 :numel(signal));
else
    startSignal = signal;
    endSignal = signal;
end

startIntervals = findMaximasIntervalsInSignal(startSignal',0.,0.001,-0.1,2);
endIntervals = findMaximasIntervalsInSignal(endSignal',0.,0.001,-0.1,2);
%intervals = findMaximasIntervalsInSignal(signal',0.,0.001,-0.1,2)
if(numel(startIntervals) == 0 || numel(endIntervals) == 0)
    fixedSignal = signal;
    return;
end
[x1 y1] = getRelevantMaximaAtRange(startSignal,startIntervals,range,'Max','beginning');
[x2 y2] = getRelevantMaximaAtRange(endSignal,endIntervals,range,'Min','end');
a = double(y2-y1)/double(x2-x1);
deltas = ((1:numel(signal))*a)';
fixedSignal = double(signal)-deltas;

%a range of n is either the first or the last n maximas. from it the
%relevant maxima is chosen to be the mxima with the highest value
function [x y] = getRelevantMaximaAtRange(signal, intervals, range,method,startFrom)
    if strcmp(startFrom,'beginning')
        firstInterval = 1;
        lastInterval = range;
    end

    if strcmp(startFrom,'end')
        numOfInterval = size(intervals,1);
        firstInterval = numOfInterval-range+1;
        lastInterval = numOfInterval;
    end
    x = 0.0;
    y= -10000.0;
    relevantMaximaPoints = [];
    for i=firstInterval:lastInterval
        [tmpX tmpY] = getMaximaAtInterval(signal, intervals(i,:));
        relevantMaximaPoints = [relevantMaximaPoints ; tmpX tmpY]; 
    end
    [x y] = getRelevantPointByMethod(relevantMaximaPoints, method);

function [x y] = getRelevantPointByMethod(allPoints, method)
    if(strcmp(method,'None'))
        y = 0;
        x = 0;
    end

    allYValues = allPoints(:,2);
    if(strcmp(method,'Min'))
        y = min(allYValues);
    end
    if(strcmp(method,'Median'))
        y = median(allYValues);
    end
    if(strcmp(method,'Max'))
         y = max(allYValues);
    end
    numOfPoints = numel(allYValues);
    for i=1:numOfPoints
        if(allYValues(i) == y)
            x = allPoints(i,1);
            return;
        end
    end
    
function [x y] = getMaximaAtInterval(signal, interval)
    startPoint= interval(1);
    w= interval(2);
    endPoint = startPoint+w;
    if(endPoint > numel(signal))
        endPoint = numel(signal);
    end
    y = max(signal(startPoint: endPoint));
    for i=startPoint:endPoint
        if signal(i) == y
            x=double(i);
            return;
        end
    end
    
    