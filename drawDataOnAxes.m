function plotHandle = drawDataOnAxes(axesHandle, xValues, yValues, varargin) %varargin - whether to hold or not
    refreshingData = 1;
    if(~isempty(varargin) && varargin{1})
        refreshingData = 0;
        hold(axesHandle);
    end
    if(numel(xValues) == 2 && numel(yValues) ==2)
        axes(axesHandle);
        twoHandles = plotyy(xValues{2},yValues{2},xValues{1},yValues{1}); %doublePlot(axesHandle,xValues{1},yValues{1},xValues{2},yValues{2})
        plotHandle = twoHandles(2);
        set(twoHandles(1),'Color',[1 1 1]);
        set(twoHandles(2),'Color','none');
    else
        axisChildren = get(axesHandle,'Children');
        numChildren = numel(axisChildren);
        theLine = -1;
        for i=1:numChildren
            if(strcmp(get(axisChildren(i),'Type'),'line'))
                theLine = axisChildren(i);
                break;
            end
        end
        if(~refreshingData || theLine == -1)
            %axes(axesHandle);
            plotHandle = plot(xValues,yValues,'Parent',axesHandle);
        else
            set(theLine,'XData',xValues,'YData',yValues);
            plotHandle = axesHandle;
        end
    end
    if(~isempty(varargin))
        hold off;
    end
    
    
function twoHandles = doublePlot(axesHandle, x1, y1, x2, y2)  
plotHandle = plot(x1, y1, 'Parent',axesHandle);
secondAxes = axes('Position',get(axesHandle,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','k','YColor','k');
hl2 = line(x2,y2,'Color','k','Parent',secondAxes);
twoHandles = [plotHandle secondAxes];
