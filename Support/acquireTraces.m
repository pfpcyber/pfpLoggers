function [traces, S1, exitcode] = acquireTraces(S1)

%% Picoscope
try
    [run_block_status, timeIndisposedMs] = invoke(S1.P2Scan.scope, 'ps3000aRunBlock', ...
        S1.P2Scan.PreTriggerSamples, S1.P2Scan.PostTriggerSamples, S1.P2Scan.Timebase, ...
        1, 0,0);
    ready =0;
    h=[];
    flag = false;
    tic
    while ready == 0
        [status, ready] = invoke(S1.P2Scan.scope, 'ps3000aIsReady');
        pause(.001);
        if toc > 4.0
            if isequal(flag,false)
                h = msgbox('Waiting for data');
                flag =  true;
            end
        end
    end
    if ishandle(h)
        delete(h);
    end
    clear h;
    
    startIndex = 0;
    downSampleRatio = 1;
    downSampleRatioMode = 0;
    overflow = 0;
    
    [get_values_status, numSamples, overflow] = invoke(S1.P2Scan.scope, ...
        'ps3000aGetValues', startIndex, ...
        S1.TimeTrace.TraceLength, downSampleRatio, downSampleRatioMode,0 ...
        , overflow);

    invoke(S1.P2Scan.scope, 'ps3000aStop');
    
    ChanATrace = [];
    ChanDTrace = [];
    ChanCTrace = [];
    ChanDTrace = [];
    
    if isequal(S1.channelSettings(1).Enabled,true)
        voltage_range = S1.P2Scan.VerticalRangeDefaults(S1.channelSettings(1).Range);
 %       raw = get(S1.P2Scan.pBufferA, 'Value');
        ChanATrace = adc2mv(get(S1.P2Scan.pBufferA, 'Value'),voltage_range,S1.P2Scan.scope.maxValue);
    end
    
    if isequal(S1.channelSettings(2).Enabled,true)
        voltage_range = S1.P2Scan.VerticalRangeDefaults(S1.channelSettings(2).Range);
  %      raw = get(S1.P2Scan.pBufferB, 'Value');
        ChanBTrace = adc2mv(get(S1.P2Scan.pBufferB, 'Value'),voltage_range,S1.P2Scan.scope.maxValue);
    end
    
    if isequal(S1.channelSettings(3).Enabled,true)
        voltage_range = S1.P2Scan.VerticalRangeDefaults(S1.channelSettings(3).Range);
   %     raw = get(S1.P2Scan.pBufferC, 'Value');
        ChanCTrace = adc2mv(get(S1.P2Scan.pBufferC, 'Value'),voltage_range,S1.P2Scan.scope.maxValue);
    end
    
    if isequal(S1.channelSettings(4).Enabled,true)
        voltage_range = S1.P2Scan.VerticalRangeDefaults(S1.channelSettings(4).Range);
    %    raw = get(S1.P2Scan.pBufferD, 'Value');
        ChanDTrace = adc2mv(get(S1.P2Scan.pBufferD, 'Value'),voltage_range,S1.P2Scan.scope.maxValue);
    end
      
    traces = {ChanATrace,ChanBTrace,ChanCTrace,ChanDTrace};
   
    exitcode=1;
catch err
    uiwait(msgbox(sprintf('%s\n\n%s',err.message,'Please restart Data Collection')));
end

end