function [ Config] = MapS1_JSONPico3406D( S1, Config)
% Maps S1 structure back to JSON format.




% S1.P2Scan.configFilePath = [ConfigFilePath];
% S1.P2Scan.configChanged = 0;
% S1.P2Scan.workingDirectory = pwd;
% SampleRates3406D = [1000, 500, 250, 125, 62.5 31.25 1 .1 .01 .001];
% S1.P2Scan.VerticalRangeDefaults = [.01 .02 .05, .100, .200, .500, 1, 2, 5, 10, 20]; 


%% [TimeTrace]

Config.Pico3406D_capture.TraceLength = S1.TimeTrace.TraceLength;
Config.Pico3406D_capture.SampleFreq = S1.TimeTrace.SampleFreq;

%% [Trigger]
Config.Pico3406D_capture.TriggerSource = S1.Trigger.TriggerChannel;
Config.Pico3406D_capture.TriggerSlope = S1.Trigger.TriggerSlope;
Config.Pico3406D_capture.TriggerLevel = S1.Trigger.TriggerLevel;
Config.Pico3406D_capture.TriggerDelay = S1.Trigger.TriggerPosition;
Config.Pico3406D_capture.AutoTriggerTimeoutms = S1.Trigger.AutoTriggerTimeoutms;

switch S1.Trigger.TriggerChannel
    case 0
        Config.Pico3406D_capture.ChanAVerticalRange = S1.Trigger.VerticalRange;
        Config.Pico3406D_capture.ChanACoupling = S1.Trigger.VerticalCoupling;
    case 1
        Config.Pico3406D_capture.ChanBVerticalRange = S1.Trigger.VerticalRange;
        Config.Pico3406D_capture.ChanBCouplingS1.Trigger.VerticalCoupling;
    case 2
        Config.Pico3406D_capture.ChanCVerticalRange = S1.Trigger.VerticalRange;
        Config.Pico3406D_capture.ChanCCoupling = S1.Trigger.VerticalCoupling;
    case 3
        Config.Pico3406D_capture.ChanDVerticalRange = S1.Trigger.VerticalRange;
        Config.Pico3406D_capture.ChanDCoupling = S1.Trigger.VerticalCoupling;
end

%% [Data]
Config.Pico3406D_capture.ChanAEnabled = S1.channelSettings(1).Enabled;
Config.Pico3406D_capture.ChanACoupling = S1.channelSettings(1).Coupling;
Config.Pico3406D_capture.ChanAVerticalRange = S1.channelSettings(1).Range;
Config.Pico3406D_capture.ChanAAnalogOffsetVolts = S1.channelSettings(1).OffSet;

Config.Pico3406D_capture.ChanBEnabled = S1.channelSettings(2).Enabled;
Config.Pico3406D_capture.ChanBCoupling = S1.channelSettings(2).Coupling;
Config.Pico3406D_capture.ChanBVerticalRange = S1.channelSettings(2).Range;
Config.Pico3406D_capture.ChanBAnalogOffsetVolts = S1.channelSettings(2).OffSet;

Config.Pico3406D_capture.ChanCEnabled = S1.channelSettings(3).Enabled;
Config.Pico3406D_capture.ChanCCoupling = S1.channelSettings(3).Coupling;
Config.Pico3406D_capture.ChanCVerticalRange = S1.channelSettings(3).Range;
Config.Pico3406D_capture.ChanCAnalogOffsetVolts = S1.channelSettings(3).OffSet;

Config.Pico3406D_capture.ChanDEnabled = S1.channelSettings(4).Enabled;
Config.Pico3406D_capture.ChanDCoupling = S1.channelSettings(4).Coupling;
Config.Pico3406D_capture.ChanDVerticalRange = S1.channelSettings(4).Range;
Config.Pico3406D_capture.ChanDAnalogOffsetVolts = S1.channelSettings(4).OffSet;





%% [DataCollectionParams]
Config.daq_global.NumTraces = S1.DataCollectionParams.NumTraces;
Config.daq_global.NumStates = S1.DataCollectionParams.NumStates;

%% [DataPaths]
Config.daq_global.DataPath = S1.DataPaths.DataStorage; 
Config.daq_global.InitialSigMF = S1.DataPaths.SigMF;
        
end

