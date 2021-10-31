M=1e6; i=0.07; I=25e3;
g1 = @(a) 1./(1-a); g2 = @(a) a./(1-a);
a = 1+i;
I = @(T) M ./ (g1(a) - g2(a).*(a.^(T-1)));
e = @(T) abs(M - I(T));
[needed_time,err] = fminsearch(e,10);

fprintf('\nTo achieve $%d with %.2f%% interest rate while putting away $%d a year, you need to wait %d years.\n\n', M, i, I, ceil(needed_time));