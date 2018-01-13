function varargout = PicoScope3406DDataCollection(varargin)
% GUI for P2Scan Data Collection

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @PicoScope3406DDataCollection_OpeningFcn, ...
    'gui_OutputFcn',  @PicoScope3406DDataCollection_OutputFcn, ...
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




function PicoScope3406DDataCollection_OpeningFcn(hObject, eventdata, handles, varargin)
S1 = getappdata(0,'S1');

imageArray=imread('PFPLogo.jpg');
axes(handles.logo);
imshow(imageArray);
axes(handles.waveform);

[S1, ConfigOrg] = getConfigJSON;
setappdata(0,'ConfigOrg',ConfigOrg);

if isempty(fieldnames(S1))
    S1.P2Scan.configChanged = 0;
else
    set(handles.configFileDisplay,'String',S1.P2Scan.configFilePath);
end

setappdata(0,'S1',S1);

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

set(0,'UserData',0);

set(handles.Scope,'Value',1);

set(handles.numtraces,'String',S1.DataCollectionParams.NumTraces);
set(handles.SigMFStoragePath,'String',S1.DataPaths.SigMF);
set(handles.DataStoragePath,'String',S1.DataPaths.DataStorage);
set(handles.NumStates,'String',S1.DataCollectionParams.NumStates)
handles.output = hObject;
guidata(hObject, handles);


function varargout = PicoScope3406DDataCollection_OutputFcn(hObject, eventdata, handles)
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

totalTraces = S1.DataCollectionParams.NumStates * S1.DataCollectionParams.NumTraces;

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
ActiveChans = length(ActiveIdx);

