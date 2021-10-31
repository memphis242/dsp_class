%% Compute h for desired EQ Curve
Fs = 20e3; T = 1/Fs;
Lh=33; L=Lh-1; K=10*Lh; k=0:K-1; Omk=k*2*pi/K; fk = Omk/(2*pi*T);

% fp = 5e3; fs = 5.5e3; deltap = 1; deltas = 0.01;
% Omp = 2*pi*fp*T; Oms = 2*pi*fs*T;
% Q = (Omk<=Omp)*(1/((deltap/2)^2)) + (Omk>=Oms)*(1/(deltas^2));
% Q(fix(K/2)+2:end) = Q(round(K/2):-1:2);
% Hd = 1.0*(Omk<=Omp).*exp(-1j*k*pi*L/K);
% Hd(fix(K/2)+2:end) = conj(Hd(round(K/2):-1:2));

freqs = [10 50 100 200 500 1000 2000 5000 7000 8000 9000 9500];
gains = 0.8*[5  4.5 4.5 2.5 2.5  2.5 2    2   2.5   2.5  2.5  3.5];
OmFrqs = 2*pi*freqs*T;
Hd = generate_Hd(Omk, OmFrqs, gains).*exp(-1j*k*pi*L/K);
Hd(fix(K/2)+2:end) = conj(Hd(round(K/2):-1:2));
Q = ones(1,K);

l=(0:L)'; a=exp(1j*l*Omk)*Q.'/K; b=exp(1j*l*Omk)*(Hd.*Q/K).';
A = toeplitz(a); h = real((A\b));

%% Obtain fixed-point H
Hcoeff = getHcoeff(L,h);

%% Plot
n = (0:L)'; subplot(321); stem(n,h); title('Impulse Response h[n]');
iii = max(abs(h))*1.2;
ylim([-iii,iii]);
subplot(322); stem(n,Hcoeff); title('Impulse Response h[n]');
iii = max(abs(Hcoeff))*1.2;
ylim([-iii,iii]);

% Om = linspace(0,pi,10001);
H = polyval(h,exp(1j*Omk)).*exp(-1j*L*Omk);
subplot(323); plot(fk(1:fix(length(fk)/2)),abs(H((1:fix(length(fk)/2)))), fk((1:fix(length(fk)/2))),abs(Hd((1:fix(length(fk)/2)))), 'LineWidth', 2); legend('H', 'Hd');
ylim([0,max(abs(Hd))*1.4]); xlim([0,Fs/2]); xlabel('Frequency (Hz)'); title('Magnitude Response');

Zdig = roots(h);
subplot(325); plot(real(Zdig),imag(Zdig),'ko','Markersize', 10);
title('Zero Plot');
grid on; xlim([-1.2 1.2]), ylim([-1.2 1.2]);
hold on;
% Draw unit circle for reference
hold on;
s = exp(1j*linspace(0,2*pi));
plot(real(s),imag(s));


%% Print Text File for test freqs
freqs = [10 50 100 200 500 1000 2000 5000 7000 8000 9000 9500];
test_freqs = freqs;
test_gains = interp1(fk, abs(H), test_freqs);
test_inputs = 1.0*ones(1,length(test_freqs));
test_outputs = test_inputs .* test_gains;
fid = fopen('test_freqs.txt', 'w');
fprintf(fid, 'Order: %d\t\tFs: %dHz\t\tT: %.2fus\n\n',L,Fs,T*1e6);
fprintf(fid, 'Frequency\t\tInput\t\tExpected Output\t\tGain\n');
for i=1:length(test_freqs)
    fprintf(fid,'%.4d\t\t\t%f\t\t%f\t\t%f\n', test_freqs(i),test_inputs(i),test_outputs(i),test_gains(i));
end
fclose(fid);


