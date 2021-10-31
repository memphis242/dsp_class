deltap=1; deltas=0.01;
Lh=27; L=Lh-1; K=10*Lh; k=0:K-1; Omk=k*2*pi/K;

Omp=pi/3; Oms=pi/2;
Q = (Omk<=Omp)*(1/((deltap/2)^2)) + (Omk>=Oms)*(1/(deltas^2));
Q(fix(K/2)+2:end) = Q(round(K/2):-1:2);
Hd = 1.0*(Omk<=Omp).*exp(-1j*k*pi*L/K);
Hd(fix(K/2)+2:end) = conj(Hd(round(K/2):-1:2));

% Oms=3*pi/8; Omp=pi/2;
% Q = (Omk<=Oms)*(10000) + (Omk>=Omp)*(1);
% Q(fix(K/2)+2:end) = Q(round(K/2):-1:2);
% Hd = 1.0*(Omk>=Omp).*exp(-1j*k*pi*L/K);
% Hd(fix(K/2)+2:end) = conj(Hd(round(K/2):-1:2));

l=(0:L)'; a=exp(1j*l*Omk)*Q.'/K; b=exp(1j*l*Omk)*(Hd.*Q/K).';
A = toeplitz(a); h = real((A\b));

n = (0:L)'; subplot(311); stem(n,h); title('Impulse Response h[n]');

Om = linspace(0,pi,10001); H = polyval(h,exp(1j*Om)).*exp(-1j*L*Om);
subplot(312); plot(Om,abs(H));

pgon1 = polyshape([0,0;0,(1-deltap/2);Omp,(1-deltap/2);Omp,0]);
pgon2 = polyshape([0,(1+deltap/2);0,3;Omp,3;Omp,(1+deltap/2)]);
pgon3 = polyshape([Oms,deltas;pi,deltas;pi,3;Oms,3]);

% pgon1 = polyshape([0,deltas;Oms,deltas;Oms,3;0,3]);
% pgon2 = polyshape([Omp,0;Omp,(1-deltap/2);pi,(1-deltap/2);pi,0]);
% pgon3 = polyshape([Omp,(1+deltap/2);Omp,3;pi,3;pi,(1+deltap/2)]);

hold on;
plot(pgon1);
plot(pgon2);
plot(pgon3);
hold off;
ylim([0,1.2*(1+deltap/2)]);xlim([0,pi]); title('Magnitude Response');

Zdig = roots(h);
subplot(313); plot(real(Zdig),imag(Zdig),'ko','Markersize', 10);
title('Zero Plot');
grid on; xlim([-1.2 1.2]), ylim([-1.2 1.2]);
hold on;
% Draw unit circle for reference
hold on;
s = exp(1j*linspace(0,2*pi));
plot(real(s),imag(s));

