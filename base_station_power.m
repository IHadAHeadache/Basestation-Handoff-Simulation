function [best_power,base_number] = base_station_power(cars,base_station)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
best_power = -220;
base_number = 0;
    for i = 1:4
        distance = ( (cars(1)-base_station(i,1))^2 + (cars(2)-base_station(i,2))^2 )^0.5;
        current_power = -60 - 20*log10(distance);
        if(best_power < current_power)
            best_power = current_power;
            base_number = i;
        end
    end
end

