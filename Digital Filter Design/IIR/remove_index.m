function [new_list] = remove_index(index,list)
% This essentially performs a left shift from the removed index

    new_size = length(list)-1;
    
    for i = index:new_size
        list(i) = list(i+1);
    end
    
    new_list = zeros(1,new_size);
    for i = 1:new_size
        new_list(i) = list(i);
    end

end

