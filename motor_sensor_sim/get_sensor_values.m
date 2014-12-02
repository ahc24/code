function [ output_args ] = get_sensor_values( serial_object , event_data, stuff )
% Get the sensor values from the Rover

    [data count msg] = fread(serial_object, 18, 'char');
    
    if(data(1) ~= 255)
        term_char = 0;
        while(term_char ~= 254)
            [term_char count msg] = fread(serial_object, 1, 'char');
            disp(term_char)
        end
        return
    end
    
    % disp(data);
    
    stuff.update(data);   


end

