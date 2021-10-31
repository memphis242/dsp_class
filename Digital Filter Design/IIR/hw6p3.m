K = 10;
NS = K/2;

fp1 = [250 500 1000 2000];
A = zeros(4,NS,3);
B = zeros(4,NS,3);

for i = 1:4
    A(i,:,:) = get_filter_den_coeff(K,fp1(i));
    B(i,:,:) = get_filter_num_coeff(K,fp1(i));
end


%%
fid = fopen('coef4.h','w');
fprintf(fid,'#define K %d \n', K);
fprintf(fid, '#define NS %d \n\n', NS);
fprintf(fid,'float A[4][NS][3] = { \n');
for i = 1:4
    fprintf(fid,'\t {\n');
    for ns = 1:NS
        fprintf(fid,'\t{ ');
        fprintf(fid, '\t\t%2.12f, %2.12f, %2.12f },\n', A(i,ns,1), A(i,ns,2), A(i,ns,3));
    end
    fprintf(fid, '\t },\n\n');
end
fprintf(fid,'};\n\n');

fprintf(fid,'float B[4][NS][3] = { \n');
for i = 1:4
    fprintf(fid,'\t {\n');
    for ns = 1:NS
        fprintf(fid,'\t{ ');
        fprintf(fid, '\t\t%2.12f, %2.12f, %2.12f },\n', B(i,ns,1), B(i,ns,2), B(i,ns,3));
    end
    fprintf(fid, '\t },\n\n');
end
fprintf(fid,'};\n\n');

fclose(fid);
