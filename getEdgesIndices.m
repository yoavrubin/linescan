%edgesIndices is an array that holds all the indices of maximas and minimas
%in the given source (which is the signal), in order the differentiate
%between minimas and maximas, the maximas indices are position and the
%minimas indices values are -1* the actual minima value
function edgesIndices = getEdgesIndices(source, actualZero)
    edgesIndices = [];
    derivedSource = deriveVector(source);
    numOfPoints = numel(derivedSource);
    checkedIndex = 1;
    lastMinimaIndex = -1;
    lastMaximaIndex = -1;
    lookingForMaxima = 1;
    while(1)
        checkedIndex = checkedIndex+1;
        if(checkedIndex > numOfPoints)
            break;
        end
        % we are actually looking at index checkedIndex-1 , so we need to
        % verify that that point and its surroundings are above the zero
        % level, to make the point a valid one for edge detection
        if(checkedIndex > 2 && source(checkedIndex-2) < actualZero && source(checkedIndex-1) < actualZero && source(checkedIndex) < actualZero)
            continue;
        end
        if(lookingForMaxima &&derivedSource(checkedIndex-1) >=0 && derivedSource(checkedIndex) <=0 && lastMaximaIndex ~=checkedIndex-1) % found maxima
            foundEdgeIndex = -1;
            if(source(checkedIndex) > source(checkedIndex-1))
                foundEdgeIndex = checkedIndex;
            else
                foundEdgeIndex = checkedIndex-1;
            end
            edgesIndices = [edgesIndices ; foundEdgeIndex];
            lastMaximaIndex = foundEdgeIndex;
            lookingForMaxima = 0;
            continue;
        end
        if(~lookingForMaxima && (derivedSource(checkedIndex-1) <=0 && (abs(derivedSource(checkedIndex))< actualZero ||  derivedSource(checkedIndex) >=0)) && lastMinimaIndex ~= checkedIndex-1)%found minima
            foundEdgeIndex = -1;
            if(source(checkedIndex) < source(checkedIndex-1))
                foundEdgeIndex = checkedIndex;
            else
                foundEdgeIndex = checkedIndex-1;
            end        
            edgesIndices = [edgesIndices ; (-1)*foundEdgeIndex];
            lastMinimaIndex = foundEdgeIndex;
            lookingForMaxima = 1;
        end
    end
