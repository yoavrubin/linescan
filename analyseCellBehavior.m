function plotted = analyseCellBehavior(dfData, intervals, before, after, isCalcAvg, color,isNeuron, isRelative)
global data analysisWindowHandles
    factor = data.timePerLine;
    plotted = [];
    beforeInPixels = int16(before/factor);
    afterInPixels = int16(after / factor);
    [maxEndIndex stam]= size(dfData);
    result = [];
    [numOfIntervals stam] = size(intervals);
    if(~numOfIntervals)
        return;
    end
    for i=1:numOfIntervals
       startIndex = uint16(intervals(i,1) - beforeInPixels);
       endIndex = uint16(intervals(i,1) + afterInPixels);
       if(startIndex > maxEndIndex)
           break;
       end
       if(endIndex > maxEndIndex)
           tmpLastLine = dfData(startIndex:maxEndIndex)';
           for j=maxEndIndex:endIndex-1
               tmpLastLine = [tmpLastLine dfData(maxEndIndex)]; %#ok<AGROW>
           end
           result = [result ; tmpLastLine];
       else
           result = [result ; dfData(startIndex:endIndex)'];
       end
    end
    signedBefore = int16(beforeInPixels) * -1;
    signedAfter = int16(afterInPixels);
    xValues = double((signedBefore:1:signedAfter));
    xValues = xValues * factor;
    if(isCalcAvg)
        summed = sum(result);
        averaged = summed / numOfIntervals;
        if (isRelative)
            averaged = fixValuesAccordingToBaseline(averaged, beforeInPixels);
        end
        plotted = drawDataOnAxes(analysisWindowHandles.dataAxes, xValues, averaged,1);
        data.lines = [data.lines;plotted];

        set(plotted,'Color',color);
        if(~isNeuron)
            set(plotted,'LineStyle',':');
        end
    else
        [sizeOfResult stam] = size(result); 
        for i=1:sizeOfResult
            if (isRelative)
                result(i,:) = fixValuesAccordingToBaseline(result(i,:), beforeInPixels);
            end
            plotHandle = drawDataOnAxes(analysisWindowHandles.dataAxes, xValues, result(i,:),1);
            ln = [xValues  result(i,:)];
            data.lines = [data.lines;plotHandle];
            plotted = [plotted ; plotHandle];
            set(plotHandle,'Color',color);
            if(~isNeuron)
                set(plotted,'LineStyle',':');
            end
        end
    end

function fixedValues = fixValuesAccordingToBaseline(baseValues, baselineEnd)
    fixedValues = baseValues;
    if(baselineEnd <= 0)
        return;
    end
    baseline = sum (baseValues(1:baselineEnd)) / double(baselineEnd);
    fixedValues = fixedValues / baseline;
    fixedValues = fixedValues + (-1);



