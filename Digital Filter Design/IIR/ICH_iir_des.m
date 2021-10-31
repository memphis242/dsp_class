%% Inputs
Fs = 10e3; T = 1/Fs;
K = 20;  % Needs to be multiple of 2 because LP prototype will have order that is half as much
fp1 = 1000; fp2 = (Fs/2) - fp1;  % fp1 needs to be within [250,2000] Hz
wp1 = 2*pi*fp1; wp2 = 2*pi*fp2;


%% This code is for generating a normalized LP prototype ICH Filter given K, as, ap
K_LP = K/2;
as=20; ap=2; wp=1;
ws = wp*cosh(acosh(sqrt( (10^(as/10)-1)/(10^(ap/10)-1) )) / K_LP);
w0=1; w1=wp1; w2=wp2; wsBP = abs(roots([w0 -ws*(w2-w1) -w0*w1*w2])); % This line is to see where ws maps to
fsBP = wsBP/(2*pi);

% Now obtain polynomials that define the TF of a prototype Chebyshev that
% we will later transform to an inverse Chebyshev's
k = 1:K_LP;
% epsilon = sqrt(10^(ap/10)-1);
epsilon = 1/sqrt(10^(as/10)-1);
H0 = (mod(K_LP,2)==1) + (mod(K_LP,2)==0)*(1/sqrt(1+epsilon^2));   % For odd order, H0 always is 1; for even, it's 1/...
pkCH = -wp*sinh(asinh(1/epsilon)/K_LP)*sin(pi*(2*k-1)/(2*K_LP)) + ...
    1j*wp*cosh(asinh(1/epsilon)/K_LP)*cos(pi*(2*k-1)/(2*K_LP));

% Now the inverse Chebyshev poles and zeros
pk = wp*ws ./ pkCH;
zk = 1j*ws*sec(pi*(2*k-1)/(2*K_LP));

bL = prod(pk./zk); aK = 1;


%% Now that we have our LP prototype, let's get the digital filter
% Prewarp the critical frequencies, which here are fp1 and fp2
wp1p = tan(wp1*T/2); wp2p = tan(wp2*T/2);

% Now transform the LP ICH prototype to a digital bandpass filter using Eq. (8.25) in the book
c1 = (wp1p*wp2p - 1) / (wp1p*wp2p + 1);
c2 = (wp2p - wp1p) / (wp1p*wp2p + 1);
for i = 1:K_LP
    Zdig(i,:) = roots([1 (2*c1/(1-c2*zk(i)))  (1+c2*zk(i))/(1-c2*zk(i))]);
    Pdig(i,:) = roots([1 2*c1./(1-c2*pk(i)) (1+c2*pk(i))./(1-c2*pk(i))]);
end
overall_gain = abs(bL/aK*prod(1/c2-zk)/prod(1/c2-pk));
B = overall_gain*poly(Zdig(:)'); A = poly(Pdig(:)');

% Now verify by looking at magnitude response, and just for intuition purposes, plot the poles and zeros
Om = linspace(0,pi,1001); w = Om/T; f = w / (2*pi);
H = polyval(B,exp(1j*Om))./polyval(A,exp(1j*Om));

subplot(1,2,1); plot(f,abs(H),'LineWidth',2);
xlabel('Frequency (Hz)'), ylabel('|H(j*f)|'), title('Magnitude Response');
ylim([0 1.2]); xlim([0 Fs/2]);
delta_p = 10^(-ap/20); delta_s = 10^(-as/20);
pgon1 = polyshape([0 fsBP(2) fsBP(2) 0], [delta_s delta_s 2 2]);
pgon2 = polyshape([fp1 fp2 fp2 fp1], [1 1 2 2]);
pgon3 = polyshape([fp1 fp2 fp2 fp1], [0 0 delta_p delta_p]);
pgon4 = polyshape([fsBP(1) Fs/2 Fs/2 fsBP(1)], [delta_s delta_s 2 2]);
hold on;
plot(pgon1);
plot(pgon2);
plot(pgon3);
plot(pgon4);
hold off;

subplot(1,2,2);
plot(real(Pdig),imag(Pdig),'kx','MarkerSize',10);
title('Pole-Zero Plot');
grid on; xlim([-1.2 1.2]), ylim([-1.2 1.2]);
hold on;
plot(real(Zdig),imag(Zdig),'ko','MarkerSize',10);
% Draw unit circle for reference
hold on;
s = exp(1j*linspace(0,2*pi));
plot(real(s),imag(s));

