function[mn mx range] =  getEdgesAndRange(axesHandle,varargin)
    relevantAxis = 'y';
    if(~isempty(varargin))
        relevantAxis = varargin{1};
    end
    property = 'YLim';
    if(strcmp(relevantAxis,'x'))
        property = 'XLim';
    end
    edges = get(axesHandle, property);
    mn = double(edges(1));
    mx = double(edges(2));
    range= mx - mn;
