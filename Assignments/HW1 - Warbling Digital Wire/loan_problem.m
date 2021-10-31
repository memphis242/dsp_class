APR = 8/100;
APY = ((1+APR/12)^12 - 1) * 100;
i = APR / 12;
p = 1+i;

N = 30;  L = 12*N;
y_initial = 200e3;

monthly_payment = y_initial * (p - 1) / (1 - p^(-L));

fprintf('\n\nWith an APR of %.4f%%, the APY is %.4f%% and monthly rate is %.2f%%.\n', APR*100, APY, i*100);
fprintf('With an initial loan amount of $%.2f, the monthly payment required to pay off the loan in %d years is $%.2f.\n\n', y_initial, L, monthly_payment);