function varargout = PicoScope3406DConfigurationMC(varargin)
% GUI for P2Scan Scope Configuration
%
% Derek Liu
% 11/10/14

% Last Modified by GUIDE v2.5 04-Apr-2017 14:30:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @PicoScope3406DConfigurationMC_OpeningFcn, ...
    'gui_OutputFcn',  @PicoScope3406DConfigurationMC_OutputFcn, ...
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



function PicoScope3406DConfigurationMC_OpeningFcn(hObject, eventdata, handles, varargin)
S1 = getappdata(0,'S1');
imageArray=imread('PFPLogo.jpg');
axes(handles.logo);
imshow(imageArray);

axes(handles.waveform);
plot(zeros(1,S1.TimeTrace.TraceLength));
ylabel('Voltage (mV)');
% find max vertical range based on enable channels
EnableVec = [S1.channelSettings(1).Enabled S1.channelSettings(2).Enabled S1.channelSettings(3).Enabled S1.channelSettings(4).Enabled];

for idx = 1:length(EnableVec)
    if isequal(EnableVec(idx),true)
        MaxVertRangeSetting(idx) = S1.channelSettings(idx).Range;
    else
        MaxVertRangeSetting(idx) = 0;
    end
end
[M,I] = max(MaxVertRangeSetting); 
ylim([-(M) M]);

%Trigger
switch S1.Trigger.TriggerChannel
    case 0
        set(handles.triggerchannel,'Value',1);
    case 1
        set(handles.triggerchannel,'Value',2);
    case 2
        set(handles.triggerchannel,'Value',3);
    case 3
        set(handles.triggerchannel,'Value',4);
    case 4
        set(handles.triggerchannel,'Value',5);
end

switch S1.Trigger.VerticalRange
    case 0 % 0.01
        set(handles.triggervertrange,'Value',1);
    case 1 % 0.02
        set(handles.triggervertrange,'Value',2);
    case 2 % 0.05
        set(handles.triggervertrange,'Value',3);
    case 3 % 0.1
        set(handles.triggervertrange,'Value',4);
    case 4 % 0.2
        set(handles.triggervertrange,'Value',5);
    case 5 % 0.5
        set(handles.triggervertrange,'Value',6);
    case 6 % 1
        set(handles.triggervertrange,'Value',7);
    case 7 % 2
        set(handles.triggervertrange,'Value',8);
    case 8 % 5
        set(handles.triggervertrange,'Value',9);
    case 9 % 10
        set(handles.triggervertrange,'Value',10);
    case 10 % 20
        set(handles.triggervertrange,'Value',11);
    otherwise
        set(handles.triggervertrange,'Value',4);
end

set(handles.triggercoupling,'Value',S1.Trigger.VerticalCoupling+1);
set(handles.triggerslope,'Value',S1.Trigger.TriggerSlope+1);
set(handles.triggerlevel,'String',S1.Trigger.TriggerLevel);

switch S1.Trigger.TriggerPosition
    case 0
        set(handles.triggerposition,'Value',1);
    case 5
        set(handles.triggerposition,'Value',2);
    case 10
        set(handles.triggerposition,'Value',3);
    case 15
        set(handles.triggerposition,'Value',4);
    case 20
        set(handles.triggerposition,'Value',5);
    case 25
        set(handles.triggerposition,'Value',6);
    case 30
        set(handles.triggerposition,'Value',7);
    case 35
        set(handles.triggerposition,'Value',8);
    case 40
        set(handles.triggerposition,'Value',9);
    case 45
        set(handles.triggerposition,'Value',10);
    case 50
        set(handles.triggerposition,'Value',11);
end

set(handles.triggertimeout,'String',S1.Trigger.AutoTriggerTimeoutms);

% Initialize the GUI settings for Chan A
if isequal(S1.channelSettings(1).Enabled,true)
    set(handles.ChanAEnable,'Value',1)
else
    set(handles.ChanAEnable,'Value',2)
end
    
set(handles.ChanACoupling,'Value',S1.channelSettings(1).Coupling+1);
set(handles.ChanAVerticalRange,'Value',S1.channelSettings(1).Range);

% Initialize the GUI settings for Chan B
if isequal(S1.channelSettings(2).Enabled,true)
    set(handles.ChanBEnable,'Value',1)
