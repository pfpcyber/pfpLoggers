function [S1, exitcode] = configScope(S1)
try
    [S1, exitcode] = configPico(S1);
catch err
    uiwait(msgbox(err.message));
    exitcode = 0;
end
end


% Picoscope
function [S1, exitcode] = configPico(S1)
global methodinfo structs enuminfo ThunkLibName;
exitcode = 0;
addpath('win64')


S1.P2Scan.scope = instrfind('Status','open','Name','scope-picotech_ps3000a_generic');
if isempty(S1.P2Scan.scope)
    % Note*** the driver 'picotech_ps3000a_generic' works in streaming
    % mode, the other drivers do not.
    S1.P2Scan.scope = icdevice('picotech_ps3000a_generic', '');
    connect(S1.P2Scan.scope);
    [methodinfo, structs, enuminfo, ThunkLibName] = ps3000aMFile;
    disp('Device created success');
end



% Get active channels

ChanIdx = [0 1 2 3];

for idx = 1:length(ChanIdx)
   status  = invoke(S1.P2Scan.scope, 'ps3000aSetChannel', ChanIdx(idx), S1.channelSettings(idx).Enabled,...
       S1.channelSettings(idx).Coupling,S1.channelSettings(idx).Range,S1.channelSettings(idx).OffSet);
end


% Set Simple Trigger
enable = 1;
delay = 0;

set(S1.P2Scan.scope.Trigger(1), 'autoTriggerMs',S1.Trigger.AutoTriggerTimeoutms);
set(S1.P2Scan.scope.Trigger(1), 'delay', 0);
invoke(S1.P2Scan.scope.Trigger(1), 'SetSimpleTrigger',S1.Trigger.TriggerChannel,S1.Trigger.TriggerLevel*1000,S1.Trigger.TriggerSlope+2);
%Timebase calculation 
%if S1.Data.DataChannel == S1.Trigger.TriggerChannel
    switch S1.TimeTrace.SampleFreq
        case 0
            timebase = 0; % 1GHz
        case 1
            timebase = 1; % 500MHz
        case 2
            timebase = 2  % 250MHz
        case 3
            timebase = floor(125e6/125e6)+2;
        case 4
            timebase = floor(125e6/62.5e6)+2;
        case 5
            timebase = floor(125e6/31.25e6)+2;
        case 6
            timebase = floor(125e6/1e6)+2;
        case 7
            timebase = floor(125e6/100e3)+2;
        case 8
            timebase = floor(125e6/10e3)+2;
        case 9
            timebase = floor(125e6/1e3)+2;
        otherwise
            timebase = floor(125e6/1e3)+2;
    end
% end
S1.P2Scan.Timebase = timebase;
S1.P2Scan.scope.timebase = S1.P2Scan.Timebase;

% Pretrigger setup
S1.P2Scan.PreTriggerSamples = S1.TimeTrace.TraceLength * S1.Trigger.TriggerPosition * .01;
S1.P2Scan.PostTriggerSamples = S1.TimeTrace.TraceLength * (100-S1.Trigger.TriggerPosition) * .01;

set(S1.P2Scan.scope, 'numPreTriggerSamples', 0);
set(S1.P2Scan.scope, 'numPostTriggerSamples', S1.P2Scan.PostTriggerSamples);

if isequal(S1.channelSettings(1).Enabled,true)
    S1.P2Scan.pBufferA = libpointer('int16Ptr',zeros(S1.TimeTrace.TraceLength,1));
    status = invoke(S1.P2Scan.scope, 'ps3000aSetDataBuffer', ... 
        0, S1.P2Scan.pBufferA, S1.TimeTrace.TraceLength, 0, 0);
end
        
if isequal(S1.channelSettings(2).Enabled,true)
    S1.P2Scan.pBufferB = libpointer('int16Ptr',zeros(S1.TimeTrace.TraceLength,1));
    status = invoke(S1.P2Scan.scope, 'ps3000aSetDataBuffer', ... 
        1, S1.P2Scan.pBufferB, S1.TimeTrace.TraceLength, 0, 0);
end

if isequal(S1.channelSettings(3).Enabled,true)
    S1.P2Scan.pBufferC = libpointer('int16Ptr',zeros(S1.TimeTrace.TraceLength,1));
    status = invoke(S1.P2Scan.scope, 'ps3000aSetDataBuffer', ... 
        2, S1.P2Scan.pBufferC, S1.TimeTrace.TraceLength, 0, 0);
end

if isequal(S1.channelSettings(4).Enabled,true)
    S1.P2Scan.pBufferD = libpointer('int16Ptr',zeros(S1.TimeTrace.TraceLength,1));
    status = invoke(S1.P2Scan.scope, 'ps3000aSetDataBuffer', ... 
        3, S1.P2Scan.pBufferD, S1.TimeTrace.TraceLength, 0, 0);
end
        

exitcode=1;
end


