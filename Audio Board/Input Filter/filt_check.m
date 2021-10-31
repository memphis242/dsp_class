% From PSIM
% PSIMfileName = 'stages__1 and 2.csv';
% PSIMfileName = 'stages__3.csv';
% PSIMfileName = 'stages__1, 2, and 3.csv';
% PSIMfileName = 'stages__4.csv';
% A = readmatrix(PSIMfileName);
% fid = fopen('8th_Order_LP_Cheyshev__Part 2.txt');
% Dc = textscan(fid, '%f(%fdB,%f°)', 'CollectOutput',1);
% A = cell2mat(Dc);
breadboardFileName = 'breadboard__stages__1.txt';
A = readmatrix(PSIMfileName);
freq = A(:,1); Mag = A(:,2);
peak_PSIM = db2mag(max(Mag)); peakdb_PSIM = mag2db(peak_PSIM);


% From original design
Q1 = 13.822; wn1 = 3036.12*2*pi; poles1 = -109.828560 + 3034.136883j;
alpha1 = wn1 / (2*Q1); zeta1 = 1/(2*Q1);
num1 = wn1^2; den1 = [1, 2*alpha1, wn1^2];
G1 = tf(num1,den1);

% Q1 = 13.822; wn1 = 3036.12*2*pi; poles1 = -109.828560 + 3034.136883j;
% alpha1 = wn1 / (2*Q1); zeta1 = 1/(2*Q1);
% num1 = wn1^2; den1 = [1, 2*alpha1, wn1^2];
% G1 = tf(num1,den1);
% 
% Q2 = 4.142; wn2 = 2591.16*2*pi; poles2 = -312.765276 + 2572.217047j;
% alpha2 = wn2 / (2*Q2); zeta2 = 1/(2*Q2);
% num2 = wn2^2; den2 = [1, 2*alpha2, wn2^2];
% G2 = tf(num2,den2);
% 
% Q3 = 1.903; wn3 = 1781.30*2*pi; poles3 = -468.086315 + 1718.700483j;
% alpha3 = wn3 / (2*Q3); zeta3 = 1/(2*Q3);
% num3 = wn3^2; den3 = [1, 2*alpha3, wn3^2];
% G3 = tf(num3,den3);
% 
% Q4 = 0.741; wn4 = 817.99*2*pi; poles4 = -552.145455 + 603.527350j;
% alpha4 = wn4 / (2*Q4); zeta4 = 1/(2*Q4);
% num4 = wn4^2; den4 = [1, 2*alpha4, wn4^2];
% G4 = tf(num4,den4);

% Q1 = 13.822; wn1 = 6072.25*2*pi; poles1 = -219.657119 + 6068.273767j;
% alpha1 = wn1 / (2*Q1); zeta1 = 1/(2*Q1);
% num1 = wn1^2; den1 = [1, 2*alpha1, wn1^2];
% G1 = tf(num1,den1);
% 
% Q2 = 4.142; wn2 = 5182.32*2*pi; poles2 = -625.530552 + 5144.434095j;
% alpha2 = wn2 / (2*Q2); zeta2 = 1/(2*Q2);
% num2 = wn2^2; den2 = [1, 2*alpha2, wn2^2];
% G2 = tf(num2,den2);
% 
% Q3 = 1.903; wn3 = 3562.60*2*pi; poles3 = -936.172630 + 3437.400966j;
% alpha3 = wn3 / (2*Q3); zeta3 = 1/(2*Q3);
% num3 = wn3^2; den3 = [1, 2*alpha3, wn3^2];
% G3 = tf(num3,den3);
% 
% Q4 = 0.741; wn4 = 1635.98*2*pi; poles4 = -1104.290910 + 1207.054701j;
% alpha4 = wn4 / (2*Q4); zeta4 = 1/(2*Q4);
% num4 = wn4^2; den4 = [1, 2*alpha4, wn4^2];
% G4 = tf(num4,den4);

G = series(G1,G2);
G = series(G,G3);
G = series(G,G4);

Yorig = zeros(1,length(freq));
for i=1:length(Yorig)
    Yorig(i) = abs(evalfr(G,freq(i)*2*pi*1j));
end
Ydb_orig = mag2db(Yorig);
peak_orig = db2mag(max(Ydb_orig)); peakdb_orig = max(Ydb_orig);


% Now compare
% titleX = 'Stages 1 & 2';
% titleX = 'Stages 1, 2, and 3';
titleX = 'Stages: All 4';
semilogx(freq,Mag,freq,Ydb_orig,'LineWidth',2);
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)'); title(['Frequency Response Comparison: MATLAB vs PSIM ', titleX]);
grid on;
legend('PSIM Standardized Components','MATLAB Original Design');

f = [1 100 1000 3000 5000 10e3 50e3];
resp = zeros(1,length(f));
for i=1:length(f)
    resp(i) = abs(evalfr(G,f(i)*2*pi*1j));
end

%% Print to a text file
% fileName = 'Quick Filter Check - Stages 1 and 2.txt';
% fileName = 'Quick Filter Check - Stages 1, 2, and 3.txt';
fileName = 'Quick Filter Check - Stages All 4.txt';
fid = fopen(fileName,'w');

fprintf(fid,'Quick Filter Check\n\n');
for i=1:length(f)
    fprintf(fid, '%6d Hz\t\t-->\t\tMagnitude: %3.3f\t%3.0f dB\n', f(i), resp(i), mag2db(resp(i)));
end

fprintf(fid,'\nPeak of Original Design:\t%2.2f\t%3.0f dB\n',peak_orig,peakdb_orig);
fprintf(fid,'Peak of PSIM simulation with standardized values:\t%2.2f\t%3.0f dB\n\n', peak_PSIM, peakdb_PSIM);

fprintf(fid,'From Original Design\n');
fprintf(fid,'Poles:\t%5.1f\t+-%5.1fj Hz\n',real(poles2),imag(poles2));
fprintf(fid,'Q: %f\n',Q2);
fprintf(fid,'Damping Factor (zeta): %f\n',zeta2);

% fprintf(fid, 'From PSIM Standardized Design\n');
% fprintf(fid,'Poles:\t%5.1f\t+-%5.1fj Hz\n',real(poles),imag(poles));
% fprintf(fid,'Q: %f\n',Q);
% fprintf(fid,'Damping Factor (zeta): %f\n',zeta);

fclose(fid);