else
    set(handles.ChanBEnable,'Value',2)
end
set(handles.ChanBCoupling,'Value',S1.channelSettings(2).Coupling+1);
set(handles.ChanBVerticalRange,'Value',S1.channelSettings(2).Range);

% Initialize the GUI settings for Chan C
if isequal(S1.channelSettings(3).Enabled,true)
    set(handles.ChanCEnable,'Value',1)
else
    set(handles.ChanCEnable,'Value',2)
end
set(handles.ChanCCoupling,'Value',S1.channelSettings(3).Coupling+1);
set(handles.ChanCVerticalRange,'Value',S1.channelSettings(3).Range);

% Initialize the GUI settings for Chan D
if isequal(S1.channelSettings(4).Enabled,true)
    set(handles.ChanDEnable,'Value',1)
else
    set(handles.ChanDEnable,'Value',2)
end
set(handles.ChanDCoupling,'Value',S1.channelSettings(4).Coupling+1);
set(handles.ChanDVerticalRange,'Value',S1.channelSettings(4).Range);



% Sample Freq of 1GHz is only available in  single channel
switch S1.TimeTrace.SampleFreq
    case 0 % 1GHz
        set(handles.samplefrequency,'Value',1);
    case 1  % 500MHz
        set(handles.samplefrequency,'Value',2);
    case 2 % 250MHz
        set(handles.samplefrequency,'Value',3);
    case 3 % 125MHz
        set(handles.samplefrequency,'Value',4);
    case 4 % 62.5MHz
        set(handles.samplefrequency,'Value',5);
    case 5 % 31.25MHz
        set(handles.samplefrequency,'Value',6);
    case 6 % 1 MHz
        set(handles.samplefrequency,'Value',7);
    case 7 % 100KHz
        set(handles.samplefrequency,'Value',8);
    case 8 % 10KHz
        set(handles.samplefrequency,'Value',9);
    case 9 % 1KHZ
        set(handles.samplefrequency,'Value',10);
    case 1e3
        set(handles.samplefrequency,'Value',11);
end

set(handles.tracelength,'String',S1.TimeTrace.TraceLength);


handles.output = hObject;
guidata(hObject, handles);


function varargout = PicoScope3406DConfigurationMC_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


function ContinueButton_Callback(hObject, eventdata, handles)
close(get(hObject,'parent'));

function AcquireTrace_Callback(hObject, eventdata, handles)
%VerticalRangeDefaults = [0.01 0.02 0.05 0.1 0.2 0.5 1.0 2.0 5.0 10.0 20.0];

if(get(handles.samplefrequency,'Value') == 1 && ((get(handles.triggerchannel,'Value') ~= get(handles.datachannel,'Value')) && get(handles.triggerchannel,'Value') ~= 3))
    uiwait(msgbox('In order to use 500 Mhz sampling rate, trigger must be on data channel or on external'));
else
    S1 = getappdata(0,'S1');
    
    [S1, exitcode] = configScope(S1);
    
    [traces, exitcode] = acquireTraces(S1);
    
    
    % find max vertical range based on enable channels
    EnableVec = [S1.channelSettings(1).Enabled S1.channelSettings(2).Enabled S1.channelSettings(3).Enabled S1.channelSettings(4).Enabled];
    ActiveIdx = find(EnableVec);
    [Range(1),Range(2),Range(3),Range(4)] =  S1.channelSettings.Range;
    [M,I] = max(Range(ActiveIdx));
    ChanVec = {'ChanA','ChanB','ChanC','ChanD'};
    ColorVec = [1,0,0;0,0,1;0,0,0;0,1,0];
    
    ActiveChan = ChanVec(ActiveIdx);
    ActiveColor = ColorVec(ActiveIdx,:);
    ChanData = traces(ActiveIdx);
    
    axes(handles.waveform);
    NumOfActiveChans = length(ChanData);
    switch NumOfActiveChans
        case 1
            plot(ChanData{1,1},'Color',ActiveColor(1,:),'DisplayName',ActiveChan{1,1});
            legend show;
        case 2
            plot(ChanData{1,1},'Color',ActiveColor(1,:),'DisplayName',ActiveChan{1,1});
            hold on;
            plot(ChanData{1,2},'Color',ActiveColor(2,:),'DisplayName',ActiveChan{1,2});
            hold off;
            legend show;
        case 3
            plot(ChanData{1,1},'Color',ActiveColor(1,:),'DisplayName',ActiveChan{1,1});
            hold on;
            plot(ChanData{1,2},'Color',ActiveColor(2,:),'DisplayName',ActiveChan{1,2});
            plot(ChanData{1,3},'Color',ActiveColor(3,:),'DisplayName',ActiveChan{1,3});
            hold off;
            legend show;
        case 4
            plot(ChanData{1,1},'Color',ActiveColor(1,:),'DisplayName',ActiveChan{1,1});
            hold on;
            plot(ChanData{1,2},'Color',ActiveColor(2,:),'DisplayName',ActiveChan{1,2});
            plot(ChanData{1,3},'Color',ActiveColor(3,:),'DisplayName',ActiveChan{1,3});
            plot(ChanData{1,4},'Color',ActiveColor(4,:),'DisplayName',ActiveChan{1,4});
            hold off;
            legend show;
    end
    
    ylabel('Voltage (V)');
    drawnow;
    
    setappdata(0,'S1',S1);
