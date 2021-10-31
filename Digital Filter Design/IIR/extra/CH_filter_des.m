%% LP Chebyshev
% fp = 3e3; fs = 4e3;
% wp=2*pi*fp; ws=2*pi*fs;  % Specs
% delta_p = 0.1; delta_s = 0.01;
% ap = -20*log10(1-delta_p)
% as = -20*log10(delta_s)

% fp = 20e3; fs = 21e3;
% wp=2*pi*fp; ws=2*pi*fs;  % Specs
% delta_p = 0.1; delta_s = 0.01;
% ap = -20*log10(1-delta_p)
% as = -20*log10(delta_s)

% Determine parameters K and epsilon according to specs, while also
% choosing a more suitable wp to give buffer at spec'd wp and ws
K = ceil(acosh(sqrt((10^(as/10)-1) / (10^(ap/10)-1))) / acosh(ws/wp) )
wp = [wp, ws/cosh(acosh(sqrt((10^(as/10)-1) / (10^(ap/10)-1))) / K)]    % Range of values for wp
wp = mean(wp)   % Select middle value
epsilon = sqrt(10^(ap/10)-1)

% Now obtain polynomials that define the TF
k = 1:K;
H0 = (mod(K,2)==1) + (mod(K,2)==0)*(1/sqrt(1+epsilon^2));   % For even order, H0 always is 1; for odd, it's 1/...
pk = -wp*sinh(asinh(1/epsilon)/K)*sin(pi*(2*k-1)/(2*K)) + ...
    1j*wp*cosh(asinh(1/epsilon)/K)*cos(pi*(2*k-1)/(2*K))
B = H0*prod(-pk), A = poly(pk)

% Now the TF!
w = 0:ws*3;
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

