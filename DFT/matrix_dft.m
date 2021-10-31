N = 200; Om0 = 2*pi/N; k = 0:(N-1); n = 0:(N-1);

x = [3; 2; 3; zeros(N-3,1)];

DN = exp(-1j*Om0*k'*n); X = DN*x;

Om = linspace(0,2*pi,6001); XOm = exp(-1j*Om).*(2+6*cos(Om));
subplot(121); stem(k*Om0,abs(X)); line(Om,abs(XOm));
subplot(122); stem(k*Om0,angle(X)); line(Om,angle(XOm));