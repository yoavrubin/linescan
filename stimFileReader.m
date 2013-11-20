function stimFileContent = stimFileReader(stimFileLocation, numOfPixels)
    stimFH = fopen(stimFileLocation,'r','b');
    if(stimFH == -1)
        stimFileContent = [];
        return;
    end
    fread(stimFH,616 ,'int8');% header
    numOfChannels = fread(stimFH,1,'int32');
    pointsPerChannel = fread(stimFH,1,'int32') ; 
    numberOfPoints = numOfChannels * pointsPerChannel;
    sampStep = 0.0001;
    numOfImages = numOfChannels / 2;
    pixelsInChannel = numOfPixels / numOfImages;
    samplesPerPixel = pointsPerChannel / pixelsInChannel;

    stimFileContent = [];%pixelTimes;
    pixelsPerChannel = numOfPixels/(numOfChannels/2);%half the points are from the stimuli channel
    for c=1:numOfChannels

        tmpValues  = [];
        numOfSamplesRead = 0;
        for j=0:pixelsInChannel-1
            samplesToRead = double(uint32((j+1)*samplesPerPixel) - uint32((j)*samplesPerPixel));  
            tmp = fread(stimFH,samplesToRead,'float32');
            tmp = sum(tmp) / samplesToRead;
            tmpValues = [tmpValues;tmp]; 
            numOfSamplesRead = numOfSamplesRead+samplesToRead;
        end
        if mod(c,2) %we are in an odd channel - one of the stimulis (the even channels are the triggers)
            stimFileContent = [stimFileContent; tmpValues]; %#ok<AGROW>
        end
        trashPoints = pointsPerChannel - numOfSamplesRead; %
        fread(stimFH,trashPoints,'float32');% getting to the beginning of the next channel
    end
    fclose(stimFH);