L = 27;
Lh = L+1;
G = ceil(log2(L));

h = -0.5 + rand(1,Lh);

Nh = 32;   %0.32
QIh=0; QFh=32;
Nx = 16;   %3.13
QIx=3; QFx=13;
Nacc = 64; %(QIh + QIx + G).(45)
QIacc = QIh + QIx + G; QFacc = QFh + QFx;
QIy = QIacc; QFy = 16-QIy;
ACCtoYshift = QFacc - QFy;

H = fix(h*2^(QFh));
hp = H / (2^(QFh));
err = hp-h; max_err = max(abs(err));


fid = fopen('coeffH.h','w');
fprintf(fid, '#define QIh 0\n#define QFh 32\n');
fprintf(fid, '#define QIx 3\n#define QFx 13\n');
fprintf(fid, '#define Lh %d\n#define L %d\n#define G %d\n', Lh, L, G);
fprintf(fid, '#define QIacc %d\n#define QFacc %d\n', QIacc, QFacc);
fprintf(fid, '#define QIy %d\n#define QFy %d\n', QIy, QFy);
fprintf(fid, '#define ACCtoYshift %d\n\n', ACCtoYshift);
fprintf(fid, 'int32_t H[Lh] = {\n');
for i=1:4:length(H)
    if i < (Lh-mod(Lh,4))
        fprintf(fid, '\t%d, %d, %d, %d,\n', H(i),H(i+1),H(i+2),H(i+3));
    end
end
if mod(Lh,4)~=0
    fprintf(fid,'\t');
    for i=(Lh-mod(Lh,4)+1):Lh
        fprintf(fid, '%d, ',H(i));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'};\n\n');
fclose(fid);

