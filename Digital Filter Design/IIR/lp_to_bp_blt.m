wp1p = 1; wp2p = 2;
K = 3; L = 0;
bL = 3; aK=1;

c1 = (wp1p*wp2p-1)/(wp1p*wp2p+1);
c2 = (wp2p-wp1p)/(wp1p*wp2p+1);
Zdig = [ones(1,K-L),-ones(1,K-L)];
for i=1:K
    Pdig(i,:) = roots([1 2*c1./(1-c2*P(i)) (1+c2*P(i))./(1-c2*P(i))]);
end

B = bL/aK*prod(1/c2-Z)/prod(1/c2-P)*poly(Zdig(:)'), A = poly(Pdig(:)')

Om = linspace(0,pi,1001); T = 1e-6*pi; w = Om/T; f = w / (2*pi);
wc = 1e5; Hc = wc ./ (1j*w + wc);
H = polyval(B,exp(1j*Om))./polyval(A,exp(1j*Om));

subplot(121); plot(f,abs(H),'k',f,abs(Hc),'k--');
subplot(122); plot(f,angle(H),'k',f,angle(Hc),'k--');