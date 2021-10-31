% LP Chebyshev
fp = 8e3; fs = 9.5e3;
wp=2*pi*fp; ws=2*pi*fs;  % Specs
% delta_p = 0.1; delta_s = 0.01;
% ap = -20*log10(1-delta_p)
% as = -20*log10(delta_s)
ap = 2; as = 40;

% fp = 20e3; fs = 21e3;
% wp=2*pi*fp; ws=2*pi*fs;  % Specs
% delta_p = 0.1; delta_s = 0.01;
% ap = -20*log10(1-delta_p)
% as = -20*log10(delta_s)

% Determine parameters K and epsilon according to specs, while also
% choosing a more suitable wp to give buffer at spec'd wp and ws
K = ceil(acosh(sqrt((10^(as/10)-1) / (10^(ap/10)-1))) / acosh(ws/wp) );
wp_range = [wp, ws/cosh(acosh(sqrt((10^(as/10)-1) / (10^(ap/10)-1))) / K)]  ;  % Range of values for wp
wp = mean(wp_range); % Select middle value
fp_chosen = wp/(2*pi); fp_range = wp_range / (2*pi);
epsilon = sqrt(10^(ap/10)-1);

% Now obtain polynomials that define the TF
k = 1:K;
H0 = (mod(K,2)==1) + (mod(K,2)==0)*(1/sqrt(1+epsilon^2));   % For even order, H0 always is 1; for odd, it's 1/...
pk = -wp*sinh(asinh(1/epsilon)/K)*sin(pi*(2*k-1)/(2*K)) + ...
    1j*wp*cosh(asinh(1/epsilon)/K)*cos(pi*(2*k-1)/(2*K));
B = H0*prod(-pk); A = poly(pk);

% For implemention as Sallen-Key cascades...
pole_list = remove_conj(pk);
damp_angles = 180 - rad2deg(angle(pole_list));
zetas = cosd(damp_angles);
Q = 1./(2*zetas);
wn_vals = abs(pole_list).^2;

C=10e-12; n=10;
C1=C*n; C2=C/n;
m = zeros(1,floor(K/2));
err = m;
Rvals = zeros(floor(K/2),2);
for i=1:floor(K/2)
    qual = @(mfac) (n*mfac)./(mfac.^2+1);
    e = @(mfac) abs(Q(i)-qual(mfac));
    [m(i), err(i)] = fminsearch(e,1);
    R = 1/(C*wn_vals(i));
    Rvals(i,1) = R*m(i); Rvals(i,2) = R/m(i);
end

% Now the TF!
subplot(1,2,1);
w = linspace(0,ws*3,1001);
H = B ./ (polyval(A, 1j*w));
f = w / (2*pi);
% plot(w, abs(H), 'LineWidth', 2);
plot(f, abs(H), 'LineWidth', 2);
delta_p = 10^(-ap/20); delta_s = 10^(-as/20);
% pgon1 = polyshape([0 wp wp 0], [0 0 delta_p delta_p]);
% pgon2 = polyshape([0 wp wp 0], [1 1 2 2]);
% pgon3 = polyshape([ws ws 3*ws 3*ws], [delta_s 2 2 delta_s]);
fp = wp / (2*pi); fs = ws / (2*pi);
pgon1 = polyshape([0 fp fp 0], [0 0 delta_p delta_p]);
pgon2 = polyshape([0 fp fp 0], [1 1 2 2]);
pgon3 = polyshape([fs fs 3*fs 3*fs], [delta_s 2 2 delta_s]);
hold on;
plot(pgon1);
plot(pgon2);
plot(pgon3);
hold off;
grid on;
order_str = ["Order: ", num2str(K)];
% xlabel('\omega (rad/s)'), ylabel('|H(j\omega)|'), title('Magnitude Response of Chebychev Type 1 Filter');
xlabel('f (Hz)'), ylabel('|H(jf)|'), title(['Magnitude Response of Chebychev Type 1 Filter', order_str]);
ylim([0 1.2]);

subplot(1,2,2);
plot(real(pk),imag(pk),'kx','MarkerSize',10);
title('Pole Plot (no zeros since CH)');
bound = max(abs(pk))*0.8;
grid on; xlim([-bound 1]), ylim([-bound*2 bound*2]);

