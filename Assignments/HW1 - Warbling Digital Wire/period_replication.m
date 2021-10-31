clear y;
x = @(t) 1*(t>=-1 & t<= 1); % Rectangular pulse from t=-1 to t=1 --> Period of 2

a = 4;
t = -10:1e-2:10;
y = zeros(size(t));

for k = -10:10
    y = y + x(t-a*k);
end

plot(t, x(t), t, y, 'LineWidth', 2);
legend('x(t)', 'y(t)');
grid on, xlim([-10,10]), ylim([-0.5,10]);