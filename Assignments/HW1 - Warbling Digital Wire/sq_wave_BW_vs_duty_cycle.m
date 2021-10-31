Xk = @(a,k) (k~=0).*(1j ./ (2*pi*k + (k==0))) .* (exp(-1j*a*2*pi*k) - 1) + (k==0).*a;

N = 50;
k = -N:N;

a1 = 0.1; a2 = 0.25; a3 = 0.5; a4 = 0.75; a5 = 0.9;
X1k = Xk(a1,k); X2k = Xk(a2,k); X3k = Xk(a3,k); X4k = Xk(a4,k); X5k = Xk(a5,k);
X1mag = abs(X1k); X2mag = abs(X2k); X3mag = abs(X3k); X4mag = abs(X4k); X5mag = abs(X5k);

plot(k,X1mag, k,X2mag, k,X3mag, k,X4mag, k,X5mag, 'LineWidth',2);
xlabel('Harmonic Number'); ylabel('|X_k|'); title('Spectrum of Square Wave vs Duty Cycle');
legend('\alpha = 10%', '\alpha = 25%', '\alpha = 50%', '\alpha = 75%', '\alpha = 90%');
grid on;