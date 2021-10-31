function [result] = length_test(T)
interest=0.07; B=25e3;
y = zeros(1,ceil(T+1)); y(1) = B;

% The T+1 means by the END of the final year
for i=2:ceil(T+1)
    y(i) = (1+interest)*y(i-1) + B;
end

result = y(end);

end

