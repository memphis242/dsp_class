% This is a program for tabulating/graphing the essential 95% bandwidth of
% a rect function
N = 1e2;
B = zeros(1,N);

for i = 1:N
    
    a = 0.1*i + 1;
    Xsquare = @(w) (a*sinc(a*w/(2*pi))).^2;
    DeltaEx = @(B) quad(Xsquare, -B, B)/(2*pi);
    ObjFun = @(B) abs(0.95 - DeltaEx(B));
    B(i) = fminsearch(ObjFun, 1) / (2*pi);  % B in Hz
    
end

i = 1:N;
plot((0.1*i+1), B, 'LineWidth', 2);
xlabel('\tau (sec)'), ylabel('B (Hz)'), title('Essential Bandwidth of Unit Rect Function with width \tau');
grid on;
