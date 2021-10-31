initial = 0.34;
current = 6.86;
T = 10;

change = current - initial;
perc_change = (change/initial + 1)*100;
growth_rate = (perc_change/100) ^ (1/T);
growth_rate_perc = (growth_rate - 1) * 100;

check = initial*(annualized_growth_rate^T);