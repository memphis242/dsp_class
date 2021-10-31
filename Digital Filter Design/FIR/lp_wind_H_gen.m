%% Compute
% This script can actually be used nicely to check out LP FIR filters at
% arbitrary fc using rect- and ham- windowed FIR filters of arbitrary
% length

fc = 2e3; Fs = 20e3; T = 1/Fs;
Lh = 501; L = Lh-1;

hc_ideal = @(t) 2*fc*sinc(2*fc*t);
h_ideal = @(n) T*hc_ideal(n*T);

w_rect = @(n) (n>=0 & n<=L);
w_ham = @(n) (0.54 - 0.46*cos(2*pi*n/L)).*w_rect(n);

% n = -L-1:L+1;
n = 0:L;
h_rect = h_ideal(n-(L/2)).*w_rect(n);
h_ham = h_ideal(n-(L/2)).*w_ham(n);

Om = linspace(-pi,pi,1001); f = Om/(2*pi*T);
Hrec = polyval(h_rect,exp(1j*Om)).*exp(-1j*L*Om);
Hham = polyval(h_ham,exp(1j*Om)).*exp(-1j*L*Om);
rect = @(t,tau) (t>=(-tau/2) & t<=(tau/2));
wc = 2*pi*fc; Om_c = wc*T;
Hideal = rect(Om,2*Om_c);


%% Plot
subplot(4,2,1);
stem(n,h_ideal(n)); xlabel('n'); ylabel('h_{ideal}[n]'); title('Ideal Impulse Response');
m = max(h_ideal(n));
ylim([-1.5*m,1.5*m]); %grid on;
subplot(4,2,2);
stem(n,h_ideal(n-(L/2))); xlabel('n'); ylabel('h_{ideal}[n]'); title('Shifted Ideal Impulse Response');
ylim([-1.5*m,1.5*m]); %grid on;

subplot(4,2,3);
stem(n,w_rect(n)); xlabel('n'); ylabel('w_{rect}[n]'); title('Rectangular Window');
ylim([0,1.3]);%grid on;
subplot(4,2,4);
stem(n,w_ham(n)); xlabel('n'); ylabel('w_{ham}[n]'); title('Hamming Window');
ylim([0,1.3]);%grid on;

subplot(4,2,5);
stem(n,h_rect); xlabel('n'); ylabel('h_{rect}[n]'); title('Rectangular FIR Impulse Response');
ylim([-1.5*m,1.5*m]); %grid on;
subplot(4,2,6);
stem(n,h_ham); xlabel('n'); ylabel('w_{ham}[n]'); title('Hamming FIR Impulse Response');
ylim([-1.5*m,1.5*m]); %grid on;

subplot(4,2,7);
plot(f,abs(Hrec),f,abs(Hideal)); xlabel('Frequency (Hz)'); ylabel('|H_{rect}(\omega)|'); title('Rectangular FIR Magnitude Response');
m2 = max(abs([Hrec,Hideal]));
ylim([0,1.5*m2]);
subplot(4,2,8);
plot(f,abs(Hham),f,abs(Hideal)); xlabel('Frequency (Hz)'); ylabel('|H_{ham}(\omega)|'); title('Hamming FIR Magnitude Response');
m2 = max(abs([Hrec,Hideal]));
ylim([0,1.5*m2]);



%% Now output the H array
h = h_ham;
getHcoeff(L,h);
