Fs = 10e3; T = 1/Fs;

% %First Order
% K=1;
% Zdig = [-0.8];
% Pdig = [0.9];
% gain = prod(1-Pdig)/prod(1-Zdig);
% B = gain*poly(Zdig); A = poly(Pdig);

% Second Order
K=2;
Zdig = [-0.2+0.7j,-0.2-0.7j];
Pdig = [0.8+0.1j,0.8-0.1j];
overall_gain = prod(1-Pdig)/prod(1-Zdig);
B = overall_gain*poly(Zdig); A = poly(Pdig);

% % Tenth Order
% K=10;
% z1 = -0.1+0.9j;
% z2 = -0.3 + 0.7j;
% z3 = -0.5 + 0.5j;
% z4 = -0.7 + 0.3j;
% z5 = -0.95;
% Zdig = [z1,conj(z1),z2,conj(z2),z3,conj(z3),z4,conj(z4),z5,conj(z5)];
% p1=-z1; p2=-z2; p3=-z3; p4=-z4; p5=-z5;
% Pdig = [p1,conj(p1),p2,conj(p2),p3,conj(p3),p4,conj(p4),p5,conj(p5)];
% overall_gain = prod(1-Pdig)/prod(1-Zdig);
% B = overall_gain*poly(Zdig); A = poly(Pdig);

% % Arbitrary Order
% K=20;
% realZ = -0.9 + 1.8*rand(1,K);
% imagZ = 1j*(-0.9 + 0.2*rand(1,K));
% Zdig = [realZ+imagZ, conj(realZ+imagZ)];
% realP = -0.5 + rand(1,K/2);
% imagP = 1j*(-0.5 + rand(1,K/2));
% Pdig = [realP+imagP, conj(realP+imagP)];
% overall_gain = abs(prod(1-Pdig)/prod(1-Zdig));
% B = overall_gain*poly(Zdig); A = poly(Pdig);



Om = linspace(0,pi,1001); w = Om/T; f = w/(2*pi);
subplot(1,2,1);
H = polyval(B,exp(1j*Om)) ./ polyval(A,exp(1j*Om));
plot(f, abs(H), 'LineWidth', 2);
xlabel('Frequency (Hz)'), ylabel('Magnitude'), title('Magnitude Response of Filter');
grid on;

subplot(1,2,2);
plot(real(Pdig),imag(Pdig),'kx','MarkerSize',10);
grid on; xlim([-1.2 1.2]), ylim([-1.2 1.2]);
hold on;
plot(real(Zdig),imag(Zdig),'ko','MarkerSize',10);
title('Pole-Zero Plot');
% Draw unit circle for reference
hold on;
s = exp(1j*linspace(0,2*pi));
plot(real(s),imag(s));


%% For my testing purposes, generate some test points
fmax = f(end);
test_freqs = [linspace(0,fmax/10,5), fmax/2, 0.75*fmax, 0.95*fmax, fmax];
test_Oms = test_freqs*2*pi*T;
mag_at_test_freqs = abs(polyval(B,exp(1j*test_Oms)) ./ polyval(A,exp(1j*test_Oms)));

fid = fopen('test_freqs.txt','w');
fprintf(fid,'Frequency (Hz)\t\t\tMagnitude\n');
for i=1:length(test_freqs)
    fprintf(fid,'%f\t\t\t\t%f\n',test_freqs(i),mag_at_test_freqs(i));
end
fclose(fid);


%% Now let's generate the coefficients to go into the cascaded stages
% Step 1: H(z) in factored form --> That's P and Z
% Step 2 & 3: Pair conjugate roots and expand; real roots can also be paired; use descending order of magnitude of pole
% First make sorted list of conjugate poles
N = ceil(K/2);
sorted_poles = sort_complex_list(Pdig);

% Now multiply out to get coefficients for den terms
den_terms = zeros(N,3);
for i = 1:N
    den_terms(i,:) = real(poly(sorted_poles(i,:))); % I'm taking real part just to make data-type double instead of complex; it's all real anyways
end

% Step 4 & 5: Pair complex poles /w nearest zeros
% Ok; this may not be the most efficient way to go about it, but I will first sort the zeros, just like I did for the poles, then implement a search based on distance from each pole to each zero, and pair accordingly
sorted_zeros = sort_complex_list(Zdig);

% Now /w this sorted list, I'll pair up poles and zeros using a search based on distance
zlist = zeros(size(sorted_zeros));
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
if K>2
    final_num_terms = flip(num_terms);
    final_den_terms = flip(den_terms);
else
    final_num_terms = num_terms;
    final_den_terms = den_terms;
end


% Step 7: Apply overall gain to some stage and output these coefficients to a header file
final_num_terms(end,:) = final_num_terms(end,:)*overall_gain;

NS = N;
fid = fopen('coef_lpf_test.h','w');
fprintf(fid,'#define K %du \n', K);
fprintf(fid, '#define NS %du \n\n', NS);
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