end


function PicosScope3406D_CloseRequestFcn(hObject, eventdata, handles)
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

delete(hObject);


function triggerchannel_Callback(hObject, eventdata, handles)

S1 = getappdata(0,'S1');
switch get(hObject,'Value')
    case 1
        S1.Trigger.TriggerChannel = 0;
    case 2
        S1.Trigger.TriggerChannel = 1;
    case 3
        S1.Trigger.TriggerChannel = 2;
    case 4
        S1.Trigger.TriggerChannel = 3;
    case 5
        S1.Trigger.TriggerChannel = 4;
end
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);



function triggerchannel_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function triggervertrange_Callback(hObject, eventdata, handles)

S1 = getappdata(0,'S1');
switch get(hObject,'Value')
    case 1 % 0.01
        S1.Trigger.VerticalRange = 0;
    case 2 % 0.02
        S1.Trigger.VerticalRange = 1;
    case 3 % 0.05
        S1.Trigger.VerticalRange = 2;
    case 4 % 0.1
        S1.Trigger.VerticalRange = 3;
    case 5 % 0.2
        S1.Trigger.VerticalRange = 4;
    case 6 % 0.5
        S1.Trigger.VerticalRange = 5;
    case 7 % 1
        S1.Trigger.VerticalRange = 6;
    case 8 % 2
        S1.Trigger.VerticalRange = 7;
    case 9 % 5
        S1.Trigger.VerticalRange = 8;
    case 10 % 10
        S1.Trigger.VerticalRange = 9;
    case 11 % 20
        S1.Trigger.VerticalRange = 10;
end
if S1.Trigger.VerticalRange < abs(S1.Trigger.TriggerLevel)
    if S1.Trigger.TriggerLevel < 0
        S1.Trigger.TriggerLevel = -S1.Trigger.VerticalRange;
        set(handles.triggerlevel,'String',-S1.Trigger.VerticalRange)
    else
        S1.Trigger.TriggerLevel = S1.Trigger.VerticalRange;
        set(handles.triggerlevel,'String',S1.Trigger.VerticalRange)
    end
end
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);

function triggervertrange_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function triggercoupling_Callback(hObject, eventdata, handles)

S1 = getappdata(0,'S1');
S1.Trigger.VerticalCoupling = get(hObject,'Value')-1;
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);

function triggercoupling_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function triggerslope_Callback(hObject, eventdata, handles)
S1 = getappdata(0,'S1');
S1.Trigger.TriggerSlope = get(hObject,'Value')-1;
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);

function triggerslope_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function triggerposition_Callback(hObject, eventdata, handles)
S1 = getappdata(0,'S1');
switch get(hObject,'Value')
    case 1
        S1.Trigger.TriggerPosition = 0;
    case 2
        S1.Trigger.TriggerPosition = 5;
    case 3
        S1.Trigger.TriggerPosition = 10;
    case 4
        S1.Trigger.TriggerPosition = 15;
    case 5
        S1.Trigger.TriggerPosition = 20;
    case 6
        S1.Trigger.TriggerPosition = 25;
    case 7
        S1.Trigger.TriggerPosition = 30;
    case 8
        S1.Trigger.TriggerPosition = 35;
    case 9
        S1.Trigger.TriggerPosition = 40;
    case 10
        S1.Trigger.TriggerPosition = 45;
    case 11
        S1.Trigger.TriggerPosition = 50;
