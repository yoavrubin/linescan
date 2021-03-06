function exportData( startindex, endIndex, fileNames)
global data lineScanFigureHandles
    referenceFileName = strcat(fileNames.directory,'\',fileNames.referenceImage);
    lsFileName =strcat(fileNames.directory,'\',fileNames.lsImage);
    lsImagePosition = get(lineScanFigureHandles.image,'Position');
    if(lsImagePosition(4) ==endIndex-startindex+1)
        offset = 1;
    else
        offset = lsImagePosition(2);
    end
    if(endIndex == -1)
        endIndex = size(data.imgData,1);
    end

    saveImage(lineScanFigureHandles.referenceImage,referenceFileName,512,1);
    saveImage(lineScanFigureHandles.image,lsFileName,endIndex-startindex+1,offset);

    if(~isempty(fileNames.stimuli) && ~isempty(data.stimData))
        changed = 0;
        if(endIndex == -1)
            changed = 1;
            endIndex = numel(data.stimData);
        end
        writeDataToFile(strcat(fileNames.directory,'\',fileNames.stimuli),(startindex:endIndex),data.stimData(startindex:endIndex));
        if(changed)
            endIndex = size(data.imgData,1);
        end
    end
    if(~isempty(fileNames.f) && ~isempty(data.flourecencePlotData))
        writeDataToFile(strcat(fileNames.directory,'\',fileNames.f), data.valuesX(startindex:endIndex),data.flourecencePlotData(startindex:endIndex));
    end
    if(~isempty(fileNames.df) && ~isempty(data.dfPlotData))
        writeDataToFile(strcat(fileNames.directory,'\',fileNames.df), data.valuesX(startindex:endIndex),data.dfPlotData(startindex:endIndex));
    end
    if(~isempty(fileNames.firstDerivation) && ~isempty(data.firstDerivation))
        writeDataToFile(strcat(fileNames.directory,'\',fileNames.firstDerivation), data.valuesX(startindex:endIndex),data.firstDerivation(startindex:endIndex));
    end
    if(isempty(fileNames.lsImage))
        return;
    end

function saveImage(imageHandle,fileName,windowHeight, offset)
    exportFigure = figure('Visible','off', 'PaperPositionMode', 'auto');
    colormap gray;
    copyobj(imageHandle,exportFigure);
    axisHandle = get(exportFigure,'Children');
    imagePosition = get(imageHandle, 'Position');
    set(axisHandle,'Position',[1 offset imagePosition(3) imagePosition(4)]);
    figurePosition = get(exportFigure,'Position');
    figurePosition(3) = imagePosition(3)-1;
    figurePosition(4) = windowHeight;
    set(exportFigure,'Position',figurePosition);
    drawnow;
    set(exportFigure,'Position',figurePosition);
    print(exportFigure, '-dtiffn', '-r0','-noui','-loose',fileName);
    delete(exportFigure);        
