C = 10e-9; n = 100; Q = 8;
f = @(wn) sallenKeyComponents(C,n,Q,wn);
wn_min = 1e3; wn_max = 30e3;
wn = linspace(wn_min,wn_max,1001);
Y = zeros(1001,4);
R1=0;R2=0;C1=0;C2=0;

for i=1:1001
    [R1,R2,C1,C2] = f(wn(i));
    Y(i,:) = [R1,R2,C1,C2];
end

R1 = Y(:,1); R2 = Y(:,2);

subplot(2,1,1);
plot(wn,R1,'LineWidth',2);
title('R1 vs wn'); xlabel('Q'), ylabel('R1 (ohms)');
grid on;

subplot(2,1,2);
plot(wn,R2,'LineWidth',2);
title('R2 vs wn'); xlabel('Q'), ylabel('R2 (ohms)');
grid on;

R1min = min(R1); R1max = max(R1);
R2min = min(R2); R2max = max(R2);

R1min
R1max
R2min
R2max
