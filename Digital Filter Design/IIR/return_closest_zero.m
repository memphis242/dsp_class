function [closest_zero] = return_closest_zero(pole,zero_list)

    N = size(zero_list);
    N = N(1);   % This is number of rows in zero_list; each row is a pair of conjugate zeros
    
    closest_zero = zero_list(1);
    closest_distance = abs(closest_zero - pole);
    for i = 2:N
        distance = abs(pole - zero_list(i));
        if distance < closest_distance
            closest_distance = distance;
            closest_zero = zero_list(i);
        end
    end
    
end

