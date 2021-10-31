K = 3;
C = @(x) cosh(K*acosh(x));
ap = 2;
e = sqrt(10^(ap/10)-1);
wc = 100;
H_pow = @(wp) 1 ./ (1 + e^2*(C(wp/wc)).^2);
f = @(wp) abs(H_pow(wp) - 0.5);
[m,e] = fminsearch(f, 80)