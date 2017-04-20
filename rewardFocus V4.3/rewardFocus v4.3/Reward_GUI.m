function varargout = Reward_GUI(varargin)
% REWARD_GUI M-file for Reward_GUI.fig
%      REWARD_GUI, by itself, creates a new REWARD_GUI or raises the existing
%      singleton*.
%
%      H = REWARD_GUI returns the handle to a new REWARD_GUI or the handle to
%      the existing singleton*.
%
%      REWARD_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REWARD_GUI.M with the given input arguments.
%
%      REWARD_GUI('Property','Value',...) creates a new REWARD_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Reward_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Reward_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Reward_GUI

% Last Modified by GUIDE v2.5 02-Nov-2015 18:35:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Reward_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Reward_GUI_OutputFcn, ...
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


% --- Executes just before Reward_GUI is made visible.
function Reward_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Reward_GUI (see VARARGIN)

% Choose default command line output for Reward_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Reward_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Reward_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
subName = get(handles.edit1, 'String');
if get(handles.radiobutton4, 'Value') == 1
    subGender = 'M';
else
    subGender = 'F';
end

if get(handles.radiobutton10, 'Value') == 1
    rewardSetting = 1;
else
    rewardSetting = 2;
end

if get(handles.radiobutton6, 'Value') == 1
    keySetting = 1;
else
    keySetting = 2;
end

Reward(subName, subGender, 'Normal', rewardSetting, keySetting);
close all;

% --------------------------------------------------------------------
function practice_Callback(hObject, eventdata, handles)
% hObject    handle to practice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
subName = get(handles.edit1, 'String');
if get(handles.radiobutton4, 'Value') == 1
    subGender = 'M';
else
    subGender = 'F';
end

if get(handles.radiobutton10, 'Value') == 1
    rewardSetting = 1;
else
    rewardSetting = 2;
end

if get(handles.radiobutton6, 'Value') == 1
    keySetting = 1;
else
    keySetting = 2;
end

Reward(subName, subGender, 'Practice', rewardSetting, keySetting);
close all;


% --------------------------------------------------------------------
function taskPractice_Callback(hObject, eventdata, handles)
% hObject    handle to taskPractice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
subName = get(handles.edit1, 'String');
if get(handles.radiobutton4, 'Value') == 1
    subGender = 'M';
else
    subGender = 'F';
end

if get(handles.radiobutton10, 'Value') == 1
    rewardSetting = 1;
else
    rewardSetting = 2;
end

if get(handles.radiobutton6, 'Value') == 1
    keySetting = 1;
else
    keySetting = 2;
end

RewardTEST(subName, subGender, 'Practice', rewardSetting, keySetting);
close all;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
subName = get(handles.edit1, 'String');
if get(handles.radiobutton4, 'Value') == 1
    subGender = 'M';
else
    subGender = 'F';
end

if get(handles.radiobutton10, 'Value') == 1
    rewardSetting = 1;
else
    rewardSetting = 2;
end

if get(handles.radiobutton6, 'Value') == 1
    keySetting = 1;
else
    keySetting = 2;
end

RewardTEST(subName, subGender, 'Normal', rewardSetting, keySetting);
close all;
