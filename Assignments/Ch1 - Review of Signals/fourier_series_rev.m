%% Example 1.5 (The Exponential Fourier Series and Spectra)
% Signal to be analyzed: Periodic signal exp(-t/2) with period \pi that
% starts at t=0.

% The signal:
w0 = 2; % rad/s
x = @(t) exp(-mod(t, pi)/2);    % Using mod(a,b) to periodically replicate x(t)
t = -2*pi:1e-2:2*pi;
plot(t, x(t), 'LineWidth', 2);
xlabel('t'), ylabel('x(t)'), title('Signal to be Analyzed');
grid on, xlim([-2*pi, 2*pi]), ylim([-0.1,1.1]);
pause;

% Frequency spectrum
a = (2/pi)*(1-exp(-pi/2));
Xk = @(k) a./(1+4j*k);
K = -4:4;
subplot(1,2,1); % Magnitude Spectrum |X_k|
stem(K, abs(Xk(K)), 'LineWidth', 2);
xlabel('k'), ylabel('|X_k|'), title('Magnitude Spectrum of x(t)');
grid on;
subplot(1,2,2); % Phase Spectrum |X_k|
stem(K, angle(Xk(K)), 'LineWidth', 2);
xlabel('k'), ylabel('\angleX_k'), title('Phase Spectrum of x(t)');
grid on;
pause;

%% Testing the Results: Synthesis
dim = [.2 .5 .3 .3];
for K = [0:10, 10:2:20, 20:5:50, 50:10:100]
    
    pause;
    xhat = zeros(1,length(t));
    
    for k = -K:K
        xhat = xhat + Xk(k)*exp(1j*k*w0*t);
    end
    
    clf;
    plot(t, x(t), t, real(xhat), 'LineWidth', 2);
    xlabel('Time (s)'), ylabel('Amplitude'), title('x(t) and x_{hat}(t)');
    grid on, xlim([-2*pi, 2*pi]), ylim([-0.1,1.1]);
    legend('x(t)', 'xhat(t)');
    annotation('textbox',dim,'String',['K=',num2str(K)],'FitBoxToText','on');

end
        
    