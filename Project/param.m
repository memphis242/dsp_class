Inl = 20e-3; rpm_nl = 130; Vm = 6; eff_nl = 10/100;
R = 32; L = 125e-6;
w_nl = rpm_nl * (1/60) * (2*pi);
m = 10e-3; r = 5e-2;
rad_to_rpm = (1/(2*pi))*60;

K = (Vm - Inl*R) / w_nl;
B = Vm*Inl*eff_nl / (w_nl^2);
J = 0.5*m*r^2;

b = J*R + B*L; a = J*L; c = B*R + K^2;
poles = [ ( -b + sqrt(b^2 - 4*a*c) ) / (2*a), ( -b - sqrt(b^2 - 4*a*c) ) / (2*a) ];
dom_pole = -min(abs(poles));

num = K*rad_to_rpm; den = [J*L, J*R+B*L, B*R+K^2];
G1 = tf(num,den);
zpk(G1);
DCgain = evalfr(G1,0);
num2 = -DCgain * dom_pole; den2 = [1 -dom_pole];
G = tf(num2,den2)

% subplot(121); step(G1);
% subplot(122); step(G);

% Vin = 6;
% [y,tOut] = step(G);
% y = y*Vin;
% plot(tOut',y','LineWidth',2);

MOS = @(z) exp(-pi * (z./sqrt(1-z.^2)));
desired_MOS = 0.10;
E = @(z) abs(MOS(z) - desired_MOS);
[zeta,err] = fminsearch(E, 0.5);
th = acosd(zeta);
m = tand(th);
Ts = 1;
sig = -4/Ts;
dp = sig + 1j*-sig*m;

Ci = zpk(dom_pole,[0 2*sig],1);
Li = Ci*G;
rlocus(Li);
pause
kk = @(s) -1 ./ evalfr(Li,s);
ks = real(kk(dp));
L = Li*ks; C = ks*Ci;
W = feedback(L,1);
E = 1-W;
U = C*(1-W);
step(W);
pause
step(E)
pause
step(U)

