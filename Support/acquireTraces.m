function [traces, S1, exitcode] = acquireTraces(S1)

%% Picoscope
try
   
%     S1.P2Scan.scope.timebase = 1252;
    [status.getTimebase2, timeIntervalNanoSeconds, maxSamples] = invoke(S1.P2Scan.scope, 'ps3000aGetTimebase2', S1.P2Scan.Timebase, 0)

     [run_block_status, timeIndisposedMs] = invoke(S1.P2Scan.scope.Block, 'RunBlock',0);
     
     [numSamples, overflow, ChanATrace, ChanBTrace, ChanCTrace, ChanDTrace] = invoke(S1.P2Scan.scope.Block, 'getBlockData', 0, 0, 1, 0);
     

    invoke(S1.P2Scan.scope, 'ps3000aStop');

    traces = {ChanATrace,ChanBTrace,ChanCTrace,ChanDTrace};
   
    exitcode=1;
catch err
    uiwait(msgbox(sprintf('%s\n\n%s',err.message,'Please restart Data Collection')));
end

end