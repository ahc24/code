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

% Last Modified by GUIDE v2.5 18-Nov-2014 10:15:35

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
    figure()
    % handles.encoder_left_mark = 0;
    % handles.encoder_right_mark = 0;
    % figure(handles.sensor_map);
    line([-10 10] , [10 10]);
    line([-10 -10] , [-10 10] );
    line([10 10] , [-10 10]);
    line([-10 10] , [-10 -10]);
    %line_thingy = line([5 11],[5 11]);
    disp( gcf );
    % plot(handles.sensor_map );

    % %{
    ioARMSimWiFly = serial('COM4','BaudRate',57600);
    ioARMSimWiFly.BytesAvailableFcnCount = 18;
    ioARMSimWiFly.BytesAvailableFcnMode = 'byte';
    % ioARMSimWiFly.terminator = '~';    
    ioARMSimWiFly.BytesAvailableFcn = {@get_stuff,handles};
    fopen(ioARMSimWiFly);
    % %}
    
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
    
    if(data(1) ~= 255)
        term_char = 0;
        while(term_char ~= 254)
            [term_char count msg] = fread(hObject, 1, 'char');
        end
        
    end
    

    
    
    
    % === A Motor Response
    if( data(3) == 7 )
        % disp(data);
        % Update encoder values 
        y = (bitshift(data(5),24))+(bitshift(data(6),16))+(bitshift(data(7),8))+(data(8));
        set(handles.ticks_left,'string',y);
        % set(handles.encoder_trip_left,'string', ( y - handles.encoder_left_mark ));
        % disp(handles.encoder_left_mark);
        y = (bitshift(data(9),24))+(bitshift(data(10),16))+(bitshift(data(11),8))+(data(12));
        set(handles.ticks_right,'string',y);
        %set(handles.encoder_trip_right,'string', (y - handles.encoder_right_mark));
        % ===      
        
        return
    end
    % ===
    
    persistent x;
    
    
    % === A Sensor Response
    %
    if( data(3) == 5 )
        
        % disp(data);
        if(isempty(x))
            x = 1;            
        elseif( x >=10 )
            
            set(handles.ultra,'string',data(6));        
            set(handles.forward_left_ir,'string',data(7));        
            set(handles.forward_right_ir,'string',data(8));        
            set(handles.lsf_forward_ir,'string',data(9));        
            set(handles.lsf_rear_ir,'string',data(10));        
            set(handles.lsf_ir,'string',data(11));        
            set(handles.rsf_forward_ir,'string',data(12));        
            set(handles.rsf_rear_ir,'string',data(13));
            set(handles.rsf_ir,'string',data(14));
        
            %{
            line([0 0],[0 255],'Color', [1 1 1]);
            line([0 0],[0 data(6)]);
            line([0 0],[0 0],'Color', [1 1 1]);
            line([0 0],[0 0]);
            line([0 0],[0 0],'Color', [1 1 1]);
            line([0 0],[0 0]);
            line([0 -255],[10 10],'Color', [1 1 1]);
            line([0 -data(9)],[10 10]);
            line([0 -255],[10 10],'Color', [1 1 1]);
            line([0 -data(9)],[10 10]);
            line([0 -255],[10 10],'Color', [1 1 1]);
            line([0 -data(9)],[10 10]);
            line([0 -255],[-10 -10],'Color', [1 1 1]);
            line([0 -data(10)],[-10 -10]);
            line([0 -255],[0 0],'Color', [1 1 1]);
            line([0 -data(11)],[0 0]);
            line([0 -255],[0 0],'Color', [1 1 1]);
            line([0 -data(11)],[0 0]);
            line([0 255],[10 10],'Color', [1 1 1]);
            line([0 data(12)],[10 10]);
            line([0 255],[10 10],'Color', [1 1 1]);
            line([0 data(12)],[10 10]);
            line([0 255],[-10 -10],'Color', [1 1 1]);
            line([0 data(13)],[-10 -10]);        
            line([0 255],[0 0],'Color', [1 1 1]);
            line([0 data(14)],[0 0]);
            %}
            x = 1;
            
        else
            x = x + 1;
        end
        
            
        
    end 
    %
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



function ticks_left_Callback(hObject, eventdata, handles)
% hObject    handle to ticks_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ticks_left as text
%        str2double(get(hObject,'String')) returns contents of ticks_left as a double


