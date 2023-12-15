function PsiT = dwtmtx_2( N,dbtype,wlev )
[LoD,HiD,LoR,HiR] = wfilters(dbtype);
old_dwt_mode = dwtmode('status','nodisp');
dwtmode('per');
PsiT = zeros(N, N);
for i=1:N
    unit_vec = zeros(N, 1);
    unit_vec(i) = 1;
    [coefficients, levels] = wavedec(unit_vec, wlev, LoD,HiD);
    PsiT(:, i) = coefficients;
end
end