%% For my testing purposes, generate some test points
fmax = f(end);
test_freqs = [linspace(0,fp1,3),linspace(fp1,fp2,3),linspace(fp2,fmax,3)];
test_Oms = test_freqs*2*pi*T;
mag_at_test_freqs = abs(polyval(B,exp(1j*test_Oms)) ./ polyval(A,exp(1j*test_Oms)));

fid = fopen('test_freqs.txt','w');
fprintf(fid,'2dB Passband Edges:\t\tfp1 = %dHz\tfp2 = %dHz\n',fp1,fp2);
fprintf(fid,'20dB Stopband Edges:\tfs1 = %.1fHz\tfs2 = %.1fHz\n\n',min(fsBP),max(fsBP));
fprintf(fid,'2dB Max Attenuation corresponds to delta_p of %f.\n20dB Min Attenuation corresponds to delta_s of %f.\n\n',delta_p,delta_s);
fprintf(fid,'Frequency (Hz)\t\t\tMagnitude\n');
for i=1:length(test_freqs)
    fprintf(fid,'%f\t\t\t%f\n',test_freqs(i),mag_at_test_freqs(i));
end
fclose(fid);

%% Now let's generate the coefficients to go into the cascaded stages
% Step 1: H(z) in factored form --> That's P and Z
% Step 2 & 3: Pair conjugate roots and expand; real roots can also be paired; use descending order of magnitude of pole
% First make sorted list of conjugate poles
N = K/2;
sorted_poles = sort_complex_list(Pdig);

% Now multiply out to get coefficients for den terms
den_terms = zeros(N,3);
for i = 1:N
    den_terms(i,:) = real(poly(sorted_poles(i,:))); % I'm taking real part just to make data-type double instead of complex; it's all real anyways
end

% Step 4 & 5: Pair complex poles /w nearest zeros
% Ok; this may not be the most efficient way to go about it, but I will first sort the zeros, just like I did for the poles, then implement a search based on distance from each pole to each zero, and pair accordingly
sorted_zeros = sort_complex_list(Zdig);

% Now /w this sorted list, I'll do pair up poles and zeros using a search based on distance
zlist = zeros(size(Zdig));
temp = sorted_zeros(:,1);
for i = 1:N
    % Find closest zero
    p = sorted_poles(i,1);
    zc = return_closest_zero(p,temp);
    zlist(i,:) = [zc,conj(zc)];
    
    % Remove that zero from list and update temp
    index = find( abs(temp - zc) < 1e-5 );
    temp = remove_index(index,temp);
end

% Now multiply out to get coefficients for num terms
num_terms = zeros(N,3);
for i = 1:N
    num_terms(i,:) = real(poly(zlist(i,:)));
end

% Just to more easily remember...
plist = sorted_poles;

% Step 6: Reverse Order
final_num_terms = flip(num_terms);
final_den_terms = flip(den_terms);

% Step 7: Apply overall gain to some stage and output these coefficients to a header file
final_num_terms(1,:) = final_num_terms(1,:)*overall_gain;

NS = N;
fid = fopen('coef.h','w');
fprintf(fid,'#define K %du \n', K);
fprintf(fid, '#define NS %du \n', NS);
fprintf(fid, '#define fp1 %ff \n', fp1);
fprintf(fid, '#define fp2 %ff \n\n', fp2);
fprintf(fid,'float A[NS][3] = { \n');
for ns = 1:NS
    fprintf(fid,'\t{ ');
    fprintf(fid, '%2.18ff, %2.18ff, %2.18ff },\n', final_den_terms(ns,1), final_den_terms(ns,2), final_den_terms(ns,3));
end
fprintf(fid, '};\n\n');

fprintf(fid,'float B[NS][3] = { \n');
for ns = 1:NS
    fprintf(fid,'\t{ ');
    fprintf(fid, '%2.18ff, %2.18ff, %2.18ff },\n', final_num_terms(ns,1), final_num_terms(ns,2), final_num_terms(ns,3));
end
fprintf(fid, '};\n\n');
fclose(fid);


% I'll also print a text file containing the pole-zero pairings, since I don't know of a neat way of showing this on a plot with so many poles and zeros
fid = fopen('pole_zero_pairings.txt','w');
fprintf(fid,'Pole\t\t\t\tZero\n');
for i=1:NS
    fprintf(fid,'%2.4f +- %2.4f\t\t%2.4f +- %2.4f\n', real(plist(i,1)), imag(plist(i,1)), real(zlist(i,1)), imag(zlist(i,1)));
end
fclose(fid);