function [newlist] = remove_conj(list)

newlist = reshape(list,1,[]);
N = length(list);
i=1;
while i<=N
    j=1;
%     fd1 = list(i);
    while j<=N
%         fd2 = list(j);
        if conj_equality(newlist(i),newlist(j)) && abs(imag(newlist(j)))>= 1e-4
            newlist = remove_index(j,newlist);
            N = N-1;
        end
        j=j+1;
    end
    i=i+1;
end

end

