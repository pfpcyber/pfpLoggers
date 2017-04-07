function [ rc  ] = errorCheckPico3406D( config )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

rc = 0;
ConfigFields = {'daq_global','Pico3406D_capture'};
daq_globalFields = {'DataPath','InitialSigMF','NumTraces','NumStates','EnableDAQDevice'};
Pico3406D_captureFields = {'ScopeActive','ScopeIndex', 'ScopePicoScopeModel',...
    'ScopeSerialNumber', 'AcquisitionMode','SampleFreq', 'TraceLength',...
    'ChanAEnabled','ChanAVerticalRange','ChanACoupling','ChanAAnalogOffsetVolts',...
    'ChanBEnabled','ChanBVerticalRange','ChanBCoupling','ChanBAnalogOffsetVolts',...
    'ChanCEnabled','ChanCVerticalRange','ChanCCoupling','ChanCAnalogOffsetVolts',...
    'ChanDEnabled','ChanDVerticalRange','ChanDCoupling','ChanDAnalogOffsetVolts',...
    'TriggerEnable','TriggerSource','TriggerLevel','TriggerSlope','TriggerDelay',...
    'AutoTriggerTimeoutms'};

% TrueFalse = {'true','false'};
errorStr = '';
warnStr = '';
%% daq_globals
NotFields = ~isfield(config, ConfigFields);
try
    if sum(NotFields) ~= 0
        BadFieldsIdx = find(NotFields);
        errorStr = sprintf('%s\n\n%s',errorStr,'One or more missing/incorrect objects in:');
        errorStr1 = '';
        for idx = 1:length(BadFieldsIdx)
            errorStr1 = sprintf('%s\n%s',errorStr1,ConfigFields{BadFieldsIdx(idx)});
        end
    end
    if ~isempty(errorStr)
        errorStr = sprintf('%s\n%s\n%s','The following errors were found in the configuration file.','After correcting, please relaunch.',errorStr,errorStr1);
        uiwait(msgbox(errorStr,'modal'));
        errorStr = '';
        errorStr1 = '';
    end
catch err
    rc = 1;
    uiwait(msgbox(err.message));
end



%% daq_global fields
NotFields = ~isfield(config.daq_global, daq_globalFields);
try
    if sum(NotFields) ~= 0
        BadFieldsIdx = find(NotFields);
        errorStr = sprintf('%s\n\n%s',errorStr,'One or more missing/incorrect fields in daq_global:');
        errorStr1 = '';
        for idx = 1:length(BadFieldsIdx)
            errorStr1 = sprintf('%s\n%s',errorStr1,daq_globalFields{BadFieldsIdx(idx)});
        end
    end
    if ~isempty(errorStr)
        errorStr = sprintf('\n%s\n%s\n%s','The following errors were found in the configuration file.','After correcting, please relaunch.',errorStr,errorStr1);
        uiwait(msgbox(errorStr,'modal'));
        errorStr = '';
        errorStr1 = '';
    end
catch err
    rc = 1;
    uiwait(msgbox(err.message));
end

%% Pico3406D_capture Fields
NotFields = ~isfield(config.Pico3406D_capture, Pico3406D_captureFields);
try
    if sum(NotFields) ~= 0
        BadFieldsIdx = find(NotFields);
        errorStr = sprintf('%s\n\n%s',errorStr,'One or more missing/incorrect fields in Pico3406D_capture:');
        errorStr1 = '';
        for idx = 1:length(BadFieldsIdx)
            errorStr1 = sprintf('%s\n%s',errorStr1,Pico3406D_captureFields{BadFieldsIdx(idx)});
        end
    end
    if ~isempty(errorStr)
        errorStr = sprintf('%s\n%s\n%s','The following errors were found in the configuration file.','After correcting, please relaunch.',errorStr,errorStr1);
        uiwait(msgbox(errorStr,'modal'));
        errorStr = '';
        errorStr1 = '';
    end
