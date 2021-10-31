function [result] = int_test(interest)
T=7; B=12e3;
y = zeros(1,T+1); y(1) = B;

% The T+1 means by the END of the final year
for i=2:T+1
    y(i) = (1+interest)*y(i-1) + B;
end

result = y(end);

end