end
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);


function triggerposition_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function triggerlevel_Callback(hObject, eventdata, handles)
S1 = getappdata(0,'S1');
level = str2double(get(hObject,'String'));
if abs(level) > S1.Trigger.VerticalRange
    uiwait(msgbox('Trigger level cannot exceed vertical range'));
    if level < 0
        set(hObject,'String',-S1.Trigger.VerticalRange)
    else
        set(hObject,'String',S1.Trigger.VerticalRange)
    end
end
S1.Trigger.TriggerLevel = str2double(get(hObject,'String'));

S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);

function triggerlevel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function triggertimeout_Callback(hObject, eventdata, handles)
S1 = getappdata(0,'S1');
if str2double(get(hObject,'String')) < 1
    uiwait(msgbox('Timeout cannot be less than 1'));
    set(hObject,'String',1)
end
S1.Trigger.AutoTriggerTimeoutms = str2double(get(hObject,'String'));
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);

function triggertimeout_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function samplefrequency_Callback(hObject, eventdata, handles)
S1 = getappdata(0,'S1');

switch get(hObject,'Value')
    case 1
        S1.TimeTrace.SampleFreq = 0;
    case 2
        S1.TimeTrace.SampleFreq = 1;
    case 3
        S1.TimeTrace.SampleFreq = 2;
    case 4
        S1.TimeTrace.SampleFreq = 3;
    case 5
        S1.TimeTrace.SampleFreq = 4;
    case 6
        S1.TimeTrace.SampleFreq = 5;
    case 7
        S1.TimeTrace.SampleFreq = 6;
    case 8
        S1.TimeTrace.SampleFreq = 7;
    case 9
        S1.TimeTrace.SampleFreq = 8;
    case 10
        S1.TimeTrace.SampleFreq = 9;
end
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);


function samplefrequency_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function tracelength_Callback(hObject, eventdata, handles)
S1 = getappdata(0,'S1');
if str2double(get(hObject,'String')) > 10000000
    uiwait(msgbox('Trace length cannot be greater than 10M'));
    set(hObject,'String',10000000)
end
S1.TimeTrace.TraceLength = str2double(get(hObject,'String'));
% if ~isempty(strfind(S1.P2Scan.configFilePath,'.pfpproj'));
%     S1.DataAnalysis.TraceSubsetLength = S1.TimeTrace.TraceLength-1;
%     S1.DataAnalysis.TraceSubsetOffset = 0;
% end
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);



function tracelength_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ChanAEnable.
function ChanAEnable_Callback(hObject, eventdata, handles)
% hObject    handle to ChanAEnable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns ChanAEnable contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChanAEnable
S1 = getappdata(0,'S1');
switch handles.ChanAEnable.Value
    case 1
        S1.channelSettings(1).Enabled = true;
    case 2 
        S1.channelSettings(1).Enabled = false;
    otherwise 
        S1.channelSettings(1).Enabled = false;
end
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);


% --- Executes during object creation, after setting all properties.
function ChanAEnable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChanAEnable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ChanAVerticalRange.
function ChanAVerticalRange_Callback(hObject, eventdata, handles)
% hObject    handle to ChanAVerticalRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ChanAVerticalRange contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChanAVerticalRange
S1 = getappdata(0,'S1');
S1.channelSettings(1).Range = handles.ChanAVerticalRange.Value;
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);


% --- Executes during object creation, after setting all properties.
function ChanAVerticalRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChanAVerticalRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ChanACoupling.
function ChanACoupling_Callback(hObject, eventdata, handles)
% hObject    handle to ChanACoupling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ChanACoupling contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChanACoupling
S1 = getappdata(0,'S1');
S1.channelSettings(1).Coupling = handles.ChanACoupling.Value-1;
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);


