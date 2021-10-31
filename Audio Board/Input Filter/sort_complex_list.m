function [sorted_list] = sort_complex_list(list)
% This sort assumes list has conjugate pairs
% Inputs
%   list            --> This is the complex list of conjugate pairs to be
%                       sorted in row-vector or column-vector form
% Outputs
%   sorted_list     --> A N/2 rows by 2 columns list with conjugate pairs
%                       in a row, sorted from largest to smallest in
%                       magnitude

% First get rid of conjugate pairs cuz that makes this sorting more
% complicated
list = reshape(list,1,[]);
N = length(list);
i=1;
while i<=N
    j=1;
%     fd1 = list(i);
    while j<=N
%         fd2 = list(j);
        if conj_equality(list(i),list(j)) && abs(imag(list(j)))>= 1e-4
            list = remove_index(j,list);
            N = N-1;
        end
        j=j+1;
    end
    i=i+1;
end

% Now sort in descending order of magnitude
swap = 1;
while swap==1
    swap = 0;
    for i=1:length(list)-1
        if abs(list(i)) < abs(list(i+1))
            temp = list(i+1);
            list(i+1) = list(i);
            list(i) = temp;
            swap = 1;
        elseif list(i) == -list(i+1)
            
        end
    end
end

% Now we make a (something)-by-2 matrix with each row being a complex
% number and its conjugate
sorted_list = zeros(length(list),2);
for i=1:length(list)
    sorted_list(i,1) = list(i);
    sorted_list(i,2) = conj(list(i));
end

end

