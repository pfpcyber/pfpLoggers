function [S1,Config] = getConfigJSON()
% Returns P2Scan struct S1 and the Orginial JSON Config file contents
%
% Derek Liu
% 10/28/2104

%Default to .ini files
[FileName,PathName] = uigetfile('*.json*','Select the PFP Logger Configuration File');

try
    Config = jsondecode(fileread([PathName FileName]));
    errorFlag = errorCheckPico3406D(Config);
    
    if errorFlag == 1
        errorStr = sprintf('%s\n','Configuration Errors in Config file');
        msgbox(errorStr,'modal');
    end
    
    switch upper(Config.daq_global.EnableDAQDevice)
        case 'RP'
            x = 1;
        case 'PICO3406D'
            S1 = MapJSONPico3406D_S1(Config,[PathName FileName]);
    end
catch err
    uiwait(msgbox(err.message));
end

end