N = S1.TimeTrace.TraceLength;
switch ActiveChans
    case 1
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_start = 0;
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,1}.PFP_0x3A_channel = ActiveIdx(1);
        ObjSigMF.core_0x3A_capture{1,1}.PFP_0x3A_length = N;
        ObjSigMF.core_0x3A_capture{1,2} = [];
        ObjSigMF.core_0x3A_capture{1,3} = [];
        ObjSigMF.core_0x3A_capture{1,4} = [];
        ObjSigMF.core_0x3A_capture = ObjSigMF.core_0x3A_capture(~cellfun('isempty',ObjSigMF.core_0x3A_capture));
        
        ObjSigMF.core_0x3A_annotations{1,1}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,1}.core_0x3A_sample_count = N ;
        ObjSigMF.core_0x3A_annotations{1,2} = [];
        ObjSigMF.core_0x3A_annotations{1,3} = [];
        ObjSigMF.core_0x3A_annotations{1,4} = [];
        ObjSigMF.core_0x3A_annotations = ObjSigMF.core_0x3A_annotations(~cellfun('isempty',ObjSigMF.core_0x3A_annotations));

    case 2
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_start = 0;
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,1}.PFP_0x3A_channel = ActiveIdx(1);
        ObjSigMF.core_0x3A_capture{1,1}.PFP_0x3A_length = S1.TimeTrace.TraceLength;
        
        ObjSigMF.core_0x3A_annotations{1,1}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,1}.core_0x3A_sample_count = N ;

        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_sample_start = N;
        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,2}.PFP_0x3A_channel = ActiveIdx(2);
        ObjSigMF.core_0x3A_capture{1,2}.PFP_0x3A_length = S1.TimeTrace.TraceLength;
        
        ObjSigMF.core_0x3A_annotations{1,2}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,2}.core_0x3A_sample_count = N ;

        ObjSigMF.core_0x3A_capture{1,3} = [];
        ObjSigMF.core_0x3A_capture{1,4} = [];
        
        ObjSigMF.core_0x3A_capture = ObjSigMF.core_0x3A_capture(~cellfun('isempty',ObjSigMF.core_0x3A_capture));
        
    case 3
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_start = 0;
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,1}.PFP_0x3A_channel = ActiveIdx(1);
        ObjSigMF.core_0x3A_capture{1,1}.PFP_0x3A_length = S1.TimeTrace.TraceLength;

        ObjSigMF.core_0x3A_annotations{1,1}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,1}.core_0x3A_sample_count = N;

        
        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_sample_start = N;
        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,2}.PFP_0x3A_channel = ActiveIdx(2);
        ObjSigMF.core_0x3A_capture{1,2}.PFP_0x3A_length = S1.TimeTrace.TraceLength;

        ObjSigMF.core_0x3A_annotations{1,2}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,2}.core_0x3A_sample_count = N;

        ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_sample_start = 2*N;
        ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,3}.PFP_0x3A_channel = ActiveIdx(3);
        ObjSigMF.core_0x3A_capture{1,3}.PFP_0x3A_length = S1.TimeTrace.TraceLength;

        ObjSigMF.core_0x3A_annotations{1,3}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,3}.core_0x3A_sample_count = N;

        
        ObjSigMF.core_0x3A_capture{1,4} = [];
        ObjSigMF.core_0x3A_capture = ObjSigMF.core_0x3A_capture(~cellfun('isempty',ObjSigMF.core_0x3A_capture));
        
    case 4
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_start = 0;
        ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,1}.PFP_0x3A_channel = ActiveIdx(1);
        ObjSigMF.core_0x3A_capture{1,1}.PFP_0x3A_length = S1.TimeTrace.TraceLength;
        
        ObjSigMF.core_0x3A_annotations{1,1}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,1}.core_0x3A_sample_count = N;

        
        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_sample_start = N;
        ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,2}.PFP_0x3A_channel = ActiveIdx(2);
        ObjSigMF.core_0x3A_capture{1,2}.PFP_0x3A_length = S1.TimeTrace.TraceLength;
        
        ObjSigMF.core_0x3A_annotations{1,2}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,2}.core_0x3A_sample_count = N;
        
        ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_sample_start = 2*N;
        ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,3}.PFP_0x3A_channel = ActiveIdx(3);
        ObjSigMF.core_0x3A_capture{1,3}.PFP_0x3A_length = S1.TimeTrace.TraceLength;
        
        ObjSigMF.core_0x3A_annotations{1,3}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,3}.core_0x3A_sample_count = N;

        ObjSigMF.core_0x3A_capture{1,4}.core_0x3A_sample_start = 3*N;
        ObjSigMF.core_0x3A_capture{1,4}.core_0x3A_sample_rate = S1.TimeTrace.SampleFreq;
        ObjSigMF.core_0x3A_capture{1,4}.PFP_0x3A_channel = ActiveIdx(4);
        ObjSigMF.core_0x3A_capture{1,4}.PFP_0x3A_length = S1.TimeTrace.TraceLength;
        
        ObjSigMF.core_0x3A_annotations{1,4}.core_0x3A_sample_start = 0 ;
        ObjSigMF.core_0x3A_annotations{1,4}.core_0x3A_sample_count = N;

end


