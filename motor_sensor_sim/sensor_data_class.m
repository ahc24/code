classdef sensor_data_class < handle
	properties
        %{
		ultra = [0 0 0];
        FLIR = [0 0 0];
        FRIR = [0 0 0];
        SLFIR = [0 0 0];
        SLRIR = [0 0 0];
        SLCIR = [0 0 0];
        SRFIR = [0 0 0];
        SRRIR = [0 0 0];
        SRCIR = [0 0 0];
        FLS = [0 0 0];
        RLS = [0 0 0];
        %}
        sensor_values = zeros(11, 3);
        
    end
    methods 
        function update(obj, data)
            obj.sensor_values(:,1) = obj.sensor_values(:,2);
            obj.sensor_values(:,2) = obj.sensor_values(:,3);
            obj.sensor_values(:,3) = data(6:16);
        end 
        
        function return_value = get_mean(obj)
            return_value = zeros(11,1);
            for i = 1:11
                return_value(i) = median(obj.sensor_values(i,:));
            end
        end
    end
end