catch err
    rc = 1;
    uiwait(msgbox(err.message));
end

% ********** Checking of Fields is complete ************

% ********** Check the values of Fields in daq_global *********
try
    %% daq_globals Field Values
    FieldValue = config.daq_global.DataPath;
    if strcmp(FieldValue,'/') || strcmp(FieldValue(1),'\')
        errorStr = sprintf('%s\n\n%s\n',errorStr,'Invalid entry daq_global.Datapath','Invalid Path format. Must begin with [Drive]:/');
    else
        [status,mess,messid] = mkdir(FieldValue);
        if status  == 0
            errorStr = sprintf('%s\n\n%s\n',errorStr,'Invalid entry daq_global.Datapath','Cannot create directory. Check path.');
        end
    end
    
    FieldValue = config.daq_global.InitialSigMF;
    if strcmp(FieldValue,'/') || strcmp(FieldValue(1),'\')
        errorStr = sprintf('%s\n\n%s\n',errorStr,'Invalid entry daq_global.InitialSigMF','Invalid Path format. Must begin with [Drive]:/');
    elseif exist(config.daq_global.InitialSigMF, 'file') ~= 2
        errorStr = sprintf('%s\n\n%s\n',errorStr,'No file found in daq_global.InitialSigMF','. Check path and file.');
    end
    
    FieldValue = config.daq_global.NumTraces;
    if (FieldValue <= 0) 
        errorStr = sprintf('%s\n\n%s\n',errorStr,'Number of Traces has to be larger than 0');
    end
    
    FieldValue = config.daq_global.NumStates;
    if (FieldValue <= 0)
        errorStr = sprintf('%s\n\n%s\n',errorStr,'Number of States has to be larger than 0');
    end
       
    if ~isempty(errorStr)
        errorStr = sprintf('%s\n%s\n','The following errors were found in the configuration file.','After correcting, please relaunch.',errorStr);
        uiwait(msgbox(errorStr,'modal'));
        errorStr = '';
    end
    if ~isempty(warnStr)
        warnStr = sprintf('%s\n%s\n','**** Warning ****',warnStr);
        uiwait(msgbox(warnStr,'modal'));
        warnStr = '';
    end

catch err
    rc = 1;
    uiwait(msgbox(err.message));
    errorStr = '';
end
% ********** End of checking the values of Fields in daq_global *********


%% *************** Check Values in Pico3406D_capture

try
    %% Picos3406D Field Values
    
    % Check ScopeActive value
    FieldValue = config.Pico3406D_capture.ScopeActive;
    if ~isequal(FieldValue,true) && ~isequal(FieldValue,false)
        errorStr = sprintf('%s%s',errorStr,'Pico3406D_capture.ScopeActive Incorrect Value');
    end

    
    % Check ScopeIndex value
    FieldValue = config.Pico3406D_capture.ScopeIndex;
    if sum(FieldValue==(0:0)) == 0
        errorStr = sprintf('%s\n%s',errorStr,'Pico3406D_capture.ScopeIndex should be 0');
    end 
    
    % Check Scope Model
    FieldValue = config.Pico3406D_capture.ScopePicoScopeModel;
    if sum(FieldValue==(0:0)) == 0
        errorStr = sprintf('%s\n%s',errorStr,'Pico3406D_capture.ScopePicoScopeModel should be 0');
    end 
    
    % Check Acquisition Mode value
    FieldValue = config.Pico3406D_capture.AcquisitionMode;
    if sum(FieldValue==(0:1)) == 0
        errorStr = sprintf('%s\n%s',errorStr,'Pico3406D_capture.AcquisitionMode should be between 0-1');
    end 
       
    % Check Channels Enable values
    FieldValue = config.Pico3406D_capture.ChanAEnabled;
    if ~isequal(FieldValue,true) && ~isequal(FieldValue,false)
        errorStr = sprintf('%s\n%s',errorStr,'Pico3406D_capture.ChanAEnabled Incorrect Value');
    end

    FieldValue = config.Pico3406D_capture.ChanBEnabled;
    if ~isequal(FieldValue,true) && ~isequal(FieldValue,false)
        errorStr = sprintf('%s\n%s',errorStr,'Picos3406D_capture.ChanBEnabled Incorrect Value');
    end

    FieldValue = config.Pico3406D_capture.ChanCEnabled;
    if ~isequal(FieldValue,true) && ~isequal(FieldValue,false)
        errorStr = sprintf('%s\n%s',errorStr,'Picos3406D_capture.ChanCEnabled Incorrect Value');
    end
    
    FieldValue = config.Pico3406D_capture.ChanDEnabled;
    if ~isequal(FieldValue,true) && ~isequal(FieldValue,false)
        errorStr = sprintf('%s\n%s',errorStr,'Picos3406D_capture.ChanDEnabled Incorrect Value');
    end
    % End Of Channel Enable check
    
    %% Check Sample rate 
    FieldValue = config.Pico3406D_capture.SampleFreq;
    
    % For Picoscope the Max Sample Rate is depenant number of enabled
    % channels
    NumOfChanEnable = sum([config.Pico3406D_capture.ChanAEnabled,...
         config.Pico3406D_capture.ChanBEnabled, config.Pico3406D_capture.ChanCEnabled,...
          config.Pico3406D_capture.ChanDEnabled]);
    if sum(FieldValue==(0:9)) == 0
        errorStr = sprintf('%s\n%s',errorStr,'Pico3406D_capture.SampleFreq must be number between 0-9');
    end 
        
    if (NumOfChanEnable >= 2 && FieldValue == 0) % Fs = 1GHz and 2 or more channels enabled 
        errorStr = sprintf('%s\n%s',errorStr,'Pico3406D_capture.SampleFreq for 2 or more channels has to be 500MHz or less');
    end

    if ~isempty(errorStr)
        errorStr = sprintf('%s\n%s\n\n%s','The following errors were found in the configuration file.','After correcting, please relaunch.',errorStr);
        uiwait(msgbox(errorStr,'modal'));
        errorStr = '';
    end
catch err
    rc = 1;
    uiwait(msgbox(err.message));
end


%% Check Trace Length, chanX :Vertical Range,Coupling, AnalogOffset
try
    % Check Trace Length
    FieldValue = config.Pico3406D_capture.TraceLength;
    if rem(FieldValue,1) ~= 0
        errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.TraceLength must be an integer');
    end
    if (FieldValue <= 0) || (FieldValue > 50e6)
        errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.TraceLength must be between 1-50e6.');
    end
    
    % Vertical Range value check for Channels A, B, C,& D
    FieldValue = config.Pico3406D_capture.ChanAVerticalRange;
    if sum(FieldValue==(0:9)) == 0
        errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.ChanAVerticalRange must be number between 0-8');
    end
    
    FieldValue = config.Pico3406D_capture.ChanBVerticalRange;
    if sum(FieldValue==(0:9)) == 0
        errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.ChanBVerticalRange must be number between 0-8');
    end
    FieldValue = config.Pico3406D_capture.ChanCVerticalRange;
    if sum(FieldValue==(0:9)) == 0
        errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.ChanCVerticalRange must be number between 0-8');
    end
    FieldValue = config.Pico3406D_capture.ChanDVerticalRange;
    if sum(FieldValue==(0:9)) == 0
        errorStr = sprintf('%s\%s\n',errorStr,'Pico3406D_capture.ChanDVerticalRange must be number between 0-8');
    end
    
    % Coupling value check for Channels A, B, C,& D
    FieldValue = config.Pico3406D_capture.ChanACoupling;
    if sum(FieldValue==(0:1)) == 0
        errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.ChanACoupling must be number between 0-1');
    end
    
    FieldValue = config.Pico3406D_capture.ChanBCoupling;
    if sum(FieldValue==(0:8)) == 0
        errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.ChanBCoupling must be number between 0-1');
    end
    FieldValue = config.Pico3406D_capture.ChanCCoupling;
    if sum(FieldValue==(0:8)) == 0
        errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.ChanCCoupling must be number between 0-1');
    end
    FieldValue = config.Pico3406D_capture.ChanDCoupling;
    if sum(FieldValue==(0:8)) == 0
        errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.ChanDCoupling must be number between 0-1/');
    end
    
    % AnalogOffSets value check for Channels A, B, C,& D
    VerticalRangeDefaults = [.02 .05, .100, .200, .500, 1, 2, 5, 10, 20]; 

    %    if channel is eanble check the values otherwise ignore.
    if isequal(config.Pico3406D_capture.ChanAEnabled,true)
        VoltRange = VerticalRangeDefaults(config.Pico3406D_capture.ChanAVerticalRange+1);
        FieldValue = config.Pico3406D_capture.ChanAAnalogOffsetVolts;
        if (abs(FieldValue) >= VoltRange)
            errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.ChanAAnalogOffsetVolts must be within Channel A Vertical Range');
        end
    end
    
    if isequal(config.Pico3406D_capture.ChanBEnabled,true)
        VoltRange = VerticalRangeDefaults(config.Pico3406D_capture.ChanBVerticalRange+1);
        FieldValue = config.Pico3406D_capture.ChanBAnalogOffsetVolts;
        if (abs(FieldValue) >= VoltRange)
            errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.ChanBAnalogOffsetVolts must be within Channel B +/- Vertical Range');
        end
    end
    
    if isequal(config.Pico3406D_capture.ChanCEnabled,true)
        VoltRange = VerticalRangeDefaults(config.Pico3406D_capture.ChanCVerticalRange+1);
        FieldValue = config.Pico3406D_capture.ChanCAnalogOffsetVolts;
        if (abs(FieldValue) >= VoltRange)
            errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.ChanCAnalogOffsetVolts must be within Channel C +/- Vertical Range');
        end
    end
    
    if isequal(config.Pico3406D_capture.ChanDEnabled,true)
        VoltRange = VerticalRangeDefaults(config.Pico3406D_capture.ChanDVerticalRange+1);
        FieldValue = config.Pico3406D_capture.ChanDAnalogOffsetVolts;
        if (abs(FieldValue) >= VoltRange)
            errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.ChanDAnalogOffsetVolts must be within Channel D +/- Vertical Range');
        end
    end
    
    if ~isempty(errorStr)
        errorStr = sprintf('%s\n%s\n\n%s','The following errors were found in the configuration file.','After correcting, please relaunch.',errorStr);
        uiwait(msgbox(errorStr,'modal'));
        errorStr = '';
    end
    
catch err
    rc = 1;
    uiwait(msgbox(err.message));
end


%% Check Trigger Settings
try
    % Check
    FieldValue = config.Pico3406D_capture.TriggerEnable;
    if ~isequal(FieldValue,true) && ~isequal(FieldValue,false)
        errorStr = sprintf('%s%s\n',errorStr,'Picos3406D_capture.TriggerEnable must be True or False');
    end
    
    FieldValue = config.Pico3406D_capture.TriggerSource;
    if sum(FieldValue==(0:3)) == 0
        errorStr = sprintf('%s%s\n',errorStr,'Picos3406D_capture.TriggerSource must be between 0-4');
    end
    
    FieldValue = config.Pico3406D_capture.TriggerSlope;
    if sum(FieldValue==(0:1)) == 0
        errorStr = sprintf('%s%s\n',errorStr,'Picos3406D_capture.TriggerSlope must be between 0-1');
    end
    
    FieldValue = config.Pico3406D_capture.TriggerDelay;
    if FieldValue < 0
        errorStr = sprintf('%s%s\n',errorStr,'Picos3406D_capture.TriggerDelay must be a positive number ');
    end
    
    FieldValue = config.Pico3406D_capture.AutoTriggerTimeoutms;
    if FieldValue < 0
        errorStr = sprintf('%s%s\n',errorStr,'Picos3406D_capture.TriggerAutoTimeoutms must be a positive number ');
    end
    
    % if Block mode is requested then a trigger must be enabled
    try
        if  (config.Pico3406D_capture.AcquisitionMode == 0) || (config.Pico3406D_capture.AcquisitionMode == 1)
            
            FieldValue = config.Pico3406D_capture.TriggerEnable;
            if isequal(config.Pico3406D_capture.TriggerEnable,false)
                errorStr = sprintf('%s%s\n',errorStr,'Picos3406D_capture.TriggerEnable must be set to true for Block Mode');
            end
            
            % Check Trigger level against Trigger Source Channel A
            if (config.Pico3406D_capture.TriggerSource == 0) && isequal(config.Pico3406D_capture.ChanAEnabled,true)
                VoltRange = VerticalRangeDefaults(config.Pico3406D_capture.ChanAVerticalRange+1);
                FieldValue = config.Pico3406D_capture.TriggerLevel;
                if (abs(FieldValue) > VoltRange)
                    errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.TriggerLevel must be within Channel A +/- Vertical Range');
                end
            end
            
            % Check Trigger level against Trigger Source Channel B
            if (config.Pico3406D_capture.TriggerSource == 1) && isequal(config.Pico3406D_capture.ChanBEnabled,true)
                VoltRange = VerticalRangeDefaults(config.Pico3406D_capture.ChanBVerticalRange+1);
                FieldValue = config.Pico3406D_capture.TriggerLevel;
                if (abs(FieldValue) > VoltRange)
                    errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.TriggerLevel must be within Channel B +/- Vertical Range');
                end
            end
            
            % Check Trigger level against Trigger Source Channel C
            if (config.Pico3406D_capture.TriggerSource == 2) && isequal(config.Pico3406D_capture.ChanCEnabled,true)
                VoltRange = VerticalRangeDefaults(config.Pico3406D_capture.ChanCVerticalRange+1);
                FieldValue = config.Pico3406D_capture.TriggerLevel;
                if (abs(FieldValue) > VoltRange)
                    errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.TriggerLevel must be within Channel C +/- Vertical Range');
                end
            end
            
            % Check Trigger level against Trigger Source Channel D
            if (config.Pico3406D_capture.TriggerSource == 3) && isequal(config.Pico3406D_capture.ChanDEnabled,true)
                VoltRange = VerticalRangeDefaults(config.Pico3406D_capture.ChanDVerticalRange+1);
                FieldValue = config.Pico3406D_capture.TriggerLevel;
                if (abs(FieldValue) > VoltRange)
                    errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.TriggerLevel must be within Channel D +/- Vertical Range');
                end
            end
            
            % Check Trigger level against Trigger Source Ext
            if config.Pico3406D_capture.TriggerSource == 4
                VoltRange = 5;
                FieldValue = config.Pico3406D_capture.TriggerLevel;
                if (abs(FieldValue) > VoltRange)
                    errorStr = sprintf('%s%s\n',errorStr,'Pico3406D_capture.TriggerLevel must be less within +/- 5 Volts');
                end
            end
            
            if ~isempty(errorStr)
                errorStr = sprintf('%s\n%s\n\n%s','The following errors were found in the configuration file.','After correcting, please relaunch.',errorStr);
                uiwait(msgbox(errorStr,'modal'));
                errorStr = '';
            end
        end
    catch err
        rc = 1;
        uiwait(msgbox(err.message));
    end
catch err
    rc = 1;
    uiwait(msgbox(err.message));
    errorStr = '';
end






