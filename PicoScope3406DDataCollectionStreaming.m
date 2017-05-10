function varargout = PicoScope3406DDataCollectionStreaming(varargin)
% GUI for P2Scan Data Collection

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @PicoScope3406DDataCollectionStreaming_OpeningFcn, ...
    'gui_OutputFcn',  @PicoScope3406DDataCollectionStreaming_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
   gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT




function PicoScope3406DDataCollectionStreaming_OpeningFcn(hObject, eventdata, handles, varargin)
S1 = getappdata(0,'S1');

imageArray=imread('PFPLogo.jpg');
axes(handles.logo);
imshow(imageArray);

[S1, ConfigOrg] = getConfigJSON;
setappdata(0,'ConfigOrg',ConfigOrg);

if isempty(fieldnames(S1))
    S1.P2Scan.configChanged = 0;
else
    set(handles.configFileDisplay,'String',S1.P2Scan.configFilePath);
end

setappdata(0,'S1',S1);
set(0,'UserData',0);
set(handles.Scope,'Value',1);

set(handles.SigMFStoragePath,'String',S1.DataPaths.SigMF);
set(handles.DataStoragePath,'String',S1.DataPaths.DataStorage);
handles.output = hObject;
guidata(hObject, handles);


function varargout = PicoScope3406DDataCollectionStreaming_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


function StopButton_Callback(hObject, eventdata, handles)
set(0,'UserData',1);

function StartButton_Callback(hObject, eventdata, handles)
S1 = getappdata(0,'S1');
ConfigOrg = getappdata(0,'ConfigOrg');

if S1.P2Scan.configChanged == 1
    choice = questdlg('Current data collection settings will be saved to the JSON file.', ...
        'Save Changes', ...
        'OK','Cancel','OK');
    if strcmp(choice,'OK')
        Config = MapS1_JSONPico3406D(S1,ConfigOrg);
        JsonFileWriter(S1.P2Scan.configFilePath,Config);
        S1.P2Scan.configChanged = 0;
    else
        return;
    end
end

% Read in initial meta file, run time fields will be updated as
% needed.
try
    if exist(S1.DataPaths.SigMF, 'file') == 2
        ObjSigMF = loadjson(S1.DataPaths.SigMF);
   end
catch err
    uiwait(msgbox(sprintf('%s\n\n%s',err.message,['File not found: %s.', S1.DataPaths.SigMF])));
end


if exist(S1.DataPaths.DataStorage, 'dir')% || exist(S2.DataPaths.SigMF, 'dir')
    d1 = dir(S1.DataPaths.DataStorage);
    d1 = { d1.name };
    d1(logical(~cellfun(@isempty, regexp(d1, '^\.{1,2}$', 'start')))) = []; % filter out '.' and '..'
    if ~isempty(d1)
        msg = sprintf('Trace files found in %s.\n\nOK to delete?', S1.DataPaths.DataStorage);
        button = questdlg(msg,  'Folder Not Empty', ...
            'Yes', 'Cancel', 'Cancel');
        switch (button)
            case 'Yes'
                [status, message, messageid] = rmdir(S1.DataPaths.DataStorage, 's');
                mkdir(S1.DataPaths.DataStorage);
            otherwise
                return
        end
    end
end

set(0,'UserData',0);

% Open Scope
[S1, exitcode] = configScope(S1);
if exitcode == 0
    uiwait(msgbox('Error connecting to scope. Data collection aborted.'));
    return;
end
setappdata(0,'S1',S1);    

% SigMF meta data
ObjSigMF.core_0x3A_global.core_0x3A_date = date;
% Find active channels
EnableVec = [S1.channelSettings(1).Enabled S1.channelSettings(2).Enabled S1.channelSettings(3).Enabled S1.channelSettings(4).Enabled];
ActiveIdx = find(EnableVec);
S1.ActiveChans = length(ActiveIdx);

ObjSigMF.core_0x3A_global.PFP_0x3A_label = S1.DataLabel

