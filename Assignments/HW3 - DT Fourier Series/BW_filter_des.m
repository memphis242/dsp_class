%% BP Design
% BP characteristics in terms of LP
wp=1; wp1=100; wp2=250; ws1=40; ws2=500;
ws = abs([ wp*(ws1^2 - wp1*wp2)/(ws1*(wp2-wp1)),...
    wp*(ws2^2 - wp1*wp2)/(ws2*(wp2-wp1)) ]);
ws = min(ws); ap=3; as=17;

% Design LP prototype
p = @(k,K,wc) 1j*wc*exp((1j*pi/(2*K))*((2*k-1)));
K = @(wp, ap, ws, as) ceil( log( (10^(as/10)- 1) / (10^(ap/10)-1) ) / (2*log(ws/wp)) );
wc_range = @(wp,ap,ws,as, K) [ (wp/(10^(ap/10)-1)^(1/(2*K))) (ws/(10^(as/10)-1)^(1/(2*K))) ];
order = K(wp,ap,ws,as)
omegac_range = wc_range(wp,ap,ws,as,order)
wc = (omegac_range(1) + omegac_range(2)) / 2;
k = 1:order;
poles_p = p(k,order,wc)
A = poly(poles_p)

% Now transform
a = 1; b = -poles_p*(wp2-wp1); c = wp1*wp2;
poles = [ (-b + sqrt(b.^2 - 4*a*c))/(2*a),  (-b - sqrt(b.^2 - 4*a*c))/(2*a) ]
B = (wc^order)*((wp2-wp1)^order)*poly(zeros(order,1)), A = poly(poles)

delta_p = 10^(-ap/20); delta_s = 10^(-as/20);
w = 0:2*ws2; H = polyval(B, 1j*w) ./ polyval(A,1j*w);
plot(w, abs(H), 'LineWidth', 2);
pgon1 = polyshape([0 ws1 ws1 0], [delta_s delta_s 2 2]);
pgon2 = polyshape([wp1 wp1 wp2 wp2], [1-delta_p 0 0 1-delta_p]);
pgon3 = polyshape([wp1 wp1 wp2 wp2], [1 2 2 1]);
pgon4 = polyshape([ws2 ws2 3*ws2 3*ws2], [delta_s 2 2 delta_s]);
hold on;
plot(pgon1);
plot(pgon2);
plot(pgon3);
plot(pgon4);
hold off;
grid on;
xlabel('\omega (rad/s)'), ylabel('|H(j\omega)|'), title('Magnitude Response of BW Filter');
ylim([0 1.2]);


%% LP Design
% p = @(k,K,wc) 1j*wc*exp((1j*pi/(2*K))*((2*k-1)));
% 
% wp=10; ap=2; ws=30; as=20;
% K = @(wp, ap, ws, as) ceil( log( (10^(as/10)- 1) / (10^(ap/10)-1) ) / (2*log(ws/wp)) );
% wc_range = @(wp,ap,ws,as, K) [ (wp/(10^(ap/10)-1)^(1/(2*K))) (ws/(10^(as/10)-1)^(1/(2*K))) ];
% order = K(wp,ap,ws,as)
% wc_range(wp,ap,ws,as,order)
% 
% wc = 12.5;
% k = 1:order;
% poles = p(k,order,wc)
% A = poly(poles)
% 
% delta_p = 10^(-ap/20); delta_s = 10^(-as/20);
% w = 0:100;
% H = wc^order ./ (polyval(A, 1j*w));
% plot(w, abs(H), 'LineWidth', 2);
% pgon1 = polyshape([0 wp wp 0], [0 0 delta_p delta_p]);
% pgon2 = polyshape([0 wp wp 0], [1 1 2 2]);
% pgon3 = polyshape([ws ws 3*ws 3*ws], [delta_s 2 2 delta_s]);
% hold on;
% plot(pgon1);
% plot(pgon2);
% plot(pgon3);
% hold off;
% grid on;
% xlabel('\omega (rad/s)'), ylabel('|H(j\omega)|'), title('Magnitude Response of BW Filter');
% ylim([0 1.2]);
