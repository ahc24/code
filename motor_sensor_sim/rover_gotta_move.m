% Filename
filename = 'Map1.txt';

% Read the Map
% [XY, Ramp_Center, Ramp_Entrance, Ramp_Exit, Target] = Read_Map_File(filename);

% Create data handle for storage
my_sensor_data = sensor_data_class;
my_map_data = map_data_class;

%{
sensor_data = sensor_data_class();
sensor_data.update( [ 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1 ] )
sensor_data.update( [ 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2 ] )
sensor_data.update( [ 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3 ] )
disp(sensor_data.sensor_values)
disp(sensor_data.get_mean())
clear
return
%}

% Open wifly connection
ioARMSimWiFly = serial('COM4','BaudRate',57600);
ioARMSimWiFly.BytesAvailableFcnCount = 18;
ioARMSimWiFly.BytesAvailableFcnMode = 'byte';
% ioARMSimWiFly.terminator = '~';  
ioARMSimWiFly.BytesAvailableFcn = {@get_sensor_values, my_sensor_data};
fopen(ioARMSimWiFly);


done = 0;

counter = 0;



while(~done)
    % [current_x, current_y] = localize(my_sensor_data,my_map_data);
    counter = counter + 1;
    disp(counter);
    disp(my_sensor_data.data);

end
