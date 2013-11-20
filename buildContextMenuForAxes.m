function buildContextMenuForAxes(dataAxesHandle, varargin)
global lineScanFigureHandles
    cmenu = uicontextmenu('Parent',lineScanFigureHandles.figure1);
    axesToLink = dataAxesHandle;
    if(~isempty(varargin))
        axesToLink = varargin{1};
    end
    dt.axesHandle = dataAxesHandle;
    uimenu(cmenu,'Label','Mark Area','Callback',@handleMarkArea,'UserData',dt);
    uimenu(cmenu,'Label','Scroll to Here','Callback',@scrollToHere,'UserData',dt);
    set(axesToLink,'UIContextMenu',cmenu);

function handleMarkArea(src, eventdata)
    markArea(src);
     
function scrollToHere(src, eventdata)
global data 
    loc = 1-double(data.realX) / double(numel(data.valuesX));
    setPosition(loc);

        
             