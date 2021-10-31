M=250e3; T=7; I=12e3;
e = @(interest) abs(M - int_test(interest));
[needed_interest,err] = fminsearch(e,0.15);

fprintf('\nTo achieve $%d in %d years while putting away $%d a year, you need an average annual return of: %f\n\n', M, T, I, needed_interest);