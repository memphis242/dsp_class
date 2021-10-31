function [R1,R2,C1,C2] = sallenKeyComponents(C,n,Q,wn)

% Determine m
f = @(m) m*n ./ (m.^2 + 1);
err = @(m) abs(f(m) - Q);
m = fminsearch(err,10);

R = 1/(wn*C);
R1 = m*R; R2 = R/m;
C1 = n*C; C2 = C/n;


end

