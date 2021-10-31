T=7; a=1.07; B=25e3;
y = zeros(1,T); y(1) = B;

for i=2:T
    y(i) = a*y(i-1) + B;
end

fprintf('End Result: %f\n', y(end));
fprintf('Total Contribution: %d\n', B*T);
fprintf('Monthly Contribution: %f\n', B/12);

g1 = @(a) 1./(1-a); g2 = @(a) a./(1-a);
I = @(a,T,M) M ./ (g1(a) - g2(a).*(a.^(T-1)));