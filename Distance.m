function [distance, cross_number] = Distance(cars,cross)
    distance = 9999;
    cross_number = 0;
    if(cars(3) == 1)
        for i = 1:9
            if( cars(1) > cross(i,1) )
                continue;
            else
                temp = ( (cars(1)-cross(i,1))^2 + (cars(2)-cross(i,2))^2)^0.5;
                if( temp < distance)
                    cross_number = i;
                    distance = temp;
                end
            end
        end
    elseif(cars(3) == 2)
        for i = 1:4
            if( cars(2) > cross(i,2) )
                continue;
            else
                temp = ( (cars(1)-cross(i,1))^2 + (cars(2)-cross(i,2))^2)^0.5;
                if( temp < distance)
                    cross_number = i;
                    distance = temp;
                end
            end
        end
    elseif(cars(3) == 3)
        for i = 1:4
            if( cars(1) < cross(i,1) )
                continue;
            else
                temp = ( (cars(1)-cross(i,1))^2 + (cars(2)-cross(i,2))^2)^0.5;
                if( temp < distance)
                    cross_number = i;
                    distance = temp;
                end
            end
        end
    elseif(cars(3) == 4)
        for i = 1:4
            if( cars(2) < cross(i,2) )
                continue;
            else
                temp = ( (cars(1)-cross(i,1))^2 + (cars(2)-cross(i,2))^2)^0.5;
                if( temp < distance)
                    cross_number = i;
                    distance = temp;
                end
            end
        end
    end

end

