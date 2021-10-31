function [result,y] = interest_outcome(interest,T,B)

y = zeros(1,T); y(1) = B;

for i=2:T+1
    y(i) = (1+interest)*y(i-1) + B;
end

result = y(end);

end