% --- Executes during object creation, after setting all properties.
function ChanACoupling_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChanACoupling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ChanBEnable.
function ChanBEnable_Callback(hObject, eventdata, handles)
% hObject    handle to ChanBEnable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns ChanBEnable contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChanBEnable
S1 = getappdata(0,'S1');
switch handles.ChanBEnable.Value
    case 1
        S1.channelSettings(2).Enabled = true;
    case 2 
        S1.channelSettings(2).Enabled = false;
    otherwise 
        S1.channelSettings(2).Enabled = false;
end
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);

% --- Executes during object creation, after setting all properties.
function ChanBEnable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChanBEnable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ChanBVerticalRange.
function ChanBVerticalRange_Callback(hObject, eventdata, handles)
% hObject    handle to ChanBVerticalRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ChanBVerticalRange contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChanBVerticalRange
S1 = getappdata(0,'S1');
S1.channelSettings(2).Range = handles.ChanBVerticalRange.Value;
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);


% --- Executes during object creation, after setting all properties.
function ChanBVerticalRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChanBVerticalRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ChanBCoupling.
function ChanBCoupling_Callback(hObject, eventdata, handles)
% hObject    handle to ChanBCoupling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ChanBCoupling contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChanBCoupling
S1 = getappdata(0,'S1');
S1.channelSettings(2).Coupling = handles.ChanBCoupling.Value-1;
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);

% --- Executes during object creation, after setting all properties.
function ChanBCoupling_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChanBCoupling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ChanCEnable.
function ChanCEnable_Callback(hObject, eventdata, handles)
% hObject    handle to ChanCEnable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ChanCEnable contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChanCEnable
S1 = getappdata(0,'S1');
switch handles.ChanCEnable.Value
    case 1
        S1.channelSettings(3).Enabled = true;
    case 2 
        S1.channelSettings(3).Enabled = false;
    otherwise 
        S1.channelSettings(3).Enabled = false;
end
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);

% --- Executes during object creation, after setting all properties.
function ChanCEnable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChanCEnable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ChanCVerticalRange.
function ChanCVerticalRange_Callback(hObject, eventdata, handles)
% hObject    handle to ChanCVerticalRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ChanCVerticalRange contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChanCVerticalRange
S1 = getappdata(0,'S1');
S1.channelSettings(3).Range = handles.ChanCVerticalRange.Value;
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);


% --- Executes during object creation, after setting all properties.
function ChanCVerticalRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChanCVerticalRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ChanCCoupling.
function ChanCCoupling_Callback(hObject, eventdata, handles)
% hObject    handle to ChanCCoupling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ChanCCoupling contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChanCCoupling
S1 = getappdata(0,'S1');
S1.channelSettings(3).Coupling = handles.ChanCCoupling.Value-1;
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);

% --- Executes during object creation, after setting all properties.
function ChanCCoupling_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChanCCoupling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ChanDEnable.
function ChanDEnable_Callback(hObject, eventdata, handles)
% hObject    handle to ChanDEnable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ChanDEnable contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChanDEnable
S1 = getappdata(0,'S1');
switch handles.ChanDEnable.Value
    case 1
        S1.channelSettings(4).Enabled = true;
    case 2 
        S1.channelSettings(4).Enabled = false;
    otherwise 
        S1.channelSettings(4).Enabled = false;
end
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);

% --- Executes during object creation, after setting all properties.
function ChanDEnable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChanDEnable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ChanDVerticalRange.
function ChanDVerticalRange_Callback(hObject, eventdata, handles)
% hObject    handle to ChanDVerticalRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ChanDVerticalRange contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChanDVerticalRange
S1 = getappdata(0,'S1');
S1.channelSettings(4).Range = handles.ChanDVerticalRange.Value;
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);


% --- Executes during object creation, after setting all properties.
function ChanDVerticalRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChanDVerticalRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ChanDCoupling.
function ChanDCoupling_Callback(hObject, eventdata, handles)
% hObject    handle to ChanDCoupling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ChanDCoupling contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChanDCoupling
S1 = getappdata(0,'S1');
S1.channelSettings(3).Coupling = handles.ChanDCoupling.Value-1;
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);


% --- Executes during object creation, after setting all properties.
function ChanDCoupling_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChanDCoupling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function ChannelLabelA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChannelLabelA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function ChannelLabelB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChannelLabelB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function ChannelLabelC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChannelLabelC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function ChannelLabelD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChannelLabelD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
