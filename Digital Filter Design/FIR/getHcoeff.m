function [H] = getHcoeff(L,h)

Lh = L+1;
G = ceil(log2(L));

Nh = 32;
aaa = floor(log2(max(abs(h)))+2);
if aaa >=0
    QIh = aaa;
else
    QIh = 0;
end
QFh = Nh - QIh;
Nx = 16;   %3.13
QIx=3; QFx=13;
Nacc = 64; %(QIh + QIx + G).(45)
QIacc = QIh + QIx + G; QFacc = QFh + QFx;
QIy = QIacc; QFy = 16-QIy;
ACCtoYshift = QFacc - QFy;

YHigh = fix(1.65*2^(QFy));
YLow = fix(-1.65*2^(QFy));

H = fix(h*2^(QFh));
hp = H / (2^(QFh));
err = hp-h; max_err = max(abs(err));


fid = fopen('coeffH.h','w');
fprintf(fid, '#include <stdio.h>\n');
fprintf(fid, '#include <stdlib.h>\n');
fprintf(fid, '#include <stdint.h>\n');
fprintf(fid, '#include <inttypes.h>\n\n');

fprintf(fid, '#define QIh %d\n#define QFh %d\n',QIh,QFh);
fprintf(fid, '#define QIx %d\n#define QFx %d\n',QIx,QFx);
fprintf(fid, '#define Lh %d\n#define L %d\n#define G %d\n', Lh, L, G);
fprintf(fid, '#define QIacc %d\n#define QFacc %d\n', QIacc, QFacc);
fprintf(fid, '#define QIy %d\n#define QFy %d\n', QIy, QFy);
fprintf(fid, '#define ACCtoYshift %d\n\n', ACCtoYshift);
fprintf(fid, '#define YHigh %d\n#define YLow %d\n\n', YHigh, YLow);
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


fprintf(fid, 'double h[Lh] = {\n');
for i=1:4:length(H)
    if i < (Lh-mod(Lh,4))
        fprintf(fid, '\t%.15f, %.15f, %.15f, %.15f,\n', h(i),h(i+1),h(i+2),h(i+3));
    end
end
if mod(Lh,4)~=0
    fprintf(fid,'\t');
    for i=(Lh-mod(Lh,4)+1):Lh
        fprintf(fid, '%.15f, ',h(i));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'};\n\n');

fclose(fid);


end

