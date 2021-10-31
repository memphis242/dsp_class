%% LP Chebyshev
fp = 100; fs = 500;
wp=2*pi*fp; ws=2*pi*fs;  % Specs
delta_p = 0.01; delta_s = 0.01;
ap = -20*log10(1-delta_p);
as = -20*log10(delta_s);

% Determine parameters K and epsilon according to specs, while also
% choosing a more suitable wp to give buffer at spec'd wp and ws
K = ceil(acosh(sqrt((10^(as/10)-1) / (10^(ap/10)-1))) / acosh(ws/wp) );
wp = [wp, ws/cosh(acosh(sqrt((10^(as/10)-1) / (10^(ap/10)-1))) / K)];    % Range of values for wp
wp = mean(wp);   % Select middle value
epsilon = sqrt(10^(ap/10)-1);

% Now obtain polynomials that define the TF
k = 1:K;
H0 = (mod(K,2)==1) + (mod(K,2)==0)*(1/sqrt(1+epsilon^2));   % For even order, H0 always is 1; for odd, it's 1/...
pk = -wp*sinh(asinh(1/epsilon)/K)*sin(pi*(2*k-1)/(2*K)) + ...
    1j*wp*cosh(asinh(1/epsilon)/K)*cos(pi*(2*k-1)/(2*K));
B = H0*prod(-pk); A = poly(pk);

% Now the TF!
w = 0:ws*3;
H = B ./ (polyval(A, 1j*w));
f = w / (2*pi);
plot(f, abs(H), 'LineWidth', 2);
delta_p = 10^(-ap/20); delta_s = 10^(-as/20);
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


%% Compute components for filter implemented as a cascade of Sallen-key stages
% !!This assumes even order and no poles on real-axis!!

% Use sallenKeyCircuit2.m function to obtain Q and wn associated with each
% stage
sorted_poles = sort_complex_list(pk);
NN = length(sorted_poles);
Q = zeros(1,NN); wn = zeros(1,NN);
for i=1:NN
    [Q(i), wn(i), aa, zz] = sallenKeyCircuit2(sorted_poles(i,:));
end

% Use sallenKeyComponents to get R1,R2,C1,C2 of each stage given Q and wn
C = 10e-9; n = 100;
R1 = zeros(1,NN); R2 = zeros(1,NN);
C1 = zeros(1,NN); C2 = zeros(1,NN);
for i=1:NN
    [R1(i), R2(i), C1(i), C2(i)] = sallenKeyComponents(C,n,Q(i),wn(i));
end

%% Print stuff to text file
fid = fopen('Chebyshev Characteristics Part 2.txt','w');

fprintf(fid,'CHEBYSHEV FILTER\n\n');
fprintf(fid,'fp: %.0f Hz\t\t\t\tfs: %.0f Hz\n',fp,fs);
fprintf(fid,'delta_p: %.2f\t\t\tdelta_s: %.2f\n',delta_p,delta_s);
fprintf(fid,'ap: %.2f dB\t\t\t\tas: %.2f dB\n',ap,as);
fprintf(fid,'epsilon: %f\n\n',epsilon);
fprintf(fid,'Filter Order: %d\n\n',K);

fprintf(fid,'Poles (Hz):\n');
pk_Hz = pk/(2*pi);
pk_Hz = sort_complex_list(pk_Hz);
for i=1:length(pk_Hz)
    fprintf(fid,'%f +- %f\n',real(pk_Hz(i,1)),imag(pk_Hz(i,1)));
end

fprintf(fid,'\n\nStages:\n');
for i=1:NN
    fprintf(fid, 'Stage %d:\t\tQ: %3.3f\twn: %5.2f Hz\t\tR1: %.2f ohms\t\tR2: %.2f ohms\t\tC1: %.2f nF\t\tC2: %.2f nF\n', ...
        i, Q(i), wn(i)/(2*pi), R1(i), R2(i), C1(i)*1e9, C2(i)*1e9);
end

fclose(fid);
