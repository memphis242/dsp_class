K=3; as=20; ws=145; wp=60; ap=2;
epsilon = 1/sqrt(10^(as/10)-1)

% Now obtain polynomials that define the TF of a prototype Chebyshev that
% we will later transform to an inverse Chebyshev's
k = 1:K;
H0 = (mod(K,2)==1) + (mod(K,2)==0)*(1/sqrt(1+epsilon^2));   % For even order, H0 always is 1; for odd, it's 1/...
pk = -wp*sinh(asinh(1/epsilon)/K)*sin(pi*(2*k-1)/(2*K)) + ...
    1j*wp*cosh(asinh(1/epsilon)/K)*cos(pi*(2*k-1)/(2*K))

% Now the inverse Chebyshev
pk = wp*ws ./ pk
zk = 1j*ws*sec(pi*(2*k-1)/(2*K))

B = prod(pk./zk)*poly(zk), A = poly(pk)

% Now the TF!
w = 0:ws*3;
H = polyval(B,1j*w) ./ (polyval(A,1j*w));
plot(w, abs(H), 'LineWidth', 2);
delta_p = 10^(-ap/20); delta_s = 10^(-as/20);
pgon1 = polyshape([0 wp wp 0], [0 0 delta_p delta_p]);
pgon2 = polyshape([0 wp wp 0], [1 1 2 2]);
pgon3 = polyshape([ws ws 3*ws 3*ws], [delta_s 2 2 delta_s]);
hold on;
plot(pgon1);
plot(pgon2);
plot(pgon3);
hold off;
grid on;
xlabel('\omega (rad/s)'), ylabel('|H(j\omega)|'), title('Magnitude Response of BW Filter');
ylim([0 1.2]);