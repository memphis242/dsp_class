A = [1.000000000000000000, -1.6000000000000000, 0.650000000000000];
B = [0.025906735751295328, 0.010362694300518132, 0.013730569948186522];
X = zeros(1,3); Y = zeros(1,3);

Fs = 10e3; T = 1/Fs;

% DC Test
x = 1; t=0; num_of_samples = 20;
xvals = zeros(num_of_samples); yvals = zeros(num_of_samples);
tp = linspace(0,num_of_samples*T,num_of_samples);
for i=3:num_of_samples
    X(3) = X(2);
    X(2) = X(1);
    X(1) = x;
    Y(3) = Y(2);
    Y(2) = Y(1);
    Y(1) = B(1)*X(1) + B(2)*X(2) + B(3)*X(3) - A(2)*Y(2) - A(3)*Y(3);
   
    xvals(i) = X(1); yvals(i) = Y(1);
end

plot(tp, xvals, tp, yvals, 'LineWidth', 2);


% B = 0.025907*[1 0.4 0.53]; A = [1 -1.6 0.65];
% n = -2:1000;
% y = zeros(size(n));
% x = @(n) 1.0.*(n>=0);
% 
% for nstep = 0:1000
%     y(n==nstep) = -A(2)*y(n==nstep-1)-A(3)*y(n==nstep-2)+ B(1)*x(nstep)+B(2)*x(nstep-1)+B(3)*x(nstep-2);
% end
% plot(n,y,'k.')

