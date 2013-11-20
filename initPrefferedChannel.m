function initPrefferedChannel(stimFileLocation)
global data
    data.recordingData = getRecordingData(stimFileLocation);
    if(data.preferedChannel < 0)
        if(numel(data.recordingData.activeChannels) > 1)
            channelsString = num2str(data.recordingData.activeChannels(1));
            for cI=2:numel(data.recordingData.activeChannels)
                channelsString = [channelsString ', ' num2str(data.recordingData.activeChannels(cI))];
            end
            prompt = {['the acquired channels are ' channelsString ', enter the relevant channel number (7 is the blanking signal)']};
            dlg_title = 'Channel selection';
            def = {num2str(data.recordingData.activeChannels(1))};
            answer = inputdlg(prompt,dlg_title,1,def);
            data.preferedChannel = str2num(answer{1});
        else
            data.preferedChannel = data.recordingData.activeChannels(1);
        end  
    end
