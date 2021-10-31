R1 = 18e3; R2 = 390;
C1 = 100e-12; C2 = 1e-6;
m = sqrt(R1/R2); n = sqrt(C2/C1);
R = R2*m; C = C1*n;
Q = m*n / (m^2 + 1); wn = 1/(R*C);

f = logspace(2,5,1001);
w = 2*pi*f; s = 1j*w;
sp = s / wn;
k = R1 / (R1+R2);

Zin_mag = mag2db(abs( R1 * (sp.^2 + sp/Q + 1) ./ (sp.^2 + sp*k/Q) ));

semilogx(f,Zin_mag,'LineWidth',2);
xlabel('Frequency (Hz)'), ylabel('Impedance (\Omega) dB'), title('Input Impedance of Sallen-Key Circuit');
grid on;

Zin_min = db2mag(min(Zin_mag))
