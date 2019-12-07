function [current_power] = current_power_func(cars,policy)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
base_station = [ 750 2250;  750  750;
                2250  750; 2250 2250;];
    number = cars(policy+3);
    distance = ( (cars(1)-base_station(number,1))^2 + (cars(2)-base_station(number,2))^2 )^0.5;
    current_power = -60 - 20*log10(distance);
end

