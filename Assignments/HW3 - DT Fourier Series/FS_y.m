clear all;

A=5; B=7;
Tx = 40;
c2=1.65; c3 = 16e3; Ty = Tx/c3; wy = 2*pi/Ty; wx = 2*pi/Tx;
R = B+10; Q = A+10;
x = @(t) (2*t/Q).*(t>=0 & t<Q) + (-t/R + Tx/R).*(t>=Tx-R & t<Tx);
x_per = @(t) x(mod(t,Tx));
y = @(t) c2*x_per(c3*t);

tx = -2*Tx:(Tx/100):2*Tx;
% ty = -2*Ty:(Ty/100):2*Ty;
ty = -Ty:(Ty/40):Ty;
subplot(2,1,1);
plot(tx, x_per(tx), 'LineWidth', 2);
xlabel('t (sec)'), ylabel('x(t)'), title('Plot of x(t)');
ylim([-0.2 2.5]);
grid on;
subplot(2,1,2);
plot(ty, y(ty), 'LineWidth', 2);
xlabel('t (sec)'), ylabel('y(t)'), title('Plot of y(t)');
ylim([-0.2 3.5]);
grid on;

pause
clf;

% Now setting up the FS analysis eq's
X0 = (1/Tx) * (0.5*R + Q);
Y0 = c2*X0;
Hk = @(k) (-1/(Tx*R))*exp(1j*k*wx*R) + ((1/R) + (2/Q))*(1/Tx) + (-2/(Q*Tx))*exp(-1j*k*wx*Q);
Zk = @(k) (1/Tx)*exp(1j*k*wx*R) + (-2/Tx)*exp(-1j*k*wx*Q) + (1./(1j*k*wx)).*Hk(k);

% Deltak = @(k) k==0;
% Pk = @(k) (1/R + 1/Q)*(Q/Tx)*sinc(k*wx*Q/(2*pi));
% Ak = @(k) Pk(k).*exp(-1j*k*wx*Q/2) - (1/R)*Deltak(k);
% Zk = @(k) (1/Tx)*exp(1j*k*wx*R) + (-2/Tx)*exp(-1j*k*wx*Q) + Ak(k);

Xk = @(k) (1./(1j*k*wx)).*Zk(k);
Yk = @(k) c2*Xk(k);

% Building the approximation yhat(t) progressively as the synthesis
% sum bounds (-K and K) increase
% dim = [.2 .5 .3 .3];
for K = [1:10]
    pause;  % This will allow me to step through the steps
%     xhat = zeros(size(tx));
    yhat = zeros(size(ty));
    
    % This for loop is a nice way to implement the sum of the synthesis
    % equation
    for k = -K:K
        if k==0
%             xhat = xhat + X0;
            yhat = yhat + Y0;
        else
%             xhat = xhat + Xk(k)*exp(1j*k*wx*tx);
            yhat = yhat + Yk(k).*exp(1j*k*wy*ty);
        end
    end
    
%     clf;
%     plot(tx, x_per(tx), tx, real(xhat), 'LineWidth', 2);
    subplot(2,5,K);
    plot(ty, y(ty), ty, real(yhat), 'LineWidth', 2);
%     xlabel('Time (s)'), ylabel('Amplitude'), title('y(t) and y_{hat}(t)');
    xlabel('Time (s)'), ylabel('Amplitude'), title(['K = ',num2str(K)]);
    grid on;
    ylim([-1,3.5]);
%     annotation('textbox',dim,'String',['K=',num2str(K)],'FitBoxToText','on');
    
end


% Ck = 2*abs(Yk(1:10))
% Ok = angle(Yk(1:10))

