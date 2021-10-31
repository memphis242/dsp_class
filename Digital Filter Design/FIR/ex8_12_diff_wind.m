%% Compute
Lh = 80; L = Lh-1; n = -L-2:L+2; Om = linspace(-pi,pi,1e4+1);
wrec = @(n) (n>=0 & n<=L);
wham = @(n) (0.54-0.46*cos(2*pi*n/L)).*wrec(n);
whan = @(n) 0.5*(1-cos(2*pi*n/L));

if mod(L,2)==0
    Thshift = cos(pi*(n-L/2))./(n-L/2); 
    Thshift(n==(L/2))=0; % Since the limit is actually 0, but this point is a discontinuity
else
    Thshift = -sin(pi*(n-L/2))./(pi*(n-L/2).^2);
end

Threc = Thshift .* wrec(n);
Thham = Thshift .* wham(n);
Thhan = Thshift .* whan(n);

THrec = polyval(Threc,exp(1j*Om)).*exp(-1j*Om*L);
THham = polyval(Thham,exp(1j*Om)).*exp(-1j*Om*L);
THhan = polyval(Thhan,exp(1j*Om)).*exp(-1j*Om*L);
THideal = abs(Om);

%% Plot
subplot(4,2,1);
stem(n,Thshift); xlabel('n'); ylabel('h_{shift}[n]'); title('Shifted Ideal Impulse Response');
m = max(abs(Thshift));
ylim([-1.5*m,1.5*m]);
subplot(4,2,2);
stem(n,Thshift); xlabel('n'); ylabel('h_{shift}[n]'); title('Shifted Ideal Impulse Response');
ylim([-1.5*m,1.5*m]);

subplot(4,2,3);
stem(n,wrec(n)); xlabel('n'); ylabel('w_{rect}[n]'); title('Rectangular Window');
ylim([0,1.3]);
subplot(4,2,4);
stem(n,wham(n)); xlabel('n'); ylabel('w_{ham}[n]'); title('Hamming Window');
ylim([0,1.3]);

subplot(4,2,5);
stem(n,Thham); xlabel('n'); ylabel('h_{rect}[n]'); title('Hamming FIR Impulse Response');
ylim([-1.5*m,1.5*m]);
subplot(4,2,6);
stem(n,Thhan); xlabel('n'); title('Hann FIR Impulse Response');
ylim([-1.5*m,1.5*m]);

subplot(4,2,7);
plot(Om,abs(THrec),Om,abs(THideal)); xlabel('\Omega'); ylabel('|H_{rect}(\omega)|'); title('Rectangular FIR Magnitude Response');
m2 = max(abs([THrec,THideal]));
ylim([0,1.5*m2]);
subplot(4,2,8);
plot(Om,abs(THham),Om,abs(THideal),Om,abs(THhan)); xlabel('\Omega'); ylabel('|H_{ham}(\omega)|'); title('Hamming & Hann FIR Magnitude Response');
m2 = max(abs([THrec,THideal]));
ylim([0,1.5*m2]); legend('TH_{ham}(\Omega)','TH_{ideal}(\Omega)','TH_{han}(\Omega)');