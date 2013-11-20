function prepareImageAccordingToFilters()
global data
    filtersFileName = strcat(data.files.lsdPath,'imageSetup.imageSetup');
    fid = fopen(filtersFileName);
    while 1
        tline = fgetl(fid);
        if( ~ischar(tline))
            break;
        end
        [token, remain] = strtok(tline, '=');
        
        if  strcmp(token, 'bg')
            bg = uint16(str2num(strtok(remain,'=')));
            data.imgData = data.imgData - bg;
            continue;
        end
        if(strcmp(token,'smoothing'))
            smoothingPixels = parseSmoothingString(strtok(remain,'='));
            performSmoothing(smoothingPixels);
            continue;
        end
    end
    fclose(fid);
function smoothingPixels = parseSmoothingString(smoothString)
    smoothingPixels = zeros(3,3);
    scanned = textscan(smoothString,'%d %d %d %d %d %d %d %d');
    smoothingPixels(1,1) = scanned{1};
    smoothingPixels(1,2) = scanned{2};
    smoothingPixels(1,3) = scanned{3};
    smoothingPixels(2,1) = scanned{4};
    smoothingPixels(2,3) = scanned{5};
    smoothingPixels(3,1) = scanned{6};
    smoothingPixels(3,2) = scanned{7};
    smoothingPixels(3,3) = scanned{8};