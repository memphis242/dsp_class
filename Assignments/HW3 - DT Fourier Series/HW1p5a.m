T = 40;
t = -60:0.1:60;
x = @(t) (2*t/17).*(t>=0 & t<17) + (-t/14 + 40/14).*(t>=26 & t<40);
x_per = @(t) x(mod(t,T));

plot(t, x_per(t), 'LineWidth', 2);
xlabel('t (sec)'), ylabel('x(t)'), title('Plot of x(t)');
ylim([-0.2 2.5]);
grid on;