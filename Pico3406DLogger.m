function varargout = Pico3406DLogger(varargin)
% GUI for Pico3406DLogger Main Window
%
% Derek Liu
% 10/30/14

% Last Modified by GUIDE v2.5 09-May-2017 13:58:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Pico3406DLogger_OpeningFcn, ...
                   'gui_OutputFcn',  @Pico3406DLogger_OutputFcn, ...
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


function Pico3406DLogger_OpeningFcn(hObject, eventdata, handles, varargin)
addpath('img')
% Add json support
addpath('jsonlab-1.5')
addpath('win64')
addpath('Support')
PS3000aConfig;

imageArray=imread('PFPLogo.jpg');
axes(handles.axes1);
imshow(imageArray);

handles.output = hObject;
guidata(hObject, handles);




function varargout = Pico3406DLogger_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
    


function PicoScope3406DBlockModeDataCollection_Callback(hObject, eventdata, handles)
PicoScope3406DDataCollection();




function Pico3406DLoger_CloseRequestFcn(hObject, eventdata, handles)
S1 = getappdata(0,'S1');
if ~isempty(S1) && S1.P2Scan.configChanged == 1
    choice = questdlg('Save current changes to project file?', ...
        'Save Changes', ...
        'OK','Cancel','OK');
    if strcmp(choice,'OK')
        MapS1_JSONPico3406D(S1, Config);
        
        %save back to json
        configWriter(S1.P2Scan.configFilePath,S1);
        S1.P2Scan.configChanged = 0;
    end
end
delete(hObject);


% --- Executes during object creation, after setting all properties.
function Pico3406DLoger_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pico3406DLogger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in PicoScope3406DStreamModeDataCollection.
function PicoScope3406DStreamModeDataCollection_Callback(hObject, eventdata, handles)
% hObject    handle to PicoScope3406DStreamModeDataCollection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PicoScope3406DDataCollectionStreaming();