% --- Executes during object creation, after setting all properties.
function ticks_left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ticks_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ultra_Callback(hObject, eventdata, handles)
% hObject    handle to ultra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ultra as text
%        str2double(get(hObject,'String')) returns contents of ultra as a double


% --- Executes during object creation, after setting all properties.
function ultra_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ultra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function forward_left_ir_Callback(hObject, eventdata, handles)
% hObject    handle to forward_left_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of forward_left_ir as text
%        str2double(get(hObject,'String')) returns contents of forward_left_ir as a double


% --- Executes during object creation, after setting all properties.
function forward_left_ir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to forward_left_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function forward_right_ir_Callback(hObject, eventdata, handles)
% hObject    handle to forward_right_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of forward_right_ir as text
%        str2double(get(hObject,'String')) returns contents of forward_right_ir as a double


% --- Executes during object creation, after setting all properties.
function forward_right_ir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to forward_right_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lsf_ir_Callback(hObject, eventdata, handles)
% hObject    handle to lsf_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lsf_ir as text
%        str2double(get(hObject,'String')) returns contents of lsf_ir as a double


% --- Executes during object creation, after setting all properties.
function lsf_ir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lsf_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rsf_ir_Callback(hObject, eventdata, handles)
% hObject    handle to rsf_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rsf_ir as text
%        str2double(get(hObject,'String')) returns contents of rsf_ir as a double


% --- Executes during object creation, after setting all properties.
function rsf_ir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rsf_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rsf_rear_ir_Callback(hObject, eventdata, handles)
% hObject    handle to rsf_rear_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rsf_rear_ir as text
%        str2double(get(hObject,'String')) returns contents of rsf_rear_ir as a double


% --- Executes during object creation, after setting all properties.
function rsf_rear_ir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rsf_rear_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lsf_rear_ir_Callback(hObject, eventdata, handles)
% hObject    handle to lsf_rear_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lsf_rear_ir as text
%        str2double(get(hObject,'String')) returns contents of lsf_rear_ir as a double


% --- Executes during object creation, after setting all properties.
function lsf_rear_ir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lsf_rear_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rsf_forward_ir_Callback(hObject, eventdata, handles)
% hObject    handle to rsf_forward_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rsf_forward_ir as text
%        str2double(get(hObject,'String')) returns contents of rsf_forward_ir as a double


% --- Executes during object creation, after setting all properties.
function rsf_forward_ir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rsf_forward_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lsf_forward_ir_Callback(hObject, eventdata, handles)
% hObject    handle to lsf_forward_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lsf_forward_ir as text
%        str2double(get(hObject,'String')) returns contents of lsf_forward_ir as a double


% --- Executes during object creation, after setting all properties.
function lsf_forward_ir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lsf_forward_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ticks_right_Callback(hObject, eventdata, handles)
% hObject    handle to ticks_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ticks_right as text
%        str2double(get(hObject,'String')) returns contents of ticks_right as a double


% --- Executes during object creation, after setting all properties.
function ticks_right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ticks_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function encoder_trip_left_Callback(hObject, eventdata, handles)
% hObject    handle to encoder_trip_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of encoder_trip_left as text
%        str2double(get(hObject,'String')) returns contents of encoder_trip_left as a double


% --- Executes during object creation, after setting all properties.
function encoder_trip_left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to encoder_trip_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function encoder_trip_right_Callback(hObject, eventdata, handles)
% hObject    handle to encoder_trip_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of encoder_trip_right as text
%        str2double(get(hObject,'String')) returns contents of encoder_trip_right as a double


% --- Executes during object creation, after setting all properties.
function encoder_trip_right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to encoder_trip_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in reset_trip_left.
function reset_trip_left_Callback(hObject, eventdata, handles)
% hObject    handle to reset_trip_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.encoder_trip_left,'string',0);
    handles.encoder_left_mark = str2double(get(handles.ticks_left,'String'));
    disp(handles.encoder_left_mark)
    


% --- Executes on button press in reset_trip_right.
function reset_trip_right_Callback(hObject, eventdata, handles)
% hObject    handle to reset_trip_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.encoder_trip_right,'string',0);
    handles.encoder_right_mark = str2double(get(handles.ticks_right,'String'));
