TOTAL_FOR_CYCLE = 993;

INDEX_FUNDS = 0.40 * TOTAL_FOR_CYCLE;
INDIVIDUAL_STOCKS = 0.50 * TOTAL_FOR_CYCLE;
CASH = 0.10 * TOTAL_FOR_CYCLE;

QQQ = 0.20*INDEX_FUNDS;  % Large Cap
JKK = 0.30*INDEX_FUNDS;  % Small Cap
PTF = 0.30*INDEX_FUNDS;  % Growth
VEU = 0.10*INDEX_FUNDS;  % Global Emerging Markets /wo US
SPLG = 0.10*INDEX_FUNDS; % S&P 500

% There are 3 long-term value plays, 2 growth plays
INTC = 0.16*INDIVIDUAL_STOCKS;
MSFT = 0.12*INDIVIDUAL_STOCKS;
VAL2 = 0.12*INDIVIDUAL_STOCKS;
MEME1 = 0.30*INDIVIDUAL_STOCKS; % CRSR
MEME2 = 0.30*INDIVIDUAL_STOCKS; % <TBD>


fid = fopen('INV Cycle 12-22-2020.txt','w');

fprintf(fid, 'TOTAL AVAILABLE FOR CYCLE 12/22/2020: \t$%.2f\n\n', TOTAL_FOR_CYCLE);

fprintf(fid, 'TOTAL FOR INDEX FUNDS:\t$%.2f\n', INDEX_FUNDS);
fprintf(fid, 'QQQ:\t$%.2f\nJKK:\t$%.2f\nPTF:\t$%.2f\nVEU:\t$%.2f\nSPLG:\t$%.2f\n\n', QQQ,JKK,PTF,VEU,SPLG);

fprintf(fid, 'TOTAL FOR INDIVIDUAL STOCKS:\t$%.2f\n', INDIVIDUAL_STOCKS);
fprintf(fid, 'INTC:\t$%.2f\nMSFT:\t$%.2f\nVAL2:\t$%.2f\nMEME1 (CRSR):\t$%.2f\nMEME2 (<tbd>):\t$%.2f\n\n', INTC,MSFT,VAL2,MEME1,MEME2);

fprintf(fid, 'TOTAL CASH:\t$%.2f\n\n\n', CASH);

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