switch S1.ActiveChans
    case 1
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,1}.PFP_0x3A_channel = ActiveIdx(1);
        % Line below removes unused core:capture entires
      %  ObjSigMF.core_0x3A_capture = ObjSigMF.core_0x3A_capture{1,1};
      
        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_sample_rate = -1;
        ObjSigMF.core_0x3A_capture{1,2}.PFP_0x3A_channel = -1;
        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_sample_start = -1;
        ObjSigMF.core_0x3A_capture{1,2}.PFP_0x3A_length = -1;
        
        ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_sample_rate = -1;
        ObjSigMF.core_0x3A_capture{1,3}.PFP_0x3A_channel = -1;
        ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_sample_start = -1;
        ObjSigMF.core_0x3A_capture{1,3}.PFP_0x3A_length = -1;
        
        ObjSigMF.core_0x3A_capture{1,4}.core_0x3A_sample_rate = -1;
        ObjSigMF.core_0x3A_capture{1,4}.PFP_0x3A_channel = -1;
        ObjSigMF.core_0x3A_capture{1,4}.core_0x3A_sample_start = -1;
        ObjSigMF.core_0x3A_capture{1,4}.PFP_0x3A_length = -1;
        
    case 2
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,1}.PFP_0x3A_channel = ActiveIdx(1);
        
        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,2}.PFP_0x3A_channel = ActiveIdx(2);
        % Line below removes unused core:capture entires
        %ObjSigMF.core_0x3A_capture = {ObjSigMF.core_0x3A_capture{1,1},ObjSigMF.core_0x3A_capture{1,2}};
        
        ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_sample_rate = -1;
        ObjSigMF.core_0x3A_capture{1,3}.PFP_0x3A_channel = -1;
        ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_sample_start = -1;
        ObjSigMF.core_0x3A_capture{1,3}.PFP_0x3A_length = -1;
        
        ObjSigMF.core_0x3A_capture{1,4}.core_0x3A_sample_rate = -1;
        ObjSigMF.core_0x3A_capture{1,4}.PFP_0x3A_channel = -1;
        ObjSigMF.core_0x3A_capture{1,4}.core_0x3A_sample_start = -1;
        ObjSigMF.core_0x3A_capture{1,4}.PFP_0x3A_length = -1;
    case 3
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,1}.PFP_0x3A_channel = ActiveIdx(1);

        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,2}.PFP_0x3A_channel = ActiveIdx(2);

        ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,3}.PFP_0x3A_channel = ActiveIdx(3);
        % Line below removes unused core:capture entires
        %ObjSigMF.core_0x3A_capture = {ObjSigMF.core_0x3A_capture{1,1},...
         %   ObjSigMF.core_0x3A_capture{1,2},ObjSigMF.core_0x3A_capture{1,3}};
         
        ObjSigMF.core_0x3A_capture{1,4}.core_0x3A_sample_rate = -1;
        ObjSigMF.core_0x3A_capture{1,4}.PFP_0x3A_channel = -1;
        ObjSigMF.core_0x3A_capture{1,4}.core_0x3A_sample_start = -1;
        ObjSigMF.core_0x3A_capture{1,4}.PFP_0x3A_length = -1;
    case 4
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,1}.PFP_0x3A_channel = ActiveIdx(1);
        
        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,2}.PFP_0x3A_channel = ActiveIdx(2);
        
        ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,3}.PFP_0x3A_channel = ActiveIdx(3);
        
        ObjSigMF.core_0x3A_capture{1,4}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,4}.PFP_0x3A_channel = ActiveIdx(4);
        % Line below removes unused core:capture entires
        %ObjSigMF.core_0x3A_capture = {ObjSigMF.core_0x3A_capture{1,1},...
         %   ObjSigMF.core_0x3A_capture{1,2},ObjSigMF.core_0x3A_capture{1,3},...
         %   ObjSigMF.core_0x3A_capture{1,4}};
end


Opt = struct('Method', 'SHA-512', 'Input', 'bin');
TotalTraceCount = 1;

[S1,rc ] = Pico3406DStreamingConfig(S1);

% Variables to be used when collecting the data
hasAutoStopped      = false;
newSamples          = 0; % Number of new samples returned from the driver.
previousTotal       = 0; % The previous total number of samples.
totalSamples        = 0; % Total samples captured by the device.
startIndex          = 0; % Start index of data in the buffer returned.
getStreamingLatestValues = 0; % OK
        
[stopFig.f, stopFig.h] = stopButton();             
flag = 1; % Use flag variable to indicate if stop button has been clicked (0)
setappdata(gcf, 'run', flag);

