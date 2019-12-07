t = cputime;
cars = [];
hand_off = [0 0 0 0];
power = [0 0 0 0];
total_handoff = [];
total_power = [];
n = 0;
% [x_position y_position direction Best Threshold Entropy Mine;]
% direction:
% 1: to East
% 2: to North
% 3: to West
% 4: to South
exits = [   0 2250;    0 1500;    0  750;
          750    0; 1500    0; 2250    0;
         3000  750; 3000 1500; 3000 2250;
         2250 3000; 1500 3000;  750 3000];
p = poisspdf(0,1/30);
distance = 10;
cross = [ 750 2250;  750 1500;  750  750;
         1500  750; 2250  750; 2250 1500;
         2250 2250; 1500 2250; 1500 1500;];
%{
cross = [   0 2400;  600 2400; 1200 2400; 1800 2400; 2400 2400;
            0 1800;  600 1800; 1200 1800; 1800 1800; 2400 1800;
            0 1200;  600 1200; 1200 1200; 1800 1200; 2400 1200;
            0  600;  600  600; 1200  600; 1800  600; 2400  600;
            0    0;  600    0; 1200    0; 1800    0; 2400    0;];
%}
base_station = [ 750 2250;  750  750;
                2250  750; 2250 2250;];
% turn=0.0000~0.3333(right)
% turn=0.3334~0.5000(left)
% turn=0.5001~1.0000(straight)
%%
count = 0;
t = cputime;
for i = 1:86400
    % Initialize Power
    power = zeros(1,4);
    % Initialize Power
    % Cars Moving
    count = count + size(cars,1);
    for j = 1:size(cars,1)
        % Check How far are cars from the cross
        [how_far, cross_number] = Distance(cars(j,:), cross);
        % Check How far are cars from the cross
        if(cars(j,3) == 1)
            % To East
            if ( how_far > distance )
                cars(j,1) = cars(j,1) + distance;
            else
                turn = rand;
                if( turn < 0.3334)
                    cars(j,2) = cross(cross_number,2) - (distance - (cross(cross_number,1) - cars(j,1)));
                    cars(j,1) = cross(cross_number,1);
                elseif( turn < 0.5001)
                    cars(j,2) = cross(cross_number,2) + (distance - (cross(cross_number,1) - cars(j,1)));
                    cars(j,1) = cross(cross_number,1);
                else
                    cars(j,1) = cars(j,1) + distance;
                end
            end
            % To East
        elseif(cars(j,3) == 2)
            % To North
            if ( how_far > distance )
                cars(j,2) = cars(j,2) + distance;
            else
                turn = rand;
                if( turn < 0.3334)
                    cars(j,1) = cross(cross_number,1) + (distance - (cross(cross_number,2) - cars(j,2)));
                    cars(j,2) = cross(cross_number,2);
                elseif( turn < 0.5001)
                    cars(j,1) = cross(cross_number,1) - (distance - (cross(cross_number,2) - cars(j,2)));
                    cars(j,2) = cross(cross_number,2);
                else
                    cars(j,2) = cars(j,2) + distance;
                end
            end
            % To North
        elseif(cars(j,3) == 3)
            % To West
            if ( how_far > distance )
                cars(j,1) = cars(j,1) - distance;
            else
                turn = rand;
                if( turn < 0.3334)
                    cars(j,2) = cross(cross_number,2) + (distance - (-cross(cross_number,1) + cars(j,1)));
                    cars(j,1) = cross(cross_number,1);
                elseif( turn < 0.5001)
                    cars(j,2) = cross(cross_number,2) - (distance - (-cross(cross_number,1) + cars(j,1)));
                    cars(j,1) = cross(cross_number,1);
                else
                    cars(j,1) = cars(j,1) - distance;
                end
            end
            % To West
        elseif(cars(j,3) == 4)
            % To South
            if ( how_far > distance )
                cars(j,2) = cars(j,2) - distance;
            else
                turn = rand;
                if( turn < 0.3334)
                    cars(j,1) = cross(cross_number,1) - (distance - (-cross(cross_number,2) + cars(j,2)));
                    cars(j,2) = cross(cross_number,2);
                elseif( turn < 0.5001)
                    cars(j,1) = cross(cross_number,1) + (distance - (-cross(cross_number,2) + cars(j,2)));
                    cars(j,2) = cross(cross_number,2);
                else
                    cars(j,2) = cars(j,2) - distance;
                end
            end
            % To South
        end
    end
    % Cars Moving
    % Check Exiting Cars
    j = 1;
    while j <= size(cars,1)
        if(cars(j,1) < 0 || cars(j,1) > 3000 || cars(j,2) < 0 || cars(j,2) > 3000)
            cars(j,:) = [];
            j = j - 1;
        end
        j = j + 1;
    end
    % Check Exiting Cars
    % Calculate Power and Handoff
    for j = 1:size(cars,1)
        [best_power,base_number] = base_station_power(cars(j,:),base_station);
        current_power = current_power_func(cars(j,:),1);
        if(current_power < best_power)
            cars(j,4) = base_number;
            hand_off(1) = hand_off(1) + 1;
            power(1) = power(1) + best_power;
        else
            power(1) = power(1) + current_power;
        end
        current_power = current_power_func(cars(j,:),2);
        if(current_power < best_power & current_power < -110)
            cars(j,5) = base_number;
            hand_off(2) = hand_off(2) + 1;
            power(2) = power(2) + best_power;
        else
            power(2) = power(2) + current_power;
        end
        current_power = current_power_func(cars(j,:),3);
        if(current_power + 5 < best_power)
            cars(j,6) = base_number;
            hand_off(3) = hand_off(3) + 1;
            power(3) = power(3) + best_power;
        else
            power(3) = power(3) + current_power;
        end
        current_power = current_power_func(cars(j,:),4);
        if((current_power + 5) / best_power < 0.95 & current_power < -110)
            cars(j,7) = base_number;
            hand_off(4) = hand_off(4) + 1;
            power(4) = power(4) + best_power;
        else
            power(4) = power(4) + current_power;
        end
    end
    % Calculate Power and Handoff
    % Accumulate n (cars/second)
    n = n + size(cars,1);
    % Accumulate n (cars/second)
    % Generate New Cars at the Entrance
    for j = 1:12
        if(rand > p)
            cars = [cars;exits(j,1) exits(j,2) round(j/3+0.45) round((mod(j+1,12)+1)/3+0.45) round((mod(j+1,12)+1)/3+0.45) round((mod(j+1,12)+1)/3+0.45) round((mod(j+1,12)+1)/3+0.45)];
        end
    end
    % Generate New Cars at the Entrance
    % Store Result
    total_handoff = [total_handoff;hand_off];
    if(size(cars,1))
        total_power = [total_power;power/size(cars,1)];
    end
    % Store Result
    %{
 Store Result
    subplot(2,1,1);
    hold on;
        plot(i,hand_off(1),'Bo',i,hand_off(2),'G+',i,hand_off(3),'Rx');
        legend('Best Policy','Threshold Policy','Entropy Policy');  
    subplot(2,1,2);
    hold on;
    if(size(cars,1))
        plot(i,power(1)/size(cars,1),'Bo',i,power(2)/size(cars,1),'G+',i,power(3)/size(cars,1),'Rx');
        legend('Best Policy','Threshold Policy','Entropy Policy');  
    end
    %}
    %Store Result
end
%%
% Plot Result
    subplot(2,1,1);
        plot(1:size(total_handoff,1),total_handoff(:,1),'Bo',1:size(total_handoff,1),total_handoff(:,2),'G+',1:size(total_handoff,1),total_handoff(:,3),'Rx',1:size(total_handoff,1),total_handoff(:,4),'M*');
        legend('Best Policy','Threshold Policy','Entropy Policy','My Policy');  
    subplot(2,1,2);
        plot(1:size(total_power,1),total_power(:,1),'Bo',1:size(total_power,1),total_power(:,2),'G+',1:size(total_power,1),total_power(:,3),'Rx',1:size(total_power,1),total_power(:,4),'M*');
        legend('Best Policy','Threshold Policy','Entropy Policy','My Policy');  
% Plot Result
elapsed_time = cputime-t;