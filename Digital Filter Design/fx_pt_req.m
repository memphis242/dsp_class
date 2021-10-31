h0 = 0.150052719359518;
h1 = 0.450158158078553;
h2 = h1;
h3 = h0;


% Signed
N = 32; % Word-length
a = 1.015;
QI = floor(log2(abs(a)) + 2);
QF = N - QI;
% QF = floor(log2( (2^(N-1)-1)/abs(a) ));
% QI = N - QF;
res = 2^(-QF);
range1 = -2^(QI-1); range2 = 2^(QI-1) - 2^(-QF);
a_fxp = fix(a*2^(QF)); a_fxp_hex = dec2hex(a_fxp);
a_result = a_fxp * 2^(-QF);
err = abs(a-a_result);

str = ['\nInitial Number: %f\nQI: %d\tQF: %d\nResolution: %f\nPossible Range: %f --> %f\n\n', ...
    'Fixed-Point Representation - \tHex: ', a_fxp_hex,...
    '\tInt: %d\nCorresponding Rational Number Being Represented: %f\nError: %f\n\n'];
fprintf(str, a, QI, QF, res, range1, range2, a_fxp, a_result, err);