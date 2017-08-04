function varargout = SendFiles(varargin)
% SendFILES MATLAB code for SendFiles.fig
%      SendFILES, by itself, creates a new SendFILES or raises the existing
%      singleton*.
%
%      H = SendFILES returns the handle to a new SendFILES or the handle to
%      the existing singleton*.
%
%      SendFILES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SendFILES.M with the given input arguments.
%
%      SendFILES('Property','Value',...) creates a new SendFILES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SendFiles_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SendFiles_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SendFiles

% Last Modified by GUIDE v2.5 19-Jun-2017 17:17:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SendFiles_OpeningFcn, ...
                   'gui_OutputFcn',  @SendFiles_OutputFcn, ...
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


% --- Executes just before SendFiles is made visible.
function SendFiles_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SendFiles (see VARARGIN)

%Add logo
imageArray=imread('PFPLogo.jpg');
axes(handles.logo);
imshow(imageArray);

%Default user/password

set(handles.usernameEdit,'String','Username');
set(handles.passwordEdit,'String','Password');

% Choose default command line output for SendFiles
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SendFiles wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SendFiles_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function usernameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to usernameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function usernameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to passwordEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of passwordEdit as text
%        str2double(get(hObject,'String')) returns contents of passwordEdit as a double


% --- Executes during object creation, after setting all properties.
function passwordEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to passwordEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function passwordEdit_Callback(hObject, eventdata, handles)
% hObject    handle to passwordEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of passwordEdit as text
%        str2double(get(hObject,'String')) returns contents of passwordEdit as a double


% --- Executes on button press in sendButton.
function sendButton_Callback(hObject, eventdata, handles)
% hObject    handle to sendButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FTP = getappdata(0,'FTP');
if ~isfield(FTP,'filePath')
    return
end

host = '34.207.224.175'; %PFP server
username = get(handles.usernameEdit, 'String');
password = get(handles.passwordEdit, 'String');
filePath = FTP.filePath;

try
    ftpServer = ftp(host, username, password);
    msgTransfer = sprintf('Transferring %s...', filePath);
    ftph = msgbox(msgTransfer,'FTP Transfer');
    
    fprintf('Transferring %s...\n', filePath);
    tic;   
    mput(ftpServer,filePath); %Send file to server
    toc;
    
    if exist('ftph', 'var')
        delete(ftph);
        clear('h');
    end

    msg = sprintf('File sent to %s by %s:\n%s', host, username, filePath);
    msgbox(msg,'FTP Success');
    close('SendFiles');
catch err
    toc;
    if exist('ftph', 'var')
        delete(ftph);
        clear('h');
    end    
<<<<<<< HEAD
    uiwait(msgbox(err.message));  
=======
    uiwait(msgbox(err.message));
>>>>>>> 18a86fb3b4c4dba0052ae0870a4d02c302f18dda
end