% Get data values as long as power status has not changed (check for STOP button push inside loop)
while(hasAutoStopped == false && getStreamingLatestValues == 0)
    ready = false;
    
    while(ready == false)
        % This function instructs the driver to return the next block of values to your
        % ps3000aStreamingReady() callback. You must have previously called
        % ps3000aRunStreaming() beforehand to set up streaming.
        % Applicability Streaming
        getStreamingLatestValues = invoke(S1.P2Scan.scope.Streaming(1), 'getStreamingLatestValues');
        % This function polls the driver to verify that streaming data is ready to be received. The
        % RunBlock() or GetStreamingLatestValues() function must have been called before
        % calling this function.
        ready = invoke(S1.P2Scan.scope.Streaming(1), 'isReady');
        % Give option to abort from here
        flag = getappdata(gcf, 'run');
        drawnow;
        if(flag == 0)
            disp('STOP button clicked - aborting data collection.')
            break;
        end
        % Uncomment if drawing data as it is captured is required
        % drawnow;
    end
    % Check for data
    % This function indicates the number of samples returned from the driver and shows the
    % start index of the data in the buffer when collecting data in streaming mode.
    [newSamples, startIndex] = invoke(S1.P2Scan.scope.Streaming(1), 'availableData');
    
    if (newSamples > 0)
        
        previousTotal = totalSamples;
        totalSamples = totalSamples + newSamples;
        firstValuePosn = startIndex + 1;
        lastValuePosn = startIndex + newSamples;
        % Printing to console can slow down acquisition - use for debug
        fprintf('New Samples: %d, startIndex: %d total: %d.\n', newSamples, startIndex, totalSamples);
        fprintf('FirstValuePosn: %d, lastValuePosn: %d.\n\n', firstValuePosn, lastValuePosn);

        % Position indices of data in buffer
       
        % Convert data values to milliVolts from the application buffers
        if isequal(S1.channelSettings(1).Enabled,true)
            voltage_range = S1.P2Scan.VerticalRangeDefaults(S1.channelSettings(1).Range);
            %       raw = get(S1.P2Scan.pBufferA, 'Value');
            S1.P2Scan.pBufferChAFinal.Value = adc2mv(S1.P2Scan.pAppBufferChA.Value(firstValuePosn:lastValuePosn),voltage_range,S1.P2Scan.scope.maxADCValue);
        end
        
        if isequal(S1.channelSettings(2).Enabled,true)
            voltage_range = S1.P2Scan.VerticalRangeDefaults(S1.channelSettings(2).Range);
            %      raw = get(S1.P2Scan.pBufferB, 'Value');
            S1.P2Scan.pBufferChBFinal.Value = adc2mv(S1.P2Scan.pAppBufferChB.Value(firstValuePosn:lastValuePosn),voltage_range,S1.P2Scan.scope.maxADCValue);
        end
        
        if isequal(S1.channelSettings(3).Enabled,true)
            voltage_range = S1.P2Scan.VerticalRangeDefaults(S1.channelSettings(3).Range);
            %     raw = get(S1.P2Scan.pBufferC, 'Value');
            S1.P2Scan.pBufferChCFinal.Value = adc2mv(S1.P2Scan.pAppBufferChC.Value(firstValuePosn:lastValuePosn),voltage_range,S1.P2Scan.scope.maxADCValue);
        end
        
        if isequal(S1.channelSettings(4).Enabled,true)
            voltage_range = S1.P2Scan.VerticalRangeDefaults(S1.channelSettings(4).Range);
            %    raw = get(S1.P2Scan.pBufferD, 'Value');
            S1.P2Scan.pBufferChDFinal.Value = adc2mv(S1.P2Scan.pAppBufferChD.Value(firstValuePosn:lastValuePosn),voltage_range,S1.P2Scan.scope.maxADCValue);
        end
        % Clear variables for use again
        clear firstValuePosn;
        clear lastValuePosn;
        clear startIndex;
        Flag = LogData2SigMF( S1,ObjSigMF,TotalTraceCount,Opt );
        set(handles.SequenceNumber,'String',[num2str(TotalTraceCount), ' %']);
        TotalTraceCount = TotalTraceCount +1;
        
    end
    
    % Check if auto stop has occurred
    hasAutoStopped = invoke(S1.P2Scan.scope.Streaming(1), 'autoStopped');
    if(hasAutoStopped == PicoConstants.TRUE)
        disp('AutoStop: TRUE - exiting loop.');
        previousTotal       = 0; % The previous total number of samples.
        totalSamples        = 0; % Total samples captured by the device.
        
        break;
    end
    % Check if 'STOP' button pressed
    flag = getappdata(gcf, 'run');
    
    % Uncomment if drawing data as it is captured is required
    % drawnow;
    if(flag == 0)
        disp('STOP button clicked - aborting data collection.')
        disconnect(instrfind)
        break;
    end
