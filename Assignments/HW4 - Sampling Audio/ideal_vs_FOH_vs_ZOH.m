Fs = 2;
T = 1/Fs;
f = -4*Fs:1e-3:4*Fs;
rect = @(f) (abs(f)<0.5) + 0.5*(abs(f)==0.5);

fx = 1;
X = @(f) rect(f/(2*fx));

Hideal = @(f) T*rect(f/Fs);
Hfoh = @(f) T*(sinc(T*f)).^2;
Hzoh = @(f) T*sinc(T*f);

plot(f, abs(Hideal(f)), f, abs(Hfoh(f)), f, abs(Hzoh(f)), 'LineWidth', 2);
xlabel('f (Hz)'), title('Comparison of Interpolation Filters');
grid on;
legend('Ideal', 'FOH', 'ZOH');

pause;

dim = [.1 .4 .1 .1];
for Fs = [3,7,10]
    
    T = 1/Fs;
    f = -4*Fs:1e-3:4*Fs;
    Hideal = @(f) T*rect(f/Fs);
    Hfoh = @(f) T*(sinc(T*f)).^2;
    Hzoh = @(f) T*sinc(T*f);
    
    X_tilda = zeros(size(f));

    for k = -4:4
        X_tilda = X_tilda + X(f-Fs*k);
    end
    
    X_tilda = X_tilda*(1/T);
    
    clf;
    subplot(2,2,1);
    plot(f, abs(Hideal(f)), f, abs(Hfoh(f)), f, abs(Hzoh(f)), f, X_tilda, 'LineWidth', 2);
    xlabel('f (Hz)'), title('Comparison of Interpolation Filters');
    grid on;
    legend('Ideal', 'FOH', 'ZOH', 'X_{\delta}(f)');
    annotation('textbox',dim,'String',['Fs=',num2str(Fs),' Hz'],'FitBoxToText','on');
    
    subplot(2,2,2);
    plot(f, abs(Hideal(f)).*X_tilda, 'LineWidth', 2);
    xlabel('f (Hz)'), title('Ideal Interpolation Filter Output Spectrum');
    grid on;
    
    subplot(2,2,3);
    plot(f, abs(Hfoh(f)).*X_tilda, 'LineWidth', 2, 'Color', [0.8500 0.3250 0.0980]);
    xlabel('f (Hz)'), title('FOH Interpolation Filter Output Spectrum');
    grid on;
    
    subplot(2,2,4);
    plot(f, abs(Hzoh(f)).*X_tilda, 'LineWidth', 2, 'Color', [0.9290 0.6940 0.1250]);
    xlabel('f (Hz)'), title('ZOH Interpolation Filter Output Spectrum');
    grid on;
    
    pause;
    
end
