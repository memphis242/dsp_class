K = 3;
C = @(x) cosh(K*acosh(x));
as = 20;
e = 1 / sqrt(10^(as/10)-1);
wc = 100;
H_pow = @(ws) (e^2*(C(ws/wc)).^2) ./ (1 + e^2*(C(ws/wc)).^2);
f = @(ws) abs(H_pow(ws) - 0.5);
[m,n] = fminsearch(f, 110)