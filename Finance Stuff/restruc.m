MSFT_c = 876.00;
MSFT = MSFT_c;


INTC = (8/6)*MSFT_c;
VAL2 = MSFT_c;
CRSR = (15/6)*MSFT_c;
tbd = CRSR;

JKK = (12/6)*MSFT_c;
PTF = JKK;
QQQ = (8/6)*MSFT_c;
SPLG = (4/6)*MSFT_c;
VEU = SPLG;


INTC_c = 363.26;
VAL2_c = 25.14;
CRSR_c = 761.79;
tbd_c = 62.86;

JKK_c = 87.89;
PTF_c = 88;
QQQ_c = 58.50;
SPLG_c = 29;
VEU_c = 28.80;


INTC_d = INTC - INTC_c;
VAL2_d = VAL2 - VAL2_c;
CRSR_d = CRSR - CRSR_c;
tbd_d = tbd - tbd_c;

JKK_d = JKK - JKK_c;
PTF_d = PTF - PTF_c;
QQQ_d = QQQ - QQQ_c;
SPLG_d = SPLG - SPLG_c;
VEU_d = VEU - VEU_c;

CASH = (10/6)*MSFT;
INDEX_FUNDS = [JKK PTF QQQ SPLG VEU];
INDIVIDUAL_STOCKS = [INTC MSFT VAL2 CRSR tbd];
STOCKS = [INDEX_FUNDS INDIVIDUAL_STOCKS];
TOTAL_INV = sum(STOCKS);
STOCKS_d = [INTC_d 0 VAL2_d CRSR_d tbd_d JKK_d PTF_d QQQ_d SPLG_d VEU_d CASH];
STOCKS_dperc = STOCKS_d / (TOTAL_INV-MSFT);


TOTAL_FOR_CYCLE = 900;
INV = TOTAL_FOR_CYCLE * STOCKS_dperc;
INDEX_FUNDS_d = sum(INV(6:10));
INDIVIDUAL_STOCKS_d = sum(INV(1:5));



fid = fopen('INV Cycle 01-23-2021.txt','w');

fprintf(fid, 'TOTAL AVAILABLE FOR CYCLE: \t$%.2f\n\n', TOTAL_FOR_CYCLE);

fprintf(fid, 'TOTAL FOR INDEX FUNDS:\t$%.2f\n', INDEX_FUNDS_d);
fprintf(fid, 'JKK:\t$%.2f\nPTF:\t$%.2f\nQQQ:\t$%.2f\nSPLG:\t$%.2f\nVEU:\t$%.2f\n\n', INV(6),INV(7),INV(8),INV(9),INV(10));

fprintf(fid, 'TOTAL FOR INDIVIDUAL STOCKS:\t$%.2f\n', INDIVIDUAL_STOCKS_d);
fprintf(fid, 'INTC:\t$%.2f\nMSFT:\t$%.2f\nVAL2:\t$%.2f\nMEME1 (CRSR):\t$%.2f\nMEME2 (<tbd>):\t$%.2f\n\n', INV(1),INV(2),INV(3),INV(4),INV(5));

fprintf(fid, 'TOTAL CASH:\t$%.2f\n\n\n', INV(11));

fprintf(fid, 'FOR REFERENCE (my split):\n');
fprintf(fid, 'Index Funds: %.3f%%\n',0.40*100);
fprintf(fid, 'Individual Stocks: %.3f%%\n',0.50*100);
fprintf(fid, 'Cash: %.3f%%\n\n',0.10*100);

fprintf(fid, 'QQQ: %.3f%%\n',0.20*0.40*100);
fprintf(fid, 'JKK: %.3f%%\n',0.30*0.40*100);
fprintf(fid, 'PTF: %.3f%%\n',0.30*0.40*100);
fprintf(fid, 'VEU: %.3f%%\n',0.10*0.40*100);
fprintf(fid, 'SPLG: %.3f%%\n\n',0.10*0.40*100);

fprintf(fid, 'INTC: %.3f%%\n',0.16*0.50*100);
fprintf(fid, 'MSFT: %.3f%%\n',0.12*0.50*100);
fprintf(fid, 'VAL2: %.3f%%\n',0.12*0.50*100);
fprintf(fid, 'MEME1 (CRSR): %.3f%%\n',0.30*0.50*100);
fprintf(fid, 'MEME2 (<tbd>): %.3f%%\n',0.30*0.50*100);

fclose(fid);

