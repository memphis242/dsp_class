n = 0:50;
f = 100;
t = 0:1e-2:3;

Fs = 10e3;
Ts = 1 / Fs;
sine_wave = @(t) cos(2*pi*f*t);
x = @(n) sine_wave(n*T);
y = @(n) ((-1).^n).*x(n);

subplot(2,1,1);
stem(n, x(n));
subplot(2,1,2);
stem(n, y(n));