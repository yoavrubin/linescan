function createPan()
global data lineScanFigureHandles
    if(data.usingStimuli) % we have stimuli - allowing to pan the stimuli axis
        if(isempty(data.objects.pan))
            data.objects.pan = pan;
            setAllowAxesPan(data.objects.pan,data.stimGhoustAxis(1),true);
            setAllowAxesPan(data.objects.pan,data.stimGhoustAxis(2),true);
            setAllowAxesPan(data.objects.pan,data.stimGhoustAxis(3),true);
            setAllowAxesPan(data.objects.pan,lineScanFigureHandles.image,false);
            setAllowAxesPan(data.objects.pan,lineScanFigureHandles.referenceImage,false);
        end
        set(data.objects.pan,'Motion','vertical','Enable','on');
    end