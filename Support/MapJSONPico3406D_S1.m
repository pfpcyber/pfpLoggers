function [ S1] = MapJSONPico3406D_S1( Config, ConfigFilePath)
% Maps the configuration data to the S1 Structure.


S1 = struct;

S1.P2Scan.configFilePath = [ConfigFilePath];
S1.P2Scan.configChanged = 0;
S1.P2Scan.workingDirectory = pwd;
S1.P2Scan.VerticalRangeDefaults = [.02 .05, .100, .200, .500, 1, 2, 5, 10, 20]; 
S1.P2Scan.FsDefaults = [1e9 500e6, 250e6, 125e6 62.5e6 31.25e6 1e6 100e3 10e3 1e3];

%% [TimeTrace]

S1.TimeTrace.TraceLength = Config.Pico3406D_capture.TraceLength;
S1.TimeTrace.SampleFreq = Config.Pico3406D_capture.SampleFreq;

%% [Trigger]
S1.Trigger.TriggerChannel = Config.Pico3406D_capture.TriggerSource;
S1.Trigger.TriggerSlope = Config.Pico3406D_capture.TriggerSlope;
S1.Trigger.TriggerLevel = Config.Pico3406D_capture.TriggerLevel;
S1.Trigger.TriggerPosition = Config.Pico3406D_capture.TriggerDelay;
S1.Trigger.AutoTriggerTimeoutms = Config.Pico3406D_capture.AutoTriggerTimeoutms;

switch S1.Trigger.TriggerChannel
    case 0
        S1.Trigger.VerticalRange = Config.Pico3406D_capture.ChanAVerticalRange;
        S1.Trigger.VerticalCoupling = Config.Pico3406D_capture.ChanACoupling;
    case 1
        S1.Trigger.VerticalRange = Config.Pico3406D_capture.ChanBVerticalRange;
        S1.Trigger.VerticalCoupling = Config.Pico3406D_capture.ChanBCoupling;
    case 2
        S1.Trigger.VerticalRange = Config.Pico3406D_capture.ChanCVerticalRange;
        S1.Trigger.VerticalCoupling = Config.Pico3406D_capture.ChanCCoupling;
    case 3
        S1.Trigger.VerticalRange = Config.Pico3406D_capture.ChanDVerticalRange;
        S1.Trigger.VerticalCoupling = Config.Pico3406D_capture.ChanDCoupling;
    case 4 % external trigger
        S1.Trigger.VerticalRange = 5;
        S1.Trigger.VerticalCoupling = 1;
end

%% [Data]
S1.channelSettings(1).Enabled = Config.Pico3406D_capture.ChanAEnabled;
S1.channelSettings(1).Coupling = Config.Pico3406D_capture.ChanACoupling;
S1.channelSettings(1).Range = Config.Pico3406D_capture.ChanAVerticalRange;
S1.channelSettings(1).OffSet = Config.Pico3406D_capture.ChanAAnalogOffsetVolts;

S1.channelSettings(2).Enabled = Config.Pico3406D_capture.ChanBEnabled;
S1.channelSettings(2).Coupling = Config.Pico3406D_capture.ChanBCoupling;
S1.channelSettings(2).Range = Config.Pico3406D_capture.ChanBVerticalRange;
S1.channelSettings(2).OffSet = Config.Pico3406D_capture.ChanBAnalogOffsetVolts;

S1.channelSettings(3).Enabled = Config.Pico3406D_capture.ChanCEnabled;
S1.channelSettings(3).Coupling = Config.Pico3406D_capture.ChanCCoupling;
S1.channelSettings(3).Range = Config.Pico3406D_capture.ChanCVerticalRange;
S1.channelSettings(3).OffSet = Config.Pico3406D_capture.ChanCAnalogOffsetVolts;

S1.channelSettings(4).Enabled = Config.Pico3406D_capture.ChanDEnabled;
S1.channelSettings(4).Coupling = Config.Pico3406D_capture.ChanDCoupling;
S1.channelSettings(4).Range = Config.Pico3406D_capture.ChanDVerticalRange;
S1.channelSettings(4).OffSet = Config.Pico3406D_capture.ChanDAnalogOffsetVolts;



% 
% % Find first Active channel
% ActiveChan = find(ChanIdx,1,'first')-1;
% switch ActiveChan
%     case 0
%         S1.Data.DataChannel = 0;
%         S1.Data.VerticalRange = Config.Pico3406D_capture.ChanAVerticalRange;
%         S1.Data.VerticalCoupling = Config.Pico3406D_capture.ChanACoupling;
%     case 1
%         S1.Data.DataChannel = 1;
%         S1.Data.VerticalRange = Config.Pico3406D_capture.ChanBVerticalRange;
%         S1.Data.VerticalCoupling = Config.Pico3406D_capture.ChanBCoupling;
%     case 2
%         S1.Data.DataChannel = 2;
%         S1.Data.VerticalRange = Config.Pico3406D_capture.ChanCVerticalRange;
%         S1.Data.VerticalCoupling = Config.Pico3406D_capture.ChanCCoupling;
%     case 3
%         S1.Data.DataChannel = 3;
%         S1.Data.VerticalRange = Config.Pico3406D_capture.ChanDVerticalRange;
%         S1.Data.VerticalCoupling = Config.Pico3406D_capture.ChanDCoupling;
% end


%% [DataCollectionParams]
S1.DataCollectionParams.NumTraces = Config.daq_global.NumTraces;
S1.DataCollectionParams.NumStates = Config.daq_global.NumStates;

%% [DataPaths]
S1.DataPaths.DataStorage = Config.daq_global.DataPath; 
S1.DataPaths.SigMF = Config.daq_global.InitialSigMF;
        
end

