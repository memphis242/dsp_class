function [den_coeff] = get_filter_den_coeff(K,fp1)
%% Inputs
Fs = 10e3; T = 1/Fs;
fp2 = (Fs/2) - fp1; 
wp1 = 2*pi*fp1; wp2 = 2*pi*fp2;


%% This code is for generating a normalized LP prototype ICH Filter given K, as, ap
K_LP = K/2;
as=20; ap=2; wp=1;
ws = wp*cosh(acosh(sqrt( (10^(as/10)-1)/(10^(ap/10)-1) )) / K_LP);

% Now obtain polynomials that define the TF of a prototype Chebyshev that
% we will later transform to an inverse Chebyshev's
k = 1:K_LP;
% epsilon = sqrt(10^(ap/10)-1);
epsilon = 1/sqrt(10^(as/10)-1);
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
final_num_terms(end,:) = final_num_terms(end,:)*overall_gain;

den_coeff = final_den_terms;

end

