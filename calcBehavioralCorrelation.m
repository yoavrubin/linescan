%remove me

function correlation = calcBehavioralCorrelation(before,after,sourceSignal,targetSignal)
    numOfRuns = before + after +1;
    correlation = zeros(numOfRuns,1);
    startSource = before;
    endSource = numel(sourceSignal)-after-1;
    currSource = sourceSignal(startSource:endSource);
    sourceSize = double(numel(currSource)); 
    for i=1:numOfRuns
        startTarget = i;
        endTarget = i+sourceSize-1;
        currTarget = targetSignal(startTarget: endTarget);
        delta = abs(currTarget - currSource);
        total = sum(delta) / sourceSize;
        correlation(i) = total;
    end
    
    
    

