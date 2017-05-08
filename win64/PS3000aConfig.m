%% SETUP PATH

% addpath('PicoSDK')
% addpath('PicoSDK/Functions');
% addpath('PicoSDK/win64');


addpath('win64');

%% LOAD ENUMS AND STRUCTURES

% Added 'evalin' to support running from GUI

% Load in enumerations and structure information
%[ps3000aMethodinfo, ps3000aStructs, ps3000aEnuminfo, ps3000aThunkLibName] = ps3000aMFile; 
evalin('base','[ps3000aMethodinfo, ps3000aStructs, ps3000aEnuminfo, ps3000aThunkLibName] = ps3000aMFile');
%[ps3000aWrapMethodinfo, ps3000aWrapStructs, ps3000aWrapEnuminfo, ps3000aWrapThunkLibName] = ps3000aWrapMFile;
evalin('base','[ps3000aWrapMethodinfo, ps3000aWrapStructs, ps3000aWrapEnuminfo, ps3000aWrapThunkLibName] = ps3000aWrapMFile');
