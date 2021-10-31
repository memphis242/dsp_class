%% 2.6-2

Hp = @(s)s.^3./(s.^3+2*s.^2+2*s+1);
Hp_mag = @(w)abs(Hp(1j*w));
w = 0:1e-3:50;
f = @(w) ( Hp_mag(w) - (10^(-1/20)) ).^2;
w0 = fminsearch(f, 1);

% Part B LP -> HP
subplot(2,1,1);
w1 = 5;
H_mag1 = @(w)Hp((w1*w0)./w);
plot(w, H_mag1(w), w, Hp_mag(w), 'LineWidth', 2);
legend('H(\omega)', 'H_p(\omega)');
xlabel('\omega (rad/s)'), ylabel('|H(\omega)'), title('LPF -> HPF');
grid on;
ylim([0 1.2]);

% Part C LP -> BP
subplot(2,1,2);
w1=3; w2=4;
H_mag2 = @(w) Hp( w0 * (w.^2 - w1*w2) ./ (w*(w2-w1)) );
plot(w, H_mag2(w), w, Hp_mag(w), 'LineWidth', 2);
legend('H(\omega)', 'H_p(\omega)');
xlabel('\omega (rad/s)'), ylabel('|H(\omega)'), title('LPF -> BPF');
grid on;
ylim([0 1.2]);


%% 2.6-4

rect = @(w) 1*(abs(w) < 0.5) + 0.5*(w==0.5);
Hp = @(w) rect( (w+1)/2 );
w = -10:1e-3:10;

% Part C LP -> HP
subplot(2,1,1);
w1 = 2; w0 = 1;
H1 = @(w) Hp((w1*w0)./w);
plot(w, abs(H1(w)), w, abs(Hp(w)), 'LineWidth', 2);
legend('H(\omega)', 'H_p(\omega)');
xlabel('\omega (rad/s)'), ylabel('|H(\omega)'), title('LPF -> HPF');
grid on;
ylim([0 1.2]);

% Part E LP -> BS
subplot(2,1,2);
w0=1; w1=2; w2=4;
H2 = @(w) Hp( w0 * (w*(w2-w1)) ./ (-w.^2 + w1*w2) );
plot(w, abs(H2(w)), w, abs(Hp(w)), 'LineWidth', 2);
legend('H(\omega)', 'H_p(\omega)');
xlabel('\omega (rad/s)'), ylabel('|H(\omega)'), title('LPF -> BSF');
grid on;
ylim([0 1.2]);
