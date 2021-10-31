H = @(s) 1 ./ (1+1e-6*s);

% w = logspace(0,7);
w = (3e6-50):1e-1:(3e6+50);
subplot(121);
% semilogx(w, abs(H(1j*w)), 'LineWidth', 2);
plot(w, abs(H(1j*w)), 'LineWidth', 2);
xlabel('\omega (rad/s)'), ylabel('|H(jw)'), title('Magnitude Response');
grid on;
subplot(122);
% semilogx(w, rad2deg(angle(H(1j*w))), 'LineWidth', 2);
plot(w, rad2deg(angle(H(1j*w))), 'LineWidth', 2);
xlabel('\omega (rad/s)'), ylabel('\angle H(jw) (rad)'), title('Phase Response');
grid on;