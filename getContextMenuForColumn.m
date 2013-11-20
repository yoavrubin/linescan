function cmn = getContextMenuForColumn(cell)
global lineScanFigureHandles
    cmn = uicontextmenu('Parent',lineScanFigureHandles.figure1);
    uimenu(cmn,'Label','Remove','Callback',@removeMarkedCell);
    uimenu(cmn,'Label','Show Values','Callback',@showValuesForCell);
    uimenu(cmn,'Label','Select Color','Callback',@selectColorForLine);
    uimenu(cmn,'Label','Resize / Move','Callback',@resizeMoveCell);
    uimenu(cmn,'Label','Hide / Show tag','Callback',@hideShowTag);

function selectColorForLine(src,eventdata)
global markedCell cells
    selectedColor = uisetcolor('Select a Color for the cell');
    if(selectedColor == 0)
        return;
    end
    if(~sum((get(markedCell.col,'EdgeColor')) == selectedColor) && isUsingColor(selectedColor))
        button = questdlg('This color is already used on a different column. Do you want to generate color for the other column? Press Yes to generate color to the other column. Press No to allow both columns to have the same color. Press Cancel to abort the color changing.','Color Already Used'); 
        if(strcmp(button,'Cancel'))
            return;
        end
        if(strcmp(button,'Yes'))
            index = getCellWithColor(selectedColor);
            generateRandomColorForCell(index);
        end
    end
    [numOfCells stam] = size(cells);
    cellIndex = -1;
    for i=1:numOfCells
        if(cells(i).columnHandle == markedCell.col && cells(i).refLineMarkerHandle == markedCell.marker)
            cellIndex = i;
            break;
        end
    end
    setCellColor(cellIndex, selectedColor);

function resizeMoveCell(src,eventdata)
    run moveResizeColumnDialog;

function  showValuesForCell(src,eventdata)
global markedCell
    pos = get(markedCell.col,'Position');
    analyseColumn(pos(1));

function hideShowTag(src, eventdata)
global markedCell cells
    nc = numel(cells);
    for i=1:nc
        cell = cells(i);
        if(cell.columnHandle == markedCell.col)
            currentVisibility = get(cell.refLineLabelHandle,'Visible');
            if(strcmp(currentVisibility,'off'))
                set(cell.refLineLabelHandle,'Visible','on');
                break;
            else
                set(cell.refLineLabelHandle,'Visible','off');
                break;
            end
        end
    end

function removeMarkedCell(src,eventdata)
global markedCell cells
    set(markedCell.col,'Visible','off');
    set(markedCell.marker,'Visible','off');
    [nc stam] = size(cells);
    for i=1:nc
        cell = cells(i);
        if(cell.columnHandle == markedCell.col)
            set(cell.refLineLabelHandle,'Visible','off');
            set(cell.columnTagHandle,'Visible','off');
            cells(i) = [];
            break;
        end
    end
    markedCell.col = 0;
    markedCell.marker = 0;