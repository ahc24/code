function varargout = go(varargin)
% GO MATLAB code for go.fig
%      GO, by itself, creates a new GO or raises the existing
%      singleton*.
%
%      H = GO returns the handle to a new GO or the handle to
%      the existing singleton*.
%
%      GO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GO.M with the given input arguments.
%
%      GO('Property','Value',...) creates a new GO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before go_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to go_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help go

% Last Modified by GUIDE v2.5 05-Nov-2014 20:06:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @go_OpeningFcn, ...
                   'gui_OutputFcn',  @go_OutputFcn, ...
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


% --- Executes just before go is made visible.
function go_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to go (see VARARGIN)


    ioARMSimWiFly = serial('COM4','BaudRate',57600);
    ioARMSimWiFly.BytesAvailableFcnCount = 18;
    ioARMSimWiFly.BytesAvailableFcnMode = 'byte';
    % ioARMSimWiFly.terminator = '~';    
    ioARMSimWiFly.BytesAvailableFcn = {@get_stuff,handles};
    fopen(ioARMSimWiFly);
    
    
    handles.serial_connection = ioARMSimWiFly;
    
    
    
    % plot(1,2,'+');
    % handles.x = 0;
    % t = timer('StartDelay', 2, 'Period', 0.05, 'ExecutionMode', 'fixedRate');
    % t.TimerFcn = { @do_timer_stuff , handles };
    
    
    % start(t);
    
% Choose default command line output for go
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes go wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function get_stuff(hObject, eventdata, handles)
    
    [data count msg] = fread(hObject, 18, 'char');
    
    
    if(data(3) ~= 7)
        return
    end
    
    
    
    % disp(data);
    
    % Create and maintain index    
    persistent i;
    if isempty(i)
        i=1;  
        % disp('i oned')
    elseif i > 255
        i=1;
        % disp('i edge')
    else
        i = i + 1;
        % disp('i increment')
    end
    % ===
    
    % Create and maintain y (actual sampled values)
    persistent y;
    if isempty(y)
        % disp('y zeroed')
        y=zeros(256,1);
    else
        y(i) = (bitshift(data(5),24))+(bitshift(data(6),16))+(bitshift(data(7),8))+(data(8));
        % disp('y delta normal')
    end  
    
    set(handles.ticks,'string',y(i));
    % ===   
    
    % Create and maintain delta
    persistent delta;
    if isempty(delta)
        delta = zeros(256,1);
        delta(1) = y(1);
    elseif i > 1
        delta(i) = y(i) - y(i-1);
        % disp(delta)
    else 
        delta(i) = y(i) - y(255);
    end
    t=1:1:256;
    plot( handles.axes1, t, delta);
    % ===

    

% --- Outputs from this function are returned to the command line.
function varargout = go_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% delete(instrfindall)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in forward_button.
function forward_button_Callback(hObject, eventdata, handles)
    speed = str2double(get(handles.speed,'String'));   
    i_like_to_move_it_move_it(hObject,handles,speed,speed);
% hObject    handle to forward_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in backward_button.
function backward_button_Callback(hObject, eventdata, handles)
    speed = str2double(get(handles.speed,'String'));  
    i_like_to_move_it_move_it(hObject,handles,255-speed,255-speed);

% hObject    handle to backward_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in turn_left.
function turn_left_Callback(hObject, eventdata, handles)
    speed = str2double(get(handles.speed,'String'));  
    i_like_to_move_it_move_it(hObject,handles,speed,255-speed);
% hObject    handle to turn_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in turn_right.
function turn_right_Callback(hObject, eventdata, handles)
    speed = str2double(get(handles.speed,'String'));  
    i_like_to_move_it_move_it(hObject,handles,255-speed,speed);
% hObject    handle to turn_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
    i_like_to_move_it_move_it(hObject,handles,0,0);
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function i_like_to_move_it_move_it(hObject, handles, left_speed,right_speed)
    % some_kinda_handle_thingy = guidata(hObject);

    persistent counter;
    
    if isempty(counter) 
        counter = 0;
    elseif counter > 254
        counter = 0;    
    else
        counter = counter + 1;
    end

    header = hex2dec('ff'); 
    
    time = str2double(get(handles.time_inc,'String'));
    
    meaty_center = [1 left_speed right_speed 1 time 1 1 1 1 1 1 1 1 1];
    checksum = 0;
    for i = 1:14
        checksum = bitxor( checksum , meaty_center(i) );
    end
    footer = hex2dec('fe');
    str = strcat(header,counter,meaty_center, checksum, footer);
    fwrite(handles.serial_connection,str);



function time_inc_Callback(hObject, eventdata, handles)
% hObject    handle to time_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    
% Hints: get(hObject,'String') returns contents of time_inc as text
%        str2double(get(hObject,'String')) returns contents of time_inc as a double


% --- Executes during object creation, after setting all properties.
function time_inc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function speed_Callback(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of speed as text
%        str2double(get(hObject,'String')) returns contents of speed as a double


% --- Executes during object creation, after setting all properties.
function speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start_sim.
function start_sim_Callback(hObject, eventdata, handles)
    ioARMSimWiFly = serial('COM4','BaudRate',57600);
    fopen(ioARMSimWiFly);


    handles.serial_connection = ioARMSimWiFly;
% hObject    handle to start_sim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stop_sim.
function stop_sim_Callback(hObject, eventdata, handles)
    % Stop the ARMSim Timer
    % stop(handles.serial_connection);

    % Close WiFly FID
    fclose(handles.serial_connection);
    delete(handles.serial_connection);

    % Clear all state
    clear all;
% hObject    handle to stop_sim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function ticks_Callback(hObject, eventdata, handles)
% hObject    handle to ticks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ticks as text
%        str2double(get(hObject,'String')) returns contents of ticks as a double


% --- Executes during object creation, after setting all properties.
function ticks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ticks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
