Ck = [0.6513, 0.8942, 0.4322, 0.2387, 0.1312, 0.2314, 0.2226, 0.1337, 0.0658, 0.1079];
Ok = [-1.9174, 2.6620, -0.6346, 2.8995, 1.3452, -1.6801, 1.6153, -1.5630, 2.7450, 0.4671];

K = 4;
Y0 = 0.99;
c3 = 16e3;
Tx=40; Ty=40/c3;
wy = 2*pi/Ty;
ty = -1*Ty:(Ty/100):1*Ty;
yhat = zeros(size(ty));

for k = 0:K
    if k==0
        yhat = yhat + Y0;
    else
        yhat = yhat + Ck(k)*cos(k*wy*ty + Ok(k));
    end
end

plot(ty, real(yhat), 'LineWidth', 2);
xlabel('Time (s)'), ylabel('Amplitude'), title('y_{hat}(t)');
grid on;
ylim([-1,3.5]);
