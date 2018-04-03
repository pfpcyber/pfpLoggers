function [S1, exitcode] = Pico3406DStreamingConfig(S1)

%% Picoscope
try
    EnableVec = [S1.channelSettings(1).Enabled S1.channelSettings(2).Enabled S1.channelSettings(3).Enabled S1.channelSettings(4).Enabled];
    ActiveIdx = find(EnableVec);
    ActiveChans = length(ActiveIdx);
    
    % Set the number of pre- and post-trigger samples
    % If no trigger is set 'numPreTriggerSamples' is ignored
    set(S1.P2Scan.scope, 'numPreTriggerSamples', 0);
    set(S1.P2Scan.scope, 'numPostTriggerSamples', 250000);
%    set(S1.P2Scan.scope, 'numPostTriggerSamples', 1000000);
    set(S1.P2Scan.scope.Streaming(1), 'streamingInterval', 1/S1.P2Scan.FsDefaults(S1.TimeTrace.SampleFreq+1));
    set(S1.P2Scan.scope.Streaming(1), 'autoStop', 0);
    
    autoStop = true;
    downSampleRatio = 1; 
    downSampleRatioMode = 0; % none 
    overviewBufferSize = 250000;
    segmentIndex        = 0;
    
    % BufferPtr point to NULL if not used.
    S1.P2Scan.pBufferChAFinal = libpointer('singlePtr')
    S1.P2Scan.pBufferChBFinal = libpointer('singlePtr')
    S1.P2Scan.pBufferChCFinal = libpointer('singlePtr')
    S1.P2Scan.pBufferChDFinal = libpointer('singlePtr')
    
    % % Buffers to be passed to the driver
    if isequal(S1.channelSettings(1).Enabled,true)
        % pointer for Driver
        S1.P2Scan.pDriverBufferChA = libpointer('int16Ptr',zeros(overviewBufferSize,1,'int16'));
                statusChanA = invoke(S1.P2Scan.scope, 'ps3000aSetDataBuffer', ...
            0, S1.P2Scan.pDriverBufferChA, overviewBufferSize, segmentIndex, downSampleRatioMode);
        % Application Buffers - these are for copying from the driver into temporarily.
        S1.P2Scan.pAppBufferChA = libpointer('int16Ptr', zeros(overviewBufferSize, 1));
        
        status.setAppAndDriverBuffersA = invoke(S1.P2Scan.scope.Streaming(1),...
            'setAppAndDriverBuffers', 0, S1.P2Scan.pAppBufferChA,...
            S1.P2Scan.pDriverBufferChA, overviewBufferSize);
        
        S1.P2Scan.pBufferChAFinal = libpointer('singlePtr', zeros(overviewBufferSize, 1, 'single'));
        
    end
    
    if isequal(S1.channelSettings(2).Enabled,true)
        S1.P2Scan.pDriverBufferChB = libpointer('int16Ptr',zeros(overviewBufferSize,1,'int16'));
        statusChanB = invoke(S1.P2Scan.scope, 'ps3000aSetDataBuffer', ...
            1, S1.P2Scan.pDriverBufferChB, overviewBufferSize, segmentIndex, downSampleRatioMode);
        
        S1.P2Scan.pAppBufferChB = libpointer('int16Ptr', zeros(overviewBufferSize, 1));
        status.setAppAndDriverBuffersB = invoke(S1.P2Scan.scope.Streaming(1),...
            'setAppAndDriverBuffers', 1, S1.P2Scan.pAppBufferChB,...
            S1.P2Scan.pDriverBufferChB, overviewBufferSize);
        
        S1.P2Scan.pBufferChBFinal = libpointer('singlePtr', zeros(overviewBufferSize, 1, 'single'));

    end
    
    if isequal(S1.channelSettings(3).Enabled,true)
        S1.P2Scan.pDriverBufferChC = libpointer('int16Ptr',zeros(overviewBufferSize,1,'int16'));
        statusChanC = invoke(S1.P2Scan.scope, 'ps3000aSetDataBuffer', ...
            2, S1.P2Scan.pDriverBufferChC, overviewBufferSize, segmentIndex, downSampleRatioMode);
        
        S1.P2Scan.pAppBufferChC = libpointer('int16Ptr', zeros(overviewBufferSize, 1));
        status.setAppAndDriverBuffersC = invoke(S1.P2Scan.scope.Streaming(1),...
            'setAppAndDriverBuffers', 2, S1.P2Scan.pAppBufferChC,...
            S1.P2Scan.pDriverBufferChC, overviewBufferSize);
        
            S1.P2Scan.pBufferChCFinal = libpointer('singlePtr', zeros(overviewBufferSize, 1, 'single'));
    end
    
    if isequal(S1.channelSettings(4).Enabled,true)
        S1.P2Scan.pDriverBufferChD = libpointer('int16Ptr',zeros(overviewBufferSize,1,'int16'));
        statusChanD = invoke(S1.P2Scan.scope, 'ps3000aSetDataBuffer', ...
            3, S1.P2Scan.pDriverBufferChD, overviewBufferSize, segmentIndex, downSampleRatioMode);
        
        S1.P2Scan.pAppBufferChD = libpointer('int16Ptr', zeros(overviewBufferSize, 1));
        status.setAppAndDriverBuffersD = invoke(S1.P2Scan.scope.Streaming(1),...
            'setAppAndDriverBuffers', 3, S1.P2Scan.pAppBufferChD,...
            S1.P2Scan.pDriverBufferChD, overviewBufferSize);
        
            S1.P2Scan.pBufferChAFinal = libpointer('singlePtr', zeros(overviewBufferSize, 1, 'single'));
    end
    
    
    
    [status.runStreaming, actualSampleInterval, sampleIntervalTimeUnitsStr] = ...
        invoke(S1.P2Scan.scope.Streaming(1), 'ps3000aRunStreaming', downSampleRatio, ...
        downSampleRatioMode, overviewBufferSize);
    
    debug = 1;
    
    exitcode=1;
catch err
    uiwait(msgbox(sprintf('%s\n\n%s',err.message,'Please restart Data Collection')));
end

end