end


if get(0,'UserData') == 1
    set(0,'UserData',0);
    uiwait(msgbox('Data Collection Aborted'));
else
    uiwait(msgbox('Data Collection Complete'));
end




function OpeningFigure_CloseRequestFcn(hObject, eventdata, handles)
S1 = getappdata(0,'S1');

if  S1.P2Scan.configChanged == 1
    choice = questdlg('Save current changes to Configuration file?', ...
        'Save Changes', ...
        'OK','Cancel','OK');
    if strcmp(choice,'OK')
        ConfigOrg = getappdata(0,'ConfigOrg');
        Config = MapS1_JSONPico3406D(S1,ConfigOrg);
        JsonFileWriter(S1.P2Scan.configFilePath,Config);
        S1.P2Scan.configChanged = 0;
        setappdata(0,'S1',S1);
        setappdata(0,'ConfigOrg',ConfigOrg);    
    end
end

closeScope(getappdata(0,'S1'));



delete(hObject);
        
function Scope_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
            
            

function ChangeStoragePath_Callback(hObject, eventdata, handles)
S1 = getappdata(0,'S1');
drive = S1.P2Scan.workingDirectory;
path = uigetdir(drive,'Select Directory to Store Data files');
if path ~= 0
    set(handles.DataStoragePath,'String',path);
    S1.DataPaths.DataStorage = [path,'\'];
    S1.P2Scan.configChanged = 1;
    setappdata(0,'S1',S1);
end



function PicoScope3406DconfigureScopeStreaming_Callback(hObject, eventdata, handles)
S1 = getappdata(0,'S1');
PicoScope3406DConfigurationStreaming();



% --- Executes on button press in SigMF.
function ChangeSigMFPath_Callback(hObject, eventdata, handles)
S1 = getappdata(0,'S1');
drive = S1.P2Scan.workingDirectory;
[filename, path] = uigetfile({'*.meta'}, 'SigMF',drive);
if path ~= 0
    set(handles.SigMFStoragePath,'String',[path filename]);
    S1.DataPaths.SigMF = [path filename];
    S1.P2Scan.configChanged = 1;
    setappdata(0,'S1',S1);
end


function changeConfigFile_Callback(hObject, eventdata, handles)
S1 = getappdata(0,'S1');
ConfigOrg = getappdata(0,'ConfigOrg');

if  ~isempty(S1) && S1.P2Scan.configChanged == 1
    choice = questdlg('Save current changes to Configuration file?', ...
        'Save Changes', ...
        'OK','Cancel','OK');
    if strcmp(choice,'OK')
        Config = MapS1_JSONPico3406D(S1,ConfigOrg);
        JsonFileWriter(S1.P2Scan.configFilePath,Config);
        S1.P2Scan.configChanged = 0;
    end
end
[S1, ConfigOrg] = getConfigJSON;

if ~isempty(fieldnames(S1))
    S1.P2Scan.configChanged = 0;
    set(handles.configFileDisplay,'String',S1.P2Scan.configFilePath);
    setappdata(0,'S1',S1);
    setappdata(0,'ConfigOrg',ConfigOrg);
end




% --- Executes on button press in DataLabel.
function DataLabel_Callback(hObject, eventdata, handles)
% hObject    handle to DataLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function LableEntry_Callback(hObject, eventdata, handles)
% hObject    handle to LableEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LableEntry as text
%        str2double(get(hObject,'String')) returns contents of LableEntry as a double
S1 = getappdata(0,'S1');

S1.DataLabel = str2double(get(hObject,'String'));
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);


% --- Executes during object creation, after setting all properties.
function OpeningFigure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OpeningFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function SequenceNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SequenceNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
