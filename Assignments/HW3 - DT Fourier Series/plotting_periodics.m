modulo = @(a,m) a - m.*sign(a).*floor(abs(a./m));

T = 10;
t = -3*T:0.1:3*T;
u = @(t) (modulo(t,T)>=-3 & modulo(t,T)<3);

plot(t, u(t), 'LineWidth', 2);
grid on;
ylim([-0.2,2]);
