Fs = 5e3; T = 1/Fs; m = 5; L = m-1;
Om = linspace(-pi, pi, 1001); f = Om/(2*pi*T);

n = 0:L;
h = (1/m)*ones(1,m);
H = (1/m)*polyval(h,exp(-1j*Om)).*exp(-1j*L*Om);
zs = roots(h);  % Only zeros since FIR filters have all poles at zero

subplot(2,2,1);
plot(f,abs(H),'LineWidth',2); xlabel('Frequency (Hz)'), ylabel('Magnitude'), title('Magnitude Response');
ylim([0,max(abs(H))*1.2]);
grid on;

subplot(2,2,2);
plot(f,rad2deg(angle((H))),'LineWidth',2); xlabel('Frequency (Hz)'), ylabel('Phase (Degrees)'), title('Phase Response');
ylim([-max(abs(rad2deg(angle(H))))*1.2,max(abs(rad2deg(angle(H))))*1.2]);
grid on;

subplot(2,2,3);
plot(real(zs),imag(zs),'kx','MarkerSize',5); title('Zero Plot');
ylim([-1.2,1.2]); xlim([-1.2,1.2]);
grid on;

subplot(2,2,4);
title_str = ['Fs = ',num2str(Fs),'Hz, m = ',num2str(m),' samples'];
title(title_str);