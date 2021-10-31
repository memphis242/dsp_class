N0 = 100;
N = 3 + N0; Om0 = 2*pi/N;
n = 0:N-1;

x = [1 1 1 zeros(1,N0)];

% Taking the DFT
Xk = zeros(1,N);
for k=1:N
    Xk(k) = x * exp(-1j*(k-1)*Om0*n)';
end

% Taking the DTFT
X = @(Om) x * exp(-1j*Om*n)';

% Comparing the two
% Om = linspace(0,2*pi,1001);
% plot(Om,X(Om),'LineWidth',2);
% hold on;
stem(Om0*n,abs(Xk)); xlim([-1,2*pi*1.2]); ylim([0,1.5*max(abs(Xk))]);