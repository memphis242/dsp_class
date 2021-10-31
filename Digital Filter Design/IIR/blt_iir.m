Om = linspace(0,pi,1001); T = 1e-6*pi; w = Om/T; f = w / (2*pi);

wc = 1e5; Hc = wc ./ (1j*w + wc);
Z = []; P = [-wc]; bL = wc; aK = 1; L = length(Z); K = length(P);
B = bL/aK*prod(2/T-Z)/prod(2/T-P)*poly([(1+Z*T/2)./(1-Z*T/2),-ones(1,K-L)])
A = poly((1+P*T/2)./(1-P*T/2))

H = polyval(B,exp(1j*Om))./polyval(A,exp(1j*Om));

subplot(121); plot(f,abs(H),'k',f,abs(Hc),'k--');
subplot(122); plot(f,angle(H),'k',f,angle(Hc),'k--');