Opt = struct('Method', 'SHA-512', 'Input', 'bin');
TotalTraceCount = 1;
for StateIdx = 0:S1.DataCollectionParams.NumStates-1
    ObjSigMF.core_0x3A_global.PFP_0x3A_label = StateIdx;

    if get(0,'UserData') == 1
        break;
    end
    
    uiwait(warndlg({'Please set the device to the next run state.';'Press OK to continue.'},'Set Run State'));

    for traceNum = 0:S1.DataCollectionParams.NumTraces-1
        
        if get(0,'UserData') == 1
            break;
        end
        
        [traces, S1, exitcode] = acquireTraces(S1);
        if exitcode == 0
            uiwait(msgbox('Error acquiring trace. Data collection aborted.'));
            return;
        end
        
        
        ObjSigMF.core_0x3A_global.core_0x3A_sha512 = DataHash([single(traces{1,1}); single(traces{1,2});...
            single(traces{1,3}) ;single(traces{1,4})],Opt);
        % SigMF meta data
        DateTime = datetime('now','Timezone','local','Format','yyyy-MM-dd''T''HH:mm:ss,SSSSXXX');

        switch ActiveChans
            case 1
                ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_time = char(DateTime);
            case 2
                ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_time = char(DateTime);
                ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_time = char(DateTime);
            case 3
                ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_time = char(DateTime);
                ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_time = char(DateTime);
                ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_time = char(DateTime);
            case 4
                ObjSigMF.core_0x3A_capture{1,1}.core_0x3A_time = char(DateTime);
                ObjSigMF.core_0x3A_capture{1,2}.core_0x3A_time = char(DateTime);
                ObjSigMF.core_0x3A_capture{1,3}.core_0x3A_time = char(DateTime);
                ObjSigMF.core_0x3A_capture{1,4}.core_0x3A_time = char(DateTime);
        end
        
        %        DateTime = datetime('now','Timezone','local','Format','yyyy-MM-dd''T''HH:mm:ss,SSSSXXX');
        %        ObjSigMF.core_0x3A_capture.core_0x3A_time = char(DateTime);
        ObjSigMF.core_0x3A_global.PFP_0x3A_sequence = traceNum;
        
        % Base file name
        FileName = [num2str(DateTime.Year,'%04d'),...
            num2str(DateTime.Month,'%02d'),...
            num2str(DateTime.Day,'%02d'),...
            '_',...
            num2str(DateTime.Hour,'%02d'),...
            num2str(DateTime.Minute,'%02d'),...
            strrep(num2str(DateTime.Second,'%5.2f'), '.', '_')];
        DataFileName = [FileName '.data']; % Add .data extension
        DataFullPath = [S1.DataPaths.DataStorage DataFileName];
        MetaFileName = [FileName '.meta'];%  Add .meta extension
        MetaFullPath = [S1.DataPaths.DataStorage MetaFileName];
        
        ObjSigMF.core_0x3A_global.core_0x3A_datapath = DataFileName;
        
        DataFileWriter(DataFullPath,[traces{1,1}; traces{1,2}; traces{1,3} ;traces{1,4}], ObjSigMF.core_0x3A_global.core_0x3A_datatype);
        JsonFileWriter(MetaFullPath,ObjSigMF);
        
        percentComplete = int8((TotalTraceCount/totalTraces)*100);
        TotalTraceCount = TotalTraceCount +1;
        set(handles.pctComplete,'String',[num2str(percentComplete), ' %']);
        
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
        
        ylabel('Voltage (mV)');
        drawnow;
    end
end

if get(0,'UserData') == 1
    set(0,'UserData',0);
    uiwait(msgbox('Data Collection Aborted'));
else
    uiwait(msgbox('Data Collection Complete'));
end

function figure1_CloseRequestFcn(hObject, eventdata, handles)
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
            
            

function numtraces_Callback(hObject, eventdata, handles)
S1 = getappdata(0,'S1');
if str2double(get(hObject,'String')) < 1
    uiwait(msgbox('Number of traces cannot be less than 1'));
    set(hObject,'String',1)
% elseif str2double(get(hObject,'String')) < 100
%     uiwait(msgbox('For good results, number of traces should not be less than 100'));
end
S1.DataCollectionParams.NumTraces = str2double(get(hObject,'String'));
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);


function numtraces_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function NumStates_Callback(hObject, eventdata, handles)
S1 = getappdata(0,'S1');
% if str2double(get(hObject,'String')) < 1
%     uiwait(msgbox('Number of States cannot be less than 1'));
%     set(hObject,'String',2)
% end
S1.DataCollectionParams.NumStates = str2double(get(hObject,'String'))
S1.P2Scan.configChanged = 1;
setappdata(0,'S1',S1);


function NumStates_CreateFcn(hObject, eventdata, handles)
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



function PicoScope3406DconfigureScope_Callback(hObject, eventdata, handles)
S1 = getappdata(0,'S1');
PicoScope3406DConfigurationMC();



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


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
