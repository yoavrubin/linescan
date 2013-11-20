function recordingData = getRecordingData(stimFlieLocation)
    prmFileLoc = strrep(stimFlieLocation,'.dat','.prm');
    prmFH = fopen(prmFileLoc,'r');
    recordingData = {};
    recordingData.samplingRate = 0.0001;
    recordingData.activeChannels = [];
    if(prmFH == -1)
        return;
    end
    result = [];
    while(1)
         theLine = fgetl(prmFH);
        
        [token, remain] = strtok(theLine, '=');
        if(strcmp(token,'Acquisition Rate'))
            theRate = strtok(remain,'=');
            recordingData.samplingRate = str2double(theRate);
        end
        if(strcmp(token,'[Channel Status]'))
            for channelNum = 0:7
                theLine = fgetl(prmFH);
                if(isempty(findstr(theLine,'FALSE')))
                    recordingData.activeChannels = [recordingData.activeChannels ; channelNum];
                end   
            end
            break;
        end        
    end
    fclose(prmFH);
