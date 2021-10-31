% From PSIM
% PSIMfileName = 'stages__1 and 2.csv';
% PSIMfileName = 'stages__3.csv';
% PSIMfileName = 'stages__1, 2, and 3.csv';
% PSIMfileName = 'stages__4.csv';
% A = readmatrix(PSIMfileName);

LTspiceFileName = 'Sallen_Key_Stages.txt';
fid = fopen(LTspiceFileName);
Dc = textscan(fid, '%f(%fdB,%f°)', 'CollectOutput',1);
A = cell2mat(Dc);

breadboardFileName = 'breadboard__stages__1.txt';
B = readmatrix(breadboardFileName);

freq = A(:,1); MagLTspice = A(:,2);
f_BB = B(:,1); Mag_BB = B(:,2);
MagBreadboard = interp1(f_BB,Mag_BB,freq);

% freq = A(:,1); Mag = A(:,2);
% peak_PSIM = db2mag(max(Mag)); peakdb_PSIM = mag2db(peak_PSIM);


% Now compare
titleX = 'Stages 1';
% titleX = 'Stages 1 & 2';
% titleX = 'Stages 1, 2, and 3';
% titleX = 'Stages: All 4';
% semilogx(freq,Mag,freq,Ydb_orig,'LineWidth',2);
semilogx(freq,MagLTspice,freq,MagBreadboard, 'LineWidth',2);
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)'); title(['Frequency Response Comparison: LTspice vs Breadboard', titleX]);
grid on;
% legend('PSIM Standardized Components','MATLAB Original Design');
legend('LTspice Sim /w measured comp values','Breadboard Test